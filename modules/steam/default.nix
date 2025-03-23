{ config, pkgs, ... }:

{
  # Enable Steam hardware support (controllers, etc.)
  hardware.steam-hardware.enable = true;
  # Configure Steam client settings
  programs.steam = {
    # Enable Steam client
    enable = true;
    # Enable Steam external test client
    extest.enable = true;
    # Enable Protontricks for managing Wine prefixes
    protontricks.enable = true;
    # Customize Steam package with additional environment variables and libraries
    package = pkgs.steam.override {
      # Set environment variables for performance and compatibility
      extraEnv = {
        # Enable MangoHUD overlay
        MANGOHUD = true;
        # Enable OBS Vulkan capture support
        OBS_VKCAPTURE = true;
        # Set anisotropic filtering level
        RADV_TEX_ANISO = 16;
      };
      # Add additional libraries required for Steam
      extraLibraries =
        p: with p; [
          atk
        ];
    };
    # Install additional packages for Steam
    extraPackages = with pkgs; [ gamescope ];
    # Open firewall for local network game transfers
    localNetworkGameTransfers.openFirewall = true;
    # Open firewall for Steam Remote Play
    remotePlay.openFirewall = true;
  };
}
