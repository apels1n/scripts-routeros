/ip firewall filter 
add action=drop chain=input comment=IPSec_drop_bruteforce dst-port=500,4500 \
    in-interface=[/interface get [find comment=inet or comment=WAN] name] \
    protocol=udp src-address-list=IPSEC_failed_state2

add action=add-src-to-address-list address-list=IPSEC_failed_state2 \
    address-list-timeout=5d chain=input in-interface=[/interface get \
    [find comment=inet or comment=WAN] name] protocol=udp \
    src-address-list=IPSEC_failed_state1