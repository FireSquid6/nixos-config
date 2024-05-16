{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    homeConfigurations.firesquid = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };

      extraSpecialArgs = { inherit inputs; };

      modules = [ ./homeConfigurations/firesquid.nix ];
    };
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/kotoko/hardware-configuration.nix
        ./hosts/kotoko/configuration.nix

        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
