#Adblock by Jm
I created this project as a way to optimize adware protection of my router TPLINK 1043 with Openwrt. 

He is an excellent router, but has very little available memory (8MB) and a median processor (400mhz).
I noticed that the articles and tutorials on ad-blocking does not take into account the optimization of hosts and domains.
There are some tutorials that explore only the grouping and unification of lists of hosts. But these lists are variations of websites that create random subdomains, interfering with the blocking efficiency. Only one domain, 302br.net has +17,000 registered subdomains in lists.
So I first tried to treat domains and subdomains within the own router, but ended up being a very time consuming task, something a few hours to do the job, and impacted the performance of the navigation here at home, my wife hated me for it .
So I used a different approach: Using SQL and shell some lines on my personal computer, and update the lists in gifhub. The router only checks twice a day, the existence of a newer version, and only download if there is any modification.
The four lists that customarily see in the forums add about 62,000 entries, duplicates excluded.

This takes ~ 2mb on the router.
After grouping, my list has about 27,000 domains / hosts. It is ~ 60% lower, and occupy only only 750kb. 
but too efficient.
The number of domains in dnsmasq.conf increased from ~ 2,000 to 5,000, and the number of hosts in adblock_hosts down from 62,000 to 21,000.

  ./etc/dnsmasq.conf # grouped domains and removed from the host list.
 
 ./etc/dnsmasq.whitelist # script remove this domains from the list. 
 
 ./etc/dnsmasq.blacklist #script put this domains into the list.
 
 ./etc/adblock_hosts # list of subdomains hosts.
 
 ./etc/adblock_serial # control version of lists of domains and hosts, in unix time.
 
 ./bin/update_adware.sh #the script what do the job! You only need this, put in crontab and done.
 
 No install program. Only basic instructions in INSTALL file. 
