{ config, lib, ... }:
with lib; {
  options = {
    cadey.colemak = {
      enable = mkEnableOption "Enables colemak for the default X config";
      ignore = {
        identifier = mkOption {
          type = types.str;
          description = "Keyboard input identifier to send raw keycodes for";
          default = "moonlander";
        };
        product = mkOption {
          type = types.str;
          description = "Keyboard input product to send raw keycodes for";
          default = "Moonlander";
        };
      };
    };
  };

  config = mkIf config.cadey.colemak.enable {
    console.useXkbConfig = true;
    services.xserver = {
      layout = "us";
      xkbVariant = "colemak";
      xkbOptions = "caps:escape";

      inputClassSections = [
        ''
          Identifier "yubikey"
          MatchIsKeyboard "on"
          MatchProduct "Yubikey"
          Option "XkbLayout" "us"
          Option "XkbVariant" "basic"
        ''
        ''
          Identifier "gergoplex"
          MatchIsKeyboard "on"
          MatchProduct "GergoPlex"
          Option "XkbLayout" "us"
          Option "XkbVariant" "basic"
        ''
        ''
          Identifier "${config.cadey.colemak.ignore.identifier}"
          MatchIsKeyboard "on"
          MatchProduct "${config.cadey.colemak.ignore.product}"
          Option "XkbLayout" "us"
          Option "XkbVariant" "basic"
        ''
      ];
    };
  };
}
