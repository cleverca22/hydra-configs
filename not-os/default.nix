{ pulls ? ../simple-pr-dummy.json }:

let
  pkgs = import <nixpkgs>{};
in with import ../lib.nix;
with pkgs.lib;
let
  systems = ''[ "x86_64-linux" "i686-linux" "armv7l-linux" "aarch64-linux" ]'';
  defaults = globalDefaults // {
    nixexprinput = "notos";
    nixexprpath = "release.nix";
    checkinterval = 3600;
  };
  primary_jobsets = {
    notos-unstable = defaults // {
      description = "notos-unstable";
      inputs = {
        notos = mkFetchGithub "https://github.com/cleverca22/not-os master";
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs nixos-unstable-small";
        supportedSystems2 = { type = "nix"; value = systems; emailresponsible = false; };
      };
    };
    notos-master = defaults // {
      description = "notos-master";
      inputs = {
        notos = mkFetchGithub "https://github.com/cleverca22/not-os master";
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs master";
        supportedSystems2 = { type = "nix"; value = systems; emailresponsible = false; };
      };
    };
  };
  pr_data = builtins.fromJSON (builtins.readFile pulls);
  makePr = num: info: {
    name = "notos-${num}";
    value = defaults // {
      description = "PR ${num}: ${info.title}";
      inputs = {
        notos = mkFetchGithub "https://github.com/cleverca22/not-os pull/${num}/head";
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs nixos-unstable-small";
        supportedSystems2 = { type = "nix"; value = systems; emailresponsible = false; };
      };
    };
  };
  pull_requests = listToAttrs (mapAttrsToList makePr pr_data);
  jobsetsAttrs = pull_requests // primary_jobsets;
in {
  jobsets = makeSpec jobsetsAttrs;
}
