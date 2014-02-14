puppet-openvpn
==============

####Table of Contents

1. [Overview - What is this OpenVPN Module.](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Sever Setup - The basics of getting started with OpenVPN Server. ](#server-setup)
4. [Client Setup - How to connect to your server. ](#client-setup)
5. [Tls-auth - Creating your ta.key for use with this module. ](#tls-auth)

##Overview
This OpenVPN module uses the Puppet Certificate Authority. This negates the need to setup a separate certificate Authority. You can either use this module to create a hub and spoke setup using OpenVPN routing or this can be used in conjunction with OpenBGP if you are running on BSD. 

##Module Description
OpenVPN is a widely-used ssl vpn. This module creates the OpenVPN server and client configurations for puppet managed machines. 
Because I am using puppet keys this module enforces the use of tls-auth see [tls-auth](#tls-auth).This module
is ideally suited to when you have gateway machines connecting to a central site. By using client-configs. 
we can publish networks so the server and all client machines become routable. If you are using a BSD variant then we can use
OpenBGP to inject routes instead of OpenVPN routing. 

##Server Setup
This server setup can either use OpenVPN to provide routing or a third party software like OpenBGP.

### Configure the OpenVPN server in Bridging mode to be used in combination with OpenBGP.  
(Currently this mode only works on OpenBSD.)
This example has 3 clients donald, daffy and mickey. This time we are just allocating fix ip addresses routing can
be provided by OpenBGP.


 ```

#Setup the OpenVPN server listening on 10.1.0.26.
   openvpn::server {'vpnserver':
     tun_dev              => tun0,
     tap                  => true,
     local_ip             => '10.1.0.26',
     vpn_server           => '10.8.0.0 255.255.255.0',
     vpn_server_ip        => '10.8.0.1',
     log_level            => '1',
   } 
# Setup the Client Configs on the OpenVPN server.
  openvpn::client_configs {
    "donald.$domain_name":
      client_ip => "10.8.0.2";
    "daffy.$domain_name":
       client_ip => "10.8.0.3";
     "mickey.$domain_name":
        client_ip => "10.8.0.4";
  }
 ```
### Configurations for clients connecting to bridge mode server.

 ```
  openvpn::client {
    "vpnserver":
      remote_ip => "10.1.0.26",
      tun_dev   => "tun0",
      tap       => true,
  }
 ```


### Configure a server using OpenVPN routing for 3 clients. 
This example has 3 clients donald, daffy and mickey. Donald will publish the route 10.0.10.0/24, daffy will publish the route 10.0.20.0/24 and mickey will just be a client. 

Add the following to your vpn servers manifest.

 ```
#Set up variables. 
  $client_config_leading  = "10.8.1"
  $domain_name            = "acme.com"
  $donald_iroute          = "10.0.10.0 255.255.255.0"
  $daffy_iroute           = "10.0.20.0 255.255.255.0"
#Setup the OpenVPN server listening on 10.1.0.26.
   openvpn::server {'vpnserver':
     tun_dev              => tun0,
     local_ip             => '10.1.0.26',
     vpn_server           => '10.8.0.0 255.255.255.0',
     vpn_route            => ["$client_config_leading.0 255.255.255.0","$donald_iroute","$daffy_iroute"],
     log_level            => '1',
   } 
# Setup the Client Configs on the OpenVPN server.
  openvpn::client_configs {
    "donald.$domain_name":
      i_route   => ["$donald_iroute"],
      server_ip => "$client_config_leading.1",
      client_ip => "$client_config_leading.2";
    "daffy.$domain_name":
       i_route   => ["$daffy_iroute"],
       server_ip => "$client_config_leading.5",
       client_ip => "$client_config_leading.6";
     "mickey.$domain_name":
        i_route   => [],
        server_ip => "$client_config_leading.9",
        client_ip => "$client_config_leading.10";
  }
 ```
### Configure for clients connecting to a OpenVPN server using tun mode.

The following config would use Openvpn routing. The ip address and routing can be provided using the client configs.
 ```  
  openvpn::client {
    'server1':
     vpnserver => '10.1.0.26',
     tun_dev   => 'tun0',
  }
 ```
The following table provided last octet in the IP address for the client config endpoints

 ```
[  1,  2] [  5,  6] [  9, 10] [ 13, 14] [ 17, 18]
[ 21, 22] [ 25, 26] [ 29, 30] [ 33, 34] [ 37, 38]
[ 41, 42] [ 45, 46] [ 49, 50] [ 53, 54] [ 57, 58]
[ 61, 62] [ 65, 66] [ 69, 70] [ 73, 74] [ 77, 78]
[ 81, 82] [ 85, 86] [ 89, 90] [ 93, 94] [ 97, 98]
[101,102] [105,106] [109,110] [113,114] [117,118]
[121,122] [125,126] [129,130] [133,134] [137,138]
[141,142] [145,146] [149,150] [153,154] [157,158]
[161,162] [165,166] [169,170] [173,174] [177,178]
[181,182] [185,186] [189,190] [193,194] [197,198]
[201,202] [205,206] [209,210] [213,214] [217,218]
[221,222] [225,226] [229,230] [233,234] [237,238]
[241,242] [245,246] [249,250] [253,254]
 ```

## Tls-auth
You will need to run the following from a machine with openvpn installed.  

 ```
openvpn --genkey --secret ta.key
 ```
Then copy the ta.key file over a secure channel to the files directory under the puppet-openvpn module so it can be called by.
 ```
 source => 'puppet:///modules/openvpn/ta.key'
 ```

Here is some more information on why the ta.key is a good idea taken from openvpn.net:

>The tls-auth directive adds an additional HMAC signature to all SSL/TLS handshake packets for integrity verification. Any UDP packet not bearing the correct HMAC signature can be dropped without further processing. The tls-auth HMAC signature provides an additional level of security above and beyond that provided by SSL/TLS. It can protect against:
>   * DoS attacks or port flooding on the OpenVPN UDP port.
>   * Port scanning to determine which server UDP ports are in a listening state.
>   * Buffer overflow vulnerabilities in the SSL/TLS implementation.
>   * SSL/TLS handshake initiations from unauthorized machines (while such handshakes would ultimately fail to authenticate, tls-auth can cut them off at a much earlier point).



