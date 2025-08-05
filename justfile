build:
	nixos-rebuild build --flake .#enid --target-host root@enid --build-host root@enid --fast
switch:
	nixos-rebuild switch --flake .#enid --target-host root@enid --build-host root@enid --fast
