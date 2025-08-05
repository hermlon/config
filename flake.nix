{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.quadlet-nix = {
    url = "github:mirkolenz/quadlet-nix/v1";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    disko,
    quadlet-nix,
    ...
  }: {
    nixosConfigurations.enid = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        quadlet-nix.nixosModules.quadlet
        ./configuration.nix
        ./services.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
