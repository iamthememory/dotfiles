# NixOS settings for nightmare.
{ config
, inputs
, pkgs
, ...
}: {
  imports =
    let
      base-config = import "${inputs.mobile-nixos}/lib/configuration.nix"
        { device = "pine64-pinephone"; };
    in
    [
      # Import the base pinephone config.
      base-config
    ];
}
