# Configuration for various compatibility features.
{ lib
, pkgs
, ...
}: {
  # Extra platforms to provide userspace emulation for via QEMU.
  boot.binfmt.emulatedSystems =
    let
      # All architectures to emulate.
      arches = [
        # Various ARM architectures.
        "aarch64-linux"
        "aarch64_be-linux"
        "armv6l-linux"
        "armv7l-linux"

        # Intel-compatible architectures.
        "i386-linux"
        "i486-linux"
        "i586-linux"
        "i686-linux"
        "x86_64-linux"

        # RISC-V architectures.
        "riscv32-linux"
        "riscv64-linux"

        # Webassembly.
        "wasm32-wasi"
        "wasm64-wasi"
      ];

      # Filter out any architectures that the current system can natively run.
      filterNative = system: archList:
        let
          # Returns true if the given element is in the given list.
          contains = elem: list: builtins.any (x: x == elem) list;

          # Which architectures are able to natively run other architecture
          # binaries.
          compat = {
            "i486-linux" = [
              "i386-linux"
            ];

            "i586-linux" = [
              "i386-linux"
              "i486-linux"
            ];

            "i686-linux" = [
              "i386-linux"
              "i486-linux"
              "i586-linux"
            ];

            "x86_64-linux" = [
              "i386-linux"
              "i486-linux"
              "i586-linux"
              "i686-linux"
            ];
          };

          # Return whether a given architecture is natively executable.
          isNative = arch:
            arch == system || (contains arch (compat."${system}" or [ ]));

          # Return if a given architecture needs to be emulated.
          isNonNative = arch: !(isNative arch);
        in
        builtins.filter isNonNative archList;
    in
    filterNative pkgs.stdenv.hostPlatform.system arches;

  # Load the KVM module in the kernel for faster native VMs.
  boot.kernelModules = [
    "kvm-intel"
  ];
}
