{ config, lib, pkgs, ... }:

{
  imports = [ ./backup.nix ./mi.nix ./tron.nix ./withinbot.nix ];

  users.groups.within = { };

  systemd.services.within-homedir-setup = {
    description = "Creates homedirs for /srv/within services";
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = with pkgs; ''
      ${coreutils}/bin/mkdir -p /srv/within
      ${coreutils}/bin/chown root:within /srv/within
      ${coreutils}/bin/chmod 770 /srv/within
    '';
  };
}
