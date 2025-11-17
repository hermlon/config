{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.quadlet-nix.nixosModules.quadlet
    inputs.disko.nixosModules.disko
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./fish.nix
    ./bsprak.nix
    ./services
  ];
}
