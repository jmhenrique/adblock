#!/bin/sh
export local 
touch /etc/dnsmasq.whitelist
touch /etc/dnsmasq.blacklist
down_hosts() { 
curl -k 'https://raw.githubusercontent.com/jmhenrique/adblock/master/etc/adblock_hosts' -o /tmp/adblock_hosts 2>/null
}
down_dnsmasq_conf(){
curl -k 'https://raw.githubusercontent.com/jmhenrique/adblock/master/etc/dnsmasq.conf' > /tmp/dnsmasq.conf.0  2>/null
}


alter_blacklists(){
grep -v "^#" /etc/dnsmasq.blacklist | awk '{ print "address=/" $1 "/0.0.0.0" } ' >> /tmp/dnsmasq.conf.0
}

conf_dnsmasq() {
grep -v "^address=" /etc/dnsmasq.conf >/tmp/dnsmasq.conf.orig
grep address /tmp/dnsmasq.conf.0 /etc/dnsmasq.conf | cut -d: -f2 | sort -u >>/tmp/dnsmasq.conf.orig
mv /tmp/dnsmasq.conf.orig /etc/dnsmasq.conf
rm /tmp/dnsmasq.conf.0
}

remove() { 
while read a
do
grep "=/$a/" /etc/dnsmasq.conf >/dev/null && sed -i "/=\/$a\//d" /etc/dnsmasq.conf 
grep " $a$" /tmp/adblock_hosts >/dev/null && sed -i "/ $a$/d" /tmp/adblock_hosts
done </etc/dnsmasq.whitelist
}

alter_whitelists(){
test -f "/etc/dnsmasq.whitelist" && remove
}
restart(){ 
/etc/init.d/dnsmasq restart 
}
log1(){
logger -t logger -t "Adblock" -s "Update Domains ok"
}
log2(){
logger -t logger -t "Adblock" -s "Update Hosts ok"
}
log3(){
logger -t logger -t "Adblock" -s "Already Update"
}


test -f "/etc/adblock_serial" && local=$(head -n1 "/etc/adblock_serial" | awk '{ print $1}') || (echo 0 >/etc/adblock_serial
local=$(head -n1 "/etc/adblock_serial" | awk '{ print $1}') ) 
remoto=$(curl -k 'https://raw.githubusercontent.com/jmhenrique/adblock/master/etc/adblock_serial'  2>/null )
test $local -lt $remoto && (echo "$remoto" >/etc/adblock_serial
down_hosts
down_dnsmasq_conf
log1
alter_blacklists 
conf_dnsmasq 
alter_whitelists
restart 
log2 ) || log3

test -f "/tmp/adblock_hosts" || (down_hosts 
remove
restart
log2 )

cat /etc/dnsmasq.fixos >>/etc/dnsmasq.conf 
grep ^$   /etc/dnsmasq.conf >/dev/null && sed -i '/^$/d' /etc/dnsmasq.conf
exit 0 
