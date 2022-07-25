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
    add action=drop chain=input comment=bogon_disallow \
        in-interface=[/interface get [find comment=inet or comment=WAN] name] \
        src-address-list=bogon