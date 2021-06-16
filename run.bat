@echo off
rem title  DOS(Disk Operating System)
title Git Working

rem clear screen
cls

echo. ******************************************************************************
echo. 使用 完整/短的 commit id 都可以,如果使用短的commit id出错请使用完整的
echo                1.打包某次更新提交
echo                2.打包两个更新之间的提交
echo                3.打包最新提交和本地未提交的修改
echo                4.拉取最新代码下来
echo                5.中文错误修复
echo                6.提交本地修改代码
echo                7.查看本地更新
echo                8.查看更新记录
echo                9.进入git bash
echo. ******************************************************************************

echo git log 
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

exit;