{ }:

with import ../lib.nix;
let
  defaults = globalDefaults // {
    nixexprpath = "release.nix";
    checkinterval = 600;
  };
  cachecache = defaults // {
    keepnr = 3;
    nixexprinput = "cachecache";
    description = "a nix binary cache cache";
    inputs = {
      cachecache = mkFetchGithub "https://github.com/cleverca22/cachecache master";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable";
    };
  };
  jobsetsAttrs = {
    inherit cachecache;
  };
in {
  jobsets = makeSpec jobsetsAttrs;
}
