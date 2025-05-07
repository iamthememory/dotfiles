# Godot configuration.
{ config
, pkgs
, ...
}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-godot
  ];

  # Add an alias to listen for the godot telling us to open files.
  home.shellAliases.gdnvim =
    "${config.home.profileDirectory}/bin/nvim --listen ./godothost.pipe";

  # Configuration for godot.
  programs.neovim.extraConfig = ''
    " Register ALE godot LSP server.
    call ale#linter#Define('gdscript', {
    \   'name': 'godot',
    \   'lsp': 'socket',
    \   'address': '127.0.0.1:6005',
    \   'project_root': 'project.godot',
    \})
  '';

  programs.neovim.extraLuaConfig = ''
    vim.lsp.config('gdscript',
      require('coq').lsp_ensure_capabilities({
        name = "godot",
        cmd = vim.lsp.rpc.connect("127.0.0.1", 6005)
      })
    )
    vim.lsp.enable('gdscript')

    local dap = require("dap")

    dap.adapters.godot = {
      type = "server",
      host = "127.0.0.1",
      port = 6006,
    }

    dap.configurations.gdscript = {
      {
        type = "godot",
        request = "launch",
        name = "Launch scene",
        project = "''${workspaceFolder}",
      },
    }
  '';

  # Buffer settings for godot.
  xdg.configFile."nvim/ftplugin/gdscript.vim".text = ''
    " Use hard tabs.
    setlocal noexpandtab

    " Fold text by treesitter.
    setlocal foldmethod=expr
    setlocal foldexpr=v:lua.vim.treesitter.foldexpr()

    " Set shifts and expanded tabs to four spaces.
    setlocal shiftwidth=4
    setlocal softtabstop=4

    " Treat hard tabs as 4 spaces.
    setlocal tabstop=4

    " Try to wrap text at 80 characters.
    setlocal textwidth=80
  '';
}
