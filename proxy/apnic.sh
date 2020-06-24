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
    cat apnic.txt | grep "JP|ipv4" | awk -F "|" '{ printf "allow %s/24;\n", $4 }' > ip-list.conf
  else
    echo "$(date) - Terjadi kesalahan saat melakukan fetching data." >> error.log
  fi
else
  echo "allow all;" > ip-list.conf
fi