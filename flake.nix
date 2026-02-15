{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.quadlet-nix = {
    url = "github:mirkolenz/quadlet-nix/v1";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.agenix = {
    url = "github:ryantm/agenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nix-minecraft = {
    url = "github:Infinidoge/nix-minecraft";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.iceshrimp = {
    url = "git+https://iceshrimp.dev/iceshrimp/packaging?dir=iceshrimp-js";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs
  : {
    nixosConfigurations.yuu = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./modules/common
        ./modules/nixos
        ./hosts/yuu
      ];
    };
  };
}
