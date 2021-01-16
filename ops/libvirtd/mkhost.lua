#!/usr/bin/env nix-shell
--[[
#! nix-shell -p lua5_3 -p lua53Packages.dkjson -p wireguard -i lua
--]]

local json = require "dkjson"

local network = "fdd9:4a1e:bb91"

local function run(command)
  local f = assert(io.popen(command, 'r'))
  local s = assert(f:read('*a'))
  return s
end

local function read_file(path)
  local file = assert(io.open(path, "r"))
  local content = assert(file:read("*a"))
  file:close()
  return content
end

local subnet = run "tr -dc a-f0-9 </dev/urandom | head -c 4"
local ipaddr = string.format("%s:%s::/64", network, subnet)

local hostname = arg[1]
local endpoint = arg[2]

run(string.format("wg genkey | tee wireguard/secret/%s.privkey | wg pubkey | tr -d '\n' > wireguard/secret/%s.pubkey", hostname, hostname))
local pubkey = read_file(string.format("wireguard/secret/%s.pubkey", hostname))

local hosts = json.decode(read_file("./wireguard/hosts.json"))
hosts[hostname] = {
  allowedIPs = { ipaddr },
  publicKey = pubkey,
  endpoint = endpoint .. ":51822",
  persistentKeepalive = 25
}

local fout = assert(io.open("./wireguard/hosts.json", "w"))
fout:write(json.encode(hosts, { indent = true }))
fout:close()