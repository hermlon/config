{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.services.wireguard-netns;
in {
  options.services.wireguard-netns = {
    enable = mkEnableOption "wireguard netns";
    namespace = lib.mkOption {
      type = lib.types.str;
      description = "Network namespace to be created";
      default = "wg_client";
    };
    configFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to a file with Wireguard config (not a wg-quick one!)";
      example = lib.literalExpression ''
        pkgs.writeText "wg0.conf" '''
          [Interface]
          PrivateKey = <client's privatekey>

          [Peer]
          PublicKey = <server's publickey>
          Endpoint = <server's ip>:51820
        '''
      '';
    };
    privateIP = lib.mkOption {
      type = lib.types.str;
    };
    dnsIP = lib.mkOption {
      type = lib.types.str;
    };
  };

  config =
    mkIf cfg.enable {
    };
}
