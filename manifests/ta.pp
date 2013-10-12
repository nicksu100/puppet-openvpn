# Usage::
# Importand generate your own key with
# openvpn --genkey --secret ta.key

class openvpn::ta {


	file { "/etc/openvpn/ta.key":
          owner  => root,
          group  => wheel,
          mode   => 600,
          source => "puppet:///modules/openvpn/ta.key",
       }


}
