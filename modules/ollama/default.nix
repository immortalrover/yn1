{ config, pkgs, ... }:

{
  # Configure Ollama service with CUDA acceleration
  services.ollama = {
    # Enable the Ollama service
    enable = true;
    # Use CUDA for GPU acceleration
    acceleration = "cuda";
    # Bind to all network interfaces
    host = "0.0.0.0";
    # Set environment variables for Ollama
    environmentVariables = {
      # Allow requests from any origin
      OLLAMA_ORIGINS = "*";
    };
    # Use CUDA-enabled Ollama package
    package = pkgs.ollama-cuda;
  };
  # Enable Next.js-based UI for Ollama LLM
  services.nextjs-ollama-llm-ui = {
    # Enable the Next.js UI service
    enable = true;
  };
  # Open TCP port 11434 in the firewall for Ollama
  networking.firewall.allowedTCPPorts = [ 11434 ];
}
