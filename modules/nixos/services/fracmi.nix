{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.fracmi-polaroids;
in {
  options.services.fracmi-polaroids = {
    enable = lib.mkEnableOption "Deluge torrent client (bound to a Wireguard VPN network)";
    polaroidsDomain = lib.mkOption {
      type = lib.types.str;
    };
    editorDomain = lib.mkOption {
      type = lib.types.str;
    };
    ui_port = lib.mkOption {
      type = lib.types.str;
    };
    polaroidsEnvironmentFile = lib.mkOption {
      type = lib.types.path;
      description = "EnvironmentFile for Polaroids";
    };
    editorDir = lib.mkOption {
      type = lib.types.path;
    };
  };
  config = lib.mkIf cfg.enable {
    virtualisation.quadlet = {
      enable = true;
      containers = {
        fracmi-polaroids = {
          containerConfig = {
            Image = config.virtualisation.quadlet.builds.polaroids.ref;
            PublishPort = [
              "127.0.0.1:${cfg.ui_port}:4000/tcp"
              "127.0.0.1:${cfg.ui_port}:4000/udp"
            ];
            Environment = {
              PHX_HOST = cfg.polaroidsDomain;
              POLAROIDS_EDIT_URL = "https://${cfg.editorDomain}/#";
            };
            EnvironmentFile = cfg.polaroidsEnvironmentFile;
          };
        };
        fracmi-editor = {
          containerConfig = {
            Image = "registry.k8s.io/git-sync/git-sync:v4.2.1";
            Environment = {
              GITSYNC_ROOT = "/data";
              GITSYNC_REPO = "https://github.com/Anomasie/Fractals";
              GITSYNC_REF = "gh-pages";
              GITSYNC_PERIOD = "30s";
            };
            Volume = "${cfg.editorDir}:/data:rw";
            User = 0;
          };
        };
      };
      builds = {
        polaroids = {
          buildConfig = {
            ImageTag = "polaroids";
            SetWorkingDirectory =
              (fetchGit {
                url = "https://github.com/hermlon/polaroids.git";
                rev = "eb06934530c07124c4afc3b25281ed71d2b7cf9f";
              }).outPath;
            ForceRM = false;
            Pull = "never";
          };
        };
      };
    };
    services.nginx = {
      virtualHosts = {
        "${cfg.polaroidsDomain}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${cfg.ui_port}";
              proxyWebsockets = true;
            };
          };
        };
        "${cfg.editorDomain}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              root = "${cfg.editorDir}/Fractals";
              extraConfig = ''
                add_header Cross-Origin-Opener-Policy "same-origin";
                add_header Cross-Origin-Embedder-Policy "require-corp";
              '';
            };
          };
        };
      };
    };
  };
}
