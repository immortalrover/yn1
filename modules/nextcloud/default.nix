{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.systemPackages = [
    pkgs.nextcloud-client
  ];

  sops.secrets.nextcloud-domain-name.owner = "nextcloud";
  sops.secrets.nextcloud-admin-pass.owner = "nextcloud";

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      home = "/var/lib/nextcloud";
      hostName = "immortalcloud.cpolar.top";
      # 我找不到一种方式去加密它，加密它later
      # hostName = config.sops.secrets.nextcloud-domain-name;

      database.createLocally = true;
      maxUploadSize = "16G";
      settings.trusted_domains = [ "*" ];
      config = {
        dbtype = "sqlite";
        adminpassFile = config.sops.secrets.nextcloud-admin-pass.path;
      };
    };
    nginx.virtualHosts.${config.services.nextcloud.hostName}.listen = [
      {
        addr = "0.0.0.0";
        port = 25656;
      }
    ];
  };

  # systemd.services."nextcloud-encrypted" = {
  #   enable = true;
  #   wantedBy = [ "multi-user.target" ];
  #   script = ''

  #   '';
  # };

  networking.firewall.allowedTCPPorts = [ 25656 ];
}
