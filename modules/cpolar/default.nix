{
  config,
  pkgs,
  inputs,
  ...
}:
let
  cpolar = pkgs.callPackage ./cpolar.nix { };
  u = "cpolar";
  g = "cpolar";
  h = "/home/${u}";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  environment.systemPackages = [
    cpolar
  ];

  sops.secrets = {
    cpolar-authtoken.owner = u;
    cpolar-domain0.owner = u;
    cpolar-domain1.owner = u;
  };

  systemd.services = {
    "cpolar-ollama" = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${cpolar}/bin/cpolar authtoken $(cat ${config.sops.secrets.cpolar-authtoken.path})
        ${cpolar}/bin/cpolar http -subdomain=$(cat ${config.sops.secrets.cpolar-domain0.path}) 11434
      '';
      #
      after = [ "ollama.service" ];
      serviceConfig = {
        User = u;
        WorkingDirectory = h;
      };
    };
    "cpolar-nextcloud" = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${cpolar}/bin/cpolar authtoken $(cat ${config.sops.secrets.cpolar-authtoken.path})
        ${cpolar}/bin/cpolar http -subdomain="$(cat ${config.sops.secrets.cpolar-domain1.path})" 25656
      '';
      after = [ "nextcloud-setup.service" ];
      serviceConfig = {
        User = u;
        WorkingDirectory = h;
      };
    };
  };

  users.users.cpolar = {
    home = h;
    createHome = true;
    isNormalUser = true;
    group = g;
  };
  users.groups.${g} = { };
}
