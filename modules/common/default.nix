{ config, pkgs, ... }:

{
  imports = [
    ./sops.nix
    ./fonts.nix
    ./nix-settings.nix
    ./programs
    ./services
  ];
}
