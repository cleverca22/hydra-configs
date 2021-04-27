{ }:

with import ../lib.nix;
let
  defaults = globalDefaults // {
    nixexprinput = "nixos-configs";
    nixexprpath = "release.nix";
    checkinterval = 3600;
    keepnr = 3;
  };
  nixos-configs = defaults // {
    description = "nixos-configs";
    inputs = {
      nixos-configs = mkFetchGithub "https://github.com/cleverca22/nixos-configs master";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable-small";
    };
  };
  nixos-configs-2009 = defaults // {
    description = "nixos-configs";
    inputs = {
      nixos-configs = mkFetchGithub "https://github.com/cleverca22/nixos-configs master";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs.git nixos-20.09";
    };
  };
  jobsetsAttrs = {
    inherit nixos-configs nixos-configs-2009;
  };
in {
  jobsets = makeSpec jobsetsAttrs;
}
