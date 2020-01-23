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
  rpi-open-firmware = defaults // {
    keepnr = 3;
    nixexprinput = "rpi-open-firmware";
    description = "rpi open source firmware";
    inputs = {
      rpi-open-firmware = mkFetchGithub "https://github.com/cleverca22/rpi-open-firmware";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs 0ee0489d42e";
    };
  };
  jobsetsAttrs = {
    inherit cachecache rpi-open-firmware;
  };
in {
  jobsets = makeSpec jobsetsAttrs;
}
