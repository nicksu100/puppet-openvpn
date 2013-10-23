# Create client config
  openvpn::client {
    "vpnserver":
     remote_ip => "10.1.0.26",
     tun_dev     => "tun0",
  }
