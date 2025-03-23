{ config, pkgs, inputs, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops.secrets.deepseek_api_key.owner = config.users.defaultUser;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      theme = "kardan";
      plugins = [
        "vi-mode"
      ];
    };
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    interactiveShellInit = ''
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';

    shellInit = ''
      export DEEPSEEK_API_KEY=$(cat ${config.sops.secrets.deepseek_api_key.path})
    '';
  };
}
