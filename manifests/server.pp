# == Definition Resource Type: openvpn::server
#
# This class installs OpenVPN server 
#
# == Requirements/Dependencies
#
#
# === Parameters:
# - The $tun_dev to configure the host on
# - The $local_ip is the listenin IP
# - The $vpn_server gives the default IP range 
# - The $vpn_route defines the push routes to our clients
# - The $log_level is the log level
#
# Actions:
# - Install OpenVPN 
#
# Requires:
# - The openvpn class.
# - The openvpn::ta class.
# - The openvpn::params class.
#
# Sample Usage:
#  openvpn::server {'eqserver':
#            tun_dev    => tun0,
#            local_ip   => '10.1.0.26',
#            vpn_server => '10.8.0.0 255.255.255.0',
#            vpn_route  => ["10.8.1.0 255.255.255.0","10.8.2.0 255.255.255.0"],
#            log_level  => '1',
#          }
#############################################################################
  define  openvpn::server ( 
        $tun_dev,
        $local_ip,
        $vpn_server,
        $vpn_route,
        $log_level,	 
        $port		 = '1194',
        $proto 	 = 'udp',)
     {

  include openvpn
  include openvpn::ta
  include openvpn::params

      $openvpn_dir = $openvpn::params::openvpn_dir
      $group_perms = $openvpn::params::group_perms

        file { "${openvpn_dir}/server.conf":
          content => template('openvpn/server.erb'),
          owner   => root,
          group   => "${group_perms}",
          mode    => '0640',
          require => Package['openvpn'],
          notify  => Exec[openvpn_load],
       }

     exec { 'create_dh':
     onlyif   => "test ! -f ${openvpn_dir}/dh2048.pem",
      command => "/usr/sbin/openssl dhparam -out ${openvpn_dir}/dh2048.pem 2048"
     }
 }
