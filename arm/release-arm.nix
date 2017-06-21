{ nixpkgs }:

with import <nix/release.nix> { inherit nixpkgs; };

{
  inherit build binaryTarball coverage tarball;
}
