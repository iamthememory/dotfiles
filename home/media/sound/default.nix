# Sound-related media packages and configuration.
{ pkgs
, ...
}: {
  imports = [
    ./dev.nix
  ];

  home.packages = with pkgs; [
    # A tool for tagging music files.
    picard
  ];
}
