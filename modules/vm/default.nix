{ config, pkgs, ... }:

{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };
  boot.kernelParams = [
    "iommu=pt"
    "iommu=on"
  ];
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "${config.users.defaultUser}" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # 配置桥接接口 br0
  networking = {
    useNetworkd = true;
    bridges.br0 = {
      interfaces = [ "enp5s0" ];
    };
    interfaces = {
      enp5s0.useDHCP = false;
    };
  };
  systemd.services.enable-br0 = {
    enable = true;
    after = [ "NetworkManager.service" ];
    script = "${pkgs.networkmanager}/bin/nmcli con up br0";
    wantedBy = [ "multi-user.target" ];
  };
}
