# == Definition Resource Type: openvpn::server
#
# This class installs OpenVPN client 
#
# == Requirements/Dependencies
#
#
# === Parameters:
# - The $remote_ip the ip address or fqdn of your server 
# - The $tun_dev the tun device to use. 
#
# Actions:
# - Install OpenVPN and client config 
#
# Requires:
# - The openvpn class.
# - The openvpn::ta class.
# - The openvpn::params class.
#

#          openvpn::client {
#               'server1':
#                remote_ip => 'server1.acme.com',
#                tun_dev   => 'tun0',
#              }
#
######################################################################

define openvpn::client (
	        $remote_ip,
                $tun_dev,
                $remote_port 	= '1194',
                $proto 		= 'udp',)
    {

      include openvpn
      include openvpn::ta
      include openvpn::params

      $openvpn_dir = $openvpn::params::openvpn_dir
      $group_perms = $openvpn::params::group_perms


      file { "${openvpn_dir}/${name}.conf":
         content => template('openvpn/client.erb'),
         owner   => root,
         group   => "${group_perms}",
         mode    => '0640',
         require => Package['openvpn'],
         notify  => Exec[openvpn_load]
         }
     }
