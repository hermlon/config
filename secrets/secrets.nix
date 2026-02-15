let
  yuu = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPNXHk5Pfc380oryW3ECgy0D7dl2VHT8goI6jlRMXjY";
  systems = [yuu];

  hermlon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBkCf1r1Mj4bvdqq79oinJ1+DS6QJItGQnFjvO8DPpDX"; # hermlon@natsuki
  hermlon_jules = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmQevpxfc7Rh1bR4l2o6ooxYBRX33TuzxziVjAzvFnz"; # hermlon@jules
  users = [hermlon hermlon_jules];
  all = users ++ systems;
in {
  "mullvad.age".publicKeys = all;
  "fracmi.age".publicKeys = all;
  "iceshrimp_db_password.age".publicKeys = all;
  "iceshrimp_config.age".publicKeys = all;
}
