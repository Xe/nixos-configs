{ stdenv }:

stdenv.mkDerivation {
  name = "johaus";
  src = builtins.fetchurl {
    url =
      "https://xena.greedo.xeserv.us/files/slugs/johaus-061520192052.tar.gz";
    sha256 = "0cfx2skh7bz9w4p6xbcns14wgf2szkqlrga6dvnxrhlh3i0if519";
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    tar xf $src
    mkdir -p $out/bin
    cp bin/web $out/bin/johaus
  '';
}
