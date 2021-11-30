{ stdenv }:

stdenv.mkDerivation {
  name = "idp";
  src = builtins.fetchurl {
    url =
      "https://xena.greedo.xeserv.us/files/slugs/idp-031320190918.tar.gz";
    sha256 = "10jh58npq33xr7038g35h7pyh0cpd12fl4bv028l9hvisv9bky2n";
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp $src/web $out/bin/idp
  '';
}
