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


/ip firewall filter 
    # Drop packages from bogon networks
    add action=drop chain=input comment=bogon_disallow \
        in-interface=[/interface get [find comment=inet or comment=WAN] name] \
        src-address-list=bogon disabled=yes

    # Add VPN brutforce client ip to address list
    add action=drop chain=input comment=IPSec_drop_bruteforce \
        disabled=yes dst-port=500,4500 in-interface=inet \
        protocol=udp src-address-list=IPSEC_failed_state2

    # Allow VPN connection
    add action=accept chain=input comment=VPN_IPSec \
        port=1701,500,4500 protocol=udp disabled=yes

    add action=accept chain=input protocol=ipsec-esp \
        disabled=yes

    # Allow icmp 50p/s if more drop them
    add action=accept chain=input comment=icmp_accept in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] \
        limit=50/5s,2:packet protocol=icmp

    add action=drop chain=input comment=Pings_Drop in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] \
        protocol=icmp

    # Drop invalid connections
    add action=drop chain=input comment="drop invalid" connection-state=invalid

    # Port scan detect
    add action=add-src-to-address-list address-list="port scanners" \
        address-list-timeout=20m chain=input in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] protocol=tcp psd=21,3s,3,1 \
        comment=Port_scanner_detect

    add action=add-src-to-address-list address-list="port scanners" \
        address-list-timeout=20m chain=input in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] protocol=tcp \
        tcp-flags=fin,!syn,!rst,!psh,!ack,!urg

    add action=add-src-to-address-list address-list="port scanners" \
        address-list-timeout=20m chain=input in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] protocol=tcp \
        tcp-flags=fin,syn

    add action=add-src-to-address-list address-list="port scanners" \
        address-list-timeout=20m chain=input in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] protocol=tcp \
        tcp-flags=syn,rst

    add action=add-src-to-address-list address-list="port scanners" \
        address-list-timeout=20m chain=input in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] protocol=tcp \
        tcp-flags=fin,psh,urg,!syn,!rst,!ack

    add action=add-src-to-address-list address-list="port scanners" \
        address-list-timeout=20m chain=input in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] protocol=tcp \
        tcp-flags=fin,syn,rst,psh,ack,urg

    add action=add-src-to-address-list address-list="port scanners" \
        address-list-timeout=20m chain=input in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] protocol=tcp \
        tcp-flags=!fin,!syn,!rst,!psh,!ack,!urg

    # Detect DDoS
    add chain=forward comment=DDoS_reject connection-state=new \
        action=jump jump-target=detect-ddos

    add action=return chain=detect-ddos dst-limit=32,32,src-and-dst-addresses/10s \
        protocol=tcp tcp-flags=syn,ack
        
    add chain=detect-ddos dst-limit=32,32,src-and-dst-addresses/10s \
        action=return
        
    add action=add-dst-to-address-list address-list=ddos-target \
        address-list-timeout=5m chain=detect-ddos
        
    add action=add-src-to-address-list address-list=ddos-attackers \
        address-list-timeout=5m chain=detect-ddos

    # Limit connections to host
    add action=add-dst-to-address-list address-list=connection-limit \
        address-list-timeout=30m chain=input comment=limit_connections \
        connection-limit=200,32 \
        in-interface=[/interface get [find comment=inet or comment=WAN] name]

    # Accept established connections
    add action=accept chain=input comment="accept establish & related" \
        connection-state=established,related


/ip firewall raw
    # Drop port scan
    add action=drop chain=prerouting comment=Drop_Port_scan \
        src-address-list="port scanners"

    # Drop DDos
    add action=drop chain=prerouting comment=Drop_DDoS \
        dst-address-list=ddos-target src-address-list=ddos-attackers

    # Drop VPN bruteforce
    add action=drop chain=prerouting comment=Drop_VPN_bruteforce \
        dst-port=500,4500 protocol=udp src-address-list=IPSEC_failed_state2 \
        in-interface=[/interface get [find comment=inet or comment=WAN] name] 
        

    # Limit connections
    add action=drop chain=prerouting comment=Limit_connections \
        dst-address-list=connection-limit


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
