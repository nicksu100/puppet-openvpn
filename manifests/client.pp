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
                $proto 		= 'udp',
                $vpn_user       = '_openvpn',
                $vpn_group      = '_openvpn')
    {

      include openvpn
      include openvpn::ta
      include openvpn::params

      file { "/etc/openvpn/${name}.conf":
         content => template('openvpn/client.erb'),
         owner   => root,
         group   => wheel,
         mode    => '0640',
         require => Package['openvpn'],
         notify  => Exec[openvpn_load]
         }
     }
