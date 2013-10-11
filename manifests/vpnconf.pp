# Usage::

class openvpn::vpnconf {


	file { "/etc/openvpn/ta.key":
         owner => root,
         group => wheel,
         mode => 600,
         source => "puppet:///modules/openvpn/ta.key",
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
    enable => true,
    ensure => running,
    pattern => "openvpn",
   }

      exec { "openvpn_load":
                command => '/etc/rc.d/openvpn restart',
                refreshonly => true,
        }
}
