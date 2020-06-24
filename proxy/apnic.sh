flag=0
options=$(getopt -o f --long force -- "$@")
[ $? -eq 0 ] || {
    echo "Invalid arguments"
    exit 1
}
eval set -- "$options"

while true; do
    case "$1" in
    -f | --force)
        flag=1
        ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

if [ $flag -eq 0 ]
then
  curl -i http://ftp.apnic.net/stats/apnic/delegated-apnic-latest > apnic.txt
  http_response=$( head -n 1 apnic.txt | awk '{print $2}' )
  if [ $http_response -eq 200 ]
  then
    cat apnic.txt | grep "JP|ipv4" | awk -F "|" '{ printf "allow %s/24;\n", $4 }' > /etc/nginx/conf.d/ip-list.conf
    ip ad | grep 'eth0' | grep '/16' | awk '{print $2}' | awk -F '.' '{printf "allow %s.%s.0.0/16;\n",$1,$2}' >> /etc/nginx/conf.d/ip-list.conf
  else
    echo "$(date) - Terjadi kesalahan saat melakukan fetching data." >> error.log
  fi
else
  echo "allow all;" > /etc/nginx/conf.d/ip-list.conf
  ip ad | grep 'eth0' | grep '/16' | awk '{print $2}' | awk -F '.' '{printf "allow %s.%s.0.0/16;\n",$1,$2}' >> /etc/nginx/conf.d/ip-list.conf
fi
