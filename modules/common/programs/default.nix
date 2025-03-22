{ config, pkgs, ... }:

let
  pp = with pkgs.python312Packages; [
    litellm
    socksio
  ];
  shell-gpt-litellm = pkgs.shell-gpt.overrideAttrs (
    finalAttrs: previousAttrs: {
      propagatedBuildInputs = previousAttrs.propagatedBuildInputs ++ pp;
    }
  );
in
{
  imports = [
    ./direnv.nix
    ./zsh.nix
  ];
  programs = {
    firefox.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };
  environment.systemPackages =
    with pkgs;
    [
      vim
      wget
      git
      nvtopPackages.full
      netease-cloud-music-gtk
      obs-studio
      nix-index
      tree
      xclip
      vlc
      ffmpeg
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
      shell-gpt-litellm
    ];
}
