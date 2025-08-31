build $host:
	nixos-rebuild build --flake .#{{host}} --target-host root@{{host}} --build-host root@{{host}} --fast
switch $host:
	nixos-rebuild switch --flake .#{{host}} --target-host root@{{host}} --build-host root@{{host}} --fast
