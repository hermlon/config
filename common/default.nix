{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.quadlet-nix.nixosModules.quadlet
    inputs.disko.nixosModules.disko
    ../modules
    ./fish.nix
    ./bsprak.nix
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;
}
