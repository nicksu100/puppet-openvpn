# == Definition Resource Type: openvpn::client_configs
#
# This class installs Client configurations
#
# == Requirements/Dependencies
#
#
# === Parameters:
# - The $client_ip is the local IP
# - The $server_ip if using the server ip to route via server.
# - The $bridge_netmask if using bridging we need to set a mask client configs can be incremental ips.
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
#           $domain_name = "acme.com"
#
#           openvpn::client_configs {
#             "myhost1.$domain_name":
#                client_ip => "$vpn_cc_ip.2";
#            "myhost2.$domain_name":
#                client_ip => "$vpn_cc_ip.3";
#            "myhost3.$domain_name":
#                client_ip => "$vpn_cc_ip.4";
#           }
##################################################################
#           $vpn_cc_ip             = "10.5.129"
#           $domain_name           = "acme.com"
#
#           $myhost1_iroute = "10.100.0.0 255.255.255.0"
#           $myhost2_iroute = "10.0.80.0 255.255.255.0"
#
#
#
#           openvpn::client_configs {
#             "myhost1.$domain_name":
#                 i_route  => ["$myhost2_iroute"],
#                client_ip => "$vpn_cc_ip.2";
#                server_ip => "$vpn_cc_ip.1",
#            "myhost2.$domain_name":
#                client_ip => "$vpn_cc_ip.6";
#                server_ip => "$vpn_cc_ip.5",
#           }
#################################################################
  define openvpn::client_configs (
    $client_ip,
    $i_route        = undef,
    $server_ip      = undef,
    $bridge_netmask = undef, )
  {
      include openvpn::params
      $openvpn_dir = $openvpn::params::openvpn_dir
      $group_perms = $openvpn::params::group_perms

      # need to make condition fire if server_ip and bridge_netmask undef

# Add cc fixed ip required for BGP
    file { "${openvpn_dir}/ccd/${name}":
      content => template('openvpn/client_configs.erb'),
      owner   => root,
      group   => "${group_perms}",
      mode    => '0644',
    }
  }
