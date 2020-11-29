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
  rpi-tools = defaults // {
    keepnr = 20;
    nixexprinput = "rpi-tools";
    description = "rpi-tools";
    inputs = {
      rpi-tools = mkFetchGithub "https://github.com/librerpi/rpi-tools";
    };
  };
  esp32-baremetal = defaults // {
    keepnr = 20;
    nixexprinput = "self";
    nixexprpath = "things/esp32.nix";
    description = "esp32-baremetal";
    inputs = {
      esp32-baremetal = mkFetchGithub "https://github.com/taktoa/esp32-baremetal";
      self = mkFetchGithub "https://github.com/cleverca22/hydra-configs";
    };
  };
  "esp-idf.nix" = defaults // {
    keepnr = 20;
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
      nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable";
    };
  };
  jobsetsAttrs = {
    inherit cachecache rpi-open-firmware littlekernel testcase esp32-baremetal "esp-idf.nix" rpi-tools;
  };
in {
  jobsets = makeSpec jobsetsAttrs;
}
