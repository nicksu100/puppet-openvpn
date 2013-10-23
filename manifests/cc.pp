# == Definition Resource Type: openvpn::cc
#
# This class installs Client configurations
#
# == Requirements/Dependencies
#
#
# === Parameters:
# - The $server_ip the server ip to route via
# - The $client_ip is the local IP
# - The $i_route any routes we want to publish
#   via OpenVPN to the serve and clients.
# Actions:
# - Install OpenVPN client configs for the server.
#
# Requires:
# - The openvpn::params class.
#
# == Usage
# Static client config
# Sample Usage:
##################################################################
#  $vpn_cc_ip             = "10.5.129"
#  $domain_name           = "acme.com"
#
#  $myhost1_iroute = "10.100.0.0 255.255.255.0"
#  $myhost2_iroute = "10.0.80.0 255.255.255.0"
#
#  openvpn::cc {
#    "myhost1.$domain_name":
#       i_route  => ["$myhost2_iroute"],
#       server_ip => "$vpn_cc_ip.1",
#       client_ip => "$vpn_cc_ip.2";
#    "myhost2.$domain_name":
#       i_route  => [],
#       server_ip => "$vpn_cc_ip.5",
#       client_ip => "$vpn_cc_ip.6";
#   }
#################################################################
  define openvpn::cc (
    $i_route,
    $server_ip,
    $client_ip,)
  {
      include openvpn::params
      $openvpn_dir = $openvpn::params::openvpn_dir
      $group_perms = $openvpn::params::group_perms

# Add cc fixed ip required for BGP
    file { "${openvpn_dir}/ccd/${name}":
      content => template('openvpn/cc.erb'),
      owner   => root,
      group   => "${group_perms}",
      mode    => '0644',
    }
  }
