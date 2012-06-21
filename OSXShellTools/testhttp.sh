#!/bin/bash

proto=(http https)
cdn_host=(s.mzstatic.com)

cdn="akam"
hostname="ChinaTest"
sender="smokeping"
salt="02269aeb7c67a095dc074467a6aaa3b4"
ip_resolver=`dig whoami.akamai.net +short | tail -n 1`

while true;
do
  count=0
  date=`date +%s`
  while [ "x${proto[count]}" != "x" ]
  do
  #	echo ${proto[${count}]}
  # echo ${cdn_host[0]}
  	ip=`dig ${cdn_host[0]} +short | tail -n 1`
    if [ ${proto[${count}]} == "http" ]; then
  	  curl_s=`/usr/local/bin/echoping -n 5 -w 1 -h /htmlResources/1E54/dt-storefront-base.cssz -H s.mzstatic.com s.mzstatic.com | grep Average | cut -d ' ' -f 3`
    fi
    if [ ${proto[${count}]} == "https" ]; then
  	  curl_s=`/usr/local/bin/echoping -n 5 -w 1 --ssl -h /htmlResources/1E54/dt-storefront-base.cssz -H s.mzstatic.com s.mzstatic.com | grep Average | cut -d ' ' -f 3`
    fi
  	curl=`echo "${curl_s} * 1000" | bc -l`
  	query="time=${date}&sender=${sender}&agent=${hostname}&cdn=${cdn}&edgeip=${ip}&dnsip=${ip_resolver}&proto=${proto[${count}]}&httpping=${curl}"
  #	echo ${query}
  	url="https://metrics.mzstatic.com/?${query}"
    md5=`/sbin/md5 -s "${url}${salt}" | cut -d ' ' -f 4`
  	curl -s "${url}&md5=${md5}" -H "Host: metrics.mzstatic.com"
  	count=$(( ${count} + 1 ))
  done
  sleep 60
done
