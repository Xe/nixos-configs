{ config, pkgs, ... }:

{
  users.users.cadey = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "docker" "audio" "plugdev" "libvirtd" "adbusers" "dialout" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDK1sv1j0XAuHkcUB78D1S0Gv1mvJDjpCcZSTSgR5j3vxFoONctnb1BtnV75zR5YRkAfDNs00qeL+nyWA1s2VR9onaYRTQYO5TRsJhOgSijthn8qT8uK1ws1tWWui/sPzxbLu34nW8IsoQm3iFLD9yQCR7GK9e4WOU5itqLNMyh5jS7LTRKCSC2mi9IvYyTfFMggtuF3u7yFTksR02FOoox2YPzB8bHM3xBqPK46Z+fq+/mWaulnoXWcC3SZgjwpRmcEOAmTEQuk67jlpeumGqRU3lO6UFY3FDvQ8W1VYv2O1ZwPmV87S1pIEulX3WG+r7lO73bPT420PdoQehS/pY7"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsviqiUuN6t4YM2H+ApQtGAFx6TWJbWCqDDhInIh3X40ZAxtTmryRwAXdtHJ+v6HuGFU5XH3chDX1WSRbwVIrlxkX1hJIEZO379YSIHkORSrAmxF/2lsrW2zSjufZ6IS9yI7nsxe2mJf3GEiFjoAh2iGrSKnOACK2Y+o/SiO0BtDkOUIabofuAxf/RNOpn/HSPh/MabOxYuNOMO2bl+quYN7C1idyvVcNp0llfrnGGTCk5g3rDpR+CDQ0P2Ebg1hf4j2i/6XJmHL52Zg4b8hkoS9BzRcb2vOjGYZVR4lOMqR9ZcNMUBwMboJeQtsAib9DYaGjhMWgMQ76brXwE65sX"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPrz5T/RdragJF6StZm92JZKPMJinYdw5fYnV4osiY8Q"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH6BhO4roUnnppgf4GPDonhu0DOaA60dZ+JaFBZUa+IW"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg9gYKVglnO2HQodSJt4z4mNrUSUiyJQ7b+J798bwD9"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAv/8Iprp3f+THr9txqoWKTO5KxnYVpiKI7e4mdTO2+b"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBp8WiNUFK6mbehvO94LAzIA4enTuWxugABC79tiQSHT"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC1e4qhGYEUCNoCYHUqfvPSkBfVdlIjmwQI7q8eibeWw"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOyr7PjUfbALe3+zgygnL0fQz4GhQ7qT9b0Lw+1Gzwk"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQAQCZLLbbrMTsR1NYqFRftXM2Dm8V83uaOrAxIy7zZ"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL46usOZyZD+CYa5wNBSpPxNWwF3EMeeAytPq6iVPO2X"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN76Ol48QNvRjjjIaAa3WPqVWB/ryFMmOUJpszEz13TO"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYr9hiLtDHgd6lZDgQMkJzvYeAXmePOrgFaWHAjJvNU"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.cadey.openssh.authorizedKeys.keys;

  users.users.mai = {
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOyr7PjUfbALe3+zgygnL0fQz4GhQ7qT9b0Lw+1Gzwk"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg9gYKVglnO2HQodSJt4z4mNrUSUiyJQ7b+J798bwD9"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPrz5T/RdragJF6StZm92JZKPMJinYdw5fYnV4osiY8Q"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0I+UJPT7noL/bDvPj25SC24kpThqHUtge3tSQ9sIUx"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL46usOZyZD+CYa5wNBSpPxNWwF3EMeeAytPq6iVPO2X"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN76Ol48QNvRjjjIaAa3WPqVWB/ryFMmOUJpszEz13TO"
    ];
  };

  users.users.vic = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "adbusers" "dialout" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZBjzU/7vrR8isVC2xzRamcREWw+oLeB2cS+zfZwqEwXHTI99LonR2ow5xlnngmBcJMQo8aIChwwX4iHVuUIx5ObvfbtauqWjImr8ItNqJgMnbPXwzNVJmuuhC7ThxoSYWlmyRQNChE1BAcVeSqU9Vjvc4No9GYAOMOazeAhz5jnesauemFU1WTgIcdnUyuBA2vHNYj/I0K5FHUSjpePccCwpCz+5ieELMcpGv+Wtlq8v8OiasxmLP7MORX6AClvqPtczd5M40rLlX96AoEXuviUbEvy2GzaKsutzyI7OdnfCMw2PWhxL0kjNWsU4VAYVH1EdOfoJeeEO8FuSUIQnd"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIChFSS2KUKbGYFrkbO2VwxuWqFkCSdzbxh68Edk+Pkss victo@Nami"
    ];
  };

  environment.systemPackages = [ pkgs.git ];
}
