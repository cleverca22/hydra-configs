let
  pkgs = import <nixpkgs>{};
in with (import ../lib.nix { inherit pkgs; });
let
  defaults = globalDefaults // {
    nixexprinput = "extra";
  };
  jobsetsAttrs = {
    nix = defaults // {
      description = "nix on arm";
      nixexprpath = "arm/nix/release-arm.nix";
      inputs = {
        nix = mkFetchGithub "https://github.com/nixos/nix master";
        extra = mkFetchGithub "https://github.com/cleverca22/hydra-configs master";
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable-small";
      };
    };
    nixpkgs = defaults // {
      nixexprpath = "arm/nixpkgs/release-arm.nix";
      inputs = {
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable-small";
        extra = mkFetchGithub "https://github.com/cleverca22/hydra-configs master";
        supportedSystems = { type = "nix"; value = ''[ "armv7l-linux" ]''; emailresponsible = false; };
      };
    };
  };
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}
