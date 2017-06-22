{ pkgs }:

{
  mkFetchGithub = value: {
    inherit value;
    type = "git";
    emailresponsible = false;
  };
}
