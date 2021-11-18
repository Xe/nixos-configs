let
  pkgs = (import <nixpkgs> {});
  xe   = (import ../pkgs pkgs);
  vm   = pkgs.vmTools.diskImageFuns.debian8x86_64 {};
  args = {
    diskImage = vm;
    src       = xe.github.com.Xe.site.src;
    name      = "xesite-deb";
    buildInputs = [];
    meta.description = "No descr";
  };
in pkgs.releaseTools.debBuild args
