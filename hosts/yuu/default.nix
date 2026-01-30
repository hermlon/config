{
  modulesPath,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
    ./services.nix
    ./config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.helix
    pkgs.hyfetch
    pkgs.neovim
    pkgs.tmux
    pkgs.htop
    pkgs.wget
    pkgs.foot.terminfo
    pkgs.wireguard-tools
    pkgs.deluge
  ];

  networking.hostName = "yuu";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBkCf1r1Mj4bvdqq79oinJ1+DS6QJItGQnFjvO8DPpDX hermlon@natsuki"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmQevpxfc7Rh1bR4l2o6ooxYBRX33TuzxziVjAzvFnz hermlon@jules"
  ];

  system.stateVersion = "24.05";
}
