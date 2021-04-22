{ config, lib, pkgs, ... }:

let
  mkUser = {shell, keys, ...}: {
    isNormalUser = true;
    extraGroups = [ "ponydev" ];
    createHome = true;
    inherit shell;
    openssh.authorizedKeys.keys = keys;
  };

in {
  users.groups.ponydev = { gid = 1337; };

  documentation.man.generateCaches = false;

  security.pam.loginLimits = [
    {
      domain = "@ponydev";
      type = "soft";
      item = "nofile";
      value = "2048";
    }
    {
      domain = "@ponydev";
      type = "hard";
      item = "nice";
      value = "2";
    }
    {
      domain = "@ponydev";
      type = "hard";
      item = "nproc";
      value = "420";
    }
  ];

  programs.fish.enable = true;
  programs.zsh.enable = true;

  users.motd = ''
      _____.__
    _/ ____\__|______  ____  __ __
    \   __\|  \_  __ \/ ___\|  |  \
     |  |  |  ||  | \/ /_/  >  |  /
     |__|  |__||__|  \___  /|____/
                    /_____/

    firgu(noun/adj): Benificial, nice, an aid to

    Welcome to the ponydev pubnix! Things are still being set up.

    Check us out on gemini at gemini://sh.pony.dev/!

    To make your own gemini content, make a folder in your home
    directory named `public_gemini`, add an index.gmi and then
    get going! See section 5 of here[1] for information on the
    syntax of gemtext. If you've used markdown before the only
    real difference is in how you make links.

    For a beautiful gemini client on your desktop, check out
    lagrange[2]!

    [1]: https://gemini.circumlunar.space/docs/specification.html
    [2]: https://gmi.skyjake.fi/lagrange/

    If you need help contact Cadey.
  '';

  within.backups = {
    enable = true;
    repo = "57196@usw-s007.rsync.net:firgu";
  };

  cadey.rhea = {
    enable = true;
    sites = [
      rec {
        domain = "sh.pony.dev";
        certPath = "/var/lib/acme/${domain}/cert.pem";
        keyPath = "/var/lib/acme/${domain}/key.pem";
        files = {
          root = "/srv/gemini/${domain}";
          autoIndex = true;
          userPaths = true;
        };
      }
    ];
  };

  security.acme.acceptTerms = true;
  security.acme.email = "me+firgu@christine.website";

  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";
  services.nginx = {
    enable = true;
    group = "users";
    virtualHosts = {
      "sh.pony.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = { root = "/srv/http/sh.pony.dev"; };
        extraConfig = ''
          location ~ ^/~(.+?)(/.*)?$ {
            alias /home/$1/public_html$2;
            index index.html index.htm;
            autoindex on;
          }
        '';
      };
    };
  };

  users.users = {
    # TODO(Xe): add user information here, make sure to add them to
    # @ponydevs

    ansis = mkUser {
      shell = pkgs.bashInteractive;
      keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTEe/IOfB8ZOGRPH2rEs04rgFCP+WS62v6hTUtRQc/HrztCHECJ/oDEaIv+3rOFJE2DehdV4uYhBjDVYzU8Fq46LG2HHBULWexb826qbUfmkmI81O1P4avppTQUTDT3H9z74CNUvO+xJ8LIOmDuBJntxzShYY622x7c80tZo9SpPDJW4S5uKxNT/DGWwxhlYxCsqpi7DERROEeuq5yxN/bEQesvDx9zjxBvODFLgGl4RBxL2oGHEYPIZud4n8v67zVBwicY0pSESJqV/DffEtCSANOZtXZM8xd73oif1mET39QXD2PaootBceStDN9dDmK1ETDG8UEIlww31FcYQO9 ansis@canterlot"
      ];
    };

    bytewave = mkUser {
      shell = pkgs.zsh;
      keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWR1CzI5q+vCmKUj8faYqFae2RYhbLhyrIaEIwzapMURrTyPd2uWbV4bY+hbkIOOZcumtcUUs35LkQzP9NcBA5lzn1zTmDExqofRO6fn7PTORFH8FUQGuJ0nQPANEBiOTGToiqfdDCStHMwkB8b7xUavFP0mh3997UYfRIBNzUFryfJBJbB9RH1HrcYBUS1mC0pN8a6XaMzI3jVNiqS6tGch8syZo3kxp13h93R4rbDPJajSu+3k1YmhOv0GF5utGNcndJ55WAdisySuP/uE3gqsOJ8yOLwavvk0Ftx7ziMWT+TW3Uv7LAfk2w1/QH3BNI5xCWJ8Q8K85UDbQmgMfFqTtVzzArKDJN/Np5TrIc/KhRzU1ShUyIZdtiWZlf3hLD8h9HxYU/4lwxyRF6gQ3Y7tx+2ocGFtfnkmy0jWXPcnJI2M2cgeavvHzryJ9bVhhPLll2WWd2BU1vSOARz9dmr4yRjX4QIedI80u7Siahr9b5TP4nnYe511g1ZY5LJnGevNVYL7SZ/TqsK95m+r25uIxLfF0o/npqasHCoH/nJnhs52WD2jfhfHjyxKpvUzA6iwW4pwyFDHpedgRqFN1SSa81BZBOybB7bQc3rRX8/AaWCz3antcztctVEynIcoIhkBdYFGDXo8HI3xvqgTEcrFNIh2GKS07+H1PDHXR5Dw== openpgp:0xE69E4814"
      ];
    };

    cloudhop = mkUser {
      shell = pkgs.powershell;
      keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1XRspEClARKnN06gEdb88Wh8XAz5nJqcQORV8UC++dEXOT+xSc7fp9WuVg02n++OtUQMnaRdZFXxhrF64zb4q8/HW9ycWlablt6Pl/E3kTIdXr+X3N/FMJoPSjAOqjgPrhGnw5Tkk72c1ZQKxyVRnyVysBFj/07sWgVYVgxAHtCP6AiKu9CLrdomz642GGuMsyL+GK/cWaabAdJLtFK/w6nh8CfljyhTEvGhkYDt2fW5dtnH8RhQ7opFHhG/NixbxlNrYSXpoKma7W2XzE5jDWEyMKDjXk51e0os+IWtjC8godJgy3cSp0Y9MkCRe1hu6uhtWQiFJLr/qOMHC5NJf mcclu@ERIKDESKTOP"
      ];
    };

    openskies = mkUser {
      shell = pkgs.bashInteractive;
      keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCza57+Kj+VdonMr4J/x6vbd14hcVOKlexInh/WXeEw6uhytX0Iu8gv5IKe6Ncn5oOrGbGuRAdx1D7IuVqV2nGxGrMwkc1Lu4+srZf0HiK0KyHf8g60OTew+JeaPA4zoesq4k71xg8YfLDUI9voctfTASuwHjSdiF6rMGjxj9a9ErWd/tDD9vpqeYss3dGNR28N7I5YeMfuWsAcUniUK4v97uHzP26ArODoHsBn3/JlHm4P7qeo+KwxC4mqbklX0vTEokOMSt7Wc1qJv7SVs37QtFp7smh0cn1lC0jWREpdEaoG2LZpM8fdc3kJEDXfz+K6qcxHTXnVqBbgNG5cGR1b aiverson@nixos"
      ];
    };
  };
}
