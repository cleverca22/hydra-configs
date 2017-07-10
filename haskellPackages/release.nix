{ nixpkgs ? <nixpkgs> }:

let
  pkgs = import nixpkgs {};
  subset = input: {
    inherit (input) xmonad shake git-annex blaze ghc-mod highjson-swagger servant;
  };
in {
  haskell.packages = {
    ghc7103 = subset pkgs.haskell.packages.ghc7103;
    ghc802 = subset pkgs.haskell.packages.ghc802;
  };
}
