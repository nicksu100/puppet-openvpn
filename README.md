puppet-openvpn
==============

####Table of Contents

1. [Overview - What is this OpenVPN Module.](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Sever Setup - The basics of getting started with OpenVPN Server. ](#server-setup)
4. [Static Client Setup - Supporting static clients or BGP configurations. ](#static-client-setup)
5. [Client Setup - How to connect to your server. ](#client-setup)
6. [Tls-auth - Creating your ta.key for use with this module. ](#tls-auth)

##Overview

This OpenVPN module uses the Puppet Certificate Authority. This negates the need to setup a Certificate Authority. 
I am using this setup to provide an iBGP full mesh backup on OpenBSD.

##Module Description


OpenVPN is a widely-used ssl vpn. This module creates the OpenVPN server and client configurations for puppet managed machines. 
Because I am using puppet keys this module enforces the use of tls-auth see [tls-auth](#tls-auth). 

##Server Setup

 ``` 
# Sample Usage:
  openvpn::server {'vpnserver':
            tun_dev     => tun0,
            local_ip    => '10.1.0.26',
            vpn_server => '10.8.0.0 255.255.255.0',
            vpn_route  => ["10.8.1.0 255.255.255.0","10.8.2.0 255.255.255.0"],
            log_level  => '1',
          }

 ```

##Static Client Setup
 Static client configs can be implemented as below which would create 2 config files. 

 myhost1.acme.com

 myhost2.acme.com 

 With the following content 

 myhost1.acme.com: ifconfig-push 10.5.129.1  10.5.129.2

 myhost2.acme.com  ifconfig-push 10.5.129.1  10.5.129.2
 ``` 
           $vpn_cc_ip             = "10.5.129"
           $domain_name           = "acme.com"

           openvpn::cc {
             "myhost1.$domain_name":
                server_ip => "$vpn_cc_ip.1",
                client_ip => "$vpn_cc_ip.2";
            "myhost2.$domain_name":
                server_ip => "$vpn_cc_ip.5",
                client_ip => "$vpn_cc_ip.6";
           }

 ```

## Client Setup
 Make remote_ip => the address of your server or fqdn.

 Make tun_dev   => your tun device
 ```
          openvpn::client {
               "server1":
                remote_ip => "server1.acme.com",
                tun_dev   => "tun0",
              }
 ```

## Tls-auth
You will need to run the following from a machine with openvpn installed.  

 ```
openvpn --genkey --secret ta.key
 ```
Then copy the ta.key file over a secure channel to the files directory under the puppet-openvpn module.

Here is some more information on why the ta.key is a good idea taken from openvpn.net:

>The tls-auth directive adds an additional HMAC signature to all SSL/TLS handshake packets for integrity verification. Any UDP packet not bearing the correct HMAC signature can be dropped without further processing. The tls-auth HMAC signature provides an additional level of security above and beyond that provided by SSL/TLS. It can protect against:
>   * DoS attacks or port flooding on the OpenVPN UDP port.
>   * Port scanning to determine which server UDP ports are in a listening state.
>   * Buffer overflow vulnerabilities in the SSL/TLS implementation.
>   * SSL/TLS handshake initiations from unauthorized machines (while such handshakes would ultimately fail to authenticate, tls-auth can cut them off at a much earlier point).



