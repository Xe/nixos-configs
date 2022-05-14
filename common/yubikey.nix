{ config, pkgs, ... }:

{
  # expose u2f
  services.udev.packages = with pkgs; [ libu2f-host yubikey-personalization ];

  # smartcard daemon
  services.pcscd.enable = true;

  # GPG agent setup
  environment.shellInit = ''
    export GPG_TTY="$(tty)"
  '';

  services.yubikey-agent.enable = config.cadey.gui.enable;
}
