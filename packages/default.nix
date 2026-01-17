# Various customized packages.
{ inputs
, pkgs
, revision
, ...
}: {
  cataclysm-dda-git-with-mods = pkgs.callPackage ./cataclysm-dda-git-with-mods {
    cataclysm-dda-git-latest = inputs.cataclysm-dda;
    flake-revision = revision;
    inherit (inputs)
      cataclysm-dda-arcana
      cataclysm-dda-e85-engines
      cataclysm-dda-elf-crops
      cataclysm-dda-grow-more-drugs
      cataclysm-dda-medieval
      cataclysm-dda-mining-enchanced
      cataclysm-dda-minimods
      cataclysm-dda-mining-mod
      cataclysm-dda-mom-submods
      cataclysm-dda-mst-extra
      cataclysm-dda-no-class-limit
      cataclysm-dda-nocts
      cataclysm-dda-pm-world
      cataclysm-dda-sleepscumming
      cataclysm-dda-stats-through-kills
      cataclysm-dda-stats-through-skills
      cataclysm-dda-tankmod
      cdda-sounds
      cdda-tilesets;
  };
}
