{
  pkgs,
  pkgsets,
}:
rec {
  mkhomeenv = name: packages: pkgs.buildEnv {
    inherit name;
    paths = with pkgs; packages ++ [
      desktop_file_utils
      shared_mime_info
      texinfoInteractive
      xdg_utils
    ];

    pathsToLink = [
      "/bin"
      "/etc"
      "/lib/libexec"
      "/lib/seahorse"
      "/share/applications"
      "/share/doc"
      "/share/fonts"
      "/share/icons"
      "/share/info"
      "/share/man"
      "/share/mime"
    ];

    extraOutputsToInstall = [
      "bin"
      "devdoc"
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
      if [ -x $out/bin/update-mime-database -a -w $out/share/mime ]; then
        $out/bin/update-mime-database $out/share/mime
      fi
      if [ -x $out/bin/update-desktop-database -a -w $out/share/applications ]; then
        $out/bin/update-desktop-database -v $out/share/applications
      fi
    '';
  };

  mkdevenv = args@{name, devpkgs}:
  pkgs.buildFHSUserEnv {
    inherit name;

    targetPkgs = pkgs_:
      devpkgs
      ++ [
        pkgs_.ncurses
      ] ++ pkgsets.cli-base
      ++ pkgsets.cli-devel
      ++ pkgsets.cli-utilities;

    runScript = "zsh";
  };
}
