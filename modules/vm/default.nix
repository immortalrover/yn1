{ config, pkgs, ... }:

{
  # Enable IP forwarding for IPv4
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };
  # Set kernel parameters for IOMMU
  boot.kernelParams = [
    "iommu=pt"
    "iommu=on"
  ];
  # Enable Virt Manager for managing virtual machines
  programs.virt-manager.enable = true;
  # Add default user to libvirtd group
  users.groups.libvirtd.members = [ config.users.defaultUser ];
  # Enable libvirtd service for virtualization
  virtualisation.libvirtd.enable = true;
  # Enable USB redirection for SPICE protocol
  virtualisation.spiceUSBRedirection.enable = true;
  # Enable QEMU guest agent service
  services.qemuGuest.enable = true;
  # Enable SPICE vdagent service for better VM integration
  services.spice-vdagentd.enable = true;
  # Network configuration for bridge interface br0
  networking = {
    # Use systemd-networkd for network management
    useNetworkd = true;
    # Configure bridge interface br0 using enp5s0
    bridges.br0 = {
      interfaces = [ "enp5s0" ];
    };
    # Disable DHCP for enp5s0 interface
    interfaces = {
      enp5s0.useDHCP = false;
    };
  };
  # Systemd service to enable br0 bridge after NetworkManager starts
  systemd.services.enable-br0 = {
    enable = true;
    after = [ "NetworkManager.service" ];
    script = "${pkgs.networkmanager}/bin/nmcli con up br0";
    wantedBy = [ "multi-user.target" ];
  };
}
