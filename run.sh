ip=`ifconfig | grep -A 1 'en1' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 2`
export ROOT_URL="http://$ip:4000/"
meteor