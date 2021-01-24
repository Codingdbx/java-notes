# Linux 脚本语言Shell编程

## 1. 正则表达式

### 1.1 正则表达式与通配符

- 正则表达式
  - 正则表达式用来在文件中匹配符合条件的字符串，正则是包含匹配。
- grep、 awk、sed等命令可以支持正则表达式。
  
- 通配符
  - 通配符用来匹配符合条件的文件名，通配符是完全匹配。
  - ls、 find、 cp这些命令不支持正则表达式，所以只能使用shell自己的通配符来进行匹配了。

### 1.2 基础正则表达式

|  元字符   |                             作用                             |
| :-------: | :----------------------------------------------------------: |
|    `*`    |                前一个字符匹配0次或任意多次。                 |
|    `.`    |                匹配除了换行符外任意一个字符。                |
|    `^`    |      匹配行首。例如: `^`hello会匹配以 hello 开头的行。       |
|    `$`    |      匹配行尾。例如: hello`$`会匹配以 hello 结尾的行。       |
|   `[]`    | 匹配中括号中指定的任意一个字符，只匹配一个字符。例如: [aoeiu] 匹配任意一个<br />元音字母，[0-9] 匹配任意一位数字，[a-z] [0-9]匹配小写字和一位数字构成的两位字符。 |
|   `[^]`   | 匹配除中括号的字符以外的任意一个字符。例如: `[^0-9]` 匹配任意一位<br />非数字字符，`[^a-z]`表示任意一位非小写字母。<br/> |
|    `\`    |               转义符，用于取消特殊符号的含义。               |
|  `\{n\}`  | 表示其前面的字符恰好出现n次。例如: `[0-9]\{4\}` 匹配4位数字。<br />`[1][3-8][0-9]\{9\}`匹配手机号码。 |
| `\{n,\}`  | 表示其前面的字符出现不小于n次。例如: `[0-9]\{2,\}` 表示两位及以上的数字。 |
| `\{n,m\}` | 表示其前面的字符至少出现n次，最多出现m次。<br />例如: `[a-z]\{6,8\}` 匹配6到8位的小写字母。 |

- `*`     #前一个字符匹配0次，或任意多次。

  ```
  grep "a*"   test_rule.txt     #匹配所有内容，包括空白行
  grep "aa*"   test_rule.txt    #匹配至少包含有一个a的行
  grep "aaa*"   test_rule.txt   #匹配最少包含两个连续a的字符串
  grep "aaaaa*"  test_rule.txt  #则会匹配最少包含四个连续a的字符串
  ```

- `.`       #匹配除了换行符外任意一个字符。

  ```
  grep "s..d"  test_rule.txt   #会匹配在s和d这两个字母之间一定有两个字符的单词
  grep "s.*d"  test_rule.txt   #匹配在s和d字母之间有任意字符
  grep ".*“   test_rule.txt    #匹配所有内容
  ```

- `^`、`$`         #`^`匹配行首，`$`匹配行尾。

  ```
  grep "^M"'  test_rule.txt       #匹配以大写M开头的行
  grep "n$"    test_rule.txt      #匹配以小写n结尾的行
  grep -n "^$"  test_rule.txt     #会匹配空白行
  ```

- `[]`       #匹配中括号中指定的任意一个字符，只匹配一个字符。

  ```
  grep "s[ao]id"  test_rule.txt   #匹配s和i字母中，要不是a、要不是o
  grep "[0-9]"   test_rule.txt    #匹配任意一个数字
  grep "^[a-z]"  test_rule.txt    #匹配用小写字母开头的行
  ```

- `[^]`      #匹配除中括号的字符以外的任意一个字符。

  ```
  grep "^[^a-z]"   test_rule.txt    #匹配不用小写字母开头的行
  grep "^[^a-zA-Z]"  test_rule.txt    #匹配不用字母开头的行
  ```

- `\`      #转义符。

  ```
  grep "\.$" test_rule.txt    #匹配使用 “.” 结尾的行
  ```

- `\{n\}`       #表示其前面的字符恰好出现n次。

  ```
  grep "a\{3\}"  test_rule.txt      #匹配a字母连续出现三次的字符串
  grep "[0-9]\{3\}"  test_rule.txt   #匹配包含连续的三个数字的字符串
  ```

- `\{n,\}`      #表示其前面的字符出现不小于n次。

  ```
  grep "^[0-9]\{3,\}[a-z]" test_rule.txt  #匹配最少用连续三个数字开头的行
  ```

- `\{n,m\}`     #匹配其前面的字符至少出现n次，最多出现m次。

  ```
  grep "sa\{1,3\}i" test_rule.txt  #匹配在字母s和字母i之间有最少一个a，最多三个a
  ```



## 2 字符截取命令

### 2.1 cut 字段提取命令

`cut` 是字段提取命令。

`cut [选项] 文件名`

选项:

- `-f` 列号   #提取第几列
- `-d` 分隔符    #按照指定分隔符分割列

案例1：`cut -f 2 student.txt` 

```
# vi student.txt 
ID	Name	gender	Mark
1	Limng	M	M	
2	Sc	M	86
3	Gao	M	83
```

```
# cut -f 2 student.txt 
Name
Limng
Sc
Gao
```

案例2：`cut -f 2,3 student.txt` 

```
# cut -f 2,3 student.txt 
Name	gender
Limng	M
Sc	M
Gao	M
```

案例3：`cut -d ":" -f 1,3 /etc/passwd`

```
# cut -d ":" -f 1,3 /etc/passwd
root:0
bin:1
daemon:2
```

案例4：`cat /etc/passwd | grep /bin/bash | grep -v root | cut -d ":" -f 1`

```
# cat /etc/passwd | grep /bin/bash | grep -v root | cut -d ":" -f 1
user1
user2
user3
```

#### cut 命令的局限

不能以空格作为分隔符。

```
# df-h|cut-d " " -f 1,3
```



### 2.2 printf 命令

`printf` 是格式化输出命令。非常麻烦，但是 awk 命令识别它。

`printf`  [输出类型输出格式]  [输出内容]

输出类型：

- `%ns`    #输出字符串。n是数字指代输出几个字符
- `%ni`     #输出整数。n是数字指代输出几个数字
- `%m.nf`   #输出浮点数。m和n是数字，指代输出的总位数和小数位数。如`%8.2f`代表共输出8位数，
  其中2位是小数，6位是整数。

输出格式：

| 输出格式 |             说明              |
| :------: | :---------------------------: |
|    \a    |         输出警告声音          |
|    \b    | 输出退格键，也就是Backspace键 |
|    \f    |           清除屏幕            |
|    \n    |             换行              |
|    \r    |      回车，也就是Enter键      |
|    \t    |  水平输出退格键，也就是Tab键  |
|    \v    |  垂直输出退格键，也就是Tab键  |

#### 案例1：

```
[root@localhost ~]# printf %s 1 2 3 4 5 6
123456[root@localhost home]# 

[root@localhost ~]# printf %s %s %s 1 2 3 4 5 6
%s%s123456[root@localhost home]# 

[root@localhost ~]# printf '%s %s %s' 1 2 3 4 5 6
1 2 34 5 6[root@localhost home]# 

[root@localhost ~]# printf '%s %s %s\n' 1 2 3 4 5 6
1 2 3
4 5 6
```

#### 案例2：

```
# cat student.txt 
ID	Name	gender	Mark	Mysql	Averager
1	Limng	M	M	86	87.66
2	Sc	M	86	87	85.55
3	Gao	M	83	93	92.66
```

不调整输出格式

```
# printf '%s' $(cat student.txt)
IDNamegenderMarkMysqlAverager1LimngMM8687.662ScM868785.553GaoM839392.66[root@localhost home]# 
```

调整格式输出

```
# printf '%s\t %s\t %s\t %s\t %s\t %s\t \n' $(cat student.txt)
ID	 Name	 gender	 Mark	 Mysql	 Averager	 
1	 Limng	 M	 M	 86	 87.66	 
2	 Sc	 M	 86	 87	 85.55	 
3	 Gao	 M	 83	 93	 92.66	
```

#### awk 命令支持

在awk命令的输出中支持 print 和 printf 命令。Linux默认不支持 print 命令。

- `print`  #print会在每个输出之后自动加入一个换行符(Linux默认没有print命令)
- `printf`  #printf是 标准格式输出命令，并不会自动加入换行符，如果需要换行，需要手工加入换行符

### 2.3 awk 命令

awk `‘条件1{动作1}条件2{动作2}..’` 文件名

条件(Pattern) :一般使用关系表达式作为条件

- `x>10`    //判断变量x是否大于10
- `x>=10`   //大于等于
- `x<=10`    //小于等于

动作(Action) :

- 格式化输出
- 流程控制语句

案例：

`awk '{printf $2 "\t" $6 "\n"}'`student.txt

```
# awk '{printf $2 "\t" $6 "\n"}' student.txt
Name	Averager
Limng	87.66
Sc	85.55
Gao	92.66
```

`df -h | awk '{print $1 "\t" $3}'`

```
# df -h | awk '{print $1 "\t" $3}'
Filesystem	Used
/dev/mapper/VolGroup-lv_root	
5.5G	4.6G
tmpfs	0
/dev/sda1	32M
```

#### BEGIN

awk `'BEGIN {printf "This is a transcript \n"}{printf $2 "\t" $6 "\n"}'` student.txt

```
# awk 'BEGIN {printf "This is a transcript \n"}{printf $2 "\t" $6 "\n"}' student.txt
This is a transcript 
Name	Averager
Limng	87.66
Sc	85.55
Gao	92.66
```

#### FS内置变量

```
# cat /etc/passwd | grep "/bin/bash" | awk 'BEGIN {FS=":"}{printf $1 "\t" $3 "\n"}'
root	0
```

#### END

```
# awk 'END {printf "The End \n"}{printf $2 "\t" $6 "\n"}' student.txt
Name	Averager
Limng	87.66
Sc	85.55
Gao	92.66
The End 
```

#### 关系运算符

```
#  cat student.txt |grep -v Name |awk '$6>=87{printf $2 "\n" }'
Limng
Gao
```

### 2.4 sed 命令

#### stream editor

sed 是一种几乎包括在所有UNIX平台（包括Linux）的轻量级流编辑器。sed主要是用来将数据进行选取、替换、删除、新增的命令。

sed `[选项]‘[动作]’` 文件名

选项:

- `-n`   #一般sed命令会把所有数据都输出到屏幕，如果加入此选择，则只会把经过sed命令处
  理的行输出到屏幕。

- `-e`   #允许对输入数据应用多条sed命令编辑
- `-i`   #用sed的修改结果直接修改读取数据的文件，而不是由屏幕输出

动作:

- `a \`   #追加，在当前行后添加一行或多行。添加多行时，除最后一行外，每行末尾需要用“\”代表数据未完结。
- `c \`  #行替换，用c后面的字符串替换原数据行，替换多行时，除最后一行外，每行末尾需用“\”代表数据未完结。
- `i \`  #插入，在当前行前插入一行或多行。插入多行时，除最后一行外，每行末尾需要用“\”代表数据未完结。
- `d`    #删除，删除指定的行。
- `p`    #打印，输出指定的行。
- `s `    #字串替换，用一个字符串替换另外一个字符串。格式为“行范围s/旧字串/新字串/g”( 和vim中的替换格式类似)。

#### 行数据操作

- `sed '2p' student.txt `  #查看文件的第二行

  - ```
    # sed '2p' student.txt 
    ID	Name	gender	Mark	Mysql	Averager
    1	Limng	M	M	86	87.66
    1	Limng	M	M	86	87.66
    2	Sc	M	86	87	85.55
    3	Gao	M	83	93	92.66
    ```

- `sed -n '2p' student.txt`   #只把经过sed命令处理的行输出到屏幕

  - ```
    # sed -n '2p' student.txt
    1	Limng	M	M	86	87.66
    ```

- `sed '2,4d' student.txt `  ##删除第二行到第四行的数据，但不修改文件本身

  - ```
    # sed '2,4d' student.txt
    ID	Name	gender	Mark	Mysql	Averager
    ```

- `sed '2a hello' student.txt`    #在第二行后追加hello

  - ```
    # sed '2a hello' student.txt
    ID	Name	gender	Mark	Mysql	Averager
    1	Limng	M	M	86	87.66
    hello
    2	Sc	M	86	87	85.55
    3	Gao	M	83	93	92.66
    ```

- `sed '2i hello \baolaesa' student.txt`    #在第二行前插入两行数据

  - ```
    # sed '2i hello \
    > baolaesa ' student.txt
    ID	Name	gender	Mark	Mysql	Averager
    hello 
    baolaesa 
    1	Limng	M	M	86	87.66
    2	Sc	M	86	87	85.55
    3	Gao	M	83	93	92.66
    ```

- `sed '2c No such person' student.txt`  #数据替换

  - ```
    # sed '2c No such person' student.txt
    ID	Name	gender	Mark	Mysql	Averager
    No such person
    2	Sc	M	86	87	85.55
    3	Gao	M	83	93	92.66
    ```

#### 字符串替换

sed `‘s/旧字串/新字串/g’` 文件名

- `sed '3s/86/99/g' student.txt`  #在第三行中，把86换成99

  - ```
    # sed '3s/86/99/g' student.txt   
    ID	Name	gender	Mark	Mysql	Averager
    1	Limng	M	M	86	87.66
    2	Sc	M	99	87	85.55
    3	Gao	M	83	93	92.66
    ```



- `sed -i '3s/74/99/g' student.txt`   #sed操作的数据直接写入文件

  - ```
    # sed -i '3s/86/99/g' student.txt
    [root@localhost home]# cat student.txt 
    ID	Name	gender	Mark	Mysql	Averager
    1	Limng	M	M	86	87.66
    2	Sc	M	99	87	85.55
    3	Gao	M	83	93	92.66
    ```

- `sed -e 's/Liming//g;s/Gao//g' student.txt `   \#同时把“Liming ”和“Gao”替换为空 

  - ```
    # sed -e 's/Liming//g ; s/Gao//g' student.txt
    ID	Name	gender	Mark	Mysql	Averager
    1		M	M	86	87.66
    2	Sc	M	99	87	85.55
    3		M	83	93	92.66
    ```



## 3 字符处理命令

### 3.1 排序命令sort

`sort [选项] 文件名`

选项：

- `-f`  #忽略大小写
- `-n`   #以数值型进行排序，默认使用字符串型排序
- `-r`    #反向排序
- `-t`    #指定分隔符，默认是分隔符是制表符
- `-k n[,m]`   #按照指定的字段范围排序。从第n字段开始，m字段结束(默认到行尾)

案例：

 `sort /etc/passwd `   #排序用户信息文件

```
# sort /etc/passwd
adm:x:3:4:adm:/var/adm:/sbin/nologin
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
```

`sort -r /etc/passwd `   #反向排序

```
# sort -r /etc/passwd
vcsa:x:69:69:virtual console memory owner:/dev:/sbin/nologin
uucp:x:10:14:uucp:/var/spool/uucp:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
```

`sort -t ":" -k 3,3 /etc/passwd`  #指定分隔符是“`:`”，用第三字段开头，第三字段结尾排序，就是只用第三字段排序

```
# sort -t ":" -k 3,3 /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
uucp:x:10:14:uucp:/var/spool/uucp:/sbin/nologin

```

`sort -n -t ":" -k 3,3 /etc/passwd`

```
# sort -n -t ":" -k 3,3 /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
```

### 3.2 统计命令wc

`wc [选项] 文件名`

选项:

- `-l`   #只统计行数
- `-w`   #只统计单词数
- `-m`   #只统计字符数



## 4 条件判断

### 4.1 按照文件类型进行判断

|    作用     |                           测试选项                           |
| :---------: | :----------------------------------------------------------: |
|   -b 文件   |  判断该文件是否存在，并且是否为块设备文件(是块设备文件为真)  |
|   -c 文件   | 判断该文件是否存在，并且是否为字符设备文件(是字符设备文件为真) |
| ==-d 文件== |      判断该文件是否存在，并且是否为目录文件(是目录为真)      |
| ==-e 文件== |                 判断该文件是否存在(存在为真)                 |
| ==-f 文件== |    判断该文件是否存在，并且是否为普通文件(是普通文件为真)    |
|   -L 文件   | 判断该文件是否存在，并且是否为符号链接文件(是符号链接文件为真) |
|   -p 文件   |    判断该文件是否存在，并且是否为管道文件(是管道文件为真)    |
|   -s 文件   |         判断该文件是否存在，并且是否为非空(非空为真)         |
|   -S 文件   |  判断该文件是否存在，并且是否为套接字文件(是套接字文件为真)  |

#### 两种判断格式

`test -e /root/install.log`

```
# test -e student.txt 
# echo $?
0
```

`[ -e /root/install.log ]`  #注意：中括号两侧有空格

```
# [ -e student.txt ] 
# echo $?
0
```

`[ -d /root ] && echo "yes" || echo "no"` #第一个判断命令如果正确执行，则打印“"yes”， 否则打印“no”

```
# [ -d /root ] && echo "yes" || echo "no"
yes
```

### 4.2 按照文件权限进行判断

|  测试选项   |                             作用                             |
| :---------: | :----------------------------------------------------------: |
| ==-r 文件== |  判断该文件是否存在，并且是否该文件拥有读权限(有读权限为真)  |
| ==-w 文件== |  判断该文件是否存在，并且是否该文件拥有写权限(有写权限为真)  |
| ==-x 文件== | 判断该文件是否存在，并且是否该文件拥有执行权限(有执行权限为真) |
|   -u 文件   | 判断该文件是否存在，并且是否该文件拥有SUID权限(有SUID权限为真) |
|   -g 文件   | 判断该文件是否存在，并且是否该文件拥有SGID权限(有SGID权限为真) |
|   -k文件    | 判断该文件是否存在，并且是否该文件拥有SBit权限(有SBit权限为真) |

案例:

`[ -w student.txt ] && echo "yes" || echo "no"`  #判断文件是拥有写权限的

```
# [ -w student.txt ] && echo "yes" || echo "no"
yes
```

### 4.3 两个文件之间进行比较

|     测试选项      |                             作用                             |
| :---------------: | :----------------------------------------------------------: |
| 文件1 `-nt` 文件2 |       判断文件1的修改时间是否比文件2的新(如果新则为真)       |
| 文件1 `-ot` 文件2 |       判断文件1的修改时间是否比文件2的旧(如果旧则为真)       |
| 文件1 `-ef` 文件2 | 判断文件1是否和文件2的Inode号一致，可以理解为两个文件是否为<br />同一个文件。这个判断用于判断硬链接是很好的方法。 |

案例：

 `[ /home/student.txt -ef /tmp/stu.txt ] `  # 用test测试下

```
# ln /home/student.txt /tmp/stu.txt   #创建个硬链接吧
# [ /home/student.txt -ef /tmp/stu.txt ] && echo "yes" || echo "no"
yes
```

### 4.4 两个整数之间比较

|     测试选项      |                   作用                    |
| :---------------: | :---------------------------------------: |
| 整数1 `-eq` 整数2 |    判断整数1是否和整数2相等(相等为真)     |
| 整数1 `-ne` 整数2 |  判断整数1是否和整数2不相等(不相等为真)   |
| 整数1`-gt` 整数2  |     判断整数1是否大于整数2 (大于为真)     |
| 整数1 `-It` 整数2 |     判断整数1是否小于整数2 (小于为真)     |
| 整数1 `-ge` 整数2 | 判断整数1是否大于等于整数2 (大于等于为真) |
| 整数1 `-le` 整数2 | 判断整数1是否小于等于整数2 (小于等于为真) |

### 4.5 字符串的判断

|     测试选项     |                     作用                     |
| :--------------: | :------------------------------------------: |
|   `-z` 字符串    |        判断字符串是否为空(为空返回真)        |
|   `-n` 字符串    |       判断字符串是否为非空(非空返回真)       |
| 字串1 `==` 字串2 |   判断字符串1是否和字符串2相等(相等返回真)   |
| 字串1 `!=` 字串2 | 判断字符串1是否和字符串2不相等(不相等返回真) |

案例：

`[ -z "$name" ]`  #判断name变量是否为空

```
# name=sc
# [ -z "$name" ] && echo "yes" || echo "no"   #给name变量赋值
no
```

`[ "$aa"=="$bb" ] ` #判断两个变量的值是否相等

```
# aa=11  #给变量aa和变量bb赋值
# bb=22
# [ "$aa"=="$bb" ] && echo "yes" || echo "no"
no
```

### 4.6 多重条件判断

|     测试选项     |                       作用                       |
| :--------------: | :----------------------------------------------: |
| 判断1 `-a` 判断2 |   逻辑与，判断1和判断2都成立，最终的结果才为真   |
| 判断1 `-o` 判断2 | 逻辑或，判断1和判断2有一个成立，最终的结果就为真 |
|     `!` 判断     |            逻辑非，使原始的判断式取反            |

案例：

`[ -n "$aa" -a "$aa" -gt 23 ]` #判断变量aa是否有值，同时判断变量aa的是否大于23

```
#aa=11
# [ -n "$aa" -a "$aa" -gt 23 ] && echo "yes" || echo "no"  
no

#因为变量aa的值不大于23，所以虽然第一个判断值为真,返回的结果也是假
```



## 5 流程控制

### 5.1 if 语句

#### 单分支if条件语句

- 第一种

  ```shell
  if [ 条件判断式 ];then
  	程序
  fi
  ```

- 第二种

  ```shell
  if [ 条件判断式 ]
  	then
  		程序
  fi
  ```

##### 单分支条件语句需要注意几个点

- `if` 语句后==有空格==，使用 `fi` 结尾，和一般语言使用大括号结尾不同。
- `[ 条件判断式 ]` 就是使用test命令判断，所以中括号和条件判断式之间必须有空格。
- `then` 后面跟符合条件之后执行的程序，可以放在 `[]` 之后，用“`;`”分割。也可以换行写入，就不需要“`;`”了。

##### 案例：判断分区使用率

统计根分区使用率

```shell
#!/bin/bash
# Author: cici (E-mail: cici@163.com)

# 把根分区使用率作为变量值赋予变量rate
rate=$(df -h | grep "/dev/sda1" | awk '{print $5}' | cut -d "%" -f1)
if [ $rate -ge 10 ]
    then
        echo "Warning! /dev/sda1 is fulll!"
fi
```

#### 双分支if条件语句

```shell
if [ 条件判断式 ]
  then
	 条件成立时，执行的程序
  else
	 条件不成立时，执行的另一一个程序
fi
```

##### 案例1：备份mysql数据库

```shell
#!/bin/bash
# Author: cici (E-mail: cici@163.com)

#同步系统时间
ntpdate asia.pool.ntp.org &>/dev/null

#把当前系统时间按照“年月日”格式赋予变量date
date=$(date +%y%m%d)

#统计mysq1:数据库的大小,并把大小赋子size变量
size=$(du -sh /var/lib/yum)

if [ -d /tmp/dbbak ]
  then
          echo "Date : $date!" /tmp/dbbak/dbinfo.txt
          echo "Data size : $size" >> /tmp/dbbak/dbinfo.txt
          cd /tmp/dbbak
          tar -zcf mysql-lib-$date.tar.gz /var/lib/yum dbinfo.txt &>/dev/nu11
          rm -rf /tmp/dbbak/dbinfo.txt
  else
          mkdir /tmp/dbbak
          echo "Date : $date!" > /tmp/dbbak/dbinfo.txt
          echo "Data size : $size" >> /tmp/dbbak/dbinfo.txt
          cd /tmp/dbbak
          tar -zcf mysql-lib-$date.tar.gz /var/lib/yum dbinfo.txt &>/dev/nu11
          rm -rf /tmp/dbbak/dbinfo.txt
fi
```

##### 案例2：判断apache是否启动

```
# yum -y install nmap
# yum -y install httpd
```

```shell
#!/bin/bash
# Author: cici (E-mail: cici@163.com)

#使用nmap命令扫描服务器，并裁取apache服务的状态，赋子变量port
port=$(nmap -sT 192.168.124.156 | grep tcp | grep http | awk '{print $2}')
if [ "$port"=="open" ]
then
	echo "$(date) httpd is ok!" >> /tmp/autostart.log
else
	/etc/rc.d/init.d/httpd start &>/dev/nul1
	echo "$(date) restart httpd !!" >> /tmp/autostart.1og
fi
```

#### 多分支if条件语句

```shell
if [ 条件判断式1 ]
	then
		当条件判断式1成立时，执行程序1
elif [ 条件判断式2 ]
	then 
		当条件判断式2成立时，执行程序2
else
	当所有条件都不成立时，最后执行此程序
fi
```

##### 案例：判断用户输入的是什么文件

```shell
#!/bin/bash
# Author: cici (E-mail: cici@163.com)

#接收键盘的输入，并赋予变量file
read -p "Please input a file name :" file

if [ -z "$file" ] #判断file变量是否为空
        then
                echo "Error, please input a file name"
                exit 1
elif [ ! -e "$file" ] #判断file的值是否存在
        then
                echo "Your input is not a file!"
                exit 2
elif [ -f "$file" ] #判断file的值是否为普通文件
        then
                echo "$file is a regulare file!"
elif [ -d "$file" ] #判断file的值是否为目录文件
        then
                echo "$file is a directory!"
else
        echo "$file is an other file!"
fi
```



### 5.2 case 语句

#### 多分支case条件语句

`case` 语句和 `if... elif..else` 语句一样都是多分支条件语句，不过和 `if` 多分支条件语句不同的是，case语句只能判断一种条件关系，而`if`语句可以判断多种条件关系。

```shell
case $变量名 in 
	"值1")
		如果变量的值等于值1，则执行程序1
		;;
	"值2")
		如果变量的值等于值2，则执行程序2
		;;
	...省略其他分支...
	*)
		如果变量的值都不是以上的值，则执行此程序
		;;
esac
```

#### 案例：判断用户输入

```shell
#!/bin/bash
# Author: cici (E-mail: cici@163.com)

read -p "Please choose yes/no:" -t 30 cho
case $cho in
        "yes")
                echo "Your choose is yes!"
                ;;
        "no")
                echo"Your choose is no!"
                ;;
        *)
                echo "Your choose is error!"
                ;;
esac
```

### 5.3 for 循环

#### 语法一

```shell
for 变量 in 值1 值2 值3...
	do
		程序
	done
```

案例1：打印时间

```shell
#!/bin/bash
# Author: cici (E-mail: cici@163.com)

for time in morning noon afternoon evening
        do
                echo "This time is $time!"
        done
```

案例2：批量解压缩脚本

```shell
#!/bin/bash
# Author: cici (E-mail: cici@163.com)

cd /lamp
ls *.tar.gz > ls.log
for i in $(cat ls.log)
	do
		tar -zxf $i &>/dev/null
	done
rm -rf /lamp/ls.log
```

#### 语法二

```shell
for((初始值;循环控制条件;变量变化))
	do
		程序
	done
```

案例1：从 1 加到 100

```shell
#!/bin/bash
# Author: cici (E-mail: cici@163.com)

s=0
for((i=1;i<=100;i=i+1))
        do
                s=$(( $s+$i ))
        done
echo "The sum of 1+2+...+100 is : $s"
```

案例2：批量添加指定数量的用户

```shell
#!/bin/bash
# Author: cici ( E-mail: cici@163.com)

read -t 30 -p "Please input user name:" name
read -t 30 -p "Please input the number of users:" num
read -t 30 -p "Please input the password of users:" pass
if [ ! -z "$name" -a ! -z "$num" -a ! -z "$pass" ]
        then
        y=$(echo $num | sed 's/[0-9]//g') #或者 's/^[0-9]*$//g'
        if [ -z "$y" ]
                then
                    for((i=1;i<=$num;i=i+1))
                           do
                               /usr/sbin/useradd $name$i &>/dev/null
                               echo $pass | /usr/bin/passwd --stdin $name$i &>/dev/null
                           done
        fi
fi
```



### 5.4 while 循环与 until 循环

#### while循环

`while`循环是不定循环，也称作条件循环只要条件判断式成立，循环就会一直继续，直到条件判断式不成立，循环才会停止。这就和`for`的固定循环不太一样了。

```shell
while [ 条件判断式 ]
	do
		程序
	done
```

案例：从1加到100

```shell
#!/bin/bash
# Author: cici (E-mail: cici@163.com)

i=1
s=0
while [ $i -le 100 ] #如果变量i的值小于等于100，则执行循环
        do
                s=$(($s+$i ))
                i=$(($i+1))
        done
echo "The sum is: $s"
```

#### until循环

until循环， 和while循环相反，until循环时只要条件判断式不成立则进行循环，并执行循环程序。一旦循环条件成立，则终止循环。

```shell
until [ 条件判断式 ]
	do
		程序
	done
```

案例：从1加到100

```shell
#!/bin/bash
# Author: cici (E-mail: cici@163.com)

i=1
s=0
until [ $i -gt 100 ]  #循环直到变量的值大于100，就停止循环
	do
		s=$(($s+$i))
		i=$(($i+1))
	done
echo "The sum is: $s"
```

