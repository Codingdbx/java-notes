# Linux 启动管理



## 1. `CentOS 6.x` 启动流程

### 1.1 系统运行级别

#### 运行级别

Linux系统中默认定义了 7 种运行级别

| 运行级别 |                             含义                             |
| :------: | :----------------------------------------------------------: |
|    0     |                             关机                             |
|    1     | 单用户模式，可以想象为windows的安全模式，主要用<br/>于系统修复 |
|    2     |    不完全的命令行模式，不含NFS（Network File System）服务    |
|    3     |              完全的命令行模式，就是标准字符界面              |
|    4     |                           系统保留                           |
|    5     |                           图形模式                           |
|    6     |                            重启动                            |

#### 运行级别命令

`runlevel`  //查看运行级别命令

```shell
# runlevel
N 3
```

`init` //改变运行级别命令

```shell
# init 6
Connection closed by foreign host.
Disconnected from remote host(linux6.4-192.168.108.224) at 15:25:24.
```



#### 系统默认运行级别

`vim /etc/inittab`  //配置系统开机后直接进入哪个运行级别

```shell
# vim /etc/inittab
id:3:initdefault:
```

### 1.2 系统启动过程

启动过程



## 2 启动引导程序grub

### 2.1 grup.conf 配置文件

#### grup 中分区表示

|      硬盘      |      分区      | Linux中设备文件名 | Grub中设备文件名 |
| :------------: | :------------: | :---------------: | :--------------: |
|                |  第一个主分区  |     /dev/sda1     |     hd(0, 0)     |
| 第一块SCSI硬盘 |  第二个主分区  |     /dev/sda2     |     hd(0, 1)     |
|                |    扩展分区    |     /dev/sda3     |     hd(0, 2)     |
|                | 第一个逻辑分区 |    / dev/sda5     |     hd(0, 4)     |
|                |                |                   |                  |
|                |  第一个主分区  |     /dev/sdb1     |     hd(1, 0)     |
| 第二块SCSI硬盘 |  第二个主分区  |     /dev/sdb2     |     hd(1,1)      |
|                |    扩展分区    |     /dev/sdb3     |     hd(1, 2)     |
|                | 第一个逻辑分区 |     /dev/sdb5     |     hd(1, 4)     |

#### grub.conf 配置文件

多系统的时候，先装windows系统，后装Linux系统。因为windows系统的启动程序不会识别 grub.conf 文件。

如果不小心装错了顺序，需要重新按照grub程序。

`/boot/grub/grub.conf`

```shell
# vi /boot/grub/grub.conf
default=0
timeout=5
splashimage=(hd0,0)/grub/splash.xpm.gz
hiddenmenu
title CentOS (2.6.32-358.el6.x86_64)
	root (hd0,0)
	kernel /vmlinuz-2.6.32-358.el6.x86_64 ro root=/dev/mapper/VolGroup-lv_root rd_NO_LUKS LANG=en_US.UTF-8 rd_NO_MD rd_LVM_LV=VolGroup/lv_swap SYSFONT=latarcyrheb-sun16 crashkernel=auto rd_LVM_LV=VolGroup/lv_root  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM rhgb quiet
	initrd /initramfs-2.6.32-358.el6.x86_64.img
```

参数说明：

- default = 0
  - 默认启动第一个系统
- timeout -= 5
  - 等待时间，默认是5秒
- splashimage=(hd0,0)/ grub/splash.xpm.gz
  - 这里是指定grub启动时的背景图像文件的保存位置
- hiddenmenu
  - 隐藏菜单
- title CentOS (2.6.32-279.el6.i686)
  - title就是标题的意思
- root (hd0,0)
  - 是指启动程序的保存分区
- kernel  /vmlinuz-2.6.32-279.el6.i686.....
  - 定义内核加载时的选项
- initrd /initramfs-2.6.32-279.el6.i686.img
  - 指定了initramfs内存文件系统镜像文件的所在位置

### 2.2 grup加密与字符界面分辨率调整

#### grub加密

可以使用md5加密 e 模式：

- `grub-md5-crypt`  //生成加密密码串

  ```
  # grub-md5-crypt
  Password: 
  Retype password: 
  $1$Y84LB1$8tMY2PibScmuOCc8z8U35/
  ```

- 修改 grub.conf 文件

  ```shell
  # vi /boot/grub/grub.conf
  default=0
  timeout= 5
  password --md5 $1$Y84LB1$8tMY2PibScmuOCc8z8U35/ #password选项放在整体设置处。
  splashimage=(hd0,0)/ grub/splash.xpm.gz
  hiddenmenu
  ```

最后会发现 grub 界面变成了p键：

![1608282393856](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1608282393856.png)

#### 纯字符界面分辨率调整

首先查询内核是否支持分辨率修改：

```
# 查询内核是否支持分辨率修改
# grep "CONFIG_ FRAMEBUFFER_ CONSOLE" /boot/config-2.6.32-279.el6.i686
```

然后修改 grub.conf 文件：追加 ==vga=791==

```
# vi /boot/grub/grub.conf
kernel /vmlinuz-2.6.32-358.el6.x86_64 ro root=/dev/mapper/VolGroup-lv_root rd_NO_LUKS LANG=en_US.UTF-8 rd_NO_MD rd_LVM_LV=VolGroup/lv_swap SYSFONT=latarcyrheb-sun16 crashkernel=auto rd_LVM_LV=VolGroup/lv_root  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM rhgb quiet vga=791
```

支持的分辨率

| 色深 | 640X 480 | 800X 600 | 1024X 768 | 1280X 1024 |
| :--: | :------: | :------: | :-------: | :--------: |
| 8位  |   769    |   771    |    773    |    775     |
| 15位 |   784    |   787    |    790    |    793     |
| 16位 |   785    |   788    |    791    |    794     |
| 32位 |   786    |   789    |    792    |    795     |





### 2.3 系统修复模式

#### 单用户模式

单用户模式常见的错误修复：

- 遗忘root密码
- 修改系统默认运行级别

进入单用户模式步骤：

1.启动的时候按任意键进入grub程序选择界面。

![1608279023346](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1608279023346.png)

2.按 e 键进入编辑模式（可以修改root/grub密码，不安全）：

![1608282536919](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1608282536919.png)

3.继续按e键编辑：

![1608282656679](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1608282656679.png)

4.尾行输入字符“1”，表示启用单用户模式：

![1608283251591](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1608283251591.png)

5.回到编辑模式按b键（选中kernel）进入单用户模式：

![1608283616360](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1608283616360.png)

![1608283384520](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1608283384520.png)

6.这时候就可以修改root/grub密码了：

```
# passwd root
```



#### 光盘修复模式

可以修改grub密码和root密码。修复重要文件。

1.快速按F2键，修改启动模式为光盘启动。

![1608322852982](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1608322852982.png)

2.选第三项：rescue installed system

![1608289428743](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1608289428743.png)

3.进入命令行后：修复重要系统文件丢失，导致系统无法启动

![1608322958450](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1608322958450.png)

- bash-4. 1# chroot /mnt/sysimage   #改变主目录
- sh-4.1# cd /root                 #进入root用户
- sh-4.1# rpm -qf /etc/inittab         #查询T下 /etc/inittab 文件属于哪个包
- sh-4.1# mkdir /mnt/cdrom           #建立挂载点
- sh-4.1# mount /dev/sr0 /mnt/cdrom      #挂载光盘



#### Linux 的安全性

Linux系统无论怎么设置密码，都会有方法破解。windows系统也是一样。

![1608322497037](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1608322497037.png)