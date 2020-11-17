{config, lib, ...}:

{
  imports = [ ./mi.nix ./tron.nix ./withinbot.nix ];

  users.groups.within = {};
}
