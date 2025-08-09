({pkgs, ...}: {
  virtualisation.quadlet = {
    enable = true;
    containers = {
      pihole = {
        containerConfig = {
          Image = "docker.io/pihole/pihole";
          PublishPort = [
            "127.0.0.1:9102:53/tcp"
            "127.0.0.1:9102:53/udp"
            "127.0.0.1:9103:80/tcp"
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
      "-H=pihole.yuustan.space"
      "-l=127.0.0.1:9101"
      "-u=127.0.0.1:9102"
    ];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "pihole.yuustan.space" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:9103";
          };
          "/dns-query" = {
            proxyPass = "http://127.0.0.1:9101";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
            '';
          };
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "hermlon@yuustan.space";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [80 443];
  };
})
