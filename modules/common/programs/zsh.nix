# ZSH configuration module
{ config, pkgs, inputs, ... }:

{
  # Import sops-nix module for secret management
  imports = [ inputs.sops-nix.nixosModules.sops ];
  # Configure secret for deepseek API key
  sops.secrets.deepseek_api_key.owner = config.users.defaultUser;
  # ZSH program configuration
  programs.zsh = {
    # Enable ZSH shell
    enable = true;
    # Enable command completion
    enableCompletion = true;
    # Oh My Zsh configuration
    ohMyZsh = {
      enable = true;
      theme = "kardan";
      plugins = [
        "vi-mode"
      ];
    };
    # Enable autosuggestions
    autosuggestions.enable = true;
    # Enable syntax highlighting
    syntaxHighlighting.enable = true;
    # Interactive shell initialization
    interactiveShellInit = ''
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
    # Shell initialization
    shellInit = ''
      export DEEPSEEK_API_KEY=$(cat ${config.sops.secrets.deepseek_api_key.path})
    '';
  };
}
