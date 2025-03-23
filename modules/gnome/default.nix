{ config, pkgs, ... }:

{
  # List of system-wide packages to install
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-shell-extensions
    whitesur-gtk-theme
    whitesur-icon-theme
    whitesur-cursors
  ];

  # Enable dconf for GNOME settings management
  programs.dconf = {
    enable = true;
    # Configure GDM (GNOME Display Manager) settings
    profiles.gdm = {
      databases = [
        {
          settings = {
            "org/gnome/desktop/input-sources" = {
              # Set keyboard options:
              # - Ctrl+Alt+Backspace to terminate X server
              # - Caps Lock acts as Escape, Shift+Caps Lock acts as Caps Lock
              xkb-options = "['terminate:ctrl_alt_bksp',
              'caps:escape_shifted_capslock']";
            };
          };
        }
      ];
    };
  };

  # Configure X server and display services
  services = {
    xserver = {
      enable = true;
      # Use GNOME Display Manager (GDM) and GNOME desktop environment
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    # Enable GNOME browser connector for extension support
    gnome.gnome-browser-connector.enable = true;
    # Configure automatic login for the default user
    displayManager = {
      autoLogin = {
        enable = true;
        user = config.users.defaultUser;
      };
    };
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # Disable getty and autovt services on tty1 to prevent login prompt interference
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
