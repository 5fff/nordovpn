download_list_url="https://nordvpn.com/ovpn/"
config_dir=ovpn_config_files
file_url_list=ovpn_config_url_list
download_concurrency=1000;

echo "Fetching ovpn config download page source and composing url list"
curl -s $download_list_url | \
#Extract all ovpn file urls
grep -Eo "https:\/\/downloads\.nordcdn\.\S*\.ovpn" > $file_url_list

echo "Downloading (#of files, list filename) $(wc -l $file_url_list)"
rm -rf $config_dir
mkdir $config_dir
cd $config_dir

file_count=0
for url in $(cat ../$file_url_list)
do 
    echo -en "\r$url"
    curl -O -s $url &
    if((++file_count%download_concurrency==0)); then wait; fi
done
wait
echo -e "\nDownloading finished!"