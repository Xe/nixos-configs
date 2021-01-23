{ nixpkgs, declInput }: let pkgs = import nixpkgs {}; in {
  jobsets = pkgs.runCommand "spec.json" {} ''
    cat <<EOF
    ${builtins.toXML declInput}
    EOF
    cat > $out <<EOF
    {
        "pkgs": {
            "enabled": 1,
            "hidden": false,
            "description": "js",
            "nixexprinput": "src",
            "nixexprpath": "pkgs/release.nix",
            "checkinterval": 300,
            "schedulingshares": 100,
            "enableemail": false,
            "emailoverride": "",
            "keepnr": 3,
            "inputs": {
                "src": { "type": "git", "value": "git://github.com/Xe/nixos-configs", "emailresponsible": false },
                "nixpkgs": { "type": "git", "value": "git://github.com/NixOS/nixpkgs.git nixos-unstable", "emailresponsible": false }
            }
        }
    }
    EOF
  '';
}
