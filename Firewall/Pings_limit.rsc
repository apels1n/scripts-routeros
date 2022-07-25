/ip firewall filter
    add action=accept chain=input comment=icmp_accept in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] \
        limit=50/5s,2:packet protocol=icmp

    add action=drop chain=input comment=Pings_Drop in-interface=[/interface get \
        [find comment=inet or comment=WAN] name] \
        protocol=icmp