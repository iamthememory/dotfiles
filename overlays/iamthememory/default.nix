self: super:
  {
    # Overridden and custom packages.
    bumpversion = import ./packages/bumpversion.nix { inherit self super; };
    cataclysm-dda-git = import ./packages/cataclysm-dda-git.nix { inherit self super; };
    chromium = import ./packages/chromium.nix { inherit self super; };
    ftb = import ./packages/ftb.nix { inherit self super; };
    gitAndTools = import ./packages/gitAndTools { inherit self super; };
    gnupg = import ./packages/gnupg.nix { inherit self super; };
    i3pystatus = import ./packages/i3pystatus.nix { inherit self super; };
    metasploit = super.callPackage ./packages/metasploit { };
    nerdfonts = import ./packages/nerdfonts { inherit self super; };
    nxBender = import ./packages/nxBender.nix { inherit self super; };
    pandoc = import ./packages/pandoc.nix { inherit self super; };
    pydf = import ./packages/pydf.nix { inherit self super; };
    python3Packages = import ./packages/python3Packages { inherit self super; };
    speedtest-cli = import ./packages/speedtest-cli.nix { inherit self super; };
    st = import ./packages/st { inherit self super; };
    steam = import ./packages/steam.nix { inherit self super; };
    steam-run = import ./packages/steam-run.nix { inherit self super; };
    tinyfugue = import ./packages/tinyfugue.nix { inherit self super; };
    wine32 = self.wineStaging;
    wineStaging = import ./packages/wineStaging.nix { inherit self super; };
    winetricks = import ./packages/winetricks.nix { inherit self super; };
  }
