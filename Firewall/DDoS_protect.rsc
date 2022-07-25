/ip firewall address-list
    add list=ddos-attackers
    add list=ddos-target

/ip firewall filter
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

/ip firewall raw
    add action=drop chain=prerouting dst-address-list=ddos-target \
        src-address-list=ddos-attackers

/ip/settings/set tcp-syncookies=yes