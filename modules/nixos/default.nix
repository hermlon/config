{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.quadlet-nix.nixosModules.quadlet
    inputs.disko.nixosModules.disko
    ./fish.nix
    ./bsprak.nix
    ./services
  ];
}
