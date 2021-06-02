{ stdenv, fetchurl, pkgconfig, writeText, libX11, ncurses, libXft }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "st-0.8.2";

  src = fetchurl {
    url = "https://dl.suckless.org/st/${name}.tar.gz";
    sha256 = "0ddz2mdp1c7q67rd5vrvws9r0493ln0mlqyc3d73dv8im884xdxf";
  };

  conf = readFile ./config.h;
  patches = [
    ./st-alpha-0.8.2.diff
    ./st-clipboard-0.8.2.diff
    ./st-bold-is-not-bright-20190127-3be4cf1.diff
    ./st-scrollback-0.8.2.diff
    ./st-scrollback-mouse-0.8.2.diff
    ./st-boxdraw_v2-0.8.2.diff
    ./st-anysize-0.8.1.diff
  ];

  prePatch = optionalString (conf != null) ''
    cp ${writeText "config.def.h" conf} config.h
  '';

  nativeBuildInputs = [ pkgconfig ncurses ];
  buildInputs = [ libX11 libXft ];

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  meta = {
    homepage = "https://st.suckless.org/";
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [ xe ];
    platforms = platforms.linux;
  };
}
