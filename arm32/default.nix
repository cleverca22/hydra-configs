let
  pkgs = import <nixpkgs>{};
in with import ../lib.nix;
with pkgs.lib;
let
  defaults = globalDefaults // {
    nixexprinput = "hydra-configs";
    nixexprpath = "arm32/release.nix";
    checkinterval = 3600;
  };
  jobsetsAttrs = {
    notos-unstable = defaults // {
      description = "arm32 unstable";
      inputs = {
        configs = mkFetchGithub "https://github.com/cleverca22/hydra-configs master";
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs nixos-unstable-small";
      };
    };
  };
in {
  jobsets = makeSpec jobsetsAttrs;
}
