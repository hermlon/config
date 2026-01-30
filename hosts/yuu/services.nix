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
