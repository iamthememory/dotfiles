{ config, lib, options, pkgs, ... }:
  import ./home {
    inherit config lib options pkgs;
  }
