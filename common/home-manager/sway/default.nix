{ config, nixosConfig, pkgs, lib, ... }:
with lib;
let
  cfg = nixosConfig.cadey.sway;
  nanpa = pkgs.tulpa.dev.cadey.nanpa;
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
            text = "#32302f";
          };
          active = rec {
            border = "#b16286";
            background = border;
            text = "#32302f";
          };
        in {
          terminal = "${pkgs.nur.repos.xe.st}/bin/st";
          bars = [{
            fonts = [ "Primihi 11" "Hack 10" ];
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
            statusCommand = if cfg.i3status then
              "${pkgs.i3status}/bin/i3status"
            else
              "${pkgs.tulpa.dev.cadey.cabytcini}/bin/cabytcinysuhei";
            workspaceButtons = true;
            workspaceNumbers = false;
            trayOutput = "primary";
          }];
          colors = {
            focused = rec {
              background = "#d3869b";
              border = "#bdae93";
              text = "#32302f";
              indicator = "#2e9ef4";
              childBorder = "#3d3285";
            };
            focusedInactive = rec {
              background = "#b16286";
              border = "#bdae93";
              text = "#ebdbb2";
              indicator = "#b57614";
              childBorder = "#3d3285";
            };
            unfocused = rec {
              background = "#8f3f71";
              border = "#bdae93";
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
          fonts = [ "Primihi 12" "Hack 10" ];
          gaps = {
            horizontal = 3;
            vertical = 3;
            inner = 3;
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
              "${modifier}+e" = "exec $HOME/bin/e";

              "${modifier}+s" = "exec grim";
              "${modifier}+Shift+s" = "exec slurp | grim -g -";

              "${modifier}+1" = "exec ${nanpa}/bin/nanpac switch 1";
              "${modifier}+2" = "exec ${nanpa}/bin/nanpac switch 2";
              "${modifier}+3" = "exec ${nanpa}/bin/nanpac switch 3";
              "${modifier}+4" = "exec ${nanpa}/bin/nanpac switch 4";
              "${modifier}+5" = "exec ${nanpa}/bin/nanpac switch 5";
              "${modifier}+6" = "exec ${nanpa}/bin/nanpac switch 6";
              "${modifier}+7" = "exec ${nanpa}/bin/nanpac switch 7";
              "${modifier}+8" = "exec ${nanpa}/bin/nanpac switch 8";
              "${modifier}+9" = "exec ${nanpa}/bin/nanpac switch 9";

              "${modifier}+m" = "focus output DP-1";
              "${modifier}+k" = "focus output HDMI-A-1";

              "${modifier}+Shift+1" = "exec ${nanpa}/bin/nanpac move 1";
              "${modifier}+Shift+2" = "exec ${nanpa}/bin/nanpac move 2";
              "${modifier}+Shift+3" = "exec ${nanpa}/bin/nanpac move 3";
              "${modifier}+Shift+4" = "exec ${nanpa}/bin/nanpac move 4";
              "${modifier}+Shift+5" = "exec ${nanpa}/bin/nanpac move 5";
              "${modifier}+Shift+6" = "exec ${nanpa}/bin/nanpac move 6";
              "${modifier}+Shift+7" = "exec ${nanpa}/bin/nanpac move 7";
              "${modifier}+Shift+8" = "exec ${nanpa}/bin/nanpac move 8";
              "${modifier}+Shift+9" = "exec ${nanpa}/bin/nanpac move 9";

              "${modifier}+Shift+0" = "sticky toggle";

              "${modifier}+Shift+minus" = "move scratchpad";
              "${modifier}+minus" = "scratchpad show";
            };
          output = nixosConfig.cadey.sway.output;
          startup = [
            {
              command = "systemctl --user restart waybar";
              always = true;
            }
            { command = "mako -c ${./mako.conf}"; }
            { command = "firefox"; }
            { command = "Discord"; }
            {
              command = "systemctl --user restart nanpad";
              always = true;
            }
            {
              command =
                "systemctl --user restart xdg-desktop-portal xdg-desktop-portal-wlr";
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
      grim # for screenshots
      slurp
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
    ];
    home.file.".config/mako/config".source = ./mako.conf;

    systemd.user.services = {
      nanpad = {
        Unit.Description = "workspace nanpa daemon";
        Service = {
          Type = "simple";
          ExecStart = "${nanpa}/bin/nanpad";
        };
        Install.WantedBy = [ "sway-session.target" ];
      };

      xdg-desktop-portal = {
        Unit.Description = "XDG Desktop Portal";
        Service.ExecStart =
          "${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal";
        Install.WantedBy = [ "sway-session.target" ];
      };

      xdg-desktop-portal-wlr = {
        Unit.Description = "XDG Desktop Portal for wlroots compositors";
        Service.ExecStart =
          "${pkgs.xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr";
        Install.WantedBy = [ "sway-session.target" ];
      };
    };
  };
}
