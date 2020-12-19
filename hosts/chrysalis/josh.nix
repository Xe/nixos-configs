{ config, pkgs, ... }:

{
  users.users.josh = {
    isNormalUser = true;
    shell = pkgs.zsh;
    # from https://github.com/josharian.keys
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAodKa2OpzqRwfm3SEa6enjwE8LccS9LnGdFX4cgbzXgslS8QQTpJbWVe6v6sqGA6aAvkisu/RYgAZ+znvQjYXe/KLyoVN1phdJlTZXh/jVB1cdzMX4ri9S6jdl5FSZDb6g9jvWMel5IkfccnfH/thfqPw7L3z0/nIaXlyUL/G3EBBlS3M2DyaDfMJs1uHaWR1A5z5W8QX7XPua3U204W+HIkUf1BvHU05NpKx2vp/U+6ygcHoiQ74c7WnLKaF7w4Iz/uUJiPKHD5/iCjBqs89llRln6tzYuf8wp5Vj6IFF0xo47kmyKQmZJsOFsV5RYPhBB+cfpD4TTR3sG6JzXBigw=="
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBDNiaVM+J/ib2nD7AIky7w3nxkvEKdP+6jtlVrtfs5Es7RgaThTmpvJbX5shi3Ub9R95XF2Jg92fV2NlvVoa/DlCMoiqs0zw2BsieCk7de/6ntnwo+HNKqIemj80RB7hKD5bLKE+1lGheWHjXcOs3qA+xPo53OCfpMO3+AT6RdXldvrIBVSZOQuKfZfcmMqPJdTDHQN86U5WDknR/ONrMntSoj+4kmo5KzLgsihcCHqk47pnbWgzECYIlhQg9S2sQKaqeSd9aOUrlLNHsWqu9hCUWe5ewWoV5i4W3V3lOV04T6FOpQJP4hE61GEd0VsFfQydTvEYz1PQF/Neyze5H"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDwZktFiWsBjrEC6H7R9QGq6W+OaHmheXLy0Of6T6lU3Z93NihxU9TMjbSmVnkcoAQCvjdRjIJcdQusgJAxB8+pxMQqpbvJnXKWsUQAa6XSn2ucVLKEGbE3k1vZ4SURIIimnZJ5tIMQbziAcyzsln9beGv7JyYqec9ZVRz/qbmoehur5vOwG/YKfgtxnBy4Gw1AddVbNJ1mtslS1bQHZVN8F2bx/gVS3tFiZ8FNDgBPEJc4vhPBXYiiAn6jlmy8nZMG3vvyiusJ7uqLltYaOUuM/zgKdXoDuQbUAiq/eVyeMHbq3aaAK8q2xRKKUPZtnKh5CESQy2Z7aZba1M3N3HT5"
    ];
  };

  home-manager.users.josh = { config, pkgs, ... }: {
    home.packages = with pkgs; [ vim gopls go goimports git ];
  };
}
