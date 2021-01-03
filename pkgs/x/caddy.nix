{ stdenv }:

stdenv.mkDerivation {
  pname = "caddy";
  version = "1.0.4";
  src = builtins.fetchurl {
    url =
      "https://github.com/caddyserver/caddy/releases/download/v1.0.4/caddy_v1.0.4_linux_amd64.tar.gz";
    sha256 = "0cmlwkp3cjx5yw3947y91wymsr398knq92q3iwc57bdzdi33fzwy";
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    tar zxf $src
    mkdir -p $out/bin
    cp ./caddy $out/bin/caddy
  '';
}
