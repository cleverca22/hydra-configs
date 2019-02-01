{ }:

let
  pkgs = import <nixpkgs> {};
in with (import ../lib.nix { inherit pkgs; });
with pkgs.lib;
let
  defaults = globalDefaults // {
    nixexprinput = "nixos-configs";
    nixexprpath = "release.nix";
    checkinterval = 600;
  };
  nixos-configs = defaults // {
    description = "nixos-configs";
    inputs = {
      nixos-configs = mkFetchGithub "https://github.com/cleverca22/nixos-configs master";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable-small";
    };
  };
  nixos-configs-1809 = defaults // {
    description = "nixos-configs";
    inputs = {
      nixos-configs = mkFetchGithub "https://github.com/cleverca22/nixos-configs master";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-18.09";
    };
  };
  jobsetsAttrs = {
    inherit nixos-configs nixos-configs-1809;
  };
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}
