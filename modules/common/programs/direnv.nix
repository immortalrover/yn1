{ config, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    direnvrcExtra = ''
      echo "loaded direnv!"
    '';
    nix-direnv.enable = true;
  };
}
