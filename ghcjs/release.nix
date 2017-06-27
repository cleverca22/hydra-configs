{ nixpkgs ? <nixpkgs> }:

let
  pkgs = import nixpkgs {};
in pkgs.haskell.packages.ghcjs
