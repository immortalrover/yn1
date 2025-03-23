{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # Define cpolar package using the local cpolar.nix file
  cpolar = pkgs.callPackage ./cpolar.nix { };
  # Define username and group for cpolar service
  u = "cpolar";
  g = "cpolar";
  # Define home directory for cpolar user
  h = "/home/${u}";
in
{
  # Import sops-nix module for secrets management
  imports = [ inputs.sops-nix.nixosModules.sops ];
  # Add cpolar to system packages
  environment.systemPackages = [
    cpolar
  ];
  # Configure secrets for cpolar service
  sops.secrets = {
    cpolar-authtoken.owner = u;
    cpolar-domain0.owner = u;
    cpolar-domain1.owner = u;
  };
  # Define systemd services for cpolar
  systemd.services = {
    # Service for exposing ollama via cpolar
    "cpolar-ollama" = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${cpolar}/bin/cpolar authtoken $(cat ${config.sops.secrets.cpolar-authtoken.path})
        ${cpolar}/bin/cpolar http -subdomain=$(cat ${config.sops.secrets.cpolar-domain0.path}) 11434
      '';
      # Ensure this service starts after ollama
      after = [ "ollama.service" ];
      serviceConfig = {
        User = u;
        WorkingDirectory = h;
      };
    };
    # Service for exposing nextcloud via cpolar
    "cpolar-nextcloud" = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${cpolar}/bin/cpolar authtoken $(cat ${config.sops.secrets.cpolar-authtoken.path})
        ${cpolar}/bin/cpolar http -subdomain="$(cat ${config.sops.secrets.cpolar-domain1.path})" 25656
      '';
      # Ensure this service starts after nextcloud setup
      after = [ "nextcloud-setup.service" ];
      serviceConfig = {
        User = u;
        WorkingDirectory = h;
      };
    };
  };

  # Configure cpolar user
  users.users.cpolar = {
    home = h;
    createHome = true;
    isNormalUser = true;
    group = g;
  };
  # Create cpolar group
  users.groups.${g} = { };
}
