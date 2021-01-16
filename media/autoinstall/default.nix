(import <nixpkgs/nixos/lib/eval-config.nix> {
	system = "x86_64-linux";
	modules = [
		<nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
		./configuration.nix
		({ config, pkgs, lib, ... }: {
			systemd.services.install = {
				description = "Bootstrap a NixOS installation";
				wantedBy = [ "multi-user.target" ];
				after = [ "network.target" "polkit.service" ];
				path = [ "/run/current-system/sw/" ];
				script = with pkgs; ''
					echo 'journalctl -fb -n100 -uinstall' >>~nixos/.bash_history

					set -eux

					dev=/dev/vda

          parted $dev -- mklabel msdos
          parted $dev -- mkpart primary 1MiB 512MiB
          parted $dev -- mkpart primary 512MiB 100%

					mkfs.fat -F 32 -n boot ''${dev}1
					mkfs.ext4 -L nixos ''${dev}2

					sync
					sleep 10 # Allow /dev/disk/by-label names to appear.

					mount /dev/disk/by-label /mnt

					mkdir /mnt/boot
					mount /dev/disk/by-label/boot /mnt/boot

					install -D ${./configuration.nix} /mnt/etc/nixos/configuration.nix
          install -D ${./hardware-configuration.nix} /mnt/etc/nixos/hardware-configuration.nix

          sed -i -E 's/(\w*)#installer-only /\1/' /mnt/etc/nixos/*

					${config.system.build.nixos-install}/bin/nixos-install \
						--system ${(import <nixpkgs/nixos/lib/eval-config.nix> {
							system = "x86_64-linux";
							modules = [
								./configuration.nix
								./hardware-configuration.nix
							];
						}).config.system.build.toplevel} \
						--no-root-passwd \
						--cores 0

					echo 'Shutting off in 1min'
					${systemd}/bin/shutdown +1
				'';
				environment = config.nix.envVars // {
					inherit (config.environment.sessionVariables) NIX_PATH;
					HOME = "/root";
				};
				serviceConfig = {
					Type = "oneshot";
				};
			};
		})
	];
}).config.system.build.isoImage
