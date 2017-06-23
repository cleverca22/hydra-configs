{ pulls ? ../simple-pr-dummy.json }:

let
  pkgs = import <nixpkgs>{};
in with (import ../lib.nix { inherit pkgs; });
with pkgs.lib;
let
  defaults = {
    enabled = 1;
    hidden = false;
    keepnr = 10;
    schedulingshares = 100;
    checkinterval = 60;
    enableemail = false;
    emailoverride = "";
    nixexprinput = "not-os";
    nixexprpath = "release.nix";
  };
  primary_jobsets = {
    notos-unstable = defaults // {
      description = "notos-unstable";
      inputs = {
        notos = mkFetchGithub "https://github.com/cleverca22/notos master";
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable-small";
        supportedSystems2 = { type = "nix"; value = ''[ "x86_64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ]''; emailresponsible = false; };
      };
    };
    notos-master = defaults // {
      description = "notos-unstable";
      inputs = {
        notos = mkFetchGithub "https://github.com/cleverca22/notos master";
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs.git masterl";
        supportedSystems2 = { type = "nix"; value = ''[ "x86_64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ]''; emailresponsible = false; };
      };
    };
  };
  pr_data = builtins.fromJSON (builtins.readFile pulls);
  makePr = num: info: {
    name = "notos-${num}";
    value = defaults // {
      description = "PR ${num}: ${info.title}";
      inputs = {
        notos = mkFetchGithub "https://github.com/${info.head.repo.owner.login}/${info.head.repo.name}.git ${info.head.ref}";
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable-small";
        supportedSystems2 = { type = "nix"; value = ''[ "x86_64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ]''; emailresponsible = false; };
      };
    };
  };
  pull_requests = listToAttrs (mapAttrsToList makePr pr_data);
  jobsetsAttrs = pull_requests // primary_jobsets;
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}