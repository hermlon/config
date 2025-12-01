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

      servers = let
        geyser = pkgs.fetchurl {
          url = "https://download.geysermc.org/v2/projects/geyser/versions/2.9.1/builds/999/downloads/spigot";
          hash = "sha256-5f21qdfY2SZUDqknf1bGU846GGoSkzjDELmgsrvr2Rs=";
          name = "geyser.jar";
        };
      in {
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
          operators = {
            hermlon = "18b452dc-ec5d-4c96-bbed-7f13afc079aa";
            Altron_tcs = "b8840711-6c0d-41ea-bc4a-07cb665f3744";
            Mattix_MC_ = "14b65485-19f4-4dc5-b56e-861d24a70a94";
          };
          symlinks = {
            "plugins/geysermc.jar" = geyser;
          };
        };
      };
    };

    networking.firewall = {
      allowedUDPPorts = [19132];
    };
  };
}
