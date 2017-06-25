{ nixpkgs }:

with import <nix/release.nix> {
  inherit nixpkgs;
  systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "armv6l-linux" "armv7l-linux" ];
};

{
  inherit build binaryTarball coverage tarball;
}
