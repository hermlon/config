{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;
}
