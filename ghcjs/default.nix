{ pulls ? ../simple-pr-dummy.json }:

let
  pkgs = import <nixpkgs>{};
in with (import ../lib.nix { inherit pkgs; });
with pkgs.lib;
let
  defaults = globalDefaults // {
    nixexprinput = "configs";
    nixexprpath = "ghcjs/release.nix";
  };
  mkJobset = { enabled ? 1, desc, url?null, branch?"master", nixpkgs-repo?"nixpkgs-channels.git", nixpkgs-branch }: defaults // {
    inherit enabled;
    description = desc;
    inputs = {
      configs = mkFetchGithub (if url != null then "${url} ${branch}" else "https://github.com/cleverca22/hydra-configs ${branch}");
      nixpkgs = mkFetchGithub "https://github.com/nixos/${nixpkgs-repo} ${nixpkgs-branch}";
    };
  };
  primary_jobsets = {
    ghcjs-nixpkgs-unstable = mkJobset {
      desc = "ghcjs-nixpkgs-unstable";
      nixpkgs-branch = "nixpkgs-unstable";
      nixpkgs-repo = "nixpkgs-channels.git";
    };
  };
  pr_data = builtins.fromJSON (builtins.readFile pulls);
  makePr = num: info: {
    name = "arcane-chat-${num}";
    value = mkJobset {
      desc = "PR ${num}: ${info.title}";
      url = "https://github.com/${info.head.repo.owner.login}/${info.head.repo.name}.git";
      branch = info.head.ref;
      nixpkgs-branch = "master";
      nixpkgs-repo = "nixpkgs.git";
    };
  };
  pull_requests = listToAttrs (mapAttrsToList makePr pr_data);
  jobsetsAttrs = primary_jobsets;
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}
