{ stdenv }:

stdenv.mkDerivation {
  name = "johaus";
  src = builtins.fetchTarball {
    url =
      "https://xena.greedo.xeserv.us/files/slugs/johaus-061520192052.tar.gz";
    sha256 = "10xa74rrdsd24z5xqqq3m44d1lv4vf8rl2vffys8vrvj3zcxma12";
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp $src/web $out/bin/johaus
  '';
}
