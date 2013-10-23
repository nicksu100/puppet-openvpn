# Usage::
# Important generate your own key with
# openvpn --genkey --secret ta.key
# Save your key to "modules/openvpn/files/ta.key"
  class openvpn::ta {
    include openvpn::params
    file { '/etc/openvpn/ta.key':
      owner  => root,
      group  => $group_perms,
      mode   => '0600',
      source => 'puppet:///modules/openvpn/ta.key',
    }
  }
