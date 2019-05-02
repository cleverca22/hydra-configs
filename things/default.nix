{ }:

let
  pkgs = import <nixpkgs> {};
in with (import ../lib.nix { inherit pkgs; });
with pkgs.lib;
let
  defaults = globalDefaults // {
    nixexprpath = "release.nix";
    checkinterval = 600;
  };
  cachecache = defaults // {
    nixexprinput = "cachecache";
    description = "a nix binary cache cache";
    inputs = {
      cachecache = mkFetchGithub "https://github.com/cleverca22/cachecache master";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable-small";
    };
  };
  jobsetsAttrs = {
    inherit cachecache;
  };
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}
