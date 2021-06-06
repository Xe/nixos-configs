{config, pkgs, lib, ...}:

let
  metadata = pkgs.callPackage ../../../ops/metadata/peers.nix { };
  info = metadata.raw."${config.networking.hostName}".solanum;
in {
  services.solanum = {
    enable = true;
    motd = ''
      MMMMMMMMMMMMMMMMMMNmmNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNmmmd.:mmMM
      MMMMMMMMMMMMMMMMMNmmmNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNmmydmmmmmNMM
      MMMMMMMMMMMMMMMMNm/:mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNmms /mmmmmMMM
      MMMMMMMMMMMMMMMNmm:-dmMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNmmmmdsdmmmmNMMM
      MMMMMMMMMMMMMMMmmmmmmmNMMMMMMMMMMMNmmdhhddhhmNNMMMMMMMMMMMMMMMMNmy:hmmmmmmmmMMMM
      MMMMMMMMMMMMMMNm++mmmmNMMMMMMmdyo/::.........-:/sdNMMMMMMMMMMNmmms`smmmmmmmNMMMM
      MMMMMMMMMMMMMMmd.-dmmmmMMmhs/-....................-+dNMMMMMMNmmmmmmmmmmmmmmMMMMM
      MMMMMMMMMMMMMNmmmmmmmmho:-...........................:sNMMNmmmmmmmmmmmmmmmNMNmdd
      MMMMMMMMMMMMNmd+ydhs/-.................................-sNmmmmmmmmmmmmmmmdhyssss
      MMMMMMMMMMMNNh+`........................................:dmmmmmmmmmmmmmmmyssssss
      MMMMNNdhy+:-...........................................+dmmmmmmmmmmmmmmmdsssssss
      MMMN+-...............................................-smmmmmmmmmmmmmmmmmysyyhdmN
      MMMMNho:::-.--::-.......................----------..:hmmmmmmmmmmmmmmmmmmmNMMMMMM
      MMMMMMMMNNNmmdo:......................--------------:ymmmmmmmmmmmmmmmmmmmMMMMMMM
      MMMMMMMMMMds+........................-----------------+dmmmmmmmmmmmmmmmmmMMMMMMM
      MMMMMMMMMh+........................--------------------:smmmmmmmmmmmmmmNMMMMMMMM
      MMMMMMMNy/........................-------------::--------/hmmmmmmmmmmmNMMMMMMNmd
      MMMMMMMd/........................--------------so----------odmmmmmmmmMMNmdhhysss
      MMMMMMm/........................--------------+mh-----------:ymmmmdhhyysssssssss
      MMMMMMo.......................---------------:dmmo------------+dmdysssssssssssss
      yhdmNh:......................---------------:dmmmm+------------:sssssssssssyhhdm
      sssssy.......................--------------:hmmmmmmos++:---------/sssyyhdmNMMMMM
      ssssso......................--------------:hmmmNNNMNdddysso:------:yNNMMMMMMMMMM
      ysssss.....................--------------/dmNyy/mMMd``d/------------sNMMMMMMMMMM
      MNmdhy-...................--------------ommmh`o/NM/. smh+-----------:yNMMMMMMMMM
      MMMMMN+...................------------/hmmss: `-//-.smmmmd+----------:hMMMMMMMMM
      MMMMMMd:..................----------:smmmmhy+oosyysdmmy+:.  `.--------/dMMMMMMMM
      MMMMMMMh-................---------:smmmmmmmmmmmmmmmh/`      `/s:-------sMMMMMMMM
      MMMMMMMms:...............-------/ymmmmmmmmmmmmmmmd/        :dMMNy/-----+mMMMMMMM
      MMMMMMmyss/..............------ommmmmmmmmmmmmmmmd.       :yMMMMMMNs:---+mMMMMMMM
      MMMMNdssssso-............----..odmmmmmmmmmmmmmmh:.`    .sNMMMMMMMMMd/--sMMMMMMMM
      MMMmysssssssh/................`  -odmmmmmmmmmh+.     `omMMMMMMMMMMMMh/+mMMMMMMMM
      MNdyssssssymMNy-..............     `/sssso+:.      `+mMMMMMMMMMMMMMMMdNMMMMMMMMM
      NhssssssshNMMMMNo:............/.`                `+dMMMMMMMMMMMMMMMMMMMMMMMMMMMM
      ysssssssdMMMMMMMMm+-..........+ddy/.`          -omMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
      ssssssymMMMMMMMMMMMh/.........-oNMMNmy+--` `-+dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
      ssssydNMMMMMMMMMMMMMNy:........-hMMMMMMMNmdmMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
      sssymMMMMMMMMMMMMMMMMMm+....-..:hMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
      symNMMMMMMMMMMMMMMMMMMMNo.../-/dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
      dNMMMMMMMMMMMMMMMMMMMMMMh:.:hyNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
          '';
    config = ''
      loadmodule "extensions/chm_adminonly";
      loadmodule "extensions/chm_nonotice";
      loadmodule "extensions/chm_operonly";
      loadmodule "extensions/chm_sslonly";
      #loadmodule "extensions/chm_operpeace";
      #loadmodule "extensions/createauthonly";
      loadmodule "extensions/extb_account";
      loadmodule "extensions/extb_canjoin";
      loadmodule "extensions/extb_channel";
      loadmodule "extensions/extb_combi";
      loadmodule "extensions/extb_extgecos";
      loadmodule "extensions/extb_hostmask";
      loadmodule "extensions/extb_oper";
      loadmodule "extensions/extb_realname";
      loadmodule "extensions/extb_server";
      loadmodule "extensions/extb_ssl";
      loadmodule "extensions/extb_usermode";
      #loadmodule "extensions/helpops";
      #loadmodule "extensions/hurt";
      loadmodule "extensions/ip_cloaking_4.0";
      #loadmodule "extensions/ip_cloaking";
      #loadmodule "extensions/m_extendchans";
      #loadmodule "extensions/m_findforwards";
      #loadmodule "extensions/m_identify";
      #loadmodule "extensions/m_locops";
      #loadmodule "extensions/no_oper_invis";
      loadmodule "extensions/sno_farconnect";
      loadmodule "extensions/sno_globalnickchange";
      loadmodule "extensions/sno_globaloper";
      #loadmodule "extensions/sno_whois";
      loadmodule "extensions/override";
      loadmodule "extensions/no_kill_services";

      serverinfo {
        name = "${config.networking.hostName}.alrest";
        sid = "${info.sid}";
        description = "${info.description}";
        network_name = "akua";
      };

      listen {
        host = "0.0.0.0";
        port = 6667;
      };

      class "users" {
        ping_time = 2 minutes;
        number_per_ident = 10;
        number_per_ip = 10;
        number_per_ip_global = 50;
        cidr_ipv4_bitlen = 24;
        cidr_ipv6_bitlen = 64;
        number_per_cidr = 200;
        max_number = 3000;
        sendq = 400 kbytes;
      };

      class "opers" {
        ping_time = 5 minutes;
        number_per_ip = 10;
        max_number = 1000;
        sendq = 1 megabyte;
      };

      class "server" {
        ping_time = 5 minutes;
        connectfreq = 5 minutes;
        max_number = 420;
        sendq = 4 megabytes;
      };

      auth {
        user = "*@*";
        class = "users";
        flags = exceed_limit;
      };

      channel {
        default_split_user_count = 0;
      };

      privset "local_op" {
        privs = oper:general, oper:privs, oper:testline, oper:kill, oper:operwall, oper:message,
          usermode:servnotice, auspex:oper, auspex:hostname, auspex:umodes, auspex:cmodes;
      };

      privset "server_bot" {
        /* extends: a privset to inherit in this privset */
        extends = "local_op";
        privs = oper:kline, oper:remoteban, snomask:nick_changes;
      };

      privset "global_op" {
        extends = "local_op";
        privs = oper:routing, oper:kline, oper:unkline, oper:xline,
          oper:resv, oper:cmodes, oper:mass_notice, oper:wallops,
          oper:remoteban;
      };

      privset "admin" {
        extends = "global_op";
        privs = oper:admin, oper:die, oper:rehash, oper:spy, oper:grant, oper:privs;
      };

      operator "Mara" {
        user = "*@*";
        password = "L/b5FCMZ1DUc2";
        snomask = "+Zbfkrsuy";
        flags = encrypted;
        privset = "admin";
      };

      connect "kos-mos.alrest" {
        host = "100.72.50.9";
        send_password = "hunter2";
        accept_password = "hunter2";
        port = 6667;
        class = "server";
        flags = topicburst, autoconn;
      };

      connect "logos.alrest" {
        host = "100.106.69.58";
        send_password = "hunter2";
        accept_password = "hunter2";
        port = 6667;
        class = "server";
        flags = topicburst, autoconn;
      };

      connect "ontos.alrest" {
        host = "100.66.226.109";
        send_password = "hunter2";
        accept_password = "hunter2";
        port = 6667;
        class = "server";
        flags = topicburst, autoconn;
      };

      connect "pneuma.alrest" {
        host = "100.120.235.118";
        send_password = "hunter2";
        accept_password = "hunter2";
        port = 6667;
        class = "server";
        flags = topicburst, autoconn;
      };

      connect "services." {
        host = "100.67.184.57";
        send_password = "hunter2";
        accept_password = "hunter2";
        class = "server";
      };

      service {
        name = "services.";
      };
    '';
    openFilesLimit = 65536;
  };
}
