# COC settings for neovim specifically.
{ config
, lib
, pkgs
, ...
}: with lib; let
  neocfg = config.programs.neovim;
  cfg = config.programs.neovim.coc;

  jsonFormat = pkgs.formats.json { };
in
{
  options = {
    programs.neovim.coc = {
      enable = mkEnableOption "COC for Neovim";

      package = mkOption {
        type = types.package;
        default = pkgs.vimPlugins.coc-nvim;
        example = literalExample "pkgs.vimPlugins.coc-nvim";
        description = ''
          The COC plugin package to install.
        '';
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Custom vimrc lines to configure the COC plugin.
        '';
      };

      settings = mkOption {
        type = jsonFormat.type;
        default = { };
        description = ''
          Configuration to add to <filename>coc-settings.json</filename>.
        '';
      };
    };
  };

  config = mkIf (neocfg.enable && cfg.enable) {
    programs.neovim.plugins = [
      {
        plugin = cfg.package;
        config = cfg.config;
      }
    ];

    xdg.configFile."nvim/coc-settings.json" = mkIf (cfg.settings != { }) {
      source = jsonFormat.generate "coc-settings.json" cfg.settings;
    };
  };
}
