build $host:
	nixos-rebuild build --flake .#{{host}} --target-host root@{{host}} --build-host root@{{host}} --fast --show-trace
switch $host:
	nixos-rebuild switch --flake .#{{host}} --target-host root@{{host}} --build-host root@{{host}} --fast --show-trace
