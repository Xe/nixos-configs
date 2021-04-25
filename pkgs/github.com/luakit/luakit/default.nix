{ stdenv, fetchurl, pkgconfig, wrapGAppsHook, help2man, luafilesystem
, luajit, sqlite, webkitgtk, gtk3, gst_all_1, glib-networking, luasocket }:

stdenv.mkDerivation rec {
  pname = "luakit";
  version = "git";

  src = fetchurl {
    url = "https://github.com/luakit/luakit/archive/refs/tags/2.3.tar.gz";
    sha256 = "15b094cby4n7p51zq8xrymbavryk91szi04bg51lz96z1d7nn0n7";
  };

  nativeBuildInputs = [ pkgconfig help2man wrapGAppsHook ];

  buildInputs = [
    webkitgtk
    luafilesystem
    luasocket
    luajit
    sqlite
    gtk3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    glib-networking # TLS support
  ];

  preBuild = ''
    # build-utils/docgen/gen.lua:2: module 'lib.lousy.util' not found
    # TODO: why is not this the default? The test runner adds
    # ';./lib/?.lua;./lib/?/init.lua' to package.path, but the build-utils
    # scripts don't add an equivalent
    export LUA_PATH="$LUA_PATH;./?.lua;./?/init.lua"
  '';

  makeFlags = [
    "DEVELOPMENT_PATHS=0"
    "USE_LUAJIT=1"
    "INSTALLDIR=${placeholder "out"}"
    "PREFIX=${placeholder "out"}"
    "USE_GTK3=1"
    "XDGPREFIX=${placeholder "out"}/etc/xdg"
  ];

  preFixup = let
    luaKitPath = "$out/share/luakit/lib/?/init.lua;$out/share/luakit/lib/?.lua";
  in ''
    gappsWrapperArgs+=(
      --prefix XDG_CONFIG_DIRS : "$out/etc/xdg"
      --prefix LUA_PATH ';' "${luaKitPath};$LUA_PATH"
      --prefix LUA_CPATH ';' "$LUA_CPATH"
    )
  '';

  meta = with stdenv.lib; {
    description =
      "Fast, small, webkit based browser framework extensible in Lua";
    homepage = "https://luakit.github.io/";
    license = licenses.gpl3;
    platforms = platforms.linux; # Only tested linux
  };
}
