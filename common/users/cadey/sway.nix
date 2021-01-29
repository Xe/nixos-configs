{ config, nixosConfig, pkgs, lib, ... }:
with lib;
let cfg = nixosConfig.cadey.sway;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      # emulate my dwm config
      config = with pkgs;
        let
          focused = rec {
            border = "#d3869b";
            background = border;
            text = "#fbf1c7";
          };
          active = rec {
            border = "#b16286";
            background = border;
            text = "#fbf1c7";
          };
        in {
          terminal = "${pkgs.nur.repos.xe.st}";
          bars = [{
            fonts = [ "Crisa 10" "Hack 10" ];
            colors = {
              background = "#282828";
              statusline = "#ebdbb2";
              separator = "#666666";
              focusedWorkspace = focused;
              activeWorkspace = active;
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
            workspaceNumbers = true;
            trayOutput = "primary";
          }];
          colors = {
            focused = rec {
              background = "#d3869b";
              border = background;
              text = "#32302f";
              indicator = "#2e9ef4";
              childBorder = "#3d3285";
            };
            focusedInactive = rec {
              background = "#b16286";
              border = background;
              text = "#ebdbb2";
              indicator = "#b57614";
              childBorder = "#3d3285";
            };
            unfocused = rec {
              background = "#8f3f71";
              border = background;
              text = "#ebdbb2";
              indicator = "#b57614";
              childBorder = "#3d3285";
            };
          };
          floating = {
            criteria =
              [ { title = "Steam - Update News"; } { class = "Pavucontrol"; } ];
            titlebar = true;
          };
          focus = { followMouse = "yes"; };
          fonts = [ "Crisa 12" "Hack 10" ];
          gaps = {
            horizontal = 3;
            vertical = 3;
            inner = 12;
            smartBorders = "on";
            smartGaps = true;
          };
          workspaceAutoBackAndForth = true;
          keybindings =
            let modifier = config.wayland.windowManager.sway.config.modifier;
            in lib.mkOptionDefault {
              "${modifier}+Shift+Return" =
                "exec ${pkgs.nur.repos.xe.st}/bin/st";
              "${modifier}+Shift+c" = "kill";
              "${modifier}+p" =
                "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu -nb '#1d2021' -nf '#ebdbb2' -sb '#b16286' -sf '#fbf1c7' | ${pkgs.findutils}/bin/xargs swaymsg exec --";
              "${modifier}+t" = "layout toggle split";
              "${modifier}+f" = "layout tabbed";
              "${modifier}+u" = "layout stacking";
              "${modifier}+e" = "exec $home/bin/e";

              "${modifier}+1" = "workspace ";
              "${modifier}+2" = "workspace ";
              "${modifier}+3" = "workspace ";
              "${modifier}+4" = "workspace ";
              "${modifier}+5" = "workspace ";
              "${modifier}+6" = "workspace ";
              "${modifier}+7" = "workspace ";
              "${modifier}+8" = "workspace ";
              "${modifier}+9" = "workspace ";

              "${modifier}+Shift+1" =
                "move container to workspace ";
              "${modifier}+Shift+2" =
                "move container to workspace ";
              "${modifier}+Shift+3" =
                "move container to workspace ";
              "${modifier}+Shift+4" =
                "move container to workspace ";
              "${modifier}+Shift+5" =
                "move container to workspace ";
              "${modifier}+Shift+6" =
                "move container to workspace ";
              "${modifier}+Shift+7" =
                "move container to workspace ";
              "${modifier}+Shift+8" =
                "move container to workspace ";
              "${modifier}+Shift+9" =
                "move container to workspace ";
            };
          output = nixosConfig.cadey.sway.output;
          startup = [
            {
              command = "systemctl --user restart waybar";
              always = true;
            }
            { command = "firefox"; }
            { command = "Discord"; }
          ];
          window = { border = 1; };
        };
      extraConfig = ''
        set $ws1 1:
        set $ws2 2:
        set $ws3 3:
        set $ws4 4:
        set $ws5 5:
        set $ws6 6:
        set $ws7 7:
        set $ws8 8:
        set $ws9 9:
      '';
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
      grim # for screenshots
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
    ];
  };
}
