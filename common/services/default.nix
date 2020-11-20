{ config, lib, ... }:

{
  imports = [ ./backup.nix ./mi.nix ./tron.nix ./withinbot.nix ];

  users.groups.within = { };
}
