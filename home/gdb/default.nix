# Configuration for GDB.
{ config
, inputs
, lib
, pkgs
, ...
}:
let
  # Patch GDB to include extra python packages for GEF in its Python's path.
  gdb = pkgs.gdb.override {
    pythonSupport = true;

    python3 =
      let
        keystone-engine = python3Packages: python3Packages.buildPythonPackage {
          pname = "keystone-engine";
          version = inputs.keystone-engine.lastModifiedDate;

          # Keystone keeps its Python bindings in a directory inside the repo,
          # and needs the C sources inside of *that* directory when building the
          # Python bindings.
          # To simplify everything, just build a sdist like the one uploaded to
          # pypi.
          src = pkgs.stdenv.mkDerivation rec {
            pname = "keystone-engine-python-src";
            version = inputs.keystone-engine.lastModifiedDate;
            name = "${pname}-${version}.tar.gz";
            src = inputs.keystone-engine;

            # Disable unneeded phases.
            configurePhase = ":";
            checkPhase = ":";

            buildInputs = [
              (python3Packages.python.withPackages (p: [ p.setuptools ]))
            ];

            # Build the source distribution.
            buildPhase = ''
              cd bindings/python
              python3 setup.py sdist --formats=gztar
              cd ../..
            '';

            # Install it.
            installPhase = ''
              cd bindings/python
              cp -v "dist/$(python3 setup.py --fullname).tar.gz" "$out"
              cd ../..
            '';
          };

          # Disable trying to configure and build as a CMake package.
          dontUseCmakeConfigure = true;

          # Add CMake for keystone's build process.
          nativeBuildInputs = [ pkgs.cmake ];
        };

        # Make a package of ropper, but built as a Python library, rather than
        # an application.
        # This is necessary for the modules to be loadable by GEF.
        ropper-lib = python3Packages: python3Packages.buildPythonPackage {
          # Just inherit everything from ropper.
          inherit (python3Packages.ropper)
            pname version src doCheck checkInputs propagatedBuildInputs meta;
        };
      in
      pkgs.python3.withPackages (p: with p; [
        capstone
        ropper
        rpyc
        unicorn

        (keystone-engine p)
        (ropper-lib p)
      ]);
  };

  gef = import ./gef.nix {
    inherit pkgs;
    gef = inputs.gef;
  };

  gef-extras = pkgs.applyPatches {
    src = inputs.gef-extras;

    name = "gef-extras-patched";

    # Disable aliases in gef-extras that conflict with the standard
    # abbreviations.
    # Since gef-extras adds these in the code rather than the configuration, it
    # seems we need to patch it out to disable these aliases.
    patches = [
      ./0000-gef-extras-disable-conflicting-aliases.patch
    ];
  };
in
{
  # GDB configuration.
  home.file.".gdbinit".text = ''
    # Allow setting breakpoints at places that haven't been loaded yet.
    set breakpoint pending on

    # Use Intel-flavor assembly for x86.
    set disassembly-flavor intel

    # Disable pagination of output.
    set pagination off

    # Add Rust's debugging pretty printers.
    python
    import gdb
    import os
    import subprocess
    import sys

    # Default the pretty printers to nixpkgs rust.
    rustc_sysroot = '${pkgs.rustc}'

    # Try to get the pretty printer path from whichever rustc is in the
    # current PATH if possible.
    # This will let us use pretty printers from, e.g., nightly rust in a
    # flake, rather than the default pretty printers for a different rust
    # version.
    try:
        # Ask rustc for the sysroot.
        sysroot = subprocess.run(
            ['rustc', '--print=sysroot'],
            stdout=subprocess.PIPE,
            text=True,
        )

        # If it succeeded, use the sysroot it gave.
        if sysroot.returncode == 0:
            rustc_sysroot = sysroot.stdout.strip()
    except:
        # On any error, just use the default sysroot.
        pass

    # Get the pretty-printer directory.
    rustc_pretty = os.path.join(rustc_sysroot, 'lib', 'rustlib', 'etc')


    # Add Rust's pretty printers to PYTHONPATH.
    # Note that Python and gdb have different ideas of the environment
    # variables, so we have to set it for both.
    # This will ensure it's passed to any child processes.
    if os.getenv('PYTHONPATH', default=''') == ''':
      os.environ['PYTHONPATH'] = rustc_pretty
      gdb.execute('set environment PYTHONPATH %s' % rustc_pretty)
    else:
      os.environ['PYTHONPATH'] += rustc_pretty
      gdb.execute('set environment PYTHONPATH %s:%s' % (os.environ['PYTHONPATH'], rustc_pretty))

    # Add Rust's pretty printers to the in-use module path.
    sys.path.append(rustc_pretty)

    # Add Rust's pretty printers to GDB's directory search path.
    gdb.execute('directory %s' % rustc_pretty)

    # Add Rust's pretty printers to the allowed load path.
    gdb.execute('add-auto-load-safe-path %s' % rustc_pretty)
    end

    # Source GEF.
    source ${gef}/gef.py
  '';

  # GEF configuration.
  # NOTE: This is essentially what `gef config save` will generate.
  home.file.".gef.rc".text =
    let
      # Format lines in the same way as `gef config save` to make it easy to see
      # what's different.
      # This is essentially mkKeyValueDefault, but with a space around the `=`.
      toINI = lib.generators.toINI {
        mkKeyValue = k: v:
          let
            inherit (lib.strings) escape;

            # GEF wants its true/false to be capitalized.
            mkValueString = v:
              if v == true then "True"
              else if v == false then "False"
              else lib.generators.mkValueStringDefault { } v;

            sep = if v == "" then " =" else " = ";
          in
          "${escape [ "=" ] k}${sep}${mkValueString v}";
      };

      # The temporary directory to use for GEF.
      gef-tempdir = "/tmp/gef.${config.home.username}";
    in
    toINI {
      # Context configuration.

      # Don't clear the screen before printing context.
      context.clear_screen = false;

      # Show the context when breaking.
      context.enable = true;

      # Grow stack upwards.
      context.grow_stack_down = false;

      # Show all registers by default.
      context.ignore_registers = "";

      # The order of the context sections.
      context.layout =
        "legend regs stack code args source memory threads trace extra";

      # Show libc function arguments better.
      context.libc_args = true;
      context.libc_args_path = "${gef-extras}/glibc-function-args";

      # Show 10 backtrace lines.
      context.nb_lines_backtrace = 10;

      # Show 6 lines of machine code at and after the next instruction to run.
      context.nb_lines_code = 6;

      # Show 3 lines of machine code before the next instruction for context.
      context.nb_lines_code_prev = 3;

      # Show 8 lines of stack contents.
      context.nb_lines_stack = 8;

      # Show all threads in the thread section.
      context.nb_lines_threads = -1;

      # Peek into calls.
      context.peek_calls = true;

      # Peek at the return address.
      context.peek_ret = true;

      # Don't redirect context to another TTY.
      context.redirect = "";

      # Show up to 8 bytes of opcodes next to disassembly.
      context.show_opcodes_size = 8;

      # Dereference registers.
      context.show_registers_raw = false;

      # Show debug context info in the source code pane.
      context.show_source_code_variable_values = true;

      # Dereference stack pointers.
      context.show_stack_raw = false;

      # Use Capstone for disassembly rather than GDB's disassembler, since it
      # can be more reliable in certain edge cases that can confuse GDB's
      # disassembler.
      context.use_capstone = true;

      # Dereference configuration.

      # Stop dereferencing pointers after 7 levels.
      dereference.max_recursion = 7;

      # Entrypoint breaking configuration.

      # The possible symbol names for entrypoints.
      # NOTE: This is taken from the default gef config.
      entry-break.entrypoint_symbols = builtins.concatStringsSep " " [
        "main"
        "_main"
        "__libc_start_main"
        "__uClibc_main"
        "start"
        "_start"
      ];

      # Configuration for running GEF on a remote gdbserver.

      # Preserve data downloaded when the session exits in case it's useful.
      gef-remote.clean_on_exit = false;

      # General GEF configuration.

      # Don't automatically save breakpoints.
      gef.autosave_breakpoints_file = "";

      # Show debug info if any GEF commands fail.
      gef.debug = true;

      # Use color in GEF output.
      gef.disable_color = false;

      # Extra plugins to load.
      gef.extra_plugins_dir = builtins.concatStringsSep ";" [
        # Load scripts from GEF-extras.
        "${gef-extras}/scripts"
      ];

      # When the process being debugged forks, follow the child process.
      gef.follow_child = true;

      # GEF doesn't need to work around an old readline bug.
      gef.readline_compat = false;

      # The directory for GEF to use for temporary and cache files.
      gef.tempdir = gef-tempdir;

      # Don't use a WinDBG-like prompt.
      gef.use-windbg-prompt = false;

      # Settings for the Global Offsets Table.

      # Show functions as yellow in the got command if not resolved yet.
      got.function_not_resolved = "yellow";

      # Show functions as green in the got command if they've been resolved.
      got.function_resolved = "green";

      # Settings for the heap analysis helper.

      # Break on double frees.
      heap-analysis-helper.check_double_free = true;

      # Break if free(NULL) is called.
      heap-analysis-helper.check_free_null = true;

      # Break if heap allocations (may) overlap.
      heap-analysis-helper.check_heap_overlap = true;

      # Break if use-after-free conditions (may) happen.
      heap-analysis-helper.check_uaf = true;

      # Break if free() is called on a pointer the heap allocator isn't
      # tracking.
      heap-analysis-helper.check_weird_free = true;

      # Heap chunks settings.

      # Hexdump the first 16 bytes inside the heap chunk data.
      heap-chunks.peek_nb_byte = 16;

      # Hexdump settings.

      # Always show the ASCII dump when hexdumping.
      hexdump.always_show_ascii = true;

      # Highlight settings.

      # Allow custom highlights for strings that match regular expressions,
      # rather than just literal strings.
      # NOTE: This can cause performance issues, especially with a lot of
      # highlights.
      highlight.regex = true;

      # IDA/Binary Ninja remote connection settings settings.

      # Connect to the local host on port 1337.
      ida-interact.host = "127.0.0.1";
      ida-interact.port = 1337;

      # Connect to the local host on port 18812 to remotely control IDA.
      ida-rpyc.host = "127.0.0.1";
      ida-rpyc.port = 18812;
      ida-rpyc-breakpoints-list.host = "127.0.0.1";
      ida-rpyc-breakpoints-list.port = 18812;

      # Sync the $pc position between IDA/Binary Ninja and GDB.
      ida-interact.sync_cursor = true;
      ida-rpyc.sync_cursor = true;
      ida-rpyc-breakpoints-list.sync_cursor = true;

      # Configuration for the De Brujin cycle pattern finder/generator.

      # The initial length of a cyclic buffer to generate.
      pattern.length = 1024;

      # Extra configuration for pcustom/print custom/dt.

      # Only recurse 4 levels.
      pcustom.max_depth = 4;

      # The path for custom struct files.
      # Here, we load them from gef-extras.
      pcustom.struct_path = "${gef-extras}/structs";

      # The color for structure names.
      pcustom.structure_name = "bold blue";

      # The color for attribute sizes.
      pcustom.structure_size = "green";

      # The color for attribute types.
      pcustom.structure_type = "bold red";

      # Process search settings.

      # The command to run to get process information.
      process-search.ps_command = "ps auxww";

      # Settings for retdec.

      # Store decompiled code in the same directory as GEF's other temporary
      # files, if using retdec for decompilation.
      retdec.path = gef-tempdir;

      # Path to retdec.
      # This should be ~/.nix-profile.
      # FIXME: Set this when retdec works better in GEF-extras, and when retdec
      # in nixpkgs doesn't refuse to decompile x86-64 binaries.
      retdec.retdec_path = "";

      # Syscall settings.

      # The path to the syscall desciption tables.
      # We use the ones from GEF-extras.
      syscall-args.path = "${gef-extras}/syscall-tables";

      # Theme settings.

      # These are the default theme settings.
      theme.address_code = "red";
      theme.address_heap = "green";
      theme.address_stack = "pink";
      theme.context_title_line = "gray";
      theme.context_title_message = "cyan";
      theme.default_title_line = "gray";
      theme.default_title_message = "cyan";
      theme.dereference_base_address = "cyan";
      theme.dereference_code = "gray";
      theme.dereference_register_value = "bold blue";
      theme.dereference_string = "yellow";
      theme.disassemble_current_instruction = "green";
      theme.registers_register_name = "blue";
      theme.registers_value_changed = "bold red";
      theme.source_current_line = "green";
      theme.table_heading = "blue";

      # Settings for the trace-run command.

      # Don't recurse much.
      trace-run.max_tracing_recursion = 1;

      # The tracing output's file prefix.
      trace-run.tracefile_prefix = "./gef-trace-";

      # Settings for unicorn-emulate.

      # Show instructions run with unicorn.
      unicorn-emulate.show_disassembly = true;

      # Run unicorn-engine verbosely.
      unicorn-emulate.verbose = true;

      # GEF aiases.

      # The default GEF aliases.
      aliases.pf = "print-format";
      aliases.status = "process-status";
      aliases.binaryninja-interact = "ida-interact";
      aliases.bn = "ida-interact";
      aliases.binja = "ida-interact";
      aliases.lookup = "scan";
      aliases.grep = "search-pattern";
      aliases.xref = "search-pattern";
      aliases.flags = "edit-flags";
      aliases.mprotect = "set-permission";
      aliases.emulate = "unicorn-emulate";
      aliases.cs-dis = "capstone-disassemble";
      aliases.sc-search = "shellcode search";
      aliases.sc-get = "shellcode get";
      aliases.asm = "assemble";
      aliases.ps = "process-search";
      aliases.start = "entry-break";
      aliases.nb = "name-break";
      aliases.ctx = "context";
      aliases.telescope = "dereference";
      aliases."pattern offset" = "pattern search";
      aliases.hl = "highlight";
      aliases."highlight ls" = "highlight list";
      aliases.hll = "highlight list";
      aliases.hlc = "highlight clear";
      aliases."highlight set" = "highlight add";
      aliases.hla = "highlight add";
      aliases."highlight delete" = "highlight remove";
      aliases."highlight del" = "highlight remove";
      aliases."highlight unset" = "highlight remove";
      aliases."highlight rm" = "highlight remove";
      aliases.hlr = "highlight remove";
      aliases.fmtstr-helper = "format-string-helper";
      aliases.screen-setup = "tmux-setup";
      aliases.skeleton = "exploit-template";
      aliases.da = "display/s";
      aliases.dt = "pcustom";
      aliases.dq = "hexdump qword";
      aliases.dd = "hexdump dword";
      aliases.dw = "hexdump word";
      aliases.db = "hexdump byte";
      aliases.eq = "patch qword";
      aliases.ed = "patch dword";
      aliases.ew = "patch word";
      aliases.eb = "patch byte";
      aliases.ea = "patch string";
      aliases.dps = "dereference";
      aliases.bp = "break";
      aliases.bl = "info breakpoints";
      aliases.bd = "disable breakpoints";
      aliases.bc = "delete breakpoints";
      aliases.be = "enable breakpoints";
      aliases.tbp = "tbreak";
      aliases.s = "grep";
      aliases.pa = "advance";
      aliases.kp = "info stack";
      aliases.ptc = "finish";
      aliases.uf = "disassemble";
      aliases.stack = "current-stack-frame";
      aliases.full-stack = "current-stack-frame";
      aliases."ida-rpyc goto" = "ida-rpyc jump";
      aliases."ida-rpyc bp" = "ida-rpyc breakpoints";
      aliases."ida-rpyc cmt" = "ida-rpyc comments";
      aliases."ida-rpyc hl" = "ida-rpyc highlight";
      aliases.decompile = "retdec";
    };

  home.packages = [
    # GDB, with custom Python packages for GEF.
    gdb
  ];
}
