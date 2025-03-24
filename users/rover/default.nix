{ config, pkgs, ... }:
{
  users.users.${config.users.defaultUser} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = config.users.defaultUser;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
