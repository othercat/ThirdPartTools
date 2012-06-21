#!/bin/bash
#
# buildIncrementer  
#  -- a simple script to increment the 
#      build number through Xcode
#
if [ -e "$1" ]
then
  echo " do nothing" > /dev/null
else
  # creat an empty file
  touch $1
fi

#increment the build number
read number  < $1
let number++
echo $number  
echo $number > $1

