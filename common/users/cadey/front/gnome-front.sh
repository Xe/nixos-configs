#!/usr/bin/env nix-shell
#! nix-shell -p jo -p glib -p curl -i bash

front="$(curl https://home.cetacean.club/front)"

gdbus call \
  --session \
  --dest org.gnome.Shell \
  --object-path /com/soutade/GenericMonitor \
  --method com.soutade.GenericMonitor.deleteGroups \
  '{"groups":["front"]}'

gdbus call \
  --session \
  --dest org.gnome.Shell \
  --object-path /com/soutade/GenericMonitor \
  --method com.soutade.GenericMonitor.notify \
  $(jo group=front items=$(jo -a "$(jo name=first on-click=toggle-popup text=$(jo text=${front}))"))
