/ip firewall filter 
    add action=add-dst-to-address-list address-list=connection-limit \
        address-list-timeout=30m chain=input connection-limit=200,32 disabled=yes \
        in-interface=[/interface get [find comment=inet or comment=WAN] name]

/ip firewall raw
    add action=drop chain=prerouting comment=Limit_connections \
        dst-address-list=connection-limit