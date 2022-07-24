/ip firewall address-list
add address=240.0.0.0/4 comment=Bogon_Networks list=bogon
add address=0.0.0.0/8 list=bogon
add address=100.64.0.0/10 list=bogon
add address=10.0.0.0/8 list=bogon
add address=127.0.0.0/8 list=bogon
add address=169.254.0.0/16 list=bogon
add address=172.16.0.0/12 list=bogon
add address=192.0.0.0/24 list=bogon
add address=192.0.2.0/24 list=bogon
add address=192.168.0.0/16 list=bogon
add address=198.18.0.0/15 list=bogon
add address=198.51.100.0/24 list=bogon
add address=203.0.113.0/24 list=bogon
add address=224.0.0.0/4 list=bogon
add address=192.168.88.0/24 comment=Winbox list=winbox-allow
add address=192.168.89.0/24 list=winbox-allow


/ip firewall filter 
add action=drop chain=input comment=bogon_disallow \
    in-interface=[/interface get [find comment=inet or comment=WAN] name] \
    src-address-list=bogon

add action=accept chain=input comment=VPN_IPSec port=1701,500,4500 protocol=udp

add action=accept chain=input protocol=ipsec-esp

add action=accept chain=input comment=icmp in-interface=[/interface get \
    [find comment=inet or comment=WAN] name] \
    limit=50/5s,2:packet protocol=icmp

add action=drop chain=input comment=Pings_Drop in-interface=[/interface get \
    [find comment=inet or comment=WAN] name] \
    protocol=icmp

add action=drop chain=input comment="drop invalid" connection-state=invalid

# Port scan drop
add action=drop chain=input comment=Port_scanner_drop src-address-list=\
    "port scanners" disabled=yes

add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input in-interface=[/interface get \
    [find comment=inet or comment=WAN] name] protocol=tcp psd=21,3s,3,1 \
    disabled=yes

add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input in-interface=[/interface get \
    [find comment=inet or comment=WAN] name] protocol=tcp \
    tcp-flags=fin,!syn,!rst,!psh,!ack,!urg disabled=yes

add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input in-interface=[/interface get \
    [find comment=inet or comment=WAN] name] protocol=tcp \
    tcp-flags=fin,syn disabled=yes

add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input in-interface=[/interface get \
    [find comment=inet or comment=WAN] name] protocol=tcp \
    tcp-flags=syn,rst disabled=yes

add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input in-interface=[/interface get \
    [find comment=inet or comment=WAN] name] protocol=tcp \
    tcp-flags=fin,psh,urg,!syn,!rst,!ack disabled=yes

add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input in-interface=[/interface get \
    [find comment=inet or comment=WAN] name] protocol=tcp \
    tcp-flags=fin,syn,rst,psh,ack,urg disabled=yes

add action=add-src-to-address-list address-list="port scanners" \
    address-list-timeout=2w chain=input in-interface=[/interface get \
    [find comment=inet or comment=WAN] name] protocol=tcp \
    tcp-flags=!fin,!syn,!rst,!psh,!ack,!urg disabled=yes

# Drop WAN DNS requests
add action=drop chain=input comment=DNS_drop_WAN dst-port=53 \
    in-interface=[/interface get [find comment=inet or comment=WAN] name] \
    protocol=tcp

add action=drop chain=input dst-port=53 in-interface=[/interface get \
    [find comment=inet or comment=WAN] name] protocol=udp

# Deny WinBox access not from allowed (add you computer ip in interface list before enable)
add action=drop chain=input comment="Winbox_drop_not_from\1F_lan" disabled=yes \
    dst-port=8291 protocol=tcp src-address-list=!winbox-allow

add action=drop chain=input comment=limit_connections disabled=yes \
    in-interface=[/interface get [find comment=inet or comment=WAN] name] \
    rc-address-list=connection-limit

add action=add-dst-to-address-list address-list=connection-limit \
    address-list-timeout=1d chain=input connection-limit=200,32 disabled=yes \
    in-interface=[/interface get [find comment=inet or comment=WAN] name]

add action=accept chain=input comment="accept establish & related" \
    connection-state=established,related

add action=accept chain=forward comment="accept ipsec policy" ipsec-policy=\
    in,ipsec
    
add action=accept chain=forward ipsec-policy=out,ipsec


/ip firewall service-port
set ftp disabled=yes
set tftp disabled=yes
set irc disabled=yes
set h323 disabled=yes
set sip disabled=yes
set pptp disabled=yes
set udplite disabled=yes
set dccp disabled=yes
set sctp disabled=yes
