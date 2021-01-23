{ config, pkgs, ... }:

{
  nix.buildMachines = [{
    hostName = "localhost";
    system = "x86_64-linux";
    supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    maxJobs = 8;
  }];

  nix.extraOptions = ''
    allowed-uris = https://github.com/NixOS https://github.com/Xe https://github.com/nmattia https://github.com
  '';

  services.hydra = {
    enable = true;
    hydraURL = "https://hydra.cetacean.club";
    notificationSender = "hydra@localhost";
    port = 56283;
    useSubstitutes = true;
  };

  services.nginx.virtualHosts."hydra.cetacean.club" = {
    locations."/".proxyPass =
      "http://127.0.0.1:${toString config.services.hydra.port}";
    forceSSL = true;
    useACMEHost = "cetacean.club";
    extraConfig = ''
      access_log /var/log/nginx/hydra.access.log;
    '';
  };
}
