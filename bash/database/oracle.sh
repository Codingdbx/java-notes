#!/bin/sh
# Author: danny E-mail(14587457@qq.com)


# 1. 连接mysql 数据库
# shell中连接数据库的方法很简单，只需要指定用户名，密码，连接的数据库名称，然后通过重定向，输入mysql的语句，如下所示：
# <<EOF 表示后续的输入作为子命令或子Shell的输入，直到遇到EOF为止，再返回到主Shell。而EOF可以换成任何其他字符都可以。
# mysql -u USERNAME -p PASSWORD DATABASENAME << EOF 2>/dev/null
#     show databases;
# EOF

mysql -u root -p 123456 jsl << EOF 
    show databases;
EOF

# 2.创建表
# create_table_sql="create table IF NOT EXISTS ${TABLENAME} ( name varchar(20), id int(11) default 0 )"
# mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${create_table_sql}"

# 3.插入数据
# insert_sql="insert into ${TABLENAME} values('billchen',2)"
# mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${insert_sql}"
 

# 4.查询
# select_sql="select * from ${TABLENAME}"
# mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${select_sql}"

 
# 5.更新数据
# update_sql="update ${TABLENAME} set id=3"
# mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${update_sql}"
# mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${select_sql}"
 
# 6.删除数据
# delete_sql="delete from ${TABLENAME}"
# mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${delete_sql}"
# mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${select_sql}"