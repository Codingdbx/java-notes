# Linux 权限管理

## 1 回顾分区和文件系统

### 1.1 分区类型

- 主分区
  - 总共最多只能分四个
- 扩展分区
  - 只能有一个，也算作主分区的一种。也就是说主分区加扩展分区最多有四个。
  - 但扩展分区不能存储数据和格式化，必须再划分成逻辑分区才能使用。
- 逻辑分区
  - 逻辑分区是在扩展分区中划分的
  - 如果是`IDE`硬盘，Linux最多 支持59个逻辑分区
  - 如果是`SCSI`硬盘，Linux最多支持11个逻辑分区

#### 分区表示方法

![1609591172973](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1609591172973.png)

#### 分区的设备文件名

| 分区的设备文件名 |   说明    |
| :--------------: | :-------: |
|   `/dev/sda1`    |  主分区1  |
|   `/dev/sda2`    |  主分区2  |
|   `/dev/sda3`    |  主分区3  |
|   `/dev/sda4`    | 扩展分区  |
|   `/dev/sda5`    | 逻辑分区1 |
|   `/dev/sda6`    | 逻辑分区2 |
|   `/dev/sda7`    | 逻辑分区3 |

### 1.2 文件系统

单位换算：

`1EB = 1024PB; 1PB = 1024TB` 

`1TB = 1024GB; 1GB = 1024MB; 1MB = 1024KB; 1KB = 1024Byte; 1Byte = 8Bit`

- `ext2`
  - ext2是ext文件系统的升级版本，Red Hat Linux7.2 版本以前的系统默认都是 ext2 文件系统。
  - 1993年发布，最大支持 16TB 的分区和最大 2TB 的文件。
- `ext3`
  - ext3文件系统是ext2文件系统的升级版本，最大的区别就是带日志功能，以在系统突然停止时提高文件系统的可靠性。
  - 支持最大16TB的分区和最大2TB的文件。
  - CentOS 5的默认文件系统是ext3。
- `ext4`
  - ext4是ext3文件系统的升级版。ext4在性能伸缩性和可靠性方面进行了大量改进。
  - 向下兼容ext3。
  - 最大1EB文件系统和16TB文件。
  - 无限数量子目录、Extents连续数据块概念、多块分配延迟分配、持久预分配、快速FSCK、日志校验、无日志模式、在线碎片整理、inode增强、默认启用barrier等。
  - CentOS 6.3的默认文件系统是ext4。

- `xfs`
  - xfs是一个64位文件系统，最大支持8EB减1字节的单个文件系统 。
  - xfs在很多方面确实做的比ext4好，ext4受限制于磁盘结构和兼容问题，可扩展性和scalability确实不如xfs，另外xfs经过很多年发展，各种锁的细化做的也比较好。
  - CentOS 7.0开始默认文件系统是xfs。



## 2 文件系统常用命令

### 2.1 常用命令

#### df 文件系统查看命令

`df` [选项] [挂载点]

- `-a` 显示所有的文件系统信息，包括特殊文件系统，如/proc、/sysfs

- `-h` 使用习惯单位显示容量，如KB，MB或GB等

  ```
  # df -h
  Filesystem            Size  Used Avail Use% Mounted on
  /dev/mapper/VolGroup-lv_root
                        5.5G  692M  4.5G  14% /
  tmpfs                 499M     0  499M   0% /dev/shm
  /dev/sda1             485M   32M  428M   7% /boot
  ```

- `-T` 显示文件系统类型

  ```
  # df -T
  Filesystem    Type   1K-blocks      Used Available Use% Mounted on
  /dev/mapper/VolGroup-lv_root
                ext4     5716804    707812   4718588  14% /
  tmpfs        tmpfs      510268         0    510268   0% /dev/shm
  /dev/sda1     ext4      495844     32395    437849   7% /boot
  ```

- `-m` 以MB为单位显示容量

- `-k` 以KB为单位显示容量。 默认就是以KB为单位

#### du 统计目录或文件大小

`du` [选项] [目录或文件名]

- `-a` 显示每个子文件的磁盘占用量。默认只统计子目录的磁盘占用量

- `-h` 使用习惯单位显示磁盘占用量，如KB，MB或GB等

  ```
  # du -h /home
  4.0K	/home/anny/hello
  20K	/home/anny
  16K	/home/anny2
  56K	/home
  ```

- `-s` 统计总占用量，而不列出子目录和子文件的占用量

  ```
  # du -s /home
  56	/home
  # du -sh /home
  56K	/home
  ```

`df`、`du`命令的区别

- `df` 命令是从文件系统考虑的，不光要考虑文件占用的空间，还要统计被命令或程序占用的空间（最常见的就是文件已经删除，但是程序并没有释放空间）
- `du` 命令是面向文件的，只会计算文件或目录占用的空间



#### fsck 文件系统修复命令

`fsck` [选项] [分区设备文件名]

- `-a` 不用显示用户提示，自动修复文件系统
- `-y` 自动修复。和-a作用一致，不过有些文件系统只支持-y

#### dumpe2fs 显示磁盘状态命令

`dumpe2fs` [分区设备文件名]

```
# dumpe2fs /dev/sda1
dumpe2fs 1.41.12 (17-May-2010)
Filesystem volume name:   <none>
Last mounted on:          /boot
Filesystem UUID:          f992f59e-3dc5-46fa-a01d-96239e46e4cf
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
```



### 2.2 挂载命令

#### 查询与自动挂载

`mount`  [选项]

- `-l`

  - 查询系统中已经挂载的设备，`-l`会显示卷标名称。

    ```
    # mount -l
    /dev/mapper/VolGroup-lv_root on / type ext4 (rw)
    proc on /proc type proc (rw)
    sysfs on /sys type sysfs (rw)
    devpts on /dev/pts type devpts (rw,gid=5,mode=620)
    tmpfs on /dev/shm type tmpfs (rw,rootcontext="system_u:object_r:tmpfs_t:s0")
    /dev/sda1 on /boot type ext4 (rw)
    none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
    ```

- `-a`

  - 依据配置文件`/etc/fstab`的内容，自动挂载。

#### 挂载命令格式

`mount` [-t 文件系统] [-L 卷标名] [-o 特殊选项] [设备文件名] [挂载点]

- `-t` 文件系统

  - 加入文件系统类型来指定挂载的类型，可以ext3、ext4、iso9660等文件系统

- `-L` 卷标名

  - 挂载指定卷标的分区，而不是安装设备文件名挂载

- `-o` 特殊选项

  - 可以指定挂载的额外选项

    |      参数       |                             说明                             |
    | :-------------: | :----------------------------------------------------------: |
    | `atime/noatime` | 更新访问时间/不更新访问时间。访问分区文件时，是否更新文件的访问时间，默认为更新 |
    |  `async/sync`   |                    异步/同步，默认为异步                     |
    |  `auto/noauto`  | 自动/手动，mount -a命令执行时，是否会自动安装/etc/fstab文件内容挂载，默认为自动 |
    |    defaults     | 定义默认值，相当于rw，suid，dev，exec，auto，nouser，async 这七个选项 |
    |  `exec/noexec`  | 执行/不执行，设定是否允许在文件系统中执行可执行文件，默认是exec允许 |
    |    `remount`    |     重新挂载已经挂载的文件系统，一般用于指定修改特殊权限     |
    |     `rw/ro`     |    读写/只读，文件系统挂载时，是否具有读写权限，默认是rw     |
    |  `suid/nosuid`  | 具有不具有SUID权限，设定文件系统是否具有SUID和SGID的权限，默认是具有 |
    |  `user/nouser`  | 允许/不允许普通用户挂载，设定文件系统是否允许普通用户挂载，默认是不允许，只有root可以挂载分区 |
    |   `usrquota`    |         写入代表文件系统支持用户磁盘配额，默认不支持         |
    |   `grpquota`    |          写入代表文件系统支持组磁盘配额，默认不支持          |

  - 重新挂载boot分区，并使用`noexec`权限

    `mount -o remount,noexec /home`

    ```
    # mount -o remount,noexec /home
    # cd /home
    # vi hello.sh
    # chmod 755 hello.sh
    # ./hello.sh
    # mount -o remount,exec /home  #记得改回来啊，要不会影响系统启动的
    ```



### 2.3 挂载光盘与U盘

#### 挂载光盘

- 建立挂载点
  - `mkdir /mnt/cdrom/`
- 挂载光盘
  - `mount -t iso9660 /dev/cdrom /mnt/cdrom/`
  - `mount /dev/sr0 /mnt/cdrom/`

注意：

- `/dev/cdrom` 与 `/dev/sr0`   #系统默认的光盘设备文件名

- `iso9660`     #文件系统默认名，也是不会变的

#### 卸载命令

 `umount` [设备文件名或挂载点]

- `umount /mnt/cdrom`    #使用完光盘之后，进行卸载，相当于弹出U盘。

#### 挂载U盘

- `fdisk -l` #查看U盘设备文件名，因为U盘的设备文件名不是固定的

  ```
  # fdisk -l
  Disk /dev/sda: 8589 MB, 8589934592 bytes
  255 heads, 63 sectors/track, 1044 cylinders
  Units = cylinders of 16065 * 512 = 8225280 bytes
  Sector size (logical/physical): 512 bytes / 512 bytes
  I/O size (minimum/optimal): 512 bytes / 512 bytes
  Disk identifier: 0x000b0fa7
  Device Boot      Start         End      Blocks   Id  System
  /dev/sda1   *           1          64      512000   83  Linux
  Partition 1 does not end on cylinder boundary.
  /dev/sda2              64        1045     7875584   8e  Linux LVM
  Disk /dev/mapper/VolGroup-lv_root: 5947 MB, 5947523072 bytes
  255 heads, 63 sectors/track, 723 cylinders
  Units = cylinders of 16065 * 512 = 8225280 bytes
  Sector size (logical/physical): 512 bytes / 512 bytes
  I/O size (minimum/optimal): 512 bytes / 512 bytes
  Disk identifier: 0x00000000
  Disk /dev/mapper/VolGroup-lv_swap: 2113 MB, 2113929216 bytes
  255 heads, 63 sectors/track, 257 cylinders
  Units = cylinders of 16065 * 512 = 8225280 bytes
  Sector size (logical/physical): 512 bytes / 512 bytes
  I/O size (minimum/optimal): 512 bytes / 512 bytes
  Disk identifier: 0x00000000
  ```
  
- `mount -t vfat /dev/sdb1 /mnt/usb/`

  -  Linux默认是不支持NTFS文件系统的



### 2.4 支持NTFS文件系统

#### 下载NTFS-3G插件

http://www.tuxera.com/community/ntfs-3g-download/

#### 安装NTFS-3G

```
#解压
# tar -zxvf ntfs-3g_ ntfsprogs-2013.1.13.tgz

#进入解压目录
# cd ntfis-3g_ ntfsprogs-2013.1.13

#编译器准备。没有指定安装目录，安装到默认位置中
# ./configure

#编译
# make

#编译安装
# make install
```

#### 使用

`mount -t ntfs-3g`  [分区设备文件名] [挂载点]

## 3 fdisk分区

### 3.1 fdisk命令分区过程

#### 添加新硬盘

使用`vmware`增加新硬盘设备

#### 查看新硬盘

`fdisk -l`

#### 使用fdisk命令分区

`fdisk /dev/sdb`

`fdisk `交互指令说明

| 命令 |                            说明                             |
| :--: | :---------------------------------------------------------: |
|  a   |                       设置可引导标记                        |
|  b   |                      编辑`bsd`磁盘标签                      |
|  c   |                   设置DOS操作系统兼容标记                   |
|  d   |                        删除一个分区                         |
|  l   | 显示已知的文件系统类型。82为Linux swap分区，83为Linux分区。 |
|  m   |                        显示帮助菜单                         |
|  n   |                          新建分区                           |
|  o   |                      建立空白DOS分区表                      |
|  p   |                        显示分区列表                         |
|  q   |                         不保存退出                          |
|  s   |                     新建空白SUN磁盘标签                     |
|  t   |                    改变一个分区的系统ID                     |
|  u   |                      改变显示记录单位                       |
|  v   |                         验证分区表                          |
|  w   |                          保存退出                           |
|  x   |                      附加功能(仅专家)                       |

#### 重新读取分区表信息

`partprobe`   #在手动分区之后，需要重新读取分区表信息生效。

#### 格式化分区

`mkfs -t ext4 /dev/sdb1`

#### 建立挂载点并挂载

```
# mkdir /disk1
# mount /dev/sdb1 /disk1/
```



### 3.2 分区自动挂载与fstab文件修复

#### /etc/fstab 文件

- 第一字段：分区设备文件名或`UUID`(硬盘通用唯一识别码)
- 第二字段：挂载点
- 第三字段：文件系统名称
- 第四字段：挂载参数
- 第五字段：指定分区是否被`dump`备份，0代表不备份，1代表每天备份，2代表不定期备份
- 第六字段：指定分区是否被`fsck`检测，0代表不检测，其他数字代表检测的优先级，那么当然1的优先级比2高



#### 分区自动挂载 

- `vi /etc/fstab`

  - 配置`/etc/fstab`文件

    ```
    # vi /etc/fstab
    /dev/sdb1        /disk1          ext4        defaults        1 2
    ```

- `mount -a`    
  - 依据配置文件`/etc/fstab`的内容，自动挂载。
  - 如果有配置错误此时可以检测到，避免重启后系统崩溃。



#### /etc/fstab 文件修复

`mount -o remount,rw /`    #其实就是重新挂载





## 4 分配swap分区

#### free 命令

`free`   #查看内存与swap分区使用状况

- cached (缓存) 
  - 是指把读取出来的数据保存在内存当中，当再次读取时，不用读取硬盘而直接从内存当中读取，加速了数据的读取过程。
- buffer (缓冲) 
  - 是指在写入数据时，先把分散的写入操作保存到内存当中，当达到一-定程度再集中写入硬盘，减少了磁盘碎片和硬盘的反复寻道，加速了数据的写入过程。

#### 新建swap分区

`fdisk /dev/sdb `   #别忘记把分区ID改为82

#### 格式化

`mkswap /dev/sdb6`

#### 加入swap分区

- `swapon /dev/sdb6`
  - 加入swap分区
- `swapoff /dev/sdb6` 
  - 取消swap分区

#### swap分区开机自动挂载

```
# vi /etc/fstab
/dev/sdb6      swap     swap       defaults     0 0
```
