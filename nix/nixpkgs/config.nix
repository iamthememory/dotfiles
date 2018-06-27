with import <nixpkgs> {};

{
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; {

    # My basic packages.
    base = pkgs.buildEnv {
      name = "base-packages";
      paths = [
        man
        nix
        texinfoInteractive
        zsh
      ];

      pathsToLink = [
        "/bin"
        "/etc"
        "/share/doc"
        "/share/info"
        "/share/man"
      ];

      extraOutputsToInstall = [
        "doc"
        "info"
        "man"
      ];
      postBuild = ''
        if [ -x $out/bin/install-info -a -w $out/share/info ]; then
          shopt -s nullglob
          for i in $out/share/info/*.info $out/share/info/*.info.gz; do
              $out/bin/install-info $i $out/share/info/dir
          done
        fi
      '';
    };

  };
}
