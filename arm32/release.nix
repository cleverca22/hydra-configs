{
  armv7l-linux = let
    pkgs = import <nixpkgs> { system = "armv7l-linux"; };
  in {
    inherit (pkgs) stdenv;
  };
}
