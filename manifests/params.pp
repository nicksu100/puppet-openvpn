#
#
#
#
 class openvpn::params {

  case $operatingsystem {
    "freebsd": {
        $openvpn_dir = "/usr/local/etc/openvpn"
      }
     default: {
      	  $openvpn_dir = "/etc/openvpn"
      }
  
   }


  service { "openvpn":
        hasstatus => false,
        start  => $operatingsystem ? {
              'OpenBSD'  => "/etc/rc.d/openvpn restart",
               default   => undef,
        },
        stop      => $operatingsystem ? {
              'OpenBSD'  => "/etc/rc.d/openvpn stop",
               default   => undef,
        },
    	enable  => true,
    	ensure  => running,
    	pattern => "openvpn",
   }

      exec { "openvpn_load":
                command     => "/etc/rc.d/openvpn restart",
                refreshonly => true,
      }

}
