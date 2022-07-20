# Display-related GUI configuration.
{ config
, inputs
, lib
, pkgs
, ...
}:
let
  # A script to take a screenshot to a directory, organized by year and month.
  screenshot =
    with pkgs;
    let
      # The path to the profile's bin directory.
      profileBin = "${config.home.profileDirectory}/bin";

      # The path to the date binary in the profile.
      date = "${profileBin}/date";

      # The path to the flameshot binary in the profile.
      flameshot = "${profileBin}/flameshot";

      # The base screenshot directory, ~/screenshots.
      screenshotDirectory = "${config.home.homeDirectory}/screenshots";
    in
    writeShellScriptBin "screenshot.sh" ''
      #!${stdenv.shell}

      # The directory for a screenshot in the current month in the default
      # timezone.
      screendir="$(${date} "+${screenshotDirectory}/%Y/%m")"

      # If the screenshot directory doesn't exist, create it.
      if [ ! -e "$screendir" ]
      then
        mkdir -pv "$screendir"
      fi

      # Tell an existing flameshot service to take a screenshot in the month
      # directory.
      exec ${flameshot} gui -p "$screendir"
    '';
in
{
  # Enable managing the GTK configuration.
  gtk.enable = true;

  # Use Adwaita dark as the GTK theme.
  gtk.theme.name = "Adwaita-dark";

  home.packages =
    let
      # Flameshot, with its priority increased to avoid a collision with the
      # completion also provided by the general ZSH completions.
      flameshot = pkgs.flameshot.overrideAttrs (oldAttrs: {
        meta.priority = 20;
      });

      # transset, for setting window transparency without the rounding issues
      # picom-trans has, but patched to not delete the X11 property for
      # transparency if a window is set to fully opaque, because for some reason
      # picom turns windows about 60% opaque when that happens.
      transset = pkgs.xorg.transset.overrideAttrs (final: orig: {
        patches = [
          ./patches/0000-dont-delete-opacity.patch
        ];
      });
    in
    [
      # Add the redshift package to the profile.
      config.services.redshift.package

      # Coreutils, for the date program used in the screenshot script.
      pkgs.coreutils

      # Flameshot, for the utility used in the screenshot script.
      flameshot

      # Our screenshot script using flameshot.
      screenshot

      # A small utility to set window transparency.
      transset
    ];

  # The script to use for screenshotting, for whatever might want it.
  home.sessionVariables.SCREENSHOT_PROGRAM =
    "${config.home.profileDirectory}/bin/screenshot.sh";

  # Enable autorandr.
  programs.autorandr.enable = true;

  # Enable the flameshot screenshot service.
  services.flameshot.enable = true;

  # Enable the picom compositor.
  services.picom.enable = true;

  # The picom package to use.
  # FIXME: Remove this once a version in nixpkgs plays well with xsecurelock (or
  # after moving to wayland).
  services.picom.package = pkgs.picom.overrideAttrs (finalAttrs: oldAttrs: {
    name = "${oldAttrs.pname}-${finalAttrs.version}";
    version = "${inputs.picom.lastModifiedDate}";
    src = inputs.picom;
  });

  # This forces certain kinds of windows to be considered focus, which helps
  # with xsecurelock to ensure picom doesn't think it should be transparent,
  # defeating the purpose of a lockscreen.
  services.picom.settings.mark-ovredir-focused = true;

  # Enable the redshift daemon to shift color to red at night.
  services.redshift.enable = true;

  # Vary the screen brightness from 80% at night to 100% during the day.
  services.redshift.settings.redshift.brightness-day = "1.0";
  services.redshift.settings.redshift.brightness-night = "0.8";

  # By default, set the location from geoclue.
  services.redshift.provider = lib.mkDefault "geoclue2";

  # Enable the redshift tray icon.
  services.redshift.tray = true;

  # The flameshot configuration.
  xdg.configFile."flameshot/flameshot.ini".text =
    let
      # Make an INI file from an attribute set.
      mkINI = lib.generators.toINI { };

      # Solarized colors.
      inherit (inputs.lib) solarized;

      # The default screenshot directory.
      defaultScreenshotDirectory =
        "${config.home.homeDirectory}/screenshots/misc";
    in
    with solarized.colorNames; mkINI {
      # The main and contrast UI colors.
      General.uiColor = base02;
      General.contrastUiColor = base1;

      # Enable the tray icon.
      General.disabledTrayIcon = false;

      # Save filenames with full timestamps in their names.
      # NOTE: This shouldn't include the extension.
      General.filenamePattern = "screenshot-%Y-%m-%d-%H-%M-%S%z";

      # The default draw color and thickness.
      General.drawColor = violet;
      General.drawThickness = 4;

      # The default screenshot location.
      General.savePath = defaultScreenshotDirectory;
    };

  # Extra commands to run when starting an X11 session.
  xsession.initExtra = ''
    # Run autorandr to set up the attached displays.
    ${config.home.profileDirectory}/bin/autorandr -c
  '';
}
