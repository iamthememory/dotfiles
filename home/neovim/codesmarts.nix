# Neovim completion and linting configuration.
{ config
, pkgs
, ...
}: {
  # Extra code-related neovim configuration.
  #programs.neovim.extraConfig = ''
  #  " Check if we're in a word or if right before the cursor is whitespace.
  #  function! s:check_back_space() abort
  #    let col = col('.') - 1
  #    return !col || getline('.')[col - 1] =~# '\s'
  #  endfunction

  #  " Use tab for completion, snippet expansion, and jumping.
  #  inoremap <silent><expr> <TAB>
  #    \ pumvisible() ? "\<C-n>" :
  #    \ <SID>check_back_space() ? "\<TAB>" :
  #    \ deoplete#manual_complete()

  #  " Use shift-tab to move back in the completion list if it's available.
  #  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  #'';

  programs.neovim.plugins = with pkgs.vimPlugins; [
    # A plugin to show diagnostics and linter warnings.
    {
      plugin = ale;
      config = ''
        " Run fixers on each file save.
        let g:ale_fix_on_save = 1

        " General fixers to use.
        if !exists("g:ale_fixers")
          let g:ale_fixers = {}
        endif
        let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']

        " Run all linters that are available by default.
        let g:ale_linters_explicit = 0
      '';
    }

    # A completion engine.
    {
      plugin =
        let
          # FIXME: Remove this when nixpkg #377881 is merged.
          coq_nvim-patched = coq_nvim.overrideAttrs {
            passthru.python3Dependencies = ps: with ps;
              let
                std2-updated = std2.overrideAttrs {
                  version = "0.1.10";

                  src = pkgs.fetchFromGitHub {
                    owner = "ms-jpq";
                    repo = "std2";
                    rev = "808a4ae1e050033a3863c35175894aa2a97320b2";
                    hash = "sha256-Setty21ZMUAedN80ZwiMisQNiQmQR7E9khgVsExEHNc=";
                  };
                };
              in
              [
                pynvim-pp
                pyyaml
                std2-updated
              ];
          };
        in
        coq_nvim-patched;

      config = ''
        let g:coq_settings = {
        \  'auto_start': v:true,
        \  'display.statusline.helo': v:false
        \}
      '';
    }

    # The snippets for coq_nvim.
    coq-artifacts

    # A plugin to show completion function signatures.
    {
      plugin = echodoc-vim;
      config = ''
        let g:echodoc#enable_at_startup = 1
      '';
    }

    # A plugin for integrating neovim with debuggers.
    {
      plugin = nvim-dap;
      config = ''
        local dap = require("dap")
        dap.adapters.gdb = {
          type = "executable",
          command = "gdb",
          args = {
            "--interpreter=dap",
            "--eval-command",
            "set print pretty on",
          },
        }

        dap.configurations.c = {
          {
            name = "Launch",
            type = "gdb",
            request = "launch",
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = "$${workspaceFolder}",
            stopAtBeginningOfMainSubprogram = false,
          },
          {
            name = "Select and attach to process",
            type = "gdb",
            request = "attach",
            program = function()
               return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            pid = function()
               local name = vim.fn.input('Executable name (filter): ')
               return require("dap.utils").pick_process({ filter = name })
            end,
            cwd = '$${workspaceFolder}'
          },
          {
            name = 'Attach to gdbserver :1234',
            type = 'gdb',
            request = 'attach',
            target = 'localhost:1234',
            program = function()
               return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '$${workspaceFolder}'
          },
        }
        dap.configurations.cpp = dap.configurations.c
        dap.configurations.rust = dap.configurations.c
      '';
      type = "lua";
    }

    # A UI for nvim-dap.
    {
      plugin = nvim-dap-ui;
      config = ''
        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.before.attach.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close()
        end
      '';
      type = "lua";
    }

    # A set of LSP configurations.
    nvim-lspconfig

    # A plugin for parsing languages.
    {
      plugin = nvim-treesitter.withAllGrammars;
      config = ''
        require('nvim-treesitter.configs').setup {
          highlight = {
            enable = true,
          }
        }
      '';
      type = "lua";
    }
  ];
}
