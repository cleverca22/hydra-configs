{ }:

with import ../lib.nix;
let
  defaults = globalDefaults // {
    nixexprinput = "nixos-configs";
    nixexprpath = "release.nix";
    checkinterval = 600;
    keepnr = 3;
  };
  nixos-configs = defaults // {
    description = "nixos-configs";
    inputs = {
      nixos-configs = mkFetchGithub "https://github.com/cleverca22/nixos-configs master";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable-small";
    };
  };
  nixos-configs-2003 = defaults // {
    description = "nixos-configs";
    inputs = {
      nixos-configs = mkFetchGithub "https://github.com/cleverca22/nixos-configs master";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-20.03";
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
    inherit nixos-configs nixos-configs-2009 nixos-configs-2003;
  };
in {
  jobsets = makeSpec jobsetsAttrs;
}
