let
  hostPkgs = import <nixpkgs> {};
  patchedPkgs = hostPkgs.runCommand "nixpkgs" { patches = [ ./libffi.patch ]; } ''
    cp -rL ${<nixpkgs>} $out
    cd $out
    chmod -R +w .
    patchPhase
  '';
in {
  armv7l-linux = let
    overlay = self: super: {
      libunwind = super.libunwind.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [ "--target=armv7l-linux" ];
      });
      python = super.python.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [ "--with-system-ffi" ];
      });
      #pythonPackages = self.callPackage (<nixpkgs/pkgs/top-level/python-packages.nix>) {
      #  python = self.python;
      #};
    };
    pkgs = import patchedPkgs { system = "armv7l-linux"; overlays = [ overlay ]; };
  in {
    inherit (pkgs) stdenv libunwind libffi python;
    pythonPackages2 = {
      inherit (pkgs.pythonPackages) setuptools;
    };
  };
}
