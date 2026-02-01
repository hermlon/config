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
    domain = lib.mkOption {
      type = lib.types.str;
    };
    ui_port = lib.mkOption {
      type = lib.types.str;
    };
    polaroidsEnvironmentFile = lib.mkOption {
      type = lib.types.path;
      description = "EnvironmentFile for Polaroids";
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
              "127.0.0.1:${cfg.ui_port}:80/tcp"
            ];
            Environment = {
              #PHX_HOST = "gallery.fracmi.cc";
              PHX_HOST = "polaroids.yuustan.space";
              POLAROIDS_EDIT_URL = "https://editor.fracmi.cc/#";
            };
            EnvironmentFile = cfg.polaroidsEnvironmentFile;
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
    #services.nginx = {
    #  virtualHosts = {
    #    "${cfg.domain}" = {
    #      enableACME = true;
    #      forceSSL = true;
    #      locations = {
    #        "/" = {
    #          proxyPass = "http://127.0.0.1:8112";
    #        };
    #      };
    #    };
    #  };
    #};
  };
}
