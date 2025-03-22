{ config, pkgs, ... }:

{
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    extest.enable = true;
    protontricks.enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true;
        OBS_VKCAPTURE = true;
        RADV_TEX_ANISO = 16;
      };
      extraLibraries =
        p: with p; [
          atk
        ];
    };
    extraPackages = with pkgs; [ gamescope ];
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
  };
}
