{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.defaults.fish;
in {
  options.defaults.fish = {
    enable = mkEnableOption "fish";
  };

  config = mkIf cfg.enable {
    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;
  };
}
