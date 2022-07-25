/ip firewall filter 
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

/ip firewall raw
    add action=drop comment=Port_scanner_drop \
        chain=prerouting src-address-list="port scanners"