{ lib, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute }:

buildGoModule rec {
  pname = "tailscale";
  version = "date.20200727";
  tagHash =
    "37adb62a35d818f4af638924d3fc1526bdeaf215"; # from `git rev-parse v1.2.7`

  src = builtins.fetchTarball "https://github.com/Xe/tailscale/archive/report-status-systemd.tar.gz";

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  vendorSha256 = "1l894lw23aj8r3ypr9i4d1hklz1kfqshnqgdfi1xfzx8k7zw1a36";

  doCheck = false;

  subPackages = [ "cmd/tailscale" "cmd/tailscaled" ];

  preBuild = ''
    export buildFlagsArray=(
      -tags="xversion"
      -ldflags="-X tailscale.com/version.Long=${version} -X tailscale.com/version.Short=${version} -X tailscale.com/version.GitCommit=${tagHash}"
    )
  '';

  postInstall = ''
    wrapProgram $out/bin/tailscaled --prefix PATH : ${
      lib.makeBinPath [ iproute iptables ]
    }
    sed -i -e "s#/usr/sbin#$out/bin#" -e "/^EnvironmentFile/d" ./cmd/tailscaled/tailscaled.service
    install -D -m0444 -t $out/lib/systemd/system ./cmd/tailscaled/tailscaled.service
  '';

  meta = with lib; {
    homepage = "https://tailscale.com";
    description = "The node agent for Tailscale, a mesh VPN built on WireGuard";
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = with maintainers; [ danderson mbaillie ];
  };
}
