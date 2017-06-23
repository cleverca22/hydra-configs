{ pulls ? ../simple-pr-dummy.json }:

let
  pkgs = import <nixpkgs>{};
in with (import ../lib.nix { inherit pkgs; });
with pkgs.lib;
let
  defaults = globalDefaults // {
    nixexprinput = "arcane-chat";
    nixexprpath = "release.nix";
  };
  mkJobset = { desc, url?null, branch?"master", nixpkgs-repo?"nixpkgs-channels.git", nixpkgs-branch }: defaults // {
    description = desc;
    inputs = {
      arcane-chat = mkFetchGithub (if url != null then "${url} ${branch}" else "https://github.com/cleverca22/arcane-chat ${branch}");
      nixpkgs = mkFetchGithub "https://github.com/nixos/${nixpkgs-repo} ${nixpkgs-branch}";
    };
  };
  primary_jobsets = {
    arcane-chat-unstable = mkJobset {
      desc = "arcane-chat-unstable";
      nixpkgs-branch = "nixos-unstable-small";
    };
    arcane-chat-master = mkJobset {
      desc = "arcane-chat-master";
      nixpkgs-branch = "master";
      nixpkgs-repo = "nixpkgs.git";
    };
    "arcane-chat-16.09" = mkJobset {
      desc = "arcane-chat-16.09";
      nixpkgs-branch = "nixos-16.09";
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
  jobsetsAttrs = pull_requests // primary_jobsets;
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}
