{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-shell-extensions
    whitesur-gtk-theme
    whitesur-icon-theme
    whitesur-cursors
  ];

  programs.dconf = {
    enable = true;
    profiles.gdm = {
      databases = [
        {
          settings = {
            "org/gnome/desktop/input-sources" = {
              xkb-options = "['terminate:ctrl_alt_bksp',
              'caps:escape_shifted_capslock']";
            };
          };
        }
      ];
    };
  };

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    gnome.gnome-browser-connector.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = config.users.defaultUser;
      };
    };
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
