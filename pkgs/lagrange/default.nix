{ pkgs ? import <nixpkgs> { }, stdenv ? pkgs.stdenv, fetchurl ? pkgs.fetchurl
, cmake ? pkgs.cmake, pkg-config ? pkgs.pkg-config
, openssl_1_1 ? pkgs.openssl_1_1, zlib ? pkgs.zlib, pcre ? pkgs.pcre
, libunistring ? pkgs.libunistring, SDL2 ? pkgs.SDL2, mpg123 ? pkgs.mpg123 }:

stdenv.mkDerivation rec {
  pname = "lagrange";
  version = "0.12.1";

  src = fetchurl {
    url =
      "https://git.skyjake.fi/skyjake/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "1p3j8k6zgmvnip8576cicsdk9f5vjzk9g9gpf5jhpjmjqf75g00w";
  };

  hardeningDisable = [ "format" ];
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl_1_1 zlib pcre libunistring SDL2 mpg123 ];
}
