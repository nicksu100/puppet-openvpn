# Usage :: 

class openvpn::package {

       package { "openvpn":  
                 ensure => "present",
                 source => $operatingsystem ? {
                 'OpenBSD' => "http://mirror.bytemark.co.uk/OpenBSD/${operatingsystemrelease}/packages/${architecture}/openvpn-2.2.2p1.tgz",
                 default   => undef,
        },
               }
 
    file { "/etc/openvpn":
           ensure => directory, 
           owner => "root",
           group => "wheel",
           mode => 0755, 
         }

    file { "/etc/rc.d/openvpn":
          owner => root,
          group => wheel,
          mode => 755,
          source => "puppet:///modules/openvpn/openvpn_init",
       }
   

}
