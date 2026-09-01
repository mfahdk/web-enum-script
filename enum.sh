#!/bin/bash

IP="$1"

if [ -z "$IP" ]; then
    echo "Usage: $0 <IP>"
    exit 1
fi

HOST=$(nmap -sCV -T5 $IP -p 80 | grep "http-title" | awk '{print $7}' | sed 's|http://||; s|/$||')
echo "[!] HOST IS - $HOST ADDING IT TO HOSTS FILE (/etc/hosts)"

RESULT=$(sudo grep -q "$IP" /etc/hosts)

if [ -n "$RESULT" ]; then
        sudo sed -i "/# The following lines are desirable for IPv6/i $IP   $HOST" /etc/hosts
        #echo "$IP    $HOST" >> /etc/hosts
        #Use below if syntax of etc hosts file is different and comment out the sed command
else
        echo "[!] IP ALREADY IN HOSTS FILE!, SKIPPING ADDING IT"
fi

SIZE=$(curl -s -i http://$HOST/thisisnotexistingfahd123 | grep "Content-Length" | awk '{print $2}' | tr -d '\r')
SIZE_SUBDOMAIN=$(curl -s -i -H "Host: testfahd123.$HOST" http://$IP/ | grep "Content-Length" | awk '{print $2}' | tr -d '\r')

ffuf -u http://$HOST/FUZZ -w /usr/share/Seclists/Discovery/Web-Content/DirBuster-2007_directory-list-lowercase-2.3-medium.txt -t 50 -fs $SIZE > dir.txt &
PID1=$!

ffuf -u http://$HOST -H "Host: FUZZ.$HOST" -w /usr/share/Seclists/Discovery/DNS/subdomains-top1million-110000.txt -t 50 -fs $SIZE_SUBDOMAIN > subdomain.txt &
PID2=$!

wait "$PID1"
wait "$PID2"
echo "[!] DONE ENUMERATION"
