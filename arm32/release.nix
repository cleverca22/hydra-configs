{
  armv7l-linux = let
    overlay = self: super: {
      libunwind = super.libunwind.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [ "--target=armv7l-linux" ];
      });
      python = super.python.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [ "--with-system-ffi" ];
      });
      pythonPackages = self.callPackage ("${self.path}/pkgs/top-level/python-packages.nix") {
        python = self.python;
      };
    };
    pkgs = import <nixpkgs> { system = "armv7l-linux"; overlays = [ overlay ]; };
  in {
    inherit (pkgs) stdenv libunwind libffi python;
    pythonPackages = {
      inherit (pkgs.pythonPackages) setuptools;
    };
  };
}
