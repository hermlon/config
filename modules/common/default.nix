{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.default
    inputs.iceshrimp.nixosModules.iceshrimp
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
