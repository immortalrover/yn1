{
  config,
  pkgs,
  inputs,
  ...
}:
let
  proxy.url = "socks5://localhost:1080";
  u = "v2ray";
  g = "v2ray";
  h = "/home/${u}";
  f = "${h}/config.json";
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
  imports = [ inputs.sops-nix.nixosModules.sops ];
  networking.proxy = {
    httpProxy = proxy.url;
    httpsProxy = proxy.url;
    allProxy = proxy.url;
    default = proxy.url;
  };

  sops = {
    secrets = {
      server0-ip.owner = "v2ray";
      v2ray-id.owner = "v2ray";
    };
    templates = {
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
              },
              {
                "protocol": "freedom",
                "settings": {},
                "tag": "direct"
              }
            ],
            "routing": {
              "balancingRule": [],
              "domainStrategy": "IPOnDemand",
              "rule": [
                {
                  "domain": [
                    "localhost"
                  ],
                  "outboundTag": "direct",
                  "type": "field"
                }
              ]
            }
          }
        '';
      };
    };
  };

  services.v2ray = {
    enable = true;
    package = v2ray;
    configFile = f;
  };

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

  users.users.${u} = {
    home = h;
    createHome = true;
    isNormalUser = true;
    group = g;
  };
  users.groups.${g} = { };
}
