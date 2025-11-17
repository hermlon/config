{...}: {
  services.pihole-doh = {
    enable = true;
    ui_port = "9091";
    doh_port = "9092";
    dns_port = "9093";
    domain = "pihole.yuustan.space";
  };

  services.mc-servers.enable = true;

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
