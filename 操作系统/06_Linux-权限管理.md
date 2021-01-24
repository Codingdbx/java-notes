# Linux 权限管理

## 1 ACL权限

### 1.1 ACL权限简介与开启

#### ACL权限简介

ACL权限不是针对某个文件或某个目录的,它是针对分区而言的。

#### 查看分区ACL权限是否开启

`dumpe2fs -h /dev/sda3`   #`dumpe2fs`命令是查询指定分区详细文件系统信息的命令。

- `-h`  #仅显示超级块中信息，而不显示磁盘块组的详细信息。

#### 临时开启分区ACL权限

`mount -o remount,acl / `   #重新挂载根分区，并挂载加入`acl`权限。

#### 永久开启分区ACL权限

系统默认是支持`acl`权限的，如果默认不支持，我们可以在对应的分区后面加上`acl`选项 。

- `vi /etc/fstab`  #加入`acl`

  ```
  # vi /etc/fstab
  
  # /etc/fstab
  # Created by anaconda on Sun Dec 13 20:02:19 2020
  #
  # Accessible filesystems, by reference, are maintained under '/dev/disk'
  # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
  #
  /dev/mapper/VolGroup-lv_root /                       ext4    defaults        1 1
  UUID=f992f59e-3dc5-46fa-a01d-96239e46e4cf /boot      ext4    defaults        1 2
  /dev/mapper/VolGroup-lv_swap swap                    swap    defaults        0 0
  tmpfs                   /dev/shm                tmpfs   defaults        0 0
  devpts                  /dev/pts                devpts  gid=5,mode=620  0 0
  sysfs                   /sys                    sysfs   defaults        0 0
  proc                    /proc                   proc    defaults        0 0
  
  UUID=c2ca6f57-b15c-43ea-bca0-f239083d8bd2 / ext4 defaults,acl  1 2
  ```

- `mount -o remount / ` #重新挂载文件系统或重启动系统，使修改生效。



### 1.2 查看与设定ACL权限

#### 查看ACL命令

`getfacl` [文件名]   #查看`acl`权限

- `getfacl /home`

  ```
  getfacl: Removing leading '/' from absolute path names
  # file: home
  # owner: root
  # group: root
  user::rwx
  group::r-x
  other::r-x
  ```



#### 设定ACL权限的命令

`setfacl` [选项] [文件名]

- `-m`  设定ACL权限
- `-x`  删除指定的ACL权限
- `-b`  删除所有的ACL权限
- `-d`  设定默认ACL权限
- `-k`  删除默认ACL权限
- `-R`  递归设定ACL权限

案例：给用户 `st` 赋予 `r-x` 权限，使用 `u:用户名:权限` 格式

```
# useradd sa
# useradd sc
# useradd st
# groupadd tgroup
# mkdir /project
# chown root:tgroup /project/
# chmod 770 /project/
```

```
# ll
drwxrwx---. 2 root tgroup 4096 Jan  7 11:37 project
```

```
# setfacl -m u:st:rx /project/
```

```
# ll
drwxrwx---+ 2 root tgroup 4096 Jan  7 11:37 project
```

```
# getfacl /project/
user::rwx
user:st:r-x
group::rwx
mask::rwx
other::---
```

#### 给用户组设定ACL权限

- `groupadd tgroup2`

- `setfacl -m g:tgroup2:rwx project/`  #为组`tgroup2`分配ACL权限，使用 `g:组名:权限 ` 格式。

  ```
  # setfacl -m g:tgroup2:rwx project/
  
  # getfacl project/
  user::rwx
  user:st:r-x
  group::rwx
  group:tgroup2:rwx
  mask::rwx
  other::---
  ```



### 1.3 最大有效权限与删除ACL权限

#### 最大有效权限mask

- `mask`是用来指定最大有效权限的。如果我给用户赋予了ACL权限，是需要和`mask`的权限 `相与` 才能得到用户的真正权限。

  ```
  # getfacl project/
  user::rwx
  user:st:r-x
  group::rwx
  group:tgroup2:rwx
  mask::rwx
  other::---
  ```



#### 修改最大有效权限

`setfacl -m m:rx` [文件名]    #设定`mask`权限为`r-x`。使用 `m:权限` 格式。

```
# setfacl -m m:rx project/

# getfacl project/
user::rwx
user:st:r-x
group::rwx			    #effective:r-x
group:tgroup2:rwx		#effective:r-x
mask::r-x
other::---
```

注意： 最大有效权限只对所属组有效 。

#### 删除ACL权限

- `setfacl -x u:[用户名] [文件名]`    #删除文件指定用户的ACL权限
- `setfacl -x g:[组名] [文件名] `     #删除文件指定用户组的ACL权限
- `setfacl -b [文件名] `     #会删除文件的所有的ACL权限



### 1.4 递归ACL权限和默认ACL权限

#### 递归ACL权限

- 递归是父目录在设定ACL权限时，所有的子文件和子目录也会拥有相同的ACL权限。

- `setfacl -m u:[用户名]:[权限] -R [文件名]`

  ```
  # setfacl -m u:st:rx -R /root/project/
  [root@localhost project]# ll
  drwxr-xr-x+ 2 root root 4096 Jan  7 14:00 aa
  drwxr-xr-x+ 2 root root 4096 Jan  7 14:00 bb
  ```



## 2 文件特殊权限

### 2.1 SetUID

#### SetUID的功能

- 只有可以执行的二进制程序才能设定`SUID`权限
- 命令执行者要对该程序拥有x （执行）权限
- 命令执行者在执行该程序时获得该程序文件属主的身份（在执行程序的过程中灵魂附体为文件的属主）
- SetUID权限只在该程序执行过程中有效，也就是说身份改变只在程序执行过程中有效

案例：

![1610000842004](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1610000842004.png)

- `passwd`命令拥有SetUID权限，所以普通可以修改自己的密码

  ```
  # ll /usr/bin/passwd 
  -rwsr-xr-x. 1 root root 30768 Feb 22  2012 /usr/bin/passwd
  ```

- `cat`命令没有SetUID权限，所以普通用户不能查`/etc/shadow`文件内容

  ```
  # ll /bin/cat
  -rwxr-xr-x. 1 root root 45224 Jun 22  2012 /bin/cat
  ```

#### 设定SetUID的方法

- `4` 代表`SUID`

  - `chmod 4755` [文件名]

    ```
    # chmod 4755 cc
    # ll
    -rwsr-xr-x. 1 root root    0 Jan  7 14:31 cc
    ```

  - `chmod u+s` [文件名]

    ```
    # chmod u+s cc
    # ll
    ---S------. 1 root root    0 Jan  7 14:31 cc
    ```

    大`S`表示报错了，没有`x`执行权限，赋予`s`权限就没有用了。

#### 取消SetUID的方法

- `chmod 755` [文件名]
- `chmod u-s` [文件名]

#### 危险的SetUID

- 关键目录应严格控制写权限。比如 `/` 、 `/usr`等。
  - 比如：给vim赋予了SetUID权限，则所有用户都可以修改任意文件。
- 用户的密码设置要严格遵守密码三原则。
- 对系统中默认应该具有SetUID权限的文件作一列表，定时检查有没有这之外的文件被设置了SetUID权限。

注意：在Linux中文件显示色为红色代表：

1. 错误文件

2. 权限过高

### 2.2 SetGID

#### SetGID 针对文件的作用

- 只有可执行的二进制程序才能设置`SGID`权限
- 命令执行者要对该程序拥有x (执行)权限
- 命令执行在执行程序的时候，组身份升级为该程序文件的属组
- SetGID权限同样只在该程序执行过程中有效，也就是说组身份改变只在程序执行过程中有效

案例：`locate` 命令

```
# ll /usr/bin/locate
-rwx--s--x. 1 root slocate 40520 Apr 11  2018 /usr/bin/locate

# ll /var/lib/mlocate/mlocate.db
-rw-r-----. 1 root slocate 662922 Jan  7 12:34 /var/lib/mlocate/mlocate.db
```

- `/usr/bin/locate` 是可执行二进制程序，可以赋予`SGID`
- 执行用户 `st` 对`/usr/bin/locate`命令拥有执行权限
- 执行`/usr/bin/locate`命令时，组身份升级为`slocate`组，而`slocate` 对`/var/ib/mlocate/mlocate.db` 数据库拥有`r`权限，所以普通用户可以使用`locate`命令查询`mlocate.db`数据库
- 命令结束，`st` 用户的组身份返回为`st`组

#### SetGID 针对目录的作用

- 普通用户必须对此目录拥有`r`和`x`权限，才能进入此目录
- 普通用户在此目录中的有效组会变成此目录的属组
- 若普通用户对此目录拥有`w`权限时，新建的文件的默认属组是这个目录的属组

#### 设定 SetGID

- `2` 代表`SGID`
  - `chmod 2755` [文件名]
  - `chmod g+s` [文件名]

案例：

```
# cd /tmp/
# mkdir dtest
# chmod g+s dtest
# ll -d dtest/
drwxr-sr-x. 2 root root 4096 Jan  7 14:54 dtest/

# chmod 777 dtest/
# su - st
$ cd /tmp/dtest/
$ touch abc
$ ll
-rw-rw-r--. 1 st root 0 Jan  7 14:56 abc
```

#### 取消 SetGID

- `chmod 755` [文件名]
- `chmod g-s` [文件名]



### 2.3 Sticky BIT

#### SBIT 粘着位作用

- 粘着位目前只对目录有效。
- 普通用户对该目录拥有`w`和`x`权限，即普通用户可以在此目录拥有写入权限。
- 如果没有粘着位，因为普通用户拥有`w`权限, 所以可以删除此目录下所有文件，包括其他用户建立的文件。
- 一但赋予了粘着位，除了`root`可以删除所有文件，普通用户就算拥有`w`权限，也只能删除自己建立的文件，但是不能删除其他用户建立的文件。

案例：粘着位用`t`表示。

```
# ll -d /tmp/
drwxrwxrwt. 5 root root 4096 Jan  7 14:54 /tmp/
```

#### 设置粘着位

`1` 表示粘着位。

- `chmod 1755` [目录名]
- `chmod o+t` [目录名]

#### 取消粘着位

- `chmod 777` [目录名]
- `chmod o-t` [目录名]



## 3 文件系统属性chattr权限

### 3.1 chattr 命令格式

`chattr [+-=]` [选项] [文件或目录名]

- `+`：增加权限
- `-`：删除权限
- `=`：等于某权限

选项：

- `i`
  - 如果对文件设置`i`属性，那么不允许对文件进行删除、改名，也不能添加和修改数据
  - 如果对目录设置`i`属性，那么只能修改目录下文件的数据，但不允许建立和删除文件
- `a`
  - 如果对文件设置`a`属性，那么只能在文件中增加数据，但是不能删除也不能修改数据
    -   `echo 555 >> abc` 只能通过追加的方式 
  - 如果对目录设置`a`属性，那么只允许在目录中建立和修改文件，但是不允许删除



### 3.2 查看文件系统属性

`lsattr` [选项] [文件名]

- `-a` 显示所有文件和目录
- `-d` 若目标是目录，仅列出目录本身的属性，而不是子文件的

案例1：对文件的作用

```
# touch abc
# chattr +i abc
# lsattr -a abc
----i--------e- abc
```

案例2：对目录的作用

```
# mkdir test
# touch test/bcd
# chattr +i test/
# lsattr -a test/
----i--------e- test/.
-------------e- test/bcd
-------------e- test/..
```



## 4 系统命令sudo权限

### 4.1 sudo权限

- `root` 把本来只能超级用户执行的命令赋予普通用户执行
- `sudo` 的操作对象是系统命令

### 4.2 sudo使用

- `visudo `   #实际修改的是 `/etc/sudoers` 文件

```
root        ALL=(ALL)                   ALL
#用户名    被管理主机的地址=(可使用的身份)    授权命令(绝对路径)

#%wheel     ALL=(ALL)                   ALL
#%组名     被管理主机的地址=(可使用的身份)    授权命令(绝对路径)
```

### 4.3 授权sc用户可以重启服务器

```
# visudo
sc  ALL= /sbin/shutdown -r now
```

### 4.4 普通用户执行sudo赋予的命令

```
#su - sc
$ sudo -l  #查看可用的sudo命令
$ sudo /sbin/shutdown -r now #普通用户执行sudo赋予的命令
```

