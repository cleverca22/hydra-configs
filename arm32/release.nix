{
  armv7l-linux = let
    overlay = self: super: {
      libunwind = super.libunwind.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [ "--target=armv7l-linux" ];
      });
    };
    pkgs = import <nixpkgs> { system = "armv7l-linux"; overlays = [ overlay ]; };
  in {
    inherit (pkgs) stdenv libunwind;
    pythonPackages = {
      inherit (pkgs.pythonPackages) setuptools;
    };
  };
}
