# Linux 用户和用户组管理

## 1 用户配置文件

### 1.1 用户信息文件

#### 用户管理简介

- 越是对服务器安全性要求高的服务器，越需要建立合理的用户权限等级制度和服务器操作规范。
- 在Linux中主要是通过用户配置文件来查看和修改用户信息。

#### /etc/passwd 用户信息文件

```
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
```

- 第1字段：用户名称

- 第2字段：密码标志  

  - `x`   #表示该用户有密码

- 第3字段：`UID` (用户ID)

  - `0`：超级用户
  - `1-499`：系统用户(伪用户)
  - `500-65535`：普通用户

- 第4字段：`GID` (用户初始组ID)

- 第5字段：用户说明

- 第6字段：家目录

  - 普通用户：/home/用户名/

  - 超级用户：/root/

- 第7字段：登录之后的shell



#### 初始组和附加组

- 初始组
  - 指用户一登录就立刻拥有这个用户组的相关权限，每个用户的初始组只能有一个。
  - 一般就是和这个用户的用户名相同的组名作为这个用户的初始组。
- 附加组
  - 指用户可以加入多个其他的用户组，并拥有这些组的权限，附加组可以有多个。

#### shell命令解释器

- shell就是Linux的命令解释器。
- 在`/etc/passwd`当中，除了标准shell是`/bin/bash`之外，还可以写如`/sbin/nologin`。



### 1.2 用户密码文件/影子文件

#### /etc/shadow 影子文件

```
root:$6$uA8u5FbPsufsaPAy$/KFBTJBKKM8BoPGL0w4P3xKrjl0JYUYj4LmRNdWHNae6o4ukLIKSSQy5wKaRoowJpW1zqsHHEJf7aoxrq2wBN0:18609:0:99999:7:::
bin:*:15628:0:99999:7:::
daemon:*:15628:0:99999:7:::
adm:*:15628:0:99999:7:::
lp:*:15628:0:99999:7:::
sync:*:15628:0:99999:7:::
shutdown:*:15628:0:99999:7:::
saslauth:!!:18609::::::
postfix:!!:18609::::::
sshd:!!:18609::::::
```

- 第1字段：用户名
- 第2字段：加密密码
  - 加密算法升级为`SHA512`散列加密算法
  - 如果密码位是`!!` 或`*`代表没有密码，不能登录
- 第3字段：密码最后一次修改日期使用1970年1月1日作为标准时间，每过一天时间戳加1

- 第4字段：两次密码的修改间隔时间（和第3字段相比）
- 第5字段：密码有效期（和第3字段相比）
- 第6字段：密码修改到期前的警告天数（和第5字段相比）

- 第7字段：密码过期后的宽限天数(和第5字段相比)
  - `0`：代表密码过期后立即失效
  - `-1`：则代表密码永远不会失效
- 第8字段：账号失效时间
  - 要用时间戳表示
- 第9字段：保留



#### 时间戳换算

- `date -d "1970-01-01 16066 days" `   #把时间戳换算为日期

  ```
  # date -d "1970-01-01 16066 days" 
  Fri Dec 27 00:00:00 CST 2013
  ```

- `echo $(($(date --date="2014/01/06" +%s)/86400+1)) `   #把日期换算为时间戳

  ```
  # echo $(($(date --date="2014/01/06" +%s)/86400+1))
  16076
  ```



### 1.3 组信息文件和组密码文件

#### /etc/group 组信息文件

```
root:x:0:
bin:x:1:bin,daemon
daemon:x:2:bin,daemon
sys:x:3:bin,adm
adm:x:4:adm,daemon
tty:x:5:
disk:x:6:
```

- 第一字段：组名
- 第二字段：组密码标志
- 第三字段：`GID` (组ID)
- 第四字段：组中附加用户

#### /etc/gshadow 组密码文件

```
root:::
bin:::bin,daemon
daemon:::bin,daemon
sys:::bin,adm
adm:::adm,daemon
tty:::
disk:::
```

- 第一字段：组名
- 第二字段：组密码
- 第三字段：组管理员用户名
- 第四字段：组中附加用户



## 2 用户管理相关文件

### 2.1 用户的家目录

- 普通用户：`/home/用户名/`，所有者和所属组都是此用户，权限是700
  - 普通用户提示符是 `$`
- 超级用户：`/root/`， 所有者和所属组都是root用户，权限是550
  - 超级用户提示符是 `#`

### 2.2 用户的邮箱

- `/var/spool/mail/用户名/`   #创建用户的时候自动创建，每一个用户都会有个默认邮箱 

### 2.3 用户模板目录

- `/etc/skel/`   #默认自动创建用户时自带的家目录文件



## 3 用户管理命令

### 3.1 用户添加命令

#### useradd 命令格式

`useradd` [选项] [用户名]

- `-u `  `UID`：手工指定用户的`UID`号
- `-d` 家目录：手工指定用户的家目录
- `-c` 用户说明：手工指定用户的说明
- `-g` 组名：手工指定用户的初始组
- `-G` 组名：指定用户的附加组
- `-s` `shell`：手工指定用户的登录shell，默认是/bin/bash



#### 添加默认用户

 `useradd sc`

- `grep sc /etc/passwd`

  ```
  # grep sc /etc/passwd
  sc:x:503:503::/home/sc:/bin/bash
  ```

- `grep sc /etc/shadow`

  ```
  # grep sc /etc/shadow
  sc:!!:18632:0:99999:7:::
  ```

- `grep sc /etc/group`

  ```
  # grep sc /etc/group
  sc:x:503:
  ```

- `grep sc /etc/gshadow`

  ```
  # grep sc /etc/gshadow
  sc:!::
  ```

- `ll -d /home/sc/`

  ```
  # ll -d /home/sc/
  drwx------. 2 sc sc 4096 Jan  5 19:36 /home/sc/
  ```

- `ll /var/spool/mail/sc`

  ```
  # ll /var/spool/mail/sc
  -rw-rw----. 1 sc mail 0 Jan  5 19:36 /var/spool/mail/sc
  ```

#### 指定选项添加用户

- `useradd -u 550 -G root,bin -d /home/lamp1 -c "test user" -s /bin/bash sc`



#### 用户默认值文件

`/etc/default/useradd`

```
# useradd defaults file
GROUP=100
HOME=/home
INACTIVE=-1
EXPIRE=
SHELL=/bin/bash
SKEL=/etc/skel
CREATE_MAIL_SPOOL=yes
```

- `GROUP=100`    #用户默认组
- `HOME=/home`    #用户家目录
- `INACTIVE=-1`     #密码过期宽限天数（shadow文件第7字段）
- `EXPIRE=`      #密码失效时间（8）
- `SHELL=/bin/bash`    #默认shell
- `SKEL=/etc/skel`    #模板目录
- `CREATE_MAIL_SPOOL=yes`    #是否建立邮箱

`/etc/login.defs`

```
# Password aging controls:
#
#	PASS_MAX_DAYS	Maximum number of days a password may be used.
#	PASS_MIN_DAYS	Minimum number of days allowed between password changes.
#	PASS_MIN_LEN	Minimum acceptable password length.
#	PASS_WARN_AGE	Number of days warning given before a password expires.
#
PASS_MAX_DAYS	99999
PASS_MIN_DAYS	0
PASS_MIN_LEN	5
PASS_WARN_AGE	7

#
# Min/max values for automatic uid selection in useradd
#
UID_MIN			  500
UID_MAX			60000

#
# Min/max values for automatic gid selection in groupadd
#
GID_MIN			  500
GID_MAX			60000

#
# If defined, this command is run when removing a user.
# It should remove any at/cron/print jobs etc. owned by
# the user to be removed (passed as the first argument).
#
#USERDEL_CMD	/usr/sbin/userdel_local

#
# If useradd should create home directories for users by default
# On RH systems, we do. This option is overridden with the -m flag on
# useradd command line.
#
CREATE_HOME	yes

# The permission mask is initialized to this value. If not specified, 
# the permission mask will be initialized to 022.
UMASK           077

# This enables userdel to remove user groups if no members exist.
#
USERGROUPS_ENAB yes

# Use SHA512 to encrypt password.
ENCRYPT_METHOD SHA512 
```

- `PASS MAX DAYS 99999`  #密码有效期 (5)
- `PASS MIN_ DAYS 0`    #密码修改间隔 (4)
- `PASS MIN LEN 5`    #密碍最小5位(PAM)
- `PASS WARN AGE 7`    #密码到期警告(6)
- `UID MIN 500`      #最小和最大`UID`范围
- `GID MAX 60000`
- `ENCRYPT METHOD  SHA512`  #加密模式



### 3.2 修改用户密码

#### passwd 命令格式

`passwd` [选项] [用户名]

- `-S`  #查询用户密码的密码状态，仅root用户可用
- `-l`  #暂时锁定用户，仅root用户可用
- `-u`  #解锁用户，仅root用户可用
- `--stdin`  #可以通过管道符输出的数据作为用户的密码

#### 查看密码状态

`passwd -S anny`

```
# passwd -S anny
anny PS 2021-01-05 0 99999 7 -1 (Password set, SHA512 crypt.)
```

- 用户名密码设定时间（2021-01-05）
- 密码修改间隔时间（0）
- 密码有效期/天（99999）
- 警告时间（7）
- 密码不失效（-1）



#### 锁定用户和解锁用户

- `passwd -l anny`

  - 锁定用户，其实是修改了用户的密码，在密码前面加上字符`!!`

    ```
    # cat /etc/passwd
    anny:!!$6$lcnPNICg$xigz2hxdsTsW9uWgMsV2vHLaiRrVywnsXrOLvCD0OcA1BzRxL4fS7Tzfzdn309fCUV7NETGqMt1QPVKl6Ukir/:18632:0:99999:7:::
    ```

- `passwd -u anny`

  - 解锁用户，将密码改回去

#### 使用输出的数据作为用户的密码

- `echo "123456" | passwd --stdin anny`



### 3.3 修改用户信息

#### usermod 修改用户信息

`usermod` [选项] [用户名]

- `-u` `UID`：修改用户的`UID`号
- `-c` 用户说明：修改用户的说明信息
- `-G` 组名：修改用户的附加组
- `-L`：临时锁定用户(Lock)
- `-U`：解锁用户锁定(Unlock)

案例：

```
usermod -c "test user" anny   #修改用户的说明
usermod -G root anny          #把amp用户加入root组
usermod -L anny               #锁定用户
usermod -U anny               #解锁用户
```



#### chage 修改用户密码状态

- `-l`：列出用户的详细密码状态
- `-d` 日期：修改密码最后一次更改日期（3字段）
- `-m` 天数：两次密码修改间隔（4字段）
- `-M` 天数：密码有效期 （5字段）
- `-W` 天数：密码过期前警告天数 （6字段）
- `-I  ` 天数：密码过后宽限天数（7字段）
- `-E` 日期：账号失效时间（8字段）

案例：`chage -d 0 anny`

- 这个命令其实是把密码修改日期归 0 了（3字段）
- 这样用户一登陆就要修改密码

```
You are required to change your password immediately (root enforced)
Last login: Tue Jan  5 20:42:08 2021 from 192.168.1.109
WARNING: Your password has expired.
You must change your password now and login again!
Changing password for user anny.
Changing password for anny.
(current) UNIX password: 
```



### 3.4 删除用户

#### userdel 删除用户

`userdel` [-r] [用户名]

- `-r`   #删除用户的同时删除用户家目录

#### 手工删除用户

```
# vi /etc/passwd
# vi /etc/shadow
# vi /etc/group
# vi /etc/gshadow
# rm -rf /var/spool/mail/sc
# rm -rf /home/sc/
```

#### 查看用户ID

`id` [用户名]

- `id anny`

  ```
  # id anny
  uid=500(anny) gid=500(anny) groups=500(anny)
  ```



#### su 用户切换命令

`su` [选项] [用户名]

- `-`：使用`-`代表连带用户的环境变量一起切换

  ```
  # su - sc
  [sc@localhost ~]$ 
  ```

- `-c` 命令：不切换用户身份的情况下执行一次命令

  - `$ su - root -c "useradd user0"`   #不切换成root，但是执行`useradd`命令添加用户

  - 但是执行命令的时候需要输入root用户密码

  - 查看用户环境变量

    ```
    # whoami
    root
    # env
    HOSTNAME=localhost.localdomain
    SHELL=/bin/bash
    TERM=xterm
    HISTSIZE=1000
    ```



## 4 用户组管理命令

### 4.1 添加用户组

`groupadd` [选项] [组名]

- `-g` `GID`：指定组ID



### 4.2 修改用户组

`groupmod` [选项] [组名]

- `-g` `GID`：修改组ID
- `-n` 新组名：修改组名
  -  `groupmod -n testgrp group0 `   #把组名`group0`修改为`testgrp`



### 4.3 删除用户组

`groupdel` 组名



### 4.4 把用户添加入组或从组中删除

`gpasswd` [选项] [用户名]

- `-a` 用户名：把用户加入组
- `-d` 用户名：把用户从组中删除

