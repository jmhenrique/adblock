opkg install dnsmasq >/dev/null 2>/dev/null 
curl -k https://raw.githubusercontent.com/jmhenrique/adblock/master/bin/update_adware.sh -o /usr/bin/update_adware.sh 2>/dev/null ; echo . 
curl -k https://raw.githubusercontent.com/jmhenrique/adblock/master/etc/adblock_hosts -o /etc/adblock_hosts  2>/dev/null ; echo . 
curl -k https://raw.githubusercontent.com/jmhenrique/adblock/master/etc/adblock_serial -o /etc/adblock_serial  2>/dev/null ; echo . 
curl -k https://raw.githubusercontent.com/jmhenrique/adblock/master/etc/dnsmasq.conf -o /etc/dnsmasq.conf   2>/dev/null ; echo . 
curl -k https://raw.githubusercontent.com/jmhenrique/adblock/master/etc/dnsmasq.blacklist -o /etc/dnsmasq.blacklist   2>/dev/null echo . 
curl -k ttps://raw.githubusercontent.com/jmhenrique/adblock/master/etc/dnsmasq.whitelist -o /etc/dnsmasq.whitelist 2>/dev/null echo .
grep '/usr/bin/update_adware.sh >/dev/null 2>/dev/null &' /etc/rc.local  >/dev/null || echo '/usr/bin/update_adware.sh >/dev/null 2>/dev/null &' >>/etc/rc.local 
a=$(grep -v 'exit ' /etc/rc.local) 
b=$(grep 'exit' /etc/rc.local) 
echo "$a" >/etc/rc.local 
echo "$b" >>/etc/rc.local 

/etc/init.d/dnsmasq restart 
echo done 
echo "Remember to add a line in your crontab (/etc/crontabs/root) : 

0 5     * * * /usr/bin/logger -t "ROOT" update-adware && /usr/bin/update_adware.sh
"

