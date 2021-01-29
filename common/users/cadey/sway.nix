{ config, nixosConfig, pkgs, lib, ... }:
with lib;
let cfg = nixosConfig.cadey.sway;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      # emulate my dwm config
      config = with pkgs; {
        terminal = "${pkgs.nur.repos.xe.st}";
        bars = [{
          fonts = [ "Dunda 8" "Hack 8" ];
          colors = {
            background = "#282828";
            statusline = "#ebdbb2";
            separator = "#666666";
            focusedWorkspace = {
              border = "#d3869b";
              background = "#282828";
              text = "#fbf1c7";
            };
            activeWorkspace = {
              border = "#b16286";
              background = "#1d2021";
              text = "#ebdbb2";
            };
            inactiveWorkspace = {
              border = "#333333";
              background = "#222222";
              text = "#888888";
            };
            urgentWorkspace = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
            };
            bindingMode = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
            };
          };
          command = "${pkgs.sway}/bin/swaybar";
          hiddenState = "hide";
          mode = "dock";
          position = "top";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          workspaceButtons = true;
          trayOutput = "primary";
        }];
        floating = {
          criteria =
            [ { title = "Steam - Update News"; } { class = "Pavucontrol"; } ];
          titlebar = true;
        };
        focus = { followMouse = "yes"; };
        fonts = [ "Dunda 8" "Hack 8" ];
        gaps = {
          horizontal = 6;
          vertical = 6;
          inner = 12;
          smartBorders = "on";
          smartGaps = true;
        };
        keybindings =
          let modifier = config.wayland.windowManager.sway.config.modifier;
          in lib.mkOptionDefault {
            "${modifier}+Shift+Return" = "exec ${pkgs.nur.repos.xe.st}/bin/st";
            "${modifier}+Shift+c" = "kill";
            "${modifier}+p" =
              "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu -nb '#1d2021' -nf '#ebdbb2' -sb '#b16286' -sf '#fbf1c7' | ${pkgs.findutils}/bin/xargs swaymsg exec --";
            "${modifier}+t" = "layout toggle split";
            "${modifier}+f" = "layout tabbed";
            "${modifier}+u" = "layout stacking";
            "${modifier}+e" = "exec $home/bin/e";
          };
        output = nixosConfig.cadey.sway.output;
        startup = [
          {
            command = "systemctl --user restart waybar";
            always = true;
          }
          {
            command = "firefox";
            always = true;
          }
          {
            command = "Discord";
            always = true;
          }
        ];
        window = { border = 1; };
      };
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
    };
    home.packages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
    ];
  };
}
