#!/bin/bash
_todate=$(date +%Y-%m-%d-%H-%M)

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT") # script path
cd $SCRIPTPATH
while IFS= read -r ip; do     #read localtion of .conf file
echo $ip

cptotemp="mkdir -p /tmp/$_todate-log && cp /var/log/httpd/mysite.com/*.log  /var/www/html/mysite.com/*  /tmp/$_todate-log" #make folder and put the file need to zip
cptotemprun=`ssh -i "keypair1sg.pem" ec2-user@$ip $cptotemp` #run cp command
compress="cd /tmp &&  tar -czvf $_todate-log.tar.gz  $_todate-log --remove-files" #compress command and file paths
compressrun=`ssh -i "keypair1sg.pem" ec2-user@$ip $compress`   #compress command run with script
getfile=`scp -i "keypair1sg.pem" ec2-user@$ip:/tmp/$_todate-log.tar.gz $SCRIPTPATH` # cp tar file to script running location
synctoBucket=`aws s3 cp $_todate-log.tar.gz s3://myawsbucket000001/webserver_logs/` #as for your command for upload s3
logoutupload=`aws s3 ls s3://myawsbucket000001/webserver_logs/ | grep -w $_todate-log.tar.gz|wc -l` #check availability
$compressrun
$getfile
$synctoBucket

 if [[ $logoutupload == 1 ]]; then #validation availablitiy
	 echo "$_todate ------ File is uploaded "  >>task4Log.txt   #put log save in file is uploaded
 else
	 echo "$_todate ------ File is not uploaded "  >>task4Log.txt #put save in file is not uploaded
	 python send_mail.py "File is not uploaded" # if not send mail
fi



DIR="$SCRIPTPATH"  #check directory is available. removing file before confirming is harmful when directory is not avilable. Then this will check the location
FILE="$SCRIPTPATH/$_todate-log.tar.gz"  #file is exist check
if [ -d "$DIR" ]; then
        rm -f $_todate-log.tar.gz  #remove file
        if [ -f "$FILE" ]; then #file is there

            
        echo "$FILE esits"
        echo "$_todate ------ $FILE exists"  >> task4Log.txt
        python send_mail.py "remove the file" #if file is exist send the mail to app support
        else
        echo "file is deleted"
	if [[ $logoutupload == 1 ]]; then
		                echo "$_todate ------ File is uploaded to s3 and deleted from server "  >>task4Log.txt

	                         python send_mail.py "File is uploaded to s3 and deleted from server" # send the successto mail
              fi
	fi
          fi
done < location.conf
