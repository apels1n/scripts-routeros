/ip firewall filter 
    add action=add-src-to-address-list address-list=IPSEC_failed_state2 \
        address-list-timeout=5d chain=input in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] protocol=udp \
        src-address-list=IPSEC_failed_state1

/ip firewall raw
    add action=drop chain=prerouting comment=Drop_VPN_bruteforce \
        dst-port=500,4500 in-interface=inet protocol=udp \
        src-address-list=IPSEC_failed_state2