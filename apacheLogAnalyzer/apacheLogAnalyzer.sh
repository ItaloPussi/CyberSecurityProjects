#!/bin/bash

top=3

totalLines="$(wc -l $1 | cut -d ' ' -f1)"
firstRegistryDate="$(head -n1 $1 | cut -d ' ' -f4-5)"
lastRegistryDate="$(tail -n1 $1 | cut -d ' ' -f4-5)"
uniqueIps="$(cat $1 | cut -d ' ' -f1 | sort | uniq | wc -l)"
cat $1 | cut -d ' ' -f1 | sort | uniq -c | sort -unr | sed 's/  */ /g' | head -n $top | cut -d ' ' -f2 > qtd.txt
cat $1 | cut -d ' ' -f1 | sort | uniq -c | sort -unr | sed 's/  */ /g' | head -n $top | cut -d ' ' -f3 > ips.txt

l=1


echo "Total lines: $totalLines"
echo "Unique IPs: $uniqueIps"
echo "First registry date: $firstRegistryDate"
echo -e "Last registry date: $lastRegistryDate\n"

echo "Top $top IPs Requests:"

for ip in $(cat ips.txt); do
	qtd="$(sed -e $l'q;d' qtd.txt)"	
	firstRequestDate="$(cat $1 | grep $ip | head -n1 | cut -d ' ' -f4-5)"
	lastRequestDate="$(cat $1 | grep $ip | tail -n1 | cut -d ' ' -f4-5)"

	echo -e "\tIP: $ip"
	echo -e "\tTotal requests: $qtd"
	echo -e "\tFirst request date: $firstRequestDate"
	echo -e "\tLast request date: $lastRequestDate\n"
	l="$((l+1))"
done

rm qtd.txt
rm ips.txt
