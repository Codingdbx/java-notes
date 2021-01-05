# Linux 常用命令

## 1. 文件处理命令

### 1.1 命令格式与目录处理命令ls

#### 命令格式

`ls` [选项]  [参数] 

- 个别命令使用不遵循此格式
- 当有多个选项时，可以写在一起
- 简化选项与完整选项
  - -a 等于 --all

#### 目录处理命令: ls

命令英文原意: `list`

命令所在路径: `/bin/ls`

执行权限：所有用户

功能描述：显示目录文件

`ls [-a-l-d]` [文件或目录]

- `-a`  #显示所有文件，包括隐藏文件

  - `ls -a`

    ```
    # ls -a
    .  ..  student.txt  wwwww
    ```

- `-l`   #详细信息显示

  - `ls -l`

    ```
    # ls -l
    total 8
    -rw-r--r--. 2 root root 95 Dec 21 21:45 student.txt
    -rw-r--r--. 1 root root 95 Dec 19 22:14 wwwww
    ```

  - `ls -lh` # h的意思是human，人性化显示

    ```
    # ls -lh /etc
    total 1.2M
    -rw-r--r--.  1 root root   44 Dec 18 18:47 adjtime
    -rw-r--r--.  1 root root 1.5K Jan 12  2010 aliases
    -rw-r--r--.  1 root root  12K Dec 13 20:04 aliases.db
    ```

- `-d`   #查看目录属性

  ```
  # ls -d /etc
  /etc
  ```
- `-i `   #查看文件唯一ID号

  ```
  # ls -i /home
  8700138 anny     16834415 summ.sh  25632001 tt15
  ```

- `-r ` #将文件以相反次序显示(原定依英文字母次序)

  ```
  # ls -l /home
    total 16
    -rwxrwxrw-. 2 root   root     95 Dec 21 21:45 student.txt
    -rw-r--r--. 1 root   root     95 Dec 19 22:14 wwwww
  # ls -r /home
    wwwww  student.txt
  # ls -lr /home
    total 16
    -rw-r--r--. 1 root   root     95 Dec 19 22:14 wwwww
    -rwxrwxrw-. 2 root   root     95 Dec 21 21:45 student.txt
  ```

- `-t`    #将文件依建立时间之先后次序列出

  ```
  # ls -lt /home
    total 16
    -rwxrwxrw-. 2 root   root     95 Dec 21 21:45 student.txt
    -rw-r--r--. 1 root   root     95 Dec 19 22:14 wwwww
  # ls -ltr /home
    total 16
    -rw-r--r--. 1 root   root     95 Dec 19 22:14 wwwww
    -rwxrwxrw-. 2 root   root     95 Dec 21 21:45 student.txt
  ```

#### 权限字段 -rw-r--r--

- `-`   #文件类型
  - `-`    #二进制文件 
  - `d `    #目录 
  - `l`    #软链接文件

- `rw-`  
  - u 所有者权限  # r读  w写   x执行
- `r--`  
  - g 所属組权限
- `r--`
  - o 其他人权限

### 1.2 目录处理命令

#### 目录处理命令: mkdir

命令英文原意： `make directories`

命令所在路径：`/bin/mkdir`

执行权限：所有用户

功能描述：创建新目录

 `mkdir -p` [目录名]

- `-p` #递归创建
  - `mkdir -p /tmp/Japan/longze /tmp/Japan/cangjing`

#### 目录处理命令: cd

命令英文原意： `change directory`

命令所在路径： `shell`内置命令

执行权限： 所有用户

功能描述：切换新目录

`cd` [目录]

- `cd /tmp/`   #切换到指定目录

- `cd ..`    #回到上一级目录

#### 目录处理命令: pwd

命令英文原意： `psint working directory`

命令所在路径： `/bin/pwd`

执行权限：所有用户

功能描述：显示当前目录

`pwd`  

#### 目录处理命令: rmdir

命令英文原意： `remove empty directories`

命令所在路径： `/bin/rmdir`

执行权限：所有用户

功能描述：删除空目录

`rmdir` [目录名]

- `rmdir /home/wwww`   #删除空目录

#### 目录处理命令: cp

命令英文原意： `copy`

命令所在路径：`/bin/cp`

执行权限：所有用户

功能描述：复制文件或目录

 `cp [-r-p]` [原文件或目录] [目标目录]

- 不加参数 #只能复制文件类型

- `-r` 复制目录
- `-p` 保留文件属性

#### 目录处理命令: mv

命令英文原意： `move`

命令所在路径：`/bin/mv`

执行权限：所有用户

功能描述：剪切文件、改名

 `mv` [原文件或目录] [目标目录]

#### 目录处理命令: rm

命令英文原意：`remove`

命令所在路径：`/bin/rm`

执行权限：所有用户

功能描述：删除文件

 `rm [-r-f]` [文件或目录]

- `-r`  #删除目录
- `-f`  #强制执行

### 1.3 文件处理命令

#### 文件处理命令: touch

命令所在路径：`/bin/touch`

执行权限：所有用户

功能描述：创建空文件

`touch` [文件名]

-  `touch "program files"` #创建带空格的文件

#### 文件处理命令: cat

命令所在路径：`/bin/cat`

执行权限：所有用户

功能描述：显示文件内容

`cat` [文件名]

- `-n` #显示行号

#### 文件处理命令: tac

命令所在路径：`/usr/bin/tac`

执行权限：所有用户

功能描述：显示文件内容(反向列示)

 `tac` [文件名]

- `tac student.txt` 

  ```
  # tac student.txt 
  3	Gao	M	83	93	92.66
  2	Sc	M	99	87	85.55
  1	Limng	M	M	86	87.66
  ID	Name	gender	Mark	Mysql	Averager
  ```

#### 文件处理命令: more

命令所在路径：`/bin/more`

执行权限：所有用户

功能描述：分页显示文件内容

`more` [文件名]

- (空格)或f  #翻页

- (Enter)   #换行
- q或Q    #退出 

#### 文件处理命令: less

命令所在路径：`/usr/bin/less`

执行权限：所有用户

功能描述：分页显示文件内容(可向上翻页)

`less` [文件名]

- less 带搜索功能 

  - 输入`/name` 

    ```
    ID      Name    gender  Mark    Mysql   Averager
    1       Limng   M       M       86      87.66
    2       Sc      M       99      87      85.55
    3       Gao     M       83      93      92.66
    /87
    ​```
    ```
    
    - 按`enter`键确认
    - 按`n`键往下找

#### 文件处理命令: head

命令所在路径：`/usr/bin/head`

执行权限：所有用户

功能描述：显示文件前面几行

`head` [文件名]

- `-n` 指定行数

#### 文件处理命令: tail

命令所在路径：`/usr/bin/tail`

执行权限：所有用户

功能描述：显示文件后面几行

`tail` [文件名]

- `-n` 指定行数
- `-f` 动态显示文件末尾内容

==注意：==

1. `tail` 和 `head` 都是默认只显示10行。
2. `more` 和 `less` 区别是 `less` 可以往上翻页，并且可以搜索。

### 1.4 链接命令

#### 链接命令: In

命令英文原意： `link`

命令所在路径： `/bin/ln`

执行权限：所有用户

功能描述：生成链接文件

`In -s` [原文件] [目标文件]

- 不加参数 #创建硬链接

- `-s`  #创建软链接

#### 软链接特征

软链接特征：类似`Windows`快捷方式

- `lrwxrwxrwx`   `l` 指的是软链接类型`link`
  - 软链接文件权限都为 `rwxrwxrwx`
- 文件大小
  - 只是符号链接
- `/tmp/issue.soft -> /etc/issue`
  - 箭头指向源文件

#### 硬链接特征

硬链接特征：硬链接相当于备份

- 相当于拷贝命令 `cp -p`   #保留文件属性
- 同步更新     #修改文件内容会同步更新
  - `echo “www.baidu.com" >> /etc/issue`
- 通过`i`节点识别文件
  - `ls -i`  #Linux操作文件的时候是只针对`i`节点识别的
- 不能跨分区
- 不能针对目录使用



## 2. 权限管理命令

### 2.1 权限管理命令chmod

#### 权限管理命令: chmod

命令英文原意： `change the permissions mode of a file`

命令所在路径： `/bin/chmod`

执行权限：所有用户

功能描述：改变文件或目录权限

`chmod [{ugoa} {+-=} {rwx}]` [文件或目录]

- `-R` 递归修改

  ```
  # chmod -R 777 testdir #修改目录testfile及其目录下文件为所有用户具有全部权限
  ```

案例：

```
# ls -l student.txt 
-rw-r--r--. 2 root root 95 Dec 21 21:45 student.txt
# chmod u+x student.txt 
# ls -l student.txt 
-rwxr--r--. 2 root root 95 Dec 21 21:45 student.txt
```

```
# chmod u+x,o+w student.txt 
# ls -l student.txt 
-rwxr--rw-. 2 root root 95 Dec 21 21:45 student.txt
```

```
# chmod g=rwx student.txt 
# ls -l student.txt 
-rwxrwxrw-. 2 root root 95 Dec 21 21:45 student.txt
```



#### 权限的数字表示

- `r` ---- 4
- `w ` ---- 2
- `x` ---- l

`rwxrw-r--`  764

#### 文件目录权限总结

| 代表字符 |   权限   |                 对文件的含义                  |                     对目录的含义                     |
| :------: | :------: | :-------------------------------------------: | :--------------------------------------------------: |
|    r     |  读权限  | 可以查看文件内容（`cat/more/head/tail/less`） |             可以列出目录中的内容（`ls`）             |
|    w     |  写权限  |         可以修改文件内容（`vi/vim`）          | 可以在目录中创建、删除文件（`touch/mkdir/rmdir/rm`） |
|    x     | 执行权限 |       可以执行文件（`script/command`）        |                 可以进入目录（`cd`）                 |



### 2.2 其他权限管理命令

#### 权限管理命令: chown

命令英文原意：`change file ownership`

命令所在路径：`/bin/chown`

==执行权限==：只有 root 用户可以改变文件的所有者

功能描述：改变文件或目录的所有者

`chown` [用户] [文件或目录]

- 只有 root 用户可以改变文件的所有者

案例：

```
# useradd anny
# passwd anny
# userdel anny
```

```
# ls -ld anny
drwx------. 3 danny anny 4096 Dec 26 15:18 anny
# chown root /home/anny
# ls -ld anny
drwx------. 3 root anny 4096 Dec 26 15:18 anny
```

#### 权限管理命令: chgrp

命令英文原意： `change file group ownership`

命令所在路径： `/bin/chgrp`

==执行权限==：只有 root 用户可以改变文件的所属组

功能描述：改变文件或目录的所属组

`chgrp` [用户组] [文件或目录]

- 只有 root 用户可以改变文件的所属组
- 改变所属组权限后，组里的所有人都享有此权限

#### 权限管理命令: umask

命令英文原意：`the user file-creation mask`

命令所在路径：Shell内置命令

执行权限：所有用户

功能描述：显示、设置文件的缺省权限（默认权限）

`umask` [-S]

- `-S` 以`rwx`形式显示新建文件缺省权限

  ```
  $ umask -S
  u=rwx,g=rwx,o=rx
  ```

改变默认权限：

```
$ umask -S
u=rwx,g=rwx,o=rx  #776
$ umask 077       #与777异或的值就是为设置的权限
$ umask -S
u=rwx,g=,o=       #700
```

```
777 rwx rwx rwx
022 --- -w- -w-
--------------------
755 rwx r-x r-x  目录
    rw- r-- r--  文件

777 rwx rwx rwx
077 --- rwx rwx
---------------------
700 rwx --- ---  目录
    rw- --- ---  文件
```



## 3. 文件搜索命令

### 3.1 文件搜索命令 find

#### 文件搜索命令: find

命令所在路径：`/bin/find`

执行权限：所有用户

功能描述：文件搜索

`find` [搜索范围]  [匹配条件]

- `find /etc -name init`

  - 在目录`/etc`中查找文件`init`
  - `-iname` 不区分大小写

- `find / -size +204800`

  - 在根目录下查找大于`100MB`的文件
    - 1数据块 = 512字节 = `0.5Kb`
    - `100MB` = `102400KB` = `204800`
  - `+n` 大于 `-n` 小于 `n` 等于

- `find /home -user danny`

  - 在根目录下查找所有者为`danny`的文件
  - `-group`根据所属组查找

- `find /etc -cmin -5`

  - 在`/etc`下查找5分钟内被修改过属性的文件和目录
  - `-amin`   //访问时间 access
  - `-cmin`   //文件属性 change
  - `-mmin`   //文件内容 modify

- `find /etc -size +163840 -a -size -204800`

  - 在`/et`c下查找大于`80MB`小于`100MB`的文件
  - `-a` 两个条件同时满足
  - `-o` 两个条件满足任意一个即可

- `find /etc -name inittab -exec ls -l {} \;`

  - 在`/etc`下查找 `inittab `文件并显示其详细信息

  - `-exec/-ok [命令] {} \;`   //对搜索结果执行操作

    ```
    # find /etc -name inittab -exec ls -l {} \;
    -rw-r--r--. 1 root root 884 Dec 18 15:36 /etc/inittab
    ```

    ```
    # find /etc -name inittab -ok rm {} \;
    < rm ... /etc/inittab > ? n
    ```

- `-type`  根据文件类型查找

  - `f`文件 `d`目录   `l`软链接文件

  - find  /home -type d

    ```
    # find /home -type d
    /home
    /home/danny
    /home/danny/hello
    /home/danny2
    ```

- `-inum `  根据`i`节点查找

  - 查找带空格的文件名
  - 查找硬链接文件

  - `find -inum 4520 -exec cat {} \;`

    ```
    # find -inum 4520 -exec cat {} \;
    ID	Name	gender	Mark	Mysql	Averager
    1	Limng	M	M	86	87.66
    2	Sc	M	99	87	85.55
    3	Gao	M	83	93	92.66
    ```

### 3.2 其他搜索命令

#### 文件搜索命令: locate

命令所在路径：`/usr/bin/locate`

执行权限：所有用户

功能描述：在文件资料库中查找文件，速度相当快

`locate` [文件名]

- 准备条件

  ```
  # yum -y install mlocate
  ```

  ```
  # updatedb
  ```

  ```
  # locate inittab
  /etc/inittab
  /usr/share/vim/vim74/syntax/inittab.vim
  ```

- 新建文件，需要更新资料库，将新文件加入资料库

  ```
  # touch /home/aaa
  # ls -ld /home/aaa
  -rw-r--r--. 1 root root 0 Dec 26 16:19 /home/aaa
  # locate aaa
  # updatedb
  # locate aaa
  /home/aaa
  ```

- `/tmp/` 下的文件不会被收录到资料库中

  - ```
    # touch /tmp/bbb
    # ls -l /tmp/bbb
    -rw-r--r--. 1 root root 0 Dec 26 16:20 /tmp/bbb
    # locate bbb
    ```

- `-i` 不区分大小写

  - `locate -i Inittab`

    ```
    # locate -i Inittab
    /etc/inittab
    /usr/share/vim/vim74/syntax/inittab.vim
    ```

  

#### 文件搜索命令: which

命令所在路径：`/usr/bin/which`

执行权限：所有用户

功能描述：搜索命令所在目录及==别名信息==

`which` [命令]

- `which cp`

  ```
  # which cp
  alias cp='cp -i'
  	/usr/bin/cp
  ```

  ```
  # which ls
  alias ls='ls --color=auto'
  	/usr/bin/ls
  ```

  ```
  # which rm
  alias rm='rm -i'
  	/usr/bin/rm
  ```

  

#### 文件搜索命令: whereis

命令所在路径：`/usr/bin/whereis`

执行权限：所有用户

功能描述：搜索命令所在目录及==帮助文档路径==

 `whereis` [命令名称]

- `whereis ls`

  ```
  # whereis ls
  ls: /usr/bin/ls /usr/share/man/man1/ls.1.gz
  ```



#### 文件搜索命令: grep

命令所在路径：`/bin/grep`

执行权限：所有用户

功能描述：在文件中搜寻字串匹配的行并输出

`grep [-i-v]` [指定字串] [文件]

- `-i`    #不区分大小写

- `-v`    #排除指定字串

  - `rep -v ^# /etc/inittab`

    ```
    # grep -v ^# /etc/inittab
    id:3:initdefault:
    ```



## 4. 帮助命令

#### 帮助命令: man

命令英文原意：`manual`

命令所在路径：`/usr/bin/man`

执行权限：所有用户

功能描述：获得帮助信息

`man` [命令或配置文件]

- `man ls`      #查看ls命令的帮助信息
- `man services   `     #查看配置文件services的帮助信息

#### 帮助命令: help

命令所在路径：Shell内置命令

执行权限：所有用户

功能描述：获得Shell内置命令的帮助信息

`help` [命令]

- `help umask`    #查看`umask`命令的帮助信息

总结：

- `man`    //浏览的时候有点像 less/more，可以翻页，可以查找。

- `info`    //跟 man 类似

- [命令]  --help   

- `apropos`  [配置文件]

- `whatis` [命令]

  - ```
    # whatis ls
    ls (1)               - list directory contents
    ```



## 5. 用户管理命令

#### 用户管理命令:  useradd

命令所在路径：`/usr/sbin/useradd`

执行权限：`root`

功能描述：添加新用户

 `useradd ` [用户名]

- `useradd yangmi`

#### 用户密码管理命令: passwd

命令所在路径：`/usr/bin/passwd`

执行权限：所有用户

功能描述：设置用户密码

`passwd` [用户名]

- `passwd yangmi`

  - ```
    # passwd yamgmi
    Changing password for user yamgmi.
    New password: 
    Retype new password: 
    passwd: all authentication tokens updated successfully.
    ```

#### 用户管理命令: who

命令所在路径：`/usr/bin/who`

执行权限：所有用户

功能描述：查看登录用户信息

`who`

- ```
  # who
  root     pts/0        2020-12-26 13:49 (192.168.125.120)
  ```

- `tty`    #本地终端

- `pts/0 `  #远程终端/终端号

#### 用户管理命令: w

命令所在路径：`/usr/bin/w`

执行权限：所有用户

功能描述：查看登录用户详细信息

`w`

- ```
  # w
  21:54:09 up  8:35,  1 user,  load average: 0.00, 0.01, 0.05
  USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
  root     pts/0    192.168.102.120    13:49    1.00s  0.12s  0.01s w
  ```

- `IDLE`    //当前登录用户已经空闲多少时间

- `JCPU`    //当前登录的用户累计占用CPU多少时间

- `PCPU`    //当前用户执行的操作命令占用CPU的时间

- `WHAT`    //当前用户正在执行什么命令



## 6. 压缩解压命令

#### 压缩解压命令: gzip

命令英文原意：`GNUzip`

命令所在路径：`/bin/gzip`

执行权限：所有用户

功能描述：压缩文件

压缩后文件格式： `.gz`

`gzip` [文件]

- ```
  # gzip ddd.txt
  # ls
  ddd.txt.gz
  ```

- 只能压缩文件类型，目录不行

- 不保留源文件

#### 压缩解压命令: gunzip

命令英文原意：`GNUunzip`

命令所在路径：`/bin/gunzip`

执行权限：所有用户

功能描述：解压缩`.gz`的压缩文件

`gunzip` [压缩文件]

- ```
  # gunzip ddd.txt.gz 
  # ls
  ddd.txt
  ```

  

#### 压缩解压命令: tar

命令所在路径：`/bin/tar`

执行权限：所有用户

功能描述：打包目录

压缩后:文件格式： `.tar.gz`

`tar [-z-c-f]`  [压缩后文件名] [目录]

- `-c`   #打包
- `-v `   #显示详细信息
- `-f`   #指定文件名
- `-z `   #打包同时压缩

案例1：将目录/文件打包为 `.tar` 文件

```
# tar -cvf ddd.tar ddd.txt 
ddd.txt
# ls
ddd.tar  ddd.txt
```

案例2：将目录/文件打包并压缩为`.tar.gz`文件

```
# tar -zcf ddd.tar.gz ddd.txt 
# ls
ddd.tar.gz
```

#### tar 命令解压缩语法

- `-x`    #解包
- `-v`    #显示详细信息
- `-f`     #指定解压文件
- `-z`     #解压缩

案例：解压缩 `ddd.tar.gz` 

```
# tar -zxvf ddd.tar.gz 
ddd.txt
# ls
ddd.txt  
```

#### 压缩解压命令: zip

命令所在路径：`/us/bin/zip`

执行权限：所有用户

功能描述：压缩文件或目录

压缩后文件格式： `.zip`

`zip [-r]` [压缩后文件名] [文件或目录]

- `yum -y install zip`  

- -r 压缩目录

案例：压缩文件

```
# zip hello.zip hello/
  adding: hello/ (stored 0%)
# ls
hello  hello.zip
```

#### 压缩解压命令: unzip

命令所在路径：`/usr/bin/unzip`

执行权限：所有用户

功能描述：解压zip的压缩文件

 `unzip` [压缩文件]

- ```
  # unzip hello2.zip
  ```



#### 压缩解压命令: bzip2

命令所在路径：`/usr/bin/bzip2`

执行权限：所有用户

功能描述：压缩文件

压缩后文件格式：`.bz2`

`bzip2` `[-k]` [文件]

- `yum -y install bzip2`

- `-k`    #产生压缩文件后保留原文件

  - ```
    # bzip2 -k abcd.sh 
    # ls
    abcd.sh  abcd.sh.bz2 
    ```

- 只能压缩文件，但是压缩比更高

  - ```
    # bzip2 -k face
    bzip2: Input file face is a directory.
    ```

-  `tar -cjf abcd.tar.bz2 abcd.sh`

  ```
  # tar -cjf abcd.tar.bz2 abcd.sh
  # ls
  abcd.sh abcd.tar.bz2 
  ```

#### 压缩解压命令: bunzip2

命令所在路径：`/usr/bin/bunzip2`

执行权限：所有用户

功能描述：解压缩

`bunzip2` `[-k]` [压缩文件]

- `bunzip2 -k abcd.sh.bz2`
- `tar -xjf abcd.tar.bz2`



## 7. 网络命令

#### 网络命令: write

指令所在路径：`/usr/bin/write`

执行权限：所有==在线==用户

功能描述：给用户发信息，以`Ctrl+D`保存结束

`write` [用户名]

- 注意 `Ctrl+D` 结束，删除字符按住`Ctrl`键，再按删除键`Backspace`



#### 网络命令: wall

命令英文原意：`write all`

指令所在路径：`/usr/bin/wall`

执行权限：所有在线用户

功能描述：发广播信息

`wall` [message]

- 自己也会收到信息



#### 网络命令: ping

命令所在路径：`/bin/ping`

执行权限：所有用户

功能描述：测试网络连通性

`ping` `[选项]` `[IP]`

- `-c`   #指定发送次数

  ```
  # ping -c 3 192.168.112.121
  PING 192.168.1.111 (192.168.112.121) 56(84) bytes of data.
  64 bytes from 192.168.112.121: icmp_seq=1 ttl=64 time=0.368 ms
  64 bytes from 192.168.112.121: icmp_seq=2 ttl=64 time=0.402 ms
  64 bytes from 192.168.112.121: icmp_seq=3 ttl=64 time=0.336 ms
  
  --- 192.168.112.121 ping statistics ---
  3 packets transmitted, 3 received, 0% packet loss, time 2000ms
  rtt min/avg/max/mdev = 0.336/0.368/0.402/0.034 ms
  ```

  可以看到丢包率，越低说明网络约通畅。

#### 网络命令: ifconfig

命令英文原意：`interface configure`

命令所在路径：`/sbin/ifconfig`

执行权限：`root`

功能描述：查看和设置网卡信息

`ifconfig [网卡名称] [IP地址]`

- `ifconfig eth0 192. 168.122.250`

  ```
  # ifconfig
  eth0      Link encap:Ethernet  HWaddr 02:01:27:6D:69:7B  
            inet addr:192.168.112.151  Bcast:192.168.1.255  Mask:255.255.255.0
            inet6 addr: fe85::a10:25ff:fe6d:524b/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:678 errors:0 dropped:0 overruns:0 frame:0
            TX packets:193 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000 
            RX bytes:54747 (53.4 KiB)  TX bytes:12479 (12.1 KiB)
  
  lo        Link encap:Local Loopback  
            inet addr:127.0.0.1  Mask:255.0.0.0
            inet6 addr: ::1/128 Scope:Host
            UP LOOPBACK RUNNING  MTU:16436  Metric:1
            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0 
            RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
  ```

  - `eth0`   #真实网卡，后面的数字代表有几块网卡
    - `HWaddr`    #mac地址
      - 固化在网卡只读存储器上的，理论上不能修改
    - `Bcast`    #广播地址
    - `Mask`    #子网掩码
  - `lo`    #回环网卡
    - 回环网卡用来与本机通信和测试

#### 网络命令: mail

命令所在路径：`/bin/mail`

执行权限：所有用户

功能描述：查看发送电子邮件

使用须知：`yum -y install mailx`

`mail` [用户名]

- `mail kiti`  #发送邮件给了`kiti`用户

  ```
  # mail kiti
  Subject: hello world    
  EOT
  Null message body; hope that's ok
  ```

- `mail`   #接收邮件

  - h 选择邮件
  - q 退出

  

#### 网络命令: last

命令所在路径：`/usr/bin/last`

执行权限：所有用户

功能描述：列出目前与过去登入系统的用户信息

`last`

- ```
  # last
  kiti     pts/1        192.168.112.155    Sun Dec 27 17:20   still logged in   
  kiti     pts/1        192.168.112.155    Sun Dec 27 17:20 - 17:20  (00:00)    
  kiti     pts/1        192.168.112.155    Sun Dec 27 17:19 - 17:20  (00:00)  
  ```



#### 网络命令: lastlog

命令所在路径：`/usr/bin/astlog`

执行权限：所有用户

功能描述：检查某特定用户上次登录的时间

`lastlog`

- `lastlog`

  ```
  # lastlog
  Username         Port     From             Latest
  root             pts/0    192.168.112.155    Sun Dec 27 17:04:00 +0800 2020
  bin                                        **Never logged in**
  ```

-  `-u`    #指定`uid`，即用户`id` 

  ```
  # lastlog -u 502
  ```



#### 网络命令:  traceroute

命令所在路径：`/bin/traceroute`

执行权限：所有用户

功能描述：显示到达目的地的数据包路由 

使用须知： `yum install -y traceroute`

`traceroute` 

- `traceroute www.baidu.com`

  ```
  # traceroute www.baidu.com
  traceroute to www.baidu.com (182.61.220.7), 30 hops max, 60 byte packets
   1  gateway (182.148.102.145)  0.673 ms  0.686 ms  0.671 ms
   2  128.15.82.121 (128.15.82.121)  6.285 ms  6.240 ms  6.220 ms
   3  sjgmx-2.dev (10.44.181.148)  5.832 ms sjgmx-3.dev (10.44.181.148)  5.772 ms 
  ```



#### 网络命令: netstat

命令所在路径：`/bin/netstat`

执行权限：所有用户

功能描述：显示网络相关信息

`netstat` [选项]

- `-t`    #`TCP`协议
- `-u`    #`UDP`协议
- `-l  `    #监听
- `-r`    #路由
- `-n`    #显示`IP`地址和端口号

范例

- 查看本机监听的端口

  ```
  #  netstat -tlun
  Active Internet connections (only servers)
  Proto Recv-Q Send-Q Local Address           Foreign Address         State      
  tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
  tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN     
  tcp6       0      0 :::22                   :::*                    LISTEN     
  tcp6       0      0 ::1:25                  :::*                    LISTEN  
  ```

- 查看本机所有的网络连接

  ```
  # netstat -an
  Active Internet connections (servers and established)
  Proto Recv-Q Send-Q Local Address           Foreign Address         State      
  tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
  tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN     
  tcp        0      0 192.168.45.178:22       192.168.45.179:64725    ESTABLISHED
  tcp        0     52 192.168.45.178:22       192.168.45.179:63600    ESTABLISHED
  tcp6       0      0 :::22                   :::*                    LISTEN     
  tcp6       0      0 ::1:25                  :::*                    LISTEN     
  ```

- 查看本机路由表

  ```
  # netstat -rn
  Kernel IP routing table
  Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
  0.0.0.0         192.168.12.12    0.0.0.0         UG        0 0          0 enp0s3
  192.168.12.0     0.0.0.0         255.255.255.0   U         0 0          0 enp0s3
  ```

  `netstat -rn` 可以查看到本机的网关地址

#### 网络命令: setup

命令所在路径：`/usr/bin/setup`

执行权限：`root`

功能描述：配置网络

`setup`

- `setup` 是`redhat` 系统专有的命令

#### 挂载命令: mount

命令位置：`/bin/mount`

执行权限：所有用户

`mount` [-t 文件系统] [设备文件名] [挂载点]

- `mount -t iso9660 /dev/sr0 /mnt/cdrom`

  ```
  # mkdir /mnt/cdrom
  # mount /dev/sr0 /mnt/cdrom/
  # cd /mnt/cdrom
  # ls
  ```

- `mount`   #查看已经挂载的光盘

  ```
  # mount
  /dev/sda1 on /boot type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
  ```

  

## 8. 关机重启命令

### 8.1 shutdown 命令

`shutdown` [选项] [时间]

- `-c`    #取消前一个关机命令
- `-h`    #关机
- `-r`     #重启

### 8.2 其他关机命令

- `halt`
- `poweroff`
- `init 0`

### 8.3 其他重启命令

- `reboot`
- `init 6`

### 8.4 系统运行级别

| 级别 |           含义            |
| :--: | :-----------------------: |
|  0   |           关机            |
|  1   |          单用户           |
|  2   | 不完全多用户，不含NFS服务 |
|  3   |        完全多用户         |
|  4   |          未分配           |
|  5   |         图形界面          |
|  6   |           重启            |

#### 修改系统默认运行级别

```
# cat /etc/inittab
id:3:initdefault:
```

#### 查询系统运行级别

```
# runlevel
```

### 8.5 退出登录命令

```
# logout
```

