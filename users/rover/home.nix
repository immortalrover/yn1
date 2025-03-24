{
  config,
  pkgs,
  defaultUser,
  ...
}:
let
  nvimPath = "${config.home.homeDirectory}/.nixos/nvim";
  zshPath = "${config.home.homeDirectory}/.nixos/dotfiles/.zshrc";
  ghosttyPath = "${config.home.homeDirectory}/.nixos/dotfiles/ghostty";
in
{
  home = {
    username = defaultUser;
    homeDirectory = "/home/${defaultUser}";
    file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink zshPath;
  };

  xdg = {
    enable = true;
    configFile = {
      "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink nvimPath;
        recursive = true;
      };
      "ghostty" = {
        source = config.lib.file.mkOutOfStoreSymlink ghosttyPath;
        recursive = true;
      };
    };
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
