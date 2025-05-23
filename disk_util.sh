#!/bin/bash
#Set required threshold limit
THRESHOLD=70

#Fetch Current utilizayion of the disk
CURRENT_UTIL=$(df -hT | grep -w  /dev/xvda1 | awk -F " " '{print $6}' | tr "%" " ")

#Fetch instance public Ip
Instance_Public_Ip=$(aws ec2 describe-instances --instance-ids "i-04d02914xxxxxxx" | grep -i publicIpAddress | awk -F ":" '{print $2}')

echo "$CURRENT_UTIL%"

if [[ $CURRENT_UTIL -gt THRESHOLD ]];
then
        echo "Alert: Current utilization is beyond threshold"
        echo "Hence triggerring a notification"
        echo "$Instance_Public_Ip"
        aws sns publish --topic-arn arn:aws:sns:us-east-1:654654325967:EC2_CPU_UTIL_NOTIFICATION --message "
        ALERT: CPU UTILIZATION IS BEYOND THRESHOLD
        Current CPU Utilization is $CURRENT_UTIL % greater than $THRESHOLD %
        Instance_Public_Ip: $Instance_Public_Ip
        Please do clean up
        Thanks,
        Product DevOps
        "
else
        echo "CPU Utilization is stable"
fi
