{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

  outputs = inputs
  : {
    nixosConfigurations.yuu = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./modules/common
        ./modules/nixos
        ./hosts/yuu
      ];
    };
  };
}
