# Usage ::
# Add the follwoing to your clients node manifest.
# Make remote_ip => the address of your server or fqdn.
# Make tun_dev   => your tun device
#######################################################################
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
