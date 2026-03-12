# A module with defaults for itd.
{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.services.itd;

  tomlFormat = pkgs.formats.toml { };
in
{
  # The options to add.
  options.services.itd = {
    enable = lib.mkEnableOption "itd InfiniTime Daemon";

    package = lib.mkPackageOption pkgs "itd-full" { };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/itd/itd.toml`.
        See <https://gitea.elara.ws/Elara6331/itd/src/commit/37c61695aaf9d9fdec6cada79eca2ee6c55e3c31/itd.toml>
        for options.
      '';
      example = lib.literalExpression ''
        {
          metrics = {
            enabled = true;
            heartRate.enabled = true;
          };
          weather = {
            enabled = true;
            location = "Los Angeles, CA";
          };
        }
      '';
    };
  };

  # The actual config changes.
  config = lib.mkIf cfg.enable {
    # Make sure itd is installed.
    home.packages = [ cfg.package ];

    # Add the service.
    systemd.user.services.itd = {
      Unit = {
        Description = "InfiniTime Daemon (itd)";
        After = "bluetooth.target";
      };

      Service = {
        ExecStart = "${cfg.package}/bin/itd";
        Restart = "always";
        StandardOutput = "journal";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    # Generate the config.
    xdg.configFile."itd/itd.toml" = lib.mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "itd.toml" cfg.settings;
    };
  };
}
