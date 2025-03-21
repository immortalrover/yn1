{ config, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    host = "0.0.0.0";
    environmentVariables = {
      OLLAMA_ORIGINS = "*";
    };
    package = pkgs.ollama-cuda;
  };
  services.nextjs-ollama-llm-ui = {
    enable = true;
  };
  networking.firewall.allowedTCPPorts = [ 11434 ];
}
