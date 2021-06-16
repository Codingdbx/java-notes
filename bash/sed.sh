#!/bin/sh
# Author: danny (E-mail: ahutdbx@163.com)
#################################################
# ^ 行首
# $ 行尾
# . 单个字符
# * 0个或者多个匹配
# + 1个或者多个匹配
# ? 0个或者1个匹配
# {m} 前面的匹配重复m次
# {m,n} 前面的匹配重复m到n次
# \ 转义字符
# [0-9] 匹配括号中的任何一个字符,or的作用
# | 或者
# \b 匹配一个单词。比如\blucky\b 只匹配单词lucky
##################################################
for i in "$@"
    do
        var="`echo $i | cut -d '.' -f 1`"
        var2="`echo $i | cut -d '.' -f 2`"
        # date=$(date '+%Y-%m-%d %H:%M:%S')
        date=$(date '+%Y%m%d')

        if [ 'csv' != $var2 ]; then
             # else if body
             echo 'plz input correct file format!' $i
        else
             # else body
            echo 'transform csv file:'  $i

            # ``会导致sed命令解析失败
            # result="`sed -e 's#\\\\#\\#g' -e 's#%##g' -e 's#\"\"#\"#g' $i > ${var}_20210428.csv`"
            sed -e 's#\\\\#\\#g' -e 's#%##g' -e 's#\"\"#\"#g' $i > ${var}_$date.csv

            if [ ! $? -eq 0 ]; then 
                echo 'transform failure....'
            else
                echo 'transform complete....'
            fi
            
            # result=$(sed -e 's#\\\\#\\#g' -e 's#%##g' -e 's#\"\"#\"#g' $i > ${var}_20210428.csv)

        fi
        
        
    done