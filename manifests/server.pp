# Usage :: Add the following to your nodes manifest for the openvpn server
#  tun_dev : being the tun device
#  local_ip : being the listening address
# 
############################################################################
## Openvpn server
#          include openvpn::server
#          @openvpn::server::localvpnserver { "${hostname}vpnserver":
#           tun_dev => "tun0",
#           local_ip => "10.1.0.1",
#         }
#       realize( Openvpn::Server::Localvpnserver["${hostname}vpnserver"])
#############################################################################


class openvpn::server {
       define localvpnserver (
        $tun_dev,
        $local_ip,
        $port		 = "1194",
        $proto 		 = "udp",
        $vpn_server      = "10.5.128.0 255.255.255.0",
        $vpn_route	 = "10.5.129.0 255.255.255.0",
        $vpn_user	 = "_openvpn",
        $vpn_group	 = "_openvpn",
        $log_level	 = "1") 
    { 

 include openvpn::vpnconf

        file { "/etc/openvpn/server.conf":
          content => template("openvpn/server.erb"),
          owner => root,
          group => wheel,
          mode => 640,
          require => Package["openvpn"],
          notify => Exec[openvpn_load]
       }
    }

	file { "/etc/openvpn/ccd":
           ensure => directory, 
           owner => "root",
           group => "wheel",
           mode => 0755, 
         }

}
