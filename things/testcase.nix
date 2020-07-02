let
  self = ./.;
  filtered = builtins.filterSource (name: type: let
    baseName = baseNameOf (toString name);
  in baseName == "testcase.txt"
  ) ./.;
  pkgs = import <nixpkgs> {};
in {
  testcase = pkgs.writeText "testcase" (builtins.readFile ./testcase.txt);
}
