@echo off
rem title
title Git Working
cls


echo git pull origin master...
git pull origin master
git add .
echo git commit -m "add new change"
git commit -m "add new change"
echo git push origin master...
git push origin master

pause