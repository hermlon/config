{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.netns-deluge;
  ns = config.services.wireguard-netns.namespace;
in {
  options.services.netns-deluge = {
    enable = lib.mkEnableOption "Deluge torrent client (bound to a Wireguard VPN network)";
    domain = lib.mkOption {
      type = lib.types.str;
    };
  };
  config = lib.mkIf cfg.enable {
    services.deluge = {
      enable = true;
      web = {
        enable = true;
      };
    };

    services.nginx = {
      virtualHosts = {
        "${cfg.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:8112";
            };
          };
        };
      };
    };

    systemd = {
      services.deluged.bindsTo = ["netns@${ns}.service"];
      services.deluged.requires = [
        "network-online.target"
        "${ns}.service"
      ];
      services.deluged.serviceConfig.NetworkNamespacePath = ["/var/run/netns/${ns}"];
      sockets."deluged-proxy" = {
        enable = true;
        description = "Socket for Proxy to Deluge WebUI";
        listenStreams = ["58846"];
        wantedBy = ["sockets.target"];
      };
      services."deluged-proxy" = {
        enable = true;
        description = "Proxy to Deluge Daemon in Network Namespace";
        requires = [
          "deluged.service"
          "deluged-proxy.socket"
        ];
        after = [
          "deluged.service"
          "deluged-proxy.socket"
        ];
        unitConfig = {
          JoinsNamespaceOf = "deluged.service";
        };
        serviceConfig = {
          User = config.services.deluge.user;
          Group = config.services.deluge.group;
          ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:58846";
          PrivateNetwork = "yes";
        };
      };
    };
  };
}
