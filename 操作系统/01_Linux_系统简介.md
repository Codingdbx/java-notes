# Linux系统简介

BSD  (Berkeley Software Distribution，伯克利软件套件) , 是Unix的衍生系统。 



## 1. Unix与Linux发展史

### 1.1 Unix发展史

- 1965年，美国麻省理工学院（MIT）、通用电气公司（GE）及AT&T的贝尔实验室联合开发Mulitics工程计划，最后贝尔实验室宣布退出。
- 1969年，美国贝尔实验室的肯.汤普森在DEC PDP-7机器上开发出了UNIX系统。
- 1971年，肯.汤普森的同事发明了C语言；1973年，UNIX绝大部分源代码用C语言重写，提高了UNIX系统的可移植性。

### 1.2 UNIX主要发行版本

| 操作系统 |               公司               |             硬件平台              |
| :------: | :------------------------------: | :-------------------------------: |
|   AIX    |               IBM                |              PowerPC              |
|  HP-UX   |                HP                |              PA-RISC              |
| Solaris  |               Sun                |               SPARC               |
|  Linux   | Red Hat Linux、Ubuntu Linux..... | IA(Inter、AMD、Cyrix、RISE......) |

### 1.3 Linux发展史

- Linux系统诞生于1991年，由芬兰大学生李纳斯（Linux Torvalds）和后来陆续加入的众多爱好者共同开发完成。Linux是开源软件，源代码开放的UNIX。
- Linux主要发行版本
  - CentOS
  - debian
  - ubuntu
  - KNOPPIX
  - redhat
  - 红旗Linux

## 2. 开源软件简介

开源软件：使用的自由、研究的自由、散步及改良的自由。

### 2.1 开源软件种类

- Apache
- Nginx
- MySQL
- PHP
- python
- Ruby

### 2.2 LAMP 开源技术

- Linux
- Apache
- MySQL
- PHP

## 3. Linux应用领域

### 3.1 基于Linux的企业服务器

- Tencent
- Alibaba

### 3.2 嵌入式应用

- 安卓系统
- IOS系统
- 智能家电

### 3.3 Linux在电影娱乐业

- 电影剪辑
- 特效制作

## 4. Linux学习方法

学习Linux系统可以通过命令行、书籍、B站视频、学习网站等。 

### 4.1 学习网站

鸟哥的Linux私房菜：http://linux.vbird.org/new_linux.php、http://vbird.dic.ksu.edu.tw/

Linux命令大全(手册) ： https://www.linuxcool.com/

Linux中国开源社区：https://linux.cn/

Linux下载站：http://www.linuxdown.net/

Linux公社：http://www.linuxidc.com/

## 5. Linux系统安装

- Linux 严格区分大小写
- Linux 中所有的内容都是以文件形式保存，包括硬件。

### 5.1 安装工具 

- VMware 虚拟机     //功能强大
- Oracle VM VirtualBox    //小巧好用

### 5.2 系统分区

#### 分区类型

- 主分区
  - 在一个硬盘上，最多只能有4个主分区（硬盘的限制）

- 扩展分区
  - 在一个硬盘上，最多只能有一个扩展分区（操作系统的限制）
  - 在一个硬盘上，主分区加扩展分区最多有4个
  - 不能写入数据，只能包含逻辑分区
- 逻辑分区
  - 是由扩展分区继续划分出来的分区
  - 逻辑分区的设备名称号码从数字5开始（1，2，3，4留给了主分区或扩展分区）

#### 格式化

只有主要分区和逻辑分区可以被格式化。扩展分区无法被格式化。

#### 硬件设备文件命名

|       硬件        |          设备文件名          |
| :---------------: | :--------------------------: |
|      IDE硬盘      | /dev/hd[a-d]（旧式系统才有） |
| SCSI/SATA/USB硬盘 |         /dev/sd[a-p]         |
|       光驱        |     /dev/cdrom、/dev/sr0     |
|       软盘        |         /dev/fd[0-1]         |
|  打印机（25针）   |         /dev/lp[0-2]         |
|   打印机（USB）   |      /dev/usb/lp[0-15]       |
|       鼠标        |          /dev/mouse          |

案例：某一个硬盘设备文件名为 /dev/sda，那么4个分区文件名如下

- /dev/sda1
- /dev/sda2
- /dev/sda3
- /dev/sda4

#### 挂载

所谓“挂载”，就是说把文件目录与磁盘分区建立关系。

- 必须分区
  - **`/`**          //根目录必须挂载
  - **`swap分区`**     //交换分区，内存的2倍，不超过2GB
- 推荐分区
  - **`/boot`**     //启动分区，200MB

### 5.3 软件包选择

安装Linux系统时会要求选择合适的软件包

- Desktop 
- Minimal Desktop
- Minimal
- Basic Server
- Database Server
- Web Server
- Virtual Host
- software development workstation

### 5.4 安装日志

- /root/install.log   //存储了安装在系统中的软件包及其版本信息
- /root/install.log.syslog   //存储了安装过程中留下的事件记录
- /root/anaconda-ks.cfg    //以Kickstart配置文件的格式记录安装过程中设置的选项信息

### 5.5 Linux 各目录的作用

|    目录名    |                           目录作用                           |
| :----------: | :----------------------------------------------------------: |
|    /bin/     | 存放系统命令的目录，普通用户和超级用户都可以执行。<br />在单用户模式下也可以执行。 |
|    /sbin/    | 保存和系统环境设置相关的命令，只有超级用户可以使用这些命令。 |
|  /usr/bin/   | 存放系统命令的目录，普通和超级用户都可以执行。<br />在单用户模式下不能执行。 |
|  /usr/sbin/  | 存放根文件系统不必要的系统管理命令，例如多数服务程序。<br />只有超级用户可以使用。 |
|    /boot/    | 系统启动目录，保存系统启动相关的文件，如内核文件和启动引导程序（grup）文件等。 |
|    /dev/     |                    所有设备文件保存位置。                    |
|    /etc/     | 配置文件保存位置。系统内所有采用默认安装方式（rpm安装）的服务<br />的配置文件全部都保存在这个目录当中，如用户的账户和密码，<br />服务的启动脚本，常用的服务的配置文件等。 |
|    /home/    |       普通用户的家目录。如user1的家目录就是/home/user1       |
|    /lib/     |                  系统调用的函数库保存位置。                  |
| /lost+found/ | 系统意外关机时，产生的一些碎片放在这里。<br />当系统启动的过程中fsck工具会检查这里，并修复已经损坏的文件系统。<br />这个目录只在每个分区中存在，例如 /lost+found 就是根分区的备份恢复目录<br />，/boot/lost+found 就是/boot分区的备份恢复目录。 |
|   /media/    |                挂载目录，挂载媒体设备的目录。                |
|    /mnt/     |          挂载目录，早起Linux中只有这一个挂载目录。           |
|    /misc/    |        挂载目录，系统建议用来挂载NFS服务的共享目录。         |
|    /opt/     |                  第三方安装的软件保存位置。                  |
|    /proc/    | 虚拟文件系统，该目录下的数据不保存到硬盘当中，而是<br />保存到内存中。如 /proc/cpuinfo 是保存CPU信息的，/proc/devices是<br />保存设备驱动的，/proc/filesystems是保存文件系统列表的，/proc/net 是<br />保存网络协议信息的。 |
|    /sys/     |              虚拟文件系统。和 /proc 目录相似。               |
|    /root/    |         超级用户的家目录。root用户登录后的默认目录。         |
|    /srv/     | 服务数据目录。一些系统服务启动之后，可以在这个目录保存<br />所需的数据。 |
|    /tmp/     | 临时目录。系统存放临时文件的目录，该目录下所有的用户都可以<br />访问和写入。不建议保存重要数据，最好每次开机都把该目录清空。 |
|    /usr/     | 系统软件资源目录。“Unix Software Resource”的缩写，所以不是存放用户数据，<br />而是存放系统软件资源的目录。系统中安装的软件大多数保存在这里。 |
|    /var/     | 动态数据保存位置。只要保存缓存、日志及软件运行所产生的文件。 |

### 5.6 网络设置

#### 网络类型

- 桥接        
  - 说明虚拟机使用了真实的网卡跟本机通信，如果本机可以联互联网，那么虚拟机也可以，也可以访问同一网段上的局域网
  - 会占用一个真实网段的IP地址
- NAT        
  - 虚拟机通过虚拟网卡只能和本机通信（虚拟机->本），如果本机可以联互联网，那么虚拟机也可以
  - 不会占用真实网段的IP地址
- Host-only   
  - 虚拟机只能和本机通信（本机->虚拟机）
  - 不会占用真实网段的IP地址

VMware 的几个虚拟设备：

- VMware Network Adapter VMnet1：这是 Host 用于与 Host-Only 虚拟网络进行通信的虚拟网卡
- VMware Network Adapter VMnet8：这是 Host 用于与 NAT 虚拟网络进行通信的虚拟网卡



#### 配置网卡 

只在内存中临时生效

```
# ifconfig eth0 192.168.102.126    // centos6，要求网段必须和本地电脑在同一个网段上
# ifconfig enp0s3 192.168.102.126  // centos7
```

永久生效

```
# vi /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
HWADDR=01:00:22:4B:D7:0E
TYPE=Ethernet
UUID=29b38ac5-1677-4166-bf2f-45b6f70f9e23
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=dhcp
IPADDR=192.168.102.126
```

```
# systemctl restart network    //centos7
# service network restart      //centos6
```



### 5.7 运维注意事项

- 远程服务器不允许关机，只能重启
- 重启时应该关闭服务
- 不要在服务访问高峰期运行高负载命令
  - 复制大文件
  - 备份数据
- 远程配置防火墙时不要把自己剔出服务器
- 合理的密码规范并定期更新
- 合理分配权限
- 定期备份重要数据和文件





