{config, ...}: {
  services.pihole-doh = {
    enable = true;
    ui_port = "9091";
    doh_port = "9092";
    dns_port = "9093";
    domain = "pihole.yuustan.space";
  };

  services.mc-servers.enable = true;

  age.secrets.wireguardCredentials.file = ../../secrets/mullvad.age;
  services.wireguard-netns = {
    enable = true;
    configFile = config.age.secrets.wireguardCredentials.path;
    privateIPv4 = "10.67.63.23/32";
    privateIPv6 = "fc00:bbbb:bbbb:bb01::4:3f16/128";
    dnsIP = "10.64.0.1";
  };

  age.secrets.iceshrimpDbPassword = {
    file = ../../secrets/iceshrimp_db_password.age;
    owner = "postgres";
    group = "postgres";
  };
  age.secrets.iceshrimpConfig = {
    file = ../../secrets/iceshrimp_config.age;
    owner = config.services.iceshrimp.user;
    group = config.services.iceshrimp.group;
  };
  services.iceshrimp = {
    enable = true;
    settings.url = "https://yuustan.space";
    configureNginx = {
      enable = true;
    };
    createDb = true;
    dbPasswordFile = config.age.secrets.iceshrimpDbPassword.path;
    secretConfig = config.age.secrets.iceshrimpConfig.path;
    settings.db.host = "/run/postgresql";
  };

  age.secrets.polaroidsEnvironmentFile.file = ../../secrets/fracmi.age;
  services.fracmi-polaroids = {
    enable = true;
    polaroidsEnvironmentFile = config.age.secrets.polaroidsEnvironmentFile.path;
    ui_port = "9100";
    editorDir = "/srv/fracmi-editor";
    polaroidsDomain = "gallery.fracmi.cc";
    editorDomain = "editor.fracmi.cc";
  };

  services.netns-deluge = {
    enable = true;
    domain = "deluge.yuustan.space";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
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
}
