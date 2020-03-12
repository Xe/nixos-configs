# NixOps Deployment of a Docker Container

## Install NixOps

If using NixOS:

```console
$ nix-env -iA nixos.nixops
```

If using Nix on another OS:

```console
$ nix-env -iA nixpkgs.nixops
```

## Create the Deployment

```console
$ nixops create ./trivial.nix ./trivial-vbox.nix -d http
$ nixops deploy -d http
$ nixops info -d http
```

Get the IP address from that last command and:

```console
$ curl http://192.168.56.105
```

## Destroy the Deployment

```console
$ nixops destroy -d http
$ nixops delete -d http
```
