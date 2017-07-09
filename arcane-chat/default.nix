{ pulls ? ../simple-pr-dummy.json }:

let
  pkgs = import <nixpkgs>{};
in with (import ../lib.nix { inherit pkgs; });
with pkgs.lib;
let
  mkProjectJobset = { url?null, branch?"master", nixpkgs-repo?"nixpkgs-channels.git", nixpkgs-branch, ... }@args: mkJobset ((removeAttrs args [ "nixpkgs-branch" "url" "branch" "nixpkgs-repo" ]) // {
    nixexprpath = "release.nix";
    nixexprinput = "arcane-chat";
    inputs = {
      arcane-chat = mkFetchGithub (if url != null then "${url} ${branch}" else "https://github.com/arcane-chat/arcane-chat ${branch}");
      nixpkgs = mkFetchGithub "https://github.com/nixos/${nixpkgs-repo} ${nixpkgs-branch}";
    };
  });
  primary_jobsets = {
    arcane-chat-unstable = mkProjectJobset {
      description = "arcane-chat-unstable";
      nixpkgs-branch = "nixos-unstable-small";
      enabled = 0;
    };
    arcane-chat-master = mkProjectJobset {
      description = "arcane-chat-master";
      nixpkgs-branch = "master";
      nixpkgs-repo = "nixpkgs.git";
      enabled = 0;
    };
    "arcane-chat-16.09" = mkProjectJobset {
      description = "arcane-chat-16.09";
      nixpkgs-branch = "nixos-16.09";
    };
  };
  pr_data = builtins.fromJSON (builtins.readFile pulls);
  makePr = num: info: {
    name = "arcane-chat-${num}";
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
