let pkgs = import <nixpkgs> { };
in pkgs.snapTools.makeSnap rec {
  meta = rec {
    name = "zathura-transparent";
    summary = "the Zathura PDF reader with transparency support";
    description = summary;
    architectures = [ "amd64" ];
    apps.zathura = {
      plugs = [ "home" "x11" ];
      command = "${pkgs.nur.repos.xe.zathura}/bin/zathura";
    };
    confinement = "strict";
  };
}
