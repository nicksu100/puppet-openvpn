# Usage :: 
# Add the follwoing to your clients node manifest
# Make remote_ip => the address of your server or fqdn
#######################################################################
#  include openvpn::client
#          @openvpn::client::localvpnclient { "${hostname}daffy":
#           remote_ip => "10.1.0.1",
#         }
#       realize( Openvpn::Client::Localvpnclient["${hostname}ables"])
######################################################################


class openvpn::client {
      define localvpnclient (
	 	$remote_ip, 
                $remote_port 	= "1194", 
                $proto 		= "udp", 
                $vpn_user       = "_openvpn",
                $vpn_group      = "_openvpn",
                $tun_dev	= "tun0") 
    {

      include openvpn::package
      include openvpn::vpnconf

      file { "/etc/openvpn/client.conf":
         content => template("openvpn/client.erb"),
         owner => root,
         group => wheel,
         mode => 640,
         require => Package["openvpn"],
         notify => Exec[openvpn_load]
         }
      } 
   
}  
