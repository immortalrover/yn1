{ config, pkgs, ... }:

{
  imports = [
    ./fcitx5.nix
    ./keyboard.nix
    ./networking.nix
    ./docker.nix
    ./other.nix
  ];
  services = {
    todesk.enable = true;
  };
}
