build:
	nixos-rebuild build --flake .#yuu --target-host root@yuu --build-host root@yuu --fast
switch:
	nixos-rebuild switch --flake .#yuu --target-host root@yuu --build-host root@yuu --fast
