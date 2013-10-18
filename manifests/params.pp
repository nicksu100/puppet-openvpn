#
#
#
#
 class openvpn::params {

   $openvpn_dir = $::operatingsystem ? {
       FreeBSD => '/usr/local/etc/openvpn',
      default  => '/etc/openvpn'
   }  


   $group_perms = $::operatingsystem ? {
     FreeBSD		   => 'wheel',
     OpenBSD               => 'wheel',
    /(?i:Debian|Ubuntu)/   => 'root'
   }


   $restart = $::operatingsystem ? {
       FreeBSD  => '/usr/local/etc/init.d/openvpn restart',
       OpenBSD  => '/etc/rc.d/openvpn restart',
       default  => '/etc/init.d/openvpn restart'
   }

  $vpn_user = $::operatingsystem ? {
    FreeBSD  		 => 'nobody',
    OpenBSD  		 => '_openvpn',
    /(?i:Debian|Ubuntu)/ => 'nobody',
    default              => 'openvpn',
  }

  $vpn_group = $::operatingsystem ? {
    FreeBSD  		 => 'nobody',
    OpenBSD  		 => '_openvpn',
    /(?i:Debian|Ubuntu)/ => 'nogroup',
    default              => 'openvpn',
  }


  service { 'openvpn':
    	ensure    => running,
        hasstatus => false,
    	enable    => true,
    	pattern   => 'openvpn',
   }

      exec { 'openvpn_load':
                command     => "${restart}",
                refreshonly => true,
      }

}
