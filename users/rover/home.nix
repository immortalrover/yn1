{ config, pkgs, ... }:
let
  nvimPath = "${config.home.homeDirectory}/.nixos/nvim";
  zshPath = "${config.home.homeDirectory}/.nixos/dotfiles/.zshrc";
in
{
  home = {
    username = "rover";
    homeDirectory = "/home/rover";
    file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink zshPath;
  };

  xdg = {
    enable = true;
    configFile = {
      "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink nvimPath;
        recursive = true;
      };
    };
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
