# Linux 备份与恢复

## 1.备份概述

### 1.1 Linux需要备份的数据目录

#### 系统目录

- /root/       
- /home/    
- /var/spool/mail/    
- /etc/         
- 其他目录

#### 安装服务的数据

- apache需要备份的数据

  - 配置文件
  - 网页主目录
  - 日志文件

- mysql需要备份的数据

  - 源码包 安装的mysql:  /usr/oca/mysq/data/

  - RPM包 安装的mysql:  /var/lib/mysqI/

### 1.2 备份策略

#### 完全备份

完全备份就是指把所有需要备份的数据全部备份，当然完全备份可以备份整块硬盘，整个分区或某个具体的目录。

特点：恢复时比较方便，只需要恢复一次。

#### 增量备份

第一次完全备份，之后每次备份只备份新增的数据。

特点：恢复时比较麻烦，需要挨个恢复。

#### 差异备份

第一次完全备份，之后每次都备份完全备份不存在的数据。

特点：相比完全备份策略，只少一个完全备份的数据量。

## 2. dump 和 restore 命令

### 2.1 dump 命令

dump [选项]  备份之后的文件名原文件或目录

#### 选项

- `-level`        //就是我们说的 0-9 十个备份级别
- `-f` 文件名    //指定备份之后的文件名.
- `-u`              //备份成功之后，把备份时间记录在/etc/dumpdates文件
- `-v`              //显示备份过程中更多的输出信息
- `-j`              //调用bzlib库压缩备份文件，其实就是把备份文件压缩为.bz2格式
- `-W`              //显示允许被dump的分区的备份等级及备份时间

| 备份级别 |   作用   |
| :------: | :------: |
|    0     | 完全备份 |
|    1     | 增量备份 |

#### 准备条件

```
# rpm -qa | grep dump  //抓包命令，确定 yum 源可以用
# yum -y install dump  //安装dump
```

`df -h`  //查看分区大小

`ll -h`  //查看文件大小

#### 案例：备份分区

- `dump -0uj -f /root/boot.bak.bz2 /boot/`    #先执行一次完全备份，并压缩和更新备份时间。
- `cat /etc/dumpdates`                       #查看备份时间文件。
- `cp install.log /boot/`                  #复制日志文件到 /boot 分区。
- `dump -1uj -f /root/boot.bak1.bz2 /boot/`  #增量备份 /boot 分区，并压缩。
- `dump -W`               #查询分区的备份时间及备份级别的。

#### 备份文件或目录

`dump -0j -f /root/etc.dump.bz2 /etc/`   #完全备份 /etc/ 目录，只能使用0级别进行完全备份，而不再支持增量备份。

### 2.2 restore 命令

restore [模式选项] [选项]

模式选项: restore命 令常用的模式有以下四种，这四个模式不能混用。

- `-C`      //比较备份数据和实际数据的变化
- `-i`      //进入交互模式，手工选择需要恢复的文件。
- `-t`      //查看模式，用于查看备份文件中拥有哪些数据。
- `-r`       //还原模式，用于数据还原。

选项:

- `-f`     //指定备份文件的文件名

#### 比较备份数据和实际数据的变化

- 把 boot 目录中内核镜像文件改个名字

  - ```
    # mv /boot/vmlinuz-2.6.32-279.e16.i686 /boot/vmlinuz-2.6.32-279.el6.i686.bak
    ```

- restore 发现内核镜像文件丢失

  - ```
    # restore -C -f /root/boot.bak.bz2
    ```

#### 还原模式

- 还原 boot.bak.bz2 分区备份，先还原完全备份的数据

  - ```
    # mkdir boot.test
    # cd boot.test/
    # restore -r -f /root/boot.bak.bz2  #解压缩
    ```

- 恢复增量备份数据

  - ```
    # restore -r -f /root/boot.bak1.bz2
    ```

- 还原 /etc/ 目录的备份 etc.dump.bz2

  - ```
    restore -r -f etc.dump.bz2  #还原 etc.dump.bz2 备份
    ```

