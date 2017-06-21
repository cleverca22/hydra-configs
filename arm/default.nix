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
      nixexprinput = "nix";
      nixexprpath = "release-arm.nix";
      inputs = {
        nix = { type="path"; value="/etc/nixos/nix"; emailresponsible = false; };
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable-small";
      };
    };
  };
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}
