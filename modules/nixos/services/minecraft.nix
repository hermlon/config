{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.services.mc-servers;
in {
  options.services.mc-servers = {
    enable = mkEnableOption "minecraft servers";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [inputs.nix-minecraft.overlay];

    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers = {
        server-1 = {
          enable = true;
          package = pkgs.paperServers.paper-1_21_8;
          openFirewall = true;
          serverProperties = {
            server-port = 25566;
            max-players = 5;
            motd = "Minecraft Server 1";
            difficulty = "normal";
          };
        };
      };
    };
  };
}
