#!/bin/sh
myVar=`grep var include.sh | cut -d'=' -f2`
echo $myVar