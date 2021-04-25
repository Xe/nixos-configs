{ lib, pkgs, config, ... }:

with lib;

let cfg = config.xe.neofetch;
in {
  options.xe.neofetch.enable = mkEnableOption "la'o neofetch bau la lojban";
  config = mkIf cfg.enable {
    home.file.".config/neofetch/config.conf".text = ''
      # See this wiki page for more info:
      # https://github.com/dylanaraps/neofetch/wiki/Customizing-Info
      print_info() {
          info title
          info underline

          info "samcmu" distro
          info "skami" model
          info "samcmuralju" kernel
          info "akti temci" uptime
          info "bakfu" packages
          info "calku" shell
          info "tilcfu" resolution
          info "cankyuijde ralju" wm
          info "cakselsampla" term
          info "samkroxo" cpu
          info "vidnyskami" gpu
          info "datnyvaugunma" memory
          #info "elsa" song

          info cols
      }

      kernel_shorthand="on"
      distro_shorthand="off"
      os_arch="on"
      uptime_shorthand="on"
      memory_percent="off"
      package_managers="on"
      shell_path="off"
      shell_version="on"
      speed_type="bios_limit"
      speed_shorthand="off"
      cpu_brand="on"
      cpu_speed="on"
      cpu_cores="logical"
      cpu_temp="off"
      gpu_brand="on"
      gpu_type="all"
      refresh_rate="off"
      gtk_shorthand="off"
      gtk2="on"
      gtk3="on"
      public_ip_host="http://ident.me"
      public_ip_timeout=2
      disk_show=('/')
      disk_subtitle="mount"
      music_player="amarok"
      song_format="%title% - %artist%"
      song_shorthand="off"

      mpc_args=()
      colors=(distro)
      bold="on"
      underline_enabled="on"
      underline_char="-"
      separator=":"
      block_range=(0 15)
      color_blocks="on"
      block_width=3
      block_height=1
      bar_char_elapsed="-"
      bar_char_total="="
      bar_border="on"
      bar_length=15
      bar_color_elapsed="distro"
      bar_color_total="distro"
      cpu_display="off"
      memory_display="off"
      battery_display="off"
      disk_display="off"
      image_backend="ascii"
      image_source="auto"
      ascii_distro="auto"
      ascii_colors=(distro)
      ascii_bold="on"
      image_loop="off"
      thumbnail_dir=$HOME/tmp
      crop_mode="normal"
      crop_offset="center"
      image_size="auto"
      gap=3
      yoffset=0
      xoffset=0
      background_color=
      stdout="off"
    '';

    home.packages = with pkgs; [ neofetch ];
  };
}
