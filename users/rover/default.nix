{
  config,
  pkgs,
  lib,
  ...
}:

let
  defaultUser = "rover";
in
{
  options = {
    users.defaultUser = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    users = {
      defaultUser = defaultUser;
      users.${defaultUser} = {
        shell = pkgs.zsh;
        isNormalUser = true;
        description = "rover";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    };
  };
}
