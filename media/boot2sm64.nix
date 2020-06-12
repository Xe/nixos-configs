{ pkgs, config, lib, ... }:

let
  nur-no-pkgs = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") { };

  nur = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };

  dwm = with pkgs;
    let name = "dwm-6.2";
    in stdenv.mkDerivation {
      inherit name;

      src = fetchurl {
        url = "https://dl.suckless.org/dwm/${name}.tar.gz";
        sha256 = "03hirnj8saxnsfqiszwl2ds7p0avg20izv9vdqyambks00p2x44p";
      };

      buildInputs = with pkgs; [ xorg.libX11 xorg.libXinerama xorg.libXft ];

      prePatch = ''sed -i "s@/usr/local@$out@" config.mk'';
      postPatch = ''
        cp ${boot2sm64/dwm_config.h} ./config.h
      '';

      patches = [ ./boot2sm64/autostart.patch ];

      buildPhase = " make ";

      meta = {
        homepage = "https://suckless.org/";
        description = "Dynamic window manager for X";
        license = stdenv.lib.licenses.mit;
        maintainers = with stdenv.lib.maintainers; [ viric ];
        platforms = with stdenv.lib.platforms; all;
      };
    };

  sm64pc = with pkgs;
    let
      baserom = fetchurl {
        url = "http://127.0.0.1/baserom.us.z64";
        sha256 = "148xna5lq2s93zm0mi2pmb98qb5n9ad6sv9dky63y4y68drhgkhp";
      };
    in stdenv.mkDerivation rec {
      pname = "sm64pc";
      version = "latest";

      buildInputs = [
        gnumake
        python3
        audiofile
        pkg-config
        SDL2
        libusb1
        glfw3
        libgcc
        xorg.libX11
        xorg.libXrandr
        libpulseaudio
        alsaLib
        glfw
        libGL
        unixtools.hexdump
        clang_10
      ];

      src = fetchgit {
        url = "https://tulpa.dev/saved/sm64pc";
        rev = "c52fdb27f81cbb39459e1200cd3498b820c6da6a";
        sha256 = "0bxihrvxzgjxbrf8iby5vs0nddsl8y9k5bd2hy6j33vrfaqa3yd9";
      };

      buildPhase = ''
        chmod +x ./extract_assets.py
        cp ${baserom} ./baserom.us.z64
        make -j
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp ./build/us_pc/sm64.us.f3dex2e $out/bin/sm64pc
      '';

      meta = with stdenv.lib; {
        description = "Super Mario 64 PC port, requires rom :)";
      };
    };

in {
  imports = [ <home-manager/nixos> ];

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.vmware.guest.enable = true;

  system.activationScripts = {
    base-dirs = {
      text = ''
        mkdir -p /nix/var/nix/profiles/per-user/mario
        nix-channel --add https://nixos.org/channels/nixos-20.03 nixpkgs
      '';
      deps = [ ];
    };
  };

  networking.hostName = "its-a-me";
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  environment.systemPackages = with pkgs; [ st hack-font dwm sm64pc ];

  services.xserver.windowManager.session = lib.singleton {
    name = "dwm";
    start = with pkgs.nur.repos.xe; ''
      ${dwm}/bin/dwm &
      waitPID=$!
    '';
  };

  users.users.mario = { isNormalUser = true; extraGroups = [ "audio" ]; };

  services.xserver.enable = true;
  services.xserver.displayManager.defaultSession = "none+dwm";
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.user = "mario";

  home-manager.users.mario = { config, pkgs, ... }: {
    home.file = {
      ".dwm/autostart.sh" = {
        executable = true;
        text = ''
          #!/bin/sh

          ${sm64pc}/bin/sm64pc &
        '';
      };
    };
  };
}
