{inputs, ...}: {
  imports = [
    inputs.quadlet-nix.nixosModules.quadlet
    inputs.disko.nixosModules.disko
    ../modules
  ];
}
