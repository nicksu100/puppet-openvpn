# Usage ::

class openvpn {

	include openvpn::params

       $openvpn_dir = $openvpn::params::openvpn_dir
       $group_perms = $openvpn::params::group_perms

       package { 'openvpn':
                 ensure => 'present',
               }

      file { "${openvpn_dir}":
           ensure => directory,
           owner  => 'root',
           group  => "${group_perms}",
           mode   =>  '0755',
         }
      file { "${openvpn_dir}/ccd":
           ensure => directory,
           owner  => 'root',
           group  => "${group_perms}",
           mode   => '0755',
      }

     case $::operatingsystem {
          OpenBSD: {
     file { '/etc/rc.d/openvpn':
          owner  => root,
          group  => "${group_perms}",
          mode   => '0755',
          source => 'puppet:///modules/openvpn/openvpn_init',
     } 
   }
  }
}
