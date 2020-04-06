{ }:

with import ../lib.nix;
let
  defaults = globalDefaults // {
    nixexprpath = "release.nix";
    checkinterval = 600;
  };
  cachecache = defaults // {
    keepnr = 1;
    nixexprinput = "cachecache";
    description = "a nix binary cache cache";
    inputs = {
      cachecache = mkFetchGithub "https://github.com/cleverca22/cachecache master";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable";
    };
  };
  rpi-open-firmware = defaults // {
    keepnr = 20;
    nixexprinput = "rpi-open-firmware";
    description = "rpi open source firmware";
    inputs = {
      rpi-open-firmware = mkFetchGithub "https://github.com/cleverca22/rpi-open-firmware";
    };
  };
  littlekernel = defaults // {
    keepnr = 20;
    nixexprinput = "lk";
    description = "littlekernel";
    inputs = {
      lk = mkFetchGithub "https://github.com/cleverca22/lk vc4";
    };
  };
  jobsetsAttrs = {
    inherit cachecache rpi-open-firmware littlekernel;
  };
in {
  jobsets = makeSpec jobsetsAttrs;
}
