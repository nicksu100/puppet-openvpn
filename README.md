puppet-openvpn
==============

####Table of Contents

1. [Overview - What is this OpenVPN Module](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Sever Setup - The basics of getting started with OpenVPN ](#server-setup)
4. [Static Client Setup -  ](#static-client-setup)
5. [Client Setup](#client-setup)

##Overview

This OpenVPN module uses the Puppet Certificate Authority. This negates the need to setup a Certificate Authority.   

##Module Description


OpenVPN is a widely-used ssl vpn. This module creates the OpenVPN server and client configurations for puppet managed machines. 

##Server Setup

 ...

##Openvpn server
          include openvpn::server
          @openvpn::server::localvpnserver { "${hostname}vpnserver":
           tun_dev => "tun0",
           local_ip => "10.1.0.1",
         }
       realize( Openvpn::Server::Localvpnserver["${hostname}vpnserver"])

##Static Client Setup
 Static client configs can be implemented as below which would create 2 config files. This is required if you are using BGP for routing. 
 myhost1.acme.com
 myhost2.acme.com 
 With the following content 
 myhost1.acme.com: ifconfig-push 10.5.129.1  10.5.129.2
 myhost2.acme.com  ifconfig-push 10.5.129.1  10.5.129.2
 ...
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

 ...

## Client Setup

Add the follwoing to your clients node manifest.
 Make remote_ip => the address of your server or fqdn.
 Make tun_dev   => your tun device

          openvpn::client {
               "server1":
                remote_ip => "server1.acme.com",
                tun_dev   => "tun0",
              }
