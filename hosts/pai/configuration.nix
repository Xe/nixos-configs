# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nur-no-pkgs = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") { };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Boot
  boot.loader.grub.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;
  boot.loader.raspberryPi.firmwareConfig = "dtoverlay=dwc2";

  # Kernel configuration
  boot.kernelModules = [ "libcomposite" ];
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.kernelParams = ["cma=64M" "console=tty0" "modules-load=dwc2"];

  # Enable additional firmware (such as Wi-Fi drivers).
  hardware.enableRedistributableFirmware = true;

  # Swap
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

  # Networking
  networking.hostName = "pai"; # Define your hostname.

  # System tools
  environment.systemPackages = with pkgs; [ wget vim ];
  security.sudo.wheelNeedsPassword = false;

  # Time zone
  time.timeZone = "America/Toronto";

  # sshd
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
      tmux

      /home/cadey/code/nixos-configs/common/users/cadey/emacs
      /home/cadey/code/nixos-configs/common/users/cadey/fish
      /home/cadey/code/nixos-configs/common/users/cadey/pastebins
      /home/cadey/code/nixos-configs/common/users/cadey/vim
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

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;
  networking.interfaces.usb0.useDHCP = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };

  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

