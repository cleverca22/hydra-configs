{ nixpkgs ? <nixpkgs> }:

let
  pkgs = import nixpkgs {};
in {
  haskell.packages = {
    ghcjs = pkgs.haskell.packages.ghcjs;
    ghcjsHEAD = {
      inherit (pkgs.haskell.packages.ghcjsHEAD) Cabal;
    };
  };
}
