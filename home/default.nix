{ pkgs, ... }:
  {
    fonts = import ./fonts.nix { inherit pkgs; };

    home = import ./home { inherit pkgs; };

    manual = {
      html = {
        enable = true;
      };

      manpages = {
        enable = true;
      };
    };

    news = {
      display = "notify";
    };

    programs = import ./programs { inherit pkgs; };
  }
