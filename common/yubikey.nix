{ config, pkgs, ... }:

{
  # yubikey tools
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-personalization-gui
    yubikey-manager
    yubikey-manager-qt
    yubikey-neo-manager
    yubioath-desktop
    yubico-piv-tool
  ];

  # expose u2f
  services.udev.packages = with pkgs; [ libu2f-host yubikey-personalization ];

  # gpg-agent
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # smartcard daemon
  services.pcscd.enable = true;
}
