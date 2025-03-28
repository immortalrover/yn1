{
  # Description of this flake configuration
  description = "Rover's configurations";

  # Input sources for the flake
  inputs = {
    # Stable nixpkgs channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # Unstable nixpkgs channel
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Home manager for user configurations
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Sops-nix for secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Outputs of the flake
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      # System architecture
      system = "x86_64-linux";
      # Default username
      defaultUser = "rover";
    in
    {
      # NixOS configuration for desktop system
      nixosConfigurations.desktop-i8ovuv0 = nixpkgs.lib.nixosSystem {
        # Special arguments passed to modules
        specialArgs = {
          inherit inputs;
          # Unstable package set
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        system = system;
        # List of modules to include in the configuration
        modules = [
          ./host/desktop/i8ovuv0
          ./modules/common
          ./modules/cpolar
          ./modules/gnome
          ./modules/neovim
          ./modules/nextcloud
          ./modules/nvidia/rtx4090
          ./modules/ollama
          ./modules/v2ray
          ./modules/vm
          ./modules/steam
          ./users/${defaultUser}
          {
            options.users.defaultUser = nixpkgs.lib.mkOption {
              type = nixpkgs.lib.types.str;
            };
            config.users.defaultUser = defaultUser;
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit defaultUser; };
              users.${defaultUser} = import ./users/${defaultUser}/home.nix;
            };
          }
        ];
      };
    };
}
