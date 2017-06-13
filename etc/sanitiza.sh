#!/bin/sh

checa()
{
a=$( host $1 |grep -c  " has " )
echo $a 
}


cat adblock_hosts  | awk '{ print $2 }' | while read dominio ; do 

echo -n "$dominio " 
if [ "$(checa $dominio)" = "0" ] ; then 
    echo " - nao existe"
else
    wget -o /tmp/1 -O /dev/null $dominio
    resultado=$(grep -c -i Privoxy /tmp/1 )
        if [ "$resultado" = "0" ]; then 
           echo 0.0.0.0 $dominio >>passou_pelo_privoxy
           echo " - passou pelo privoxy"
        else
           echo $dominio >>block_privoxy
           echo " - bloqueado pelo privoxy"

        fi 
fi

done

