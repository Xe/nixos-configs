{ lib, stdenv, fetchgit, libX11, libXinerama, libXft }:

let
  pname = "dwm";
  version = "6.2-kadis";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchgit (builtins.fromJSON (builtins.readFile ./source.json));

  buildInputs = [ libX11 libXinerama libXft ];

  prePatch = ''sed -i "s@/usr/local@$out@" config.mk'';

  buildPhase = " make ";

  meta = {
    homepage = "https://suckless.org/";
    description = "Dynamic window manager for X";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xe ];
    platforms = with lib.platforms; all;
  };
}
