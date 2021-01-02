{ stdenv }:

stdenv.mkDerivation {
  name = "idp";
  src = builtins.fetchTarball {
    url =
      "https://xena.greedo.xeserv.us/files/slugs/idp-031320190918.tar.gz";
    sha256 = "049nlgni1myai7l9jzhxvx3k9fv4cwv8dcjj0g3z686k3vijki5g";
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp $src/web $out/bin/idp
  '';
}
