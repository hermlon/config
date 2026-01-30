{...}: {
  imports = [
    ./minecraft.nix
    ./pihole-doh.nix
    ./wireguard-netns.nix
  ];
}
