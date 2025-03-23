{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # Define proxy URL for SOCKS5
  proxy.url = "socks5://localhost:1080";
  # Define username and group for v2ray service
  u = "v2ray";
  g = "v2ray";
  # Define home directory for v2ray user
  h = "/home/${u}";
  # Define config file path
  f = "${h}/config.json";
  # Customize v2ray package with post-install fixes
  v2ray = pkgs.v2ray.overrideAttrs (
    finalAttrs: previousAttrs: {
      postFixup = ''
        wrapProgram $out/bin/v2ray \
          --suffix XDG_DATA_DIRS : $assetsDrv/share
        substituteInPlace $out/lib/systemd/system/*.service \
          --replace User=nobody User=v2ray \
          --replace /usr/local/bin/ $out/bin/ \
          --replace /usr/local/etc/ /home/
      '';
    }
  );
in
{
  # Import sops-nix module for secrets management
  imports = [ inputs.sops-nix.nixosModules.sops ];
  # Configure system-wide proxy settings
  networking.proxy = {
    httpProxy = proxy.url;
    httpsProxy = proxy.url;
    allProxy = proxy.url;
    default = proxy.url;
  };

  # Configure sops for secrets management
  sops = {
    secrets = {
      # Define secrets for v2ray server IP and ID
      server0-ip.owner = "v2ray";
      v2ray-id.owner = "v2ray";
    };
    templates = {
      # Define v2ray configuration template
      "v2ray.json" = {
        owner = "v2ray";
        content = ''
          {
            "inbounds": [
              {
                "listen": "127.0.0.1",
                "port": 1080,
                "protocol": "socks",
                "settings": {
                  "auth": "noauth"
                },
                "sniffing": {
                  "destOverride": [
                    "http",
                    "tls"
                  ],
                  "enable": true
                }
              }
            ],
            "outbounds": [
              {
                "protocol": "vmess",
                "settings": {
                  "vnext": [
                    {
                      "address": "${config.sops.placeholder.server0-ip}",
                      "port": 30567,
                      "users": [
                        {
                          "alterId": 0,
                          "id": "${config.sops.placeholder.v2ray-id}"
                        }
                      ]
                    }
                  ]
                }
              }
            ],
            "routing": {
              "balancingRule": [],
              "domainStrategy": "AsIs"
            }
          }
        '';
      };
    };
  };

  # Enable and configure v2ray service
  services.v2ray = {
    enable = true;
    package = v2ray;
    configFile = f;
  };

  # Configure systemd service for v2ray
  systemd.services.v2rayd = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    script = ''
      cat ${config.sops.templates."v2ray.json".path} > ${f}
    '';
    before = [ "v2ray.service" ];
    serviceConfig = {
      User = u;
      WorkingDirectory = h;
    };
  };

  # Create v2ray user and group
  users.users.${u} = {
    home = h;
    createHome = true;
    isNormalUser = true;
    group = g;
  };
  users.groups.${g} = { };
}
