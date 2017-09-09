{ pulls ? ../simple-pr-dummy.json }:

let
  pkgs = import <nixpkgs>{};
in with (import ../lib.nix { inherit pkgs; });
with pkgs.lib;
let
  mkProjectJobset = { url?null, branch?"master", nixpkgs-repo?"nixpkgs-channels.git", nixpkgs-branch, ... }@args: mkJobset ((removeAttrs args [ "nixpkgs-branch" "url" "branch" "nixpkgs-repo" ]) // {
    nixexprpath = "release.nix";
    nixexprinput = "haskell-capnp";
    inputs = {
      haskell-capnp = mkFetchGithub (if url != null then "${url} ${branch}" else "https://github.com/zenhack/haskell-capnp ${branch}");
      nixpkgs = mkFetchGithub "https://github.com/nixos/${nixpkgs-repo} ${nixpkgs-branch}";
    };
  });
  primary_jobsets = {
    haskell-capnp-unstable = mkProjectJobset {
      description = "haskell-capnp-unstable";
      nixpkgs-branch = "nixos-unstable-small";
    };
    haskell-capnp-master = mkProjectJobset {
      description = "haskell-capnp-master";
      nixpkgs-branch = "master";
      nixpkgs-repo = "nixpkgs.git";
    };
    "haskell-capnp-16.09" = mkProjectJobset {
      description = "haskell-capnp-16.09";
      nixpkgs-branch = "nixos-16.09";
    };
    haskell-capnp = let
      base = mkProjectJobset {
        description = "haskell-capnp";
        nixpkgs-branch = "dummy";
      };
    in base // { inputs = { inherit (base.inputs) haskell-capnp; }; };
  };
  pr_data = builtins.fromJSON (builtins.readFile pulls);
  makePr = num: info: {
    name = "haskell-capnpt-${num}";
    value = mkProjectJobset {
      description = "PR ${num}: ${info.title}";
      url = "https://github.com/${info.head.repo.owner.login}/${info.head.repo.name}.git";
      branch = info.head.ref;
      nixpkgs-branch = "master";
      nixpkgs-repo = "nixpkgs.git";
    };
  };
  pull_requests = listToAttrs (mapAttrsToList makePr pr_data);
  jobsetsAttrs = pull_requests // primary_jobsets;
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}
