{ pulls }:

let
  pkgs = import <nixpkgs>{};
in with (import ../lib.nix { inherit pkgs; });
let
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
    toxvpn-unstable = defaults // {
      description = "toxvpn";
      nixexprinput = "toxvpn";
      nixexprpath = "release.nix";
      inputs = {
        toxvpn = mkFetchGithub "https://github.com/cleverca22/toxvpn master";
        test = { type = "path"; value = pulls; emailresponsible = false; };
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable-small";
      };
    };
  };
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}
