# Usage ::
  class openvpn
  {
    include openvpn::params

    $openvpn_dir = $openvpn::params::openvpn_dir
    $group_perms = $openvpn::params::group_perms
    package { 'openvpn':
      ensure => 'present',
      source => "http://mirror.bytemark.co.uk/OpenBSD/${operatingsystemrelease}/packages/${architecture}/openvpn-2.2.2p1.tgz",
    }

    file { "${openvpn_dir}":
      ensure => directory,
      owner  => 'root',
      group  => "${group_perms}",
      mode   =>  '0755',
    }
    file { "${openvpn_dir}/ccd":
      ensure => directory,
      owner  => 'root',
      group  => "${group_perms}",
      mode   => '0755',
    }

    Exec {
      path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/local/bin',
    }

    case $::operatingsystem {
      OpenBSD: {
    file { '/etc/rc.d/openvpn':
      owner  => root,
      group  => "${group_perms}",
      mode   => '0755',
      source => 'puppet:///modules/openvpn/openvpn_init',
        }
      }
    }
  }
