{
  config,
  pkgs,
  inputs,
  ...
}:

# Import sops-nix module for secrets management
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # System-wide packages to install
  environment.systemPackages = [
    pkgs.nextcloud-client  # Nextcloud desktop client
  ];

  # Configure sops secrets ownership for Nextcloud
  sops.secrets.nextcloud-domain-name.owner = "nextcloud";
  sops.secrets.nextcloud-admin-pass.owner = "nextcloud";

  # Nextcloud service configuration
  services = {
    nextcloud = {
      enable = true;  # Enable Nextcloud service
      package = pkgs.nextcloud30;  # Use Nextcloud version 30
      home = "/var/lib/nextcloud";  # Storage location for Nextcloud data
      hostName = "immortalcloud.cpolar.top";  # Hostname for Nextcloud
      # 我找不到一种方式去加密它，暂时不加密它
      # hostName = config.sops.secrets.nextcloud-domain-name;

      database.createLocally = true;  # Create database locally
      maxUploadSize = "16G";  # Set maximum upload size
      settings.trusted_domains = [ "*" ];  # Allow access from any domain
      config = {
        dbtype = "sqlite";  # Use SQLite database
        adminpassFile = config.sops.secrets.nextcloud-admin-pass.path;  # Admin password from sops secret
      };
    };
    # Nginx virtual host configuration for Nextcloud
    nginx.virtualHosts.${config.services.nextcloud.hostName}.listen = [
      {
        addr = "0.0.0.0";  # Listen on all interfaces
        port = 25656;  # Use custom port 25656
      }
    ];
  };

  # systemd.services."nextcloud-encrypted" = {
  #   enable = true;
  #   wantedBy = [ "multi-user.target" ];
  #   script = ''

  #   '';
  # };

  # Firewall configuration to allow traffic on Nextcloud port
  networking.firewall.allowedTCPPorts = [ 25656 ];
}
