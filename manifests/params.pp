#
#
#
#
 class openvpn::params {

   case $::operatingsystem ? {
       'freebsd': {
        $openvpn_dir = '/usr/local/etc/openvpn'
      }
     default: {
      	  $openvpn_dir = '/etc/openvpn'
      }

   }


  service { 'openvpn':
    	ensure    => running,
        hasstatus => false,
    	enable    => true,
    	pattern   => 'openvpn',
   }

      exec { 'openvpn_load':
                command     => '/etc/rc.d/openvpn restart',
                refreshonly => true,
      }

}
