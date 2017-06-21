let
  pkgs = import <nixpkgs>{};
  mkFetchGithub = value: {
    inherit value;
    type = "git";
    emailresponsible = false;
  };
  defaults = {
    enabled = 1;
    hidden = false;
    keepnr = 10;
    schedulingshares = 100;
    checkinterval = 60;
    enableemail = false;
    emailoverride = "";
  };
  jobsetsAttrs = {
    nix = defaults // {
      description = "nix on arm";
      nixexprinput = "extra";
      nixexprpath = "arm/release-arm.nix";
      inputs = {
        nix = mkFetchGithub "https://github.com/nixos/nix master";
        extra = mkFetchGithub "https://github.com/cleverca22/hydra-configs master";
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable-small";
      };
    };
  };
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}
