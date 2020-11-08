{config, lib, ...}:

{
  imports = [ ./tron.nix ./withinbot.nix ];

  users.groups.within = {};
}
