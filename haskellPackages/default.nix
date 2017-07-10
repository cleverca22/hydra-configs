{ pulls ? ../simple-pr-dummy.json }:

let
  pkgs = import <nixpkgs>{};
in with (import ../lib.nix { inherit pkgs; });
with pkgs.lib;
let
  defaults = globalDefaults // {
    nixexprinput = "configs";
    nixexprpath = "haskellPackages/release.nix";
  };
  mkJobset = { enabled ? 1, desc }: defaults // {
    inherit enabled;
    schedulingshares = 1;
    description = desc;
    inputs = {
      configs = mkFetchGithub "https://github.com/cleverca22/hydra-configs master";
      nixpkgs = mkFetchGithub "https://github.com/cleverca22/nixpkgs haskell-split-output";
    };
  };
  primary_jobsets = {
    nixpkgs = mkJobset {
      desc = "nixpkgs";
    };
  };
  jobsetsAttrs = primary_jobsets;
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}
