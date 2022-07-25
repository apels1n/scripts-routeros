/ip firewall filter 
    add action=add-src-to-address-list address-list=IPSEC_failed_state2 \
        address-list-timeout=5d chain=input in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] protocol=udp \
        src-address-list=IPSEC_failed_state1 comment=Detect_VPN_bruteforce

/ip firewall raw
    add action=drop chain=prerouting comment=Drop_VPN_bruteforce \
        dst-port=500,4500 protocol=udp src-address-list=IPSEC_failed_state2 \
        in-interface=[/interface get [find comment=inet or comment=WAN] name] 