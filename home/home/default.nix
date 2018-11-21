{ pkgs, ... }:
  rec {
    extraOutputsToInstall = [
      "bin"
      "devdoc"
      "doc"
      "info"
      "man"
    ];

    keyboard = {
      options = [
        "compose:lwin"
      ];
    };

    language = {
      base = "en_US";
    };

    packages = pkgs.pkgsets.gui-full;

    sessionVariables ={
      EDITOR = "vim";
      TEXMFHOME = "\${HOME}/texmf";
    };
  }
