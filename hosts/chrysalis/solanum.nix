{ config, pkgs, lib, ... }:

{
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
        name = "chrysalis.akua";
        sid = "420";
        description = "Queen Chrysalis";
        network_name = "akua";

        vhost = "10.77.2.2";
        vhost6 = "fda2:d982:1da2:ed22:9064:6df9:4855:611d";
      };

      listen {
        host = "0.0.0.0";
        port = 6667;
      };

      auth {
        user = "*@*";
        class = "users";
        flags = exceed_limit;
      };

      channel {
        default_split_user_count = 0;
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
        privs = oper:admin, oper:die, oper:rehash, oper:spy, oper:grant;
      };

      operator "Mara" {
        user = "*@*";
        password = "L/b5FCMZ1DUc2";
        snomask = "+Zbfkrsuy";
        flags = encrypted;
        privset = "admin";
      };
    '';
    openFilesLimit = 65536;
  };
}
