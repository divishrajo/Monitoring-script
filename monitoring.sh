#!/bin/bash


LOG_FILE=/var/log/system_monitoring.log
ARCHIVE_DIR=/root/var/log/system_archives/
EMAILS=("abc@gmail.com" "12344@gmail.com")
CPU_THRESHOLD=10
DISK_THRESHOLD=25
MEMORY_THRESHOLD=30

##It will send mail alert according to the condition

send_mail_alert(){
	local message=$1
	for email in "${EMAILS[@]}"
	do

		echo "$message" | mail -s "System Alert" $email
	done
}

#It will log the message into a log file

log_message(){
	local message=$1
	if [ ! -e $LOG_FILE ]
	then
		echo "hello" > $LOG_FILE
	fi
        echo "$(date) $message " >> $LOG_FILE	
}

#It will create a zip of log file and mv into archive directory

archive_log(){
	if [ ! -d $ARCHIVE_DIR ] 
	then
		mkdir -p $ARCHIVE_DIR
	fi
	if find $LOG_FILE -mtime +7 -exec gzip {} -f \; -exec mv {}.gz $ARCHIVE_DIR \;
	then
                echo "Archived Successfully "
	else
	        echo " No file found within 7 days of Modification"
	fi
}	

#check for the CPU usage 

cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' |awk '{print 100 - $1}')
if (( $(echo " $cpu_usage > $CPU_THRESHOLD " | bc -l) ))
then
	message=$(echo "Warning Cpu usage is exceeded Current usage is $cpu_usage%")
        send_mail_alert "$message"
        log_message "$message"
	echo "$message"
else
       	echo "CPU Usage is $cpu_usage%"
fi

#Check for the disk usage 

disk_usage=$(df / | grep / | awk '{print $5}' | tr -d '%')
if (( $(echo " $disk_usage >  $DISK_THRESHOLD " | bc -l) ))
then
	message=$(echo "Warning Disk usage is high and of $disk_usage%")
        send_mail_alert "$message"
	log_message "$message"
	echo "Warning"
else
	message=$(echo "DISK Usage is $disk_usage% ")
	echo $message
	send_mail_alert "$message"
fi


#Check for the memory usage

memory_usage=$(free -h | grep Mem | awk '{print $3/$2 * 100 }')
message=$(echo "Memory Usage is $memory_usage%")
if (( $(echo "$memory_usage > $MEMORY_THRESHOLD " | bc -l) ))
then
	send_mail_alert "$message"
	log_message "$message"
	echo "WARNING $message"
else
	echo "$message"
fi



