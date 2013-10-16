#Usage:
# Static client config
# Can be implemented as below which would create 2 config files
# myhost1.acme.com
# myhost2.acme.com
# With the following content
# myhost1.acme.com: ifconfig-push 10.5.129.1  10.5.129.2
# myhost2.acme.com  ifconfig-push 10.5.129.1  10.5.129.2
##################################################################
#           $vpn_cc_ip             = "10.5.129"
#           $domain_name           = "acme.com"
#
#           openvpn::cc {
#             "myhost1.$domain_name":
#                server_ip => "$vpn_cc_ip.1",
#                client_ip => "$vpn_cc_ip.2";
#            "myhost2.$domain_name":
#                server_ip => "$vpn_cc_ip.5",
#                client_ip => "$vpn_cc_ip.6";
#           }

#################################################################

 define openvpn::cc (
           $server_ip,
           $client_ip)

   { 

 include openvpn::params

      $openvpn_dir = $openvpn::params::openvpn_dir
      $group_perms = $openvpn::params::group_perms

# Add cc fixed ip required for BGP
    file { "${openvpn_dir}/ccd/${name}":
         content => template('openvpn/cc.erb'),
         owner   => root,
         group   => ${group_perms},
         mode    => '0644',
     }
   }
