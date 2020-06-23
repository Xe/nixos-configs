{ pkgs, config, ... }:

let
  nur-no-pkgs = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") { };

in {
  imports = [ <home-manager/nixos> ];

  # Boot
  boot.loader.grub.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;

  # Kernel configuration
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.kernelParams = ["cma=64M" "console=tty0"];

  # Enable additional firmware (such as Wi-Fi drivers).
  hardware.enableRedistributableFirmware = true;

  # Filesystems
  fileSystems = {
      # There is no U-Boot on the Pi 4 (yet) -- the firmware partition has to be mounted as /boot.
      "/boot" = {
          device = "/dev/disk/by-label/FIRMWARE";
          fsType = "vfat";
      };
      "/" = {
          device = "/dev/disk/by-label/NIXOS_SD";
          fsType = "ext4";
      };
  };

  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

  networking.hostName = "pai";

  environment.systemPackages = with pkgs; [ wget vim hack-font ];
  security.sudo.wheelNeedsPassword = false;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  services.openssh.enable = true;

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;

    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
    };
  };

  sdImage = {
    firmwareSize = 128;
    # This is a hack to avoid replicating config.txt from boot.loader.raspberryPi
    populateFirmwareCommands =
      "${config.system.build.installBootLoader} ${config.system.build.toplevel} -d ./firmware";
    # As the boot process is done entirely in the firmware partition.
    populateRootCommands = "";
  };

  systemd.services.btattach = {
    before = [ "bluetooth.service" ];
    after = [ "dev-ttyAMA0.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
    };
  };

  users.users.cadey = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "audio" "plugdev" "libvirtd" "adbusers" ];
    shell = pkgs.fish;
  };

  users.extraUsers.cadey.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg9gYKVglnO2HQodSJt4z4mNrUSUiyJQ7b+J798bwD9 shachi"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBp8WiNUFK6mbehvO94LAzIA4enTuWxugABC79tiQSHT aloha"
  ];

  home-manager.users.cadey = { config, pkgs, ... }: {
    imports = with nur-no-pkgs.repos.xe.modules; [
      neofetch
      htop
      fish
      tmux

      ../common/users/cadey/emacs
      ../common/users/cadey/pastebins
    ];

    services.lorri.enable = true;

    programs.git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      userName = "Christine Dodrill";
      userEmail = "me@christine.website";
      ignores = [ ];
      extraConfig = {
        core.editor = "vim";
        credential.helper = "store --file ~/.git-credentials";
        protocol.keybase.allow = "always";
      };
    };

    home.packages = with pkgs; [
      cachix
      niv
      nixfmt
      mosh
      bind
      unzip
      drone-cli
    ];

    programs.direnv.enable = true;
    programs.direnv.enableFishIntegration = true;

    nixpkgs.config = {
      allowBroken = true;
      allowUnfree = true;

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball
          "https://github.com/nix-community/NUR/archive/master.tar.gz") {
            inherit pkgs;
          };
      };
    };
  };
}
