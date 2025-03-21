{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      "proxies"= {
        "http-proxy"= "socks5://127.0.0.1:1080";
        "https-proxy"= "socks5://127.0.0.1:1080";
      };
    };
  };
}
