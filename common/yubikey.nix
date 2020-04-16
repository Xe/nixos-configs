{ config, pkgs, ... }:

{
  # yubikey tools
  environment.systemPackages = with pkgs; [
    gnupg
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

  # GPG agent setup
  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';
}
