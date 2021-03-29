#!/bin/bash
_todate=$(date +%D-%H-%M-%S)
SCRIPT=$(readlink -f "$0")    
SCRIPTPATH=$(dirname "$SCRIPT")	#Find the path of the script
cd $SCRIPTPATH
while IFS= read -r line; do  # read the file line by line
 ip=`echo $line|tail -n 2` #get fist line
url=`echo $line|tail -n 1` #get second line
checkhttp='sudo systemctl status httpd |grep -w active|grep -w running|wc -l' #check the status of Apache service
#checkrun=`ssh -i "keypair1sg.pem" ec2-user@192.168.1.32 $checkhttp` 
checkrun=`ssh -i "keypair1sg.pem" ec2-user@$ip $checkhttp` #ssh login to webserver

checkweb=`wget --spider   -S "$url" 2>&1 | grep "HTTP/" | awk '{print $2}'|tail -n 1` #web status check for 200 code
#echo $checkrun
if [[ $checkrun == 1 ]]; then           #if Apache is running
         echo "apache server is running" 
        if [[ $checkweb == 200 ]]; then #if web application is accessible and recieve a 200 code
		echo "Web application is working"
                echo "$_todate-------Web application is working" >> task3Log.txt
                echo "INSERT INTO alertbox (datetime,status) VALUES (\"$_todate\",\"Web is up and running\");" | mysql -u root -pPassword@123 alert;    #Insert data to DB with accessible status
	
        else
		echo "Please check web application. It says $checkweb error found,please check appsupport mail."
                echo "$_todate-------Please check web application. It says $checkweb error found,please check appsupport mail." >> task3Log.txt
                python send_mail.py "Please check web application. It says $checkweb error found" #Send mail to app support
                echo "INSERT INTO alertbox (datetime,status) VALUES (\"$_todate\",\"Web server up ,But site is NOT Working\");" | mysql -u root -pPassword@123 alert;
        fi


elif [[ $checkrun == 0 ]]; then #web server is not running state
	echo "Web server is not running.So we are trying to start it up.please check app support mail" 
        echo "$_todate-------Web server is not running.So we are trying to start it up.please check app support mail" >> task3Log.txt
   #sshpass  -p  '123456'  ssh -i "keypair1sg.pem" ec2-user@$ip "systemctl start httpd"
   ssh -i "keypair1sg.pem" ec2-user@$ip "sudo systemctl start httpd"  #start Apache service
        echo "INSERT INTO alertbox (datetime,status) VALUES (\"$_todate\",\"Web server not Up.Restarting\");" | mysql -u root -pPassword@123 alert;
       python send_mail.py "Web server is not running. We are trying to start it"

fi

done < ip.conf
