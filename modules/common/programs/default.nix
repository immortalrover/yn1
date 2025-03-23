# NixOS system configuration
{ config, pkgs, ... }:

let
  # Python packages to add to shell-gpt
  pp = with pkgs.python312Packages; [
    litellm
    socksio
  ];

  # Custom shell-gpt with additional python packages
  shell-gpt-litellm = pkgs.shell-gpt.overrideAttrs (
    finalAttrs: previousAttrs: {
      propagatedBuildInputs = previousAttrs.propagatedBuildInputs ++ pp;
    }
  );
in
{
  # Import additional configuration files
  imports = [
    ./direnv.nix
    ./zsh.nix
  ];

  # Program configurations
  programs = {
    # Enable Firefox
    firefox.enable = true;

    # Configure GnuPG agent
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };

  # System packages to install
  environment.systemPackages =
    with pkgs;
    [
      # Basic utilities
      vim
      wget
      git

      # System monitoring
      nvtopPackages.full

      # Applications
      netease-cloud-music-gtk
      obs-studio
      nix-index
      tree
      xclip
      vlc
      ffmpeg

      # Development tools
      fzf
      manix
      lazygit
      age
      telegram-desktop
      sops
      ghostty
      nodejs_23
    ]
    ++ [
      # Custom shell-gpt package
      shell-gpt-litellm
    ];
}
