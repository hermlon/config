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
      description = "Path to a file with Wireguard config";
      example = lib.literalExpression ''
        [Interface]
        PrivateKey = <client's privatekey>

        [Peer]
        PublicKey = <server's publickey>
        Endpoint = <server's ip>:51820
        AllowedIPs = 0.0.0.0/0,::0/0
      '';
    };
    privateIPv4 = lib.mkOption {
      type = lib.types.str;
    };
    privateIPv6 = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    dnsIP = lib.mkOption {
      type = lib.types.str;
      default = "1.1.1.1";
    };
  };

  config = mkIf cfg.enable {
    systemd.services."netns@" = {
      description = "%I network namespace";
      before = ["network.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
        ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
      };
    };
    environment.etc."netns/${cfg.namespace}/resolv.conf".text = "nameserver ${cfg.dnsIP}";

    systemd.services.${cfg.namespace} = {
      description = "${cfg.namespace} network interface";
      bindsTo = ["netns@${cfg.namespace}.service"];
      requires = ["network-online.target"];
      after = ["netns@${cfg.namespace}.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = with pkgs;
          writers.writeBash "wg-up" ''
            set -e
            ${iproute2}/bin/ip link add wg0 type wireguard
            ${iproute2}/bin/ip link set wg0 netns ${cfg.namespace}
            ${iproute2}/bin/ip -n ${cfg.namespace} address add ${cfg.privateIPv4} dev wg0
            ${lib.optionalString (cfg.privateIPv6 != null) "${iproute2}/bin/ip -n ${cfg.namespace} -6 address add ${cfg.privateIPv6} dev wg0"}
            ${iproute2}/bin/ip netns exec ${cfg.namespace} \
            ${wireguard-tools}/bin/wg setconf wg0 ${cfg.configFile}
            ${iproute2}/bin/ip -n ${cfg.namespace} link set wg0 up
            ${iproute2}/bin/ip -n ${cfg.namespace} link set lo up
            ${iproute2}/bin/ip -n ${cfg.namespace} route add default dev wg0
            ${iproute2}/bin/ip -n ${cfg.namespace} -6 route add default dev wg0
          '';
        ExecStop = with pkgs;
          writers.writeBash "wg-down" ''
            set -e
            ${iproute2}/bin/ip -n ${cfg.namespace} route del default dev wg0
            ${iproute2}/bin/ip -n ${cfg.namespace} link del wg0
          '';
      };
    };
  };
}
