{ fetchFromGitHub, stdenv, makeWrapper, perl532Packages }:

stdenv.mkDerivation {
  name = "ircmon-head";

  src = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./source.json));

  phases = "installPhase";

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out
    cp -vrf $src/* $out

    wrapProgram $out/main.pl --set PERL5LIB ${
      with perl532Packages;
      makeFullPerlPath [ DBI DBDSQLite Dotenv IOSocketSSL ]
    }
    wrapProgram $out/cgi.pl --set PERL5LIB ${
      with perl532Packages;
      makeFullPerlPath [ DBI DBDSQLite ]
    }
  '';
}
