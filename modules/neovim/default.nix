{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lua-language-server
    pyright
    nil
    nixfmt-rfc-style
    prettierd
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };
}
