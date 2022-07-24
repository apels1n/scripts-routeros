:local loglistTimeout [:toarray [/log find  time>([/system clock get time] - 10s) message~"phase1 negotiation failed due to time up"]]
:foreach i in=$loglistTimeout do={
    :local logMessageTimeout [/log get $i message]
    :local ip1 [:pick $logMessageTimeout [:find $logMessageTimeout ">"] [:len $logMessageTimeout]]
    :local ipTimeout [:pick $ip1 1 [:find $ip1 "["] ]
    /ip firewall address-list add address=$ipTimeout list=IPSEC_failed_state1 timeout=3m
    :log info message="script=IPSEC_failed src_ip=$ipTimeout why=negotiation_failed due to time up"
}