{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qs-hyprview = {
      url = "github:Meziu/qs-hyprview";
      flake = false;
    };
    qylock = {
      url = "github:Darkkal44/qylock";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      qs-hyprview,
      qylock,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            qylock.nixosModules.default
            ./hosts/vm/configuration.nix
          ];
        };
        thinkbook = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            qylock.nixosModules.default
            ./hosts/thinkbook/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        "andreaciliberti" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/home.nix
          ];
        };
      };
    };
}
