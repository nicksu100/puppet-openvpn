# OpenVPN server creation
# A hub and spoke config
# Will create static configs for 2 hosts and publish their subnets 
# Parameters used in this test
# - The $vpn_cc_ip to use a consistent network for all client configs
# - The $domain_name domain name requrired to create correctly named file
# - The $myhost1_iroute publish a route from the server to entire hub.   
# - The $myhost2_iroute second hosts route.

  $vpn_cc_ip      = "10.8.1"
  $domain_name    = "acme.com"
  $myhost1_iroute = "10.100.0.0 255.255.255.0"
  $myhost2_iroute = "10.0.80.0 255.255.255.0"
 
  openvpn::server { 'vpnserver':
    tun_dev      => tun0,
    local_ip     => '10.1.0.26',
    vpn_server   => '10.8.0.0 255.255.255.0',
    vpn_route    => ["$vpn_cc_ip.0 255.255.255.0","$myhost1_iroute","$myhost2_iroute"],
    cc_route     => ["$myhost1_iroute","$myhost2_iroute"],
    log_level    => '1',
  }

  openvpn::cc {
    "myhost1.$domain_name":
       i_route   => ["$myhost1_iroute"],
       server_ip => "$vpn_cc_ip.1",
       client_ip => "$vpn_cc_ip.2";
    "myhost2.$domain_name":
       i_route   => ["$myhost2_iroute"],
       server_ip => "$vpn_cc_ip.5",
       client_ip => "$vpn_cc_ip.6";
   }

