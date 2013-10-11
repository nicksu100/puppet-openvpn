#Usage:
# Static client config
# Add the following to your node manifests. The cchostname must match
# the clients common name found in your puppet certs.
#
##################################################################
#         include openvpn::cc
#        $vpn_cc_ip              = "10.5.129"
#        $domain_name            = "acme.com"
#        @openvpn::cc::localclientconfig { "a1":
#            server_ip => "$vpn_cc_ip.1",
#            client_ip => "$vpn_cc_ip.2",
#            cchostname => "a1.$domain_name",
#        }
#      @openvpn::cc::localclientconfig { "a2":
#            server_ip => "$vpn_cc_ip.5",
#            client_ip => "$vpn_cc_ip.6",
#            cchostname => "a2.$domain_name",
#        }
#      @openvpn::cc::localclientconfig { "a3":
#            server_ip => "$vpn_cc_ip.9",
#            client_ip => "$vpn_cc_ip.10",
#            cchostname => "a3.$domain_name",
#        }
#      @openvpn::cc::localclientconfig { "a4":
#            server_ip => "$vpn_cc_ip.13",
#            client_ip => "$vpn_cc_ip.14",
#            cchostname => "a4.$domain_name",
#        }
#      @openvpn::cc::localclientconfig { "ables":
#            server_ip => "$vpn_cc_ip.17",
#            client_ip => "$vpn_cc_ip.18",
#            cchostname => "a5.$domain_name",
#        }
#
##       realize( Openvpn::Cc::Localclientconfig["abante"],
#                Openvpn::Cc::Localclientconfig["abell"],
#                Openvpn::Cc::Localclientconfig["ables"],
#                Openvpn::Cc::Localclientconfig["leda"],
##                Openvpn::Cc::Localclientconfig["wack"],)
#
#################################################################


class openvpn::cc {

      define localclientconfig (
           $server_ip,
           $client_ip,
           $cchostname )
    {


# Add cc fixed ip required for BGP


    file { "/etc/openvpn/ccd/${cchostname}":
         content => template("openvpn/cc.erb"),
         owner => root,
         group => wheel,
         mode => 644,
      }
   }
}
