{
  description = "Rover's configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      defaultUser = "rover";
    in
    {
      nixosConfigurations.desktop-i8ovuv0 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = system;
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
          ./users/${defaultUser}
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${defaultUser} = import ./users/${defaultUser}/home.nix;
          }
        ];
      };
    };
}
