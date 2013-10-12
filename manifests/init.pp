# Usage :: 

class openvpn {

       include openvpn::params
  
       $openvpn_dir = $openvpn::params::openvpn_dir

       package { "openvpn":  
                 ensure => "present",
                 source => $operatingsystem ? {
                 'OpenBSD' => "http://mirror.bytemark.co.uk/OpenBSD/${operatingsystemrelease}/packages/${architecture}/openvpn-2.2.2p1.tgz",
                 default   => undef,
        },
               }
 
      file { "${openvpn_dir}":
           ensure => directory, 
           owner  => "root",
           group  => "wheel",
           mode   => 0755, 
         }
      file { "${openvpn_dir}/ccd":
           ensure => directory,
           owner  => "root",
           group  => "wheel",
           mode   => 0755,
      }


     file { "/etc/rc.d/openvpn":
          owner => root,
          group => wheel,
          mode => 755,
          source => "puppet:///modules/openvpn/openvpn_init",
        }
      

}
