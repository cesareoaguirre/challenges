
# FUENTE
# https://www.system-rescue.org/networking/Load-balancing-using-iptables-with-connmark/

 

echo 1 >| /proc/sys/net/ipv4/ip_forward
echo 0 >| /proc/sys/net/ipv4/conf/all/rp_filter


# flush all iptables entries
iptables -t filter -F
iptables -t filter -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t filter -P INPUT ACCEPT
iptables -t filter -P OUTPUT ACCEPT
iptables -t filter -P FORWARD ACCEPT


# initialise chains that will do the work and log the packets
iptables -t mangle -N CONNMARK1
iptables -t mangle -A CONNMARK1 -j MARK --set-mark 1
iptables -t mangle -A CONNMARK1 -j CONNMARK --save-mark
iptables -t mangle -A CONNMARK1 -j LOG --log-prefix 'iptables-mark1: ' --log-level info


iptables -t mangle -N CONNMARK2
iptables -t mangle -A CONNMARK2 -j MARK --set-mark 2
iptables -t mangle -A CONNMARK2 -j CONNMARK --save-mark
iptables -t mangle -A CONNMARK2 -j LOG --log-prefix 'iptables-mark2: ' --log-level info


iptables -t mangle -N RESTOREMARK
iptables -t mangle -A RESTOREMARK -j CONNMARK --restore-mark
iptables -t mangle -A RESTOREMARK -j LOG --log-prefix 'restore-mark: ' --log-level info


iptables -t nat -N SNAT1
iptables -t nat -A SNAT1 -j LOG --log-prefix 'snat-to-192.168.1.73: ' --log-level info
iptables -t nat -A SNAT1 -j SNAT --to-source 192.168.1.73


iptables -t nat -N SNAT2
iptables -t nat -A SNAT2 -j LOG --log-prefix 'snat-to-192.168.8.6: ' --log-level info
iptables -t nat -A SNAT2 -j SNAT --to-source 192.168.8.6


# restore the fwmark on packets that belong to an existing connection
iptables -t mangle -A PREROUTING -i eth0 -p tcp \
         -m state --state ESTABLISHED,RELATED -j RESTOREMARK
iptables -t mangle -A PREROUTING -i eth0 -p udp \
         -m state --state ESTABLISHED,RELATED -j RESTOREMARK


# if the mark is zero it means the packet does not belong to an existing connection
iptables -t mangle -A PREROUTING -p tcp -m state --state NEW \
         -m statistic --mode nth --every 2 --packet 0 -j CONNMARK1
iptables -t mangle -A PREROUTING -p tcp -m state --state NEW \
         -m statistic --mode nth --every 2 --packet 1 -j CONNMARK2





iptables -t nat -A POSTROUTING -o eth1 -j SNAT1
iptables -t nat -A POSTROUTING -o eth2 -j SNAT2



if ! cat /etc/iproute2/rt_tables | grep -q '^251'
then
    echo '251     rt_link1' >> /etc/iproute2/rt_tables
fi
if ! cat /etc/iproute2/rt_tables | grep -q '^252'
then
    echo '252     rt_link2' >> /etc/iproute2/rt_tables
fi

ip route flush table rt_link1 2>/dev/null
ip route flush table rt_link2 2>/dev/null
ip route add table rt_link1 default dev eth1
ip route add table rt_link2 default dev eth2




ip rule del from all fwmark 0x1 lookup rt_link1 2>/dev/null
ip rule del from all fwmark 0x2 lookup rt_link2 2>/dev/null
ip rule del from all fwmark 0x2 2>/dev/null
ip rule del from all fwmark 0x1 2>/dev/null
ip rule add fwmark 1 table rt_link1
ip rule add fwmark 2 table rt_link2



ip route flush cache
