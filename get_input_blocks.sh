#! /bin/bash

cat $1 | grep false | while read line 
do
   numberp=`echo $line | awk '{print $2}'`
   number=`echo $numberp | awk -F':' '{print $1}'`
   
   cat $2 | grep "serial number: $number\$" -A 7
done

