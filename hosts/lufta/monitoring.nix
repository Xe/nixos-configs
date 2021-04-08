{ ... }: {
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        listenAddress = "10.77.3.1";
      };
      nginx = {
        enable = true;
        listenAddress = "10.77.3.1";
      };
      nginxlog = {
        enable = true;
        listenAddress = "10.77.3.1";
        settings = {
          namespaces = let
            format = ''
              $remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"'';
            mkApp = name: {
              metrics_override.prefix = "nginx";
              inherit name format;
              source.files = [ "/var/log/nginx/${name}.access.log" ];
              namespace_label = "vhost";
            };
          in [
            {
              name = "filelogger";
              inherit format;
              source.files = [ "/var/log/nginx/access.log" ];
            }
            (mkApp "gitea")
            (mkApp "goproxy")
            (mkApp "graphviz")
            (mkApp "hlang")
            (mkApp "idp")
            (mkApp "johaus")
            (mkApp "lewa")
            (mkApp "maison")
            (mkApp "mi")
            (mkApp "olin")
            (mkApp "printerfacts")
            (mkApp "todayinmarch2020")
            (mkApp "tulpaforce")
            (mkApp "tulpanomicon")
            (mkApp "when-then-zen")
            (mkApp "withinwebsite")
            (mkApp "xenafiles")
            (mkApp "xesite")
          ];
        };
        group = "nginx";
        user = "nginx";
      };
      wireguard = {
        enable = true;
        listenAddress = "10.77.3.1";
      };
    };
  };
}
