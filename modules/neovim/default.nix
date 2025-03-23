{ config, pkgs, ... }:

{
  # List of system-wide packages to install for development tools
  environment.systemPackages = with pkgs; [
    lua-language-server  # Language server for Lua
    pyright              # Type checker for Python
    nil                  # Nix language server
    nixfmt-rfc-style     # Nix formatter following RFC style
    prettierd            # Prettier formatter daemon
  ];
  # Configure Neovim as the default editor
  programs.neovim = {
    enable = true;       # Enable Neovim
    defaultEditor = true; # Set Neovim as the default editor
    vimAlias = true;     # Create 'vim' alias for Neovim
    viAlias = true;      # Create 'vi' alias for Neovim
  };
}
