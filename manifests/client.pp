# == Definition Resource Type: openvpn::server
#
# This class installs OpenVPN client
#
# == Requirements/Dependencies
#
#
# === Parameters:
# - The $vpnserver the ip address or fqdn of your server
# - The $tun_dev the tun device to use.
# - The $tap false if using openvpn routing true if using bridging.
#
# Actions:
# - Install OpenVPN and client config
#
# Requires:
# - The openvpn class.
# - The openvpn::ta class.
# - The openvpn::params class.
#
#  Sample Usage:
# - The following config is setting up bridging the ip address to be supplied from the client config. This config can be used
# - in conjunction with BGP.
#          openvpn::client {
#               'server1':
#                vpnserver => '192.168.10.1',
#                tun_dev   => 'tun0',
#                tap       => true,
#          }
#
# - The following config would use Openvpn routing. The ip address and routing can be provided using the client configs.
#          openvpn::client {
#               'server1':
#                vpnserver => '192.168.10.1',
#                tun_dev   => 'tun0',
#          }
######################################################################

  define openvpn::client (
    $vpnserver,
    $tun_dev,
    $tap         = false,
    $remote_port = '1194',
    $proto       = 'udp',)
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

    if $tap {
      file { "/etc/hostname.$tun_dev":
        content => template('openvpn/client_hostname_tun.erb'),
        owner   => root,
        group   => "${group_perms}",
        mode    => '0640',
        require => Package['openvpn'],
        notify  => Exec[openvpn_load]
      } 
    }
  }
