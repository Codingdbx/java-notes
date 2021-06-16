@echo off
rem title  DOS(Disk Operating System)
title Git Working

rem clear screen
cls

git log --oneline -5
echo git pull origin master...
git pull origin master
git add .
echo git commit -m "add new change"
git commit -m "add new change"
echo git push origin master...
git push origin master

rem Press any key to continue...
pause