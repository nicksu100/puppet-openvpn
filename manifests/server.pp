# == Definition Resource Type: openvpn::server
#
# This class installs OpenVPN server
#
# == Requirements/Dependencies
#
# === Parameters:
# - The $tun_dev tun device to configure the host on
# - The $local_ip IP the server is the listening on.
# - The $vpn_server gives the default IP range.
# - The $vpn_route defines the push routes to our clients.
# - The $vpn_server_ip defines the ip of the vpn server required for bridge mode
# - The $log_level is the log level.
# - The $tap if our device is tap device required if using bridging.
# - The $client_to_client set to true allows clients to connect to each other. 
# Actions:
# - Install OpenVPN
# Requires:
# - The openvpn class.
# - The openvpn::ta class.
# - The openvpn::params class.
#
#
# Sample Usage: 
# Create a openvpn server using bridging for use in combination with BGP. Each subsequent client can use
# incremental ip of 10.8.0.2, 10.8.0.3 and so on. 
#
#  openvpn::server {'vpnserver':
#     tun_dev              => tun0,
#     tap                  => true,
#     local_ip             => '192.168.10.1',
#     vpn_server           => '10.8.0.0 255.255.255.0',
#     vpn_server_ip        => '10.8.0.1',
#     log_level            => '1',
#   }
#
#
#   Create a server using OpenVPN routing to publish 10.8.1.0/24 and# 10.8.2.0/24 to all clients. 
#  openvpn::server {'vpnserver':
#    tun_dev    => tun0,
#    local_ip   => '10.1.0.26',
#    vpn_server => '10.8.0.0 255.255.255.0',
#    vpn_route  => ["10.8.1.0 255.255.255.0","10.8.2.0 255.255.255.0"],
#    log_level  => '1',
#  }
#############################################################################
  define openvpn::server (
    $tun_dev,
    $local_ip,
    $vpn_server,
    $vpn_route,
    $log_level,
    $vpn_route        = undef,
    $vpn_server_ip    = undef,
    $tap              = false,  
    $client_to_client = false,
    $port             = '1194',
    $proto            = 'udp',)
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
   if $::osfamily == 'OpenBSD' { 
     if $tap {
         file { "/etc/hostname.$tun_dev":
           content => template('openvpn/server_hostname_tun.erb'),
           owner   => root,
           group   => "${group_perms}",
           mode    => '0640',
           require => Package['openvpn'],
           notify  => Exec[openvpn_load]
       }
     } 
  }
Exec { path => "/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/local/bin" }
    exec { 'create_dh':
      onlyif  => "test ! -f ${openvpn_dir}/dh2048.pem",
      command => "openssl dhparam -out ${openvpn_dir}/dh2048.pem 2048"
    }
  }
