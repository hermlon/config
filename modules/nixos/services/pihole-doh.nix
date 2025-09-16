{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.services.pihole-doh;
in {
  options.services.pihole-doh = {
    enable = mkEnableOption "pihole doh service";
    domain = mkOption {
      type = types.str;
    };
    dns_port = mkOption {
      type = types.str;
    };
    doh_port = mkOption {
      type = types.str;
    };
    ui_port = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.quadlet = {
      enable = true;
      containers = {
        pihole = {
          containerConfig = {
            Image = "docker.io/pihole/pihole";
            PublishPort = [
              "127.0.0.1:${cfg.dns_port}:53/tcp"
              "127.0.0.1:${cfg.dns_port}:53/udp"
              "127.0.0.1:${cfg.ui_port}:80/tcp"
            ];
            Environment = {
              FTLCONF_dns_upstreams = "1.1.1.1";
              FTL_CONF_rate_limit = "0/0";
              TZ = "Europe/Berlin";
            };
            Volume = "pihole.volume:/etc/pihole";
          };
        };
      };
      volumes = {
        pihole.enable = true;
      };
    };

    services.doh-proxy-rust = {
      enable = true;
      flags = [
        "-H=${cfg.domain}"
        "-l=127.0.0.1:${cfg.doh_port}"
        "-u=127.0.0.1:${cfg.dns_port}"
      ];
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "${cfg.domain}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${cfg.ui_port}";
            };
            "/dns-query" = {
              proxyPass = "http://127.0.0.1:${cfg.doh_port}";
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
              '';
            };
          };
        };
      };
    };
  };
}
