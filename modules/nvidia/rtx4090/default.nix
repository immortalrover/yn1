{ config, pkgs-unstable, ... }:
{
  # Use unstable kernel packages for the latest kernel version
  boot.kernelPackages = pkgs-unstable.linuxPackages;
  # Enable graphics hardware support
  hardware.graphics.enable = true;
  # Use NVIDIA as the video driver for X server
  services.xserver.videoDrivers = [ "nvidia" ];
  # NVIDIA hardware configuration
  hardware.nvidia = {
    # Enable kernel modesetting for better display handling
    modesetting.enable = true;
    # Disable power management features
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    # Use proprietary NVIDIA driver (not open source)
    open = false;
    # Enable NVIDIA settings utility
    nvidiaSettings = true;
    # Use stable NVIDIA driver package in the unstable nixpkgs matching the kernel version
    package = (pkgs-unstable.linuxPackagesFor config.boot.kernelPackages.kernel).nvidiaPackages.stable;
  };
}
