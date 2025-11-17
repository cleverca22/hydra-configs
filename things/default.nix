{ }:

with import ../lib.nix;
let
  defaults = globalDefaults // {
    nixexprpath = "release.nix";
    checkinterval = 3600 * 24;
  };
  cachecache = defaults // {
    keepnr = 1;
    nixexprinput = "cachecache";
    description = "a nix binary cache cache";
    inputs = {
      cachecache = mkFetchGithub "https://github.com/cleverca22/cachecache master";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs nixos-unstable";
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
    keepnr = 5;
    nixexprinput = "lk";
    description = "littlekernel";
    inputs = {
      lk = mkFetchGithub "https://github.com/cleverca22/lk vc4";
    };
  };
  littlekernel-overlay = defaults // {
    keepnr = 5;
    nixexprinput = "lk-overlay";
    description = "littlekernel";
    inputs = {
      lk-overlay = mkFetchGithub "https://github.com/librerpi/lk-overlay";
    };
  };
  rpi-tools = defaults // {
    keepnr = 20;
    nixexprinput = "rpi-tools";
    description = "rpi-tools";
    inputs = {
      rpi-tools = mkFetchGithub "https://github.com/librerpi/rpi-tools";
    };
  };
  esp32-baremetal = defaults // {
    keepnr = 1;
    nixexprinput = "self";
    nixexprpath = "things/esp32.nix";
    description = "esp32-baremetal";
    inputs = {
      esp32-baremetal = mkFetchGithub "https://github.com/taktoa/esp32-baremetal";
      self = mkFetchGithub "https://github.com/cleverca22/hydra-configs";
    };
  };
  "esp-idf.nix" = defaults // {
    keepnr = 1;
    nixexprinput = "esp-idf.nix";
    nixexprpath = "default.nix";
    description = "esp-idf.nix";
    inputs = {
      "esp-idf.nix" = mkFetchGithub "https://github.com/cleverca22/esp-idf.nix";
    };
  };
  testcase = defaults // {
    keepnr = 10;
    nixexprinput = "testcase";
    nixexprpath = "things/testcase.nix";
    inputs = {
      testcase = mkFetchGithub "https://github.com/cleverca22/hydra-configs";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs nixos-unstable";
    };
  };
  arm32 = defaults // {
    keepnr = 10;
    nixexprinput = "hydra-configs";
    nixexprpath = "arm32/release.nix";
    inputs = {
      hydra-configs = mkFetchGithub "https://github.com/cleverca22/hydra-configs";
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs nixos-unstable";
    };
  };
  lk = defaults // {
    flake = "github:librerpi/lk-overlay";
    type = 1;
    checkinterval = 3600;
  };
  jobsetsAttrs = {
    inherit cachecache rpi-open-firmware littlekernel testcase esp32-baremetal "esp-idf.nix" rpi-tools littlekernel-overlay arm32 lk;
  };
in {
  jobsets = makeSpec jobsetsAttrs;
}
