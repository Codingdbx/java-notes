# Linux 系统管理

## 1 进程管理

### 1.1 进程查看

#### 进程简介

进程是正在执行的一个程序或命令，每一个进程都是一个运行的实体，都有自己的地址空间，并占用一定的系统资源。

#### 管理进程

- 判断服务器的健康状态
- 查看系统中所有进程
- 杀死进程

#### 查看系统中所有进程

- `ps aux` //查看系统中所有进程，使用BSD操作系统格式

  ```
  # ps aux
  USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
  root         1  0.0  0.6 128164  6828 ?        Ss   14:39   0:02 /usr/lib/systemd/systemd --switched-root --system --deserialize 21
  root         2  0.0  0.0      0     0 ?        S    14:39   0:00 [kthreadd]
  root         3  0.0  0.0      0     0 ?        S    14:39   0:00 [ksoftirqd/0]
  root         5  0.0  0.0      0     0 ?        S<   14:39   0:00 [kworker/0:0H]
  ```

- `ps -le`   //查看系统中所有进程，使用Linux标准命令格式

  ```
  # ps -le
  F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
  4 S     0     1     0  0  80   0 - 32041 ep_pol ?        00:00:02 systemd
  1 S     0     2     0  0  80   0 -     0 kthrea ?        00:00:00 kthreadd
  1 S     0     3     2  0  80   0 -     0 smpboo ?        00:00:00 ksoftirqd/0
  1 S     0     5     2  0  60 -20 -     0 worker ?        00:00:00 kworker/0:0H
  ```

* `ps -ef`  //查看所有进程

  ```
  # ps -ef
  UID        PID  PPID  C STIME TTY          TIME CMD
  root         1     0  0 14:39 ?        00:00:02 /usr/lib/systemd/systemd --switched-root --system --deserialize 21
  root         2     0  0 14:39 ?        00:00:00 [kthreadd]
  root         3     2  0 14:39 ?        00:00:00 [ksoftirqd/0]
  ```

  各参数意义：

  |  参数   |                             含义                             |
  | :-----: | :----------------------------------------------------------: |
  |  USER   |                   该进程是由哪个用户产生的                   |
  |   PID   |                          进程的ID号                          |
  |  %CPU   |          该进程占用的CPU资源百分比，越高越耗费资源           |
  |  %MEM   |        该进程占用的物理内存百分比，占用越高越耗费资源        |
  |   VSZ   |               该进程占用虚拟内存的大小，单位KB               |
  |   RSS   |             该进程占用实际物理内存的大小，单位KB             |
  |   TTY   | 该进程是在哪个终端中运行的。其中 tty1-tty7 代表本地控制台终端，<br />tty1-tty6 是本地的字符界面终端，tty7是图形终端。pts/0-256代表虚拟终端。 |
  |  STAT   | 进程状态。常见的有：R：运行、S：睡眠、T：停止状态、<br />s：包含子进程、+：位于后台 |
  |  START  |                       该进程的启动时间                       |
  |  TIME   |          该进程占用CPU的运算时间，注意不是系统时间           |
  | COMMAND |                      产生此进程的命令名                      |



#### 查看系统健康状态

top [选项]

- `-d`   指定 top 命令每隔几秒更新。默认是3秒。

在 top 命令的交互模式中可以执行的命令：

- `?/h`  显示交互模式的帮助
- `P`    （shift+p）以CPU使用率排序，默认选项
- `M`    （shift+m）以内存的使用率排序
- `N`    （shift+n）以PID排序
- `q`       退出 top

案例：

```
# top -d 10
top - 21:31:34 up  6:52,  1 user,  load average: 0.00, 0.01, 0.05
Tasks:  84 total,   1 running,  83 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  6.2 sy,  0.0 ni, 93.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :  1016232 total,   525652 free,   130452 used,   360128 buff/cache
KiB Swap:  1257468 total,  1257468 free,        0 used.   705528 avail Mem 
```

分析：

第一行信息：任务队列信息

|                  内容                  |                             说明                             |
| :------------------------------------: | :----------------------------------------------------------: |
|                21:31:34                |                         系统当前时间                         |
|            up  1 day,  6:52            |          系统的运行时间，本机已经运行了1天6小时52分          |
|                2 users                 |                      当前登录了2个用户                       |
| ==**load average: 0.00, 0.01, 0.05**== | 系统在之前1分钟，5分钟，15分钟的平均负载。一般认为（单核CPU）小于1小时。负载较小。如果大于1小时，系统已经超出负荷。 |

第二行信息：进程信息

|       内容       |                说明                 |
| :--------------: | :---------------------------------: |
| Tasks:  84 total |          系统中的进程总数           |
|    1 running     |           正在运行的进程            |
|   83 sleeping    |             睡眠的进程              |
|    0 stopped     |           正在停止的进程            |
|     0 zombie     | 僵尸进程。如果不是0，需要手动检查。 |

第三行信息：CPU信息

|       内容        |                             说明                             |
| :---------------: | :----------------------------------------------------------: |
| %Cpu(s):  0.1% us |                   用户模式占用的CPU百分比                    |
|      6.2 sy       |                   系统模式占用的CPU百分比                    |
|      0.0 ni       |            改变过优先级的用户进程占用的CPU百分比             |
|  ==**93.8 id**==  |                       空闲CPU的百分比                        |
|      0.1% wa      |              等待输入/输出的进程占用的CPU百分比              |
|      0.0 hi       |                硬中断请求服务占用的CPU百分比                 |
|      0.0 si       |                软中断请求服务占用的CPU百分比                 |
|      0.0 st       | st（Steal time）虚拟时间百分比。就是当有虚拟机时，<br />虚拟CPU等待实际CPU的时间百分比 |

第四行信息：内存信息

|         内容          |         说明         |
| :-------------------: | :------------------: |
| Mem :  1016232k total | 实际的物理内存总大小 |
| **==525652k free==**  |       空闲多少       |
|     130452k used      |    已经使用了多少    |
|  360128k buff/cache   |     多少是在缓冲     |

第五行信息：交换分区（swap）信息

|         内容          |             说明             |
| :-------------------: | :--------------------------: |
| Swap:  1257468k total | 交换分区（虚拟内存）的总大小 |
|     1257468k free     |      空闲交换分区的大小      |
|        0k used        |    交换分区已经使用的大小    |
|   705528k avail Mem   |      可用交换分区的大小      |



#### 查看进程树

`pstree [-p|-u]`

- `-p`   //显示进程的PID
- `-u`   //显示进程的所属用户

注意： 默认需要安装此命令。

```
# yum -y install tree     //安装tree
# yum -y install psmisc   //安装pstree
```



### 1.2 终止进程

#### kill 命令

`kill -l`  //查看可用的进程信号

```
# kill -l
1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP
6) SIGABRT	 7) SIGBUS	 8) SIGFPE	 9) SIGKILL	10) SIGUSR1
11) SIGSEGV	12) SIGUSR2	13) SIGPIPE	14) SIGALRM	15) SIGTERM
16) SIGSTKFLT	17) SIGCHLD	18) SIGCONT	19) SIGSTOP	20) SIGTSTP
```

信号代号

|  信号代号  | 信号名称 |                             说明                             |
| :--------: | :------: | :----------------------------------------------------------: |
| **==1==**  |  SIGHUP  |      该信号让进程立即关闭，然后重新读取配置文件之后重启      |
|     2      |  SIGINT  |   程序终止信号，用于终止前台进程。相当于输出CTRL+C快捷键。   |
|     8      |  SIGFPE  | 在发生致命的算术运算错误时发出，不仅包括浮点运算错误，<br />还包括溢出及除数为0等其它所有的算术的错误。 |
| **==9==**  | SIGKILL  | 用来立即结束程序的运行，本信号不能被阻塞、处理和忽略。<br />一般用于强制终止进程。 |
|     14     | SIGALRM  | 时钟定时信号，计算的是实际的时间或时钟时间。alarm函数使用该信号。 |
| **==15==** | SIGTERM  | 正常结束进程的信号，kill 命令的默认信号。有时如果进程已<br />发生问题，这个信号是无法正常终止进程的，我们才会尝试SIGKILL<br />信号，也就是信号9。 |
|     18     | SIGCONT  |      该信号可以让暂停的进程恢复执行，本信号不能被阻断。      |
|     19     | SIGSTOP  | 该信号可以暂停前台进程，相当于输入CRTL+Z快捷键。本信号<br />不能被阻断。 |

案例：

```
# kill -1 22354   //重启进程
# kill -9 22568   //强制杀死进程
```



#### killall 命令

按照进程名称杀死进程。

killall [选项] [信号] 进程名

- `-i`    //交互式，询问是否要杀死某个进程
- `-I`    //忽略进程名的大小写

#### pkill 命令

按照进程名终止进程。

pkill [选项] [信号] 进程名

- `-t` 终端号     //按照终端号踢出用户

案例：

```
# w   //查看几个用户登录了
22:15:13 up  7:35,  1 user,  load average: 0.00, 0.01, 0.05
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/0    192.168.1.109    15:23    1.00s  0.12s  0.00s w
# pkill -t -9 pts/1  //踢出用户
```



## 2 工作管理

### 2.1 把进程放入后台

- `tar -zcf etc.tar.gz  /etc &`    放在后台运行
- `ctrl + z`   放到后台暂停

### 2.2 查看后台的工作

`jobs [-l]`

- `-l`  显示工作的PID

注意：`+` 代表最后一个放入后台的工作，也是工作恢复时，默认恢复的工作。`-` 代表倒数第二个放入后台的工作。

### 2.3 恢复后台的工作

- fg  %工作号  //恢复到前台执行，%可以省略，注意工作号和PID的区别

- bg  %工作号  //恢复到后台执行

注意： vi、vim、top 放到后台执行是没有意义的。

## 3 系统资源查看

### 3.1 vmstat 监控系统资源

vmstat 比 top 命令简洁

`vmstat [刷新延迟 刷新次数]`

```
# vmstat 1 3

procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 2  0      0 530628   2108 351744    0    0    19    23   56   50  0  0 100  0  0
 0  0      0 530612   2108 351776    0    0     0     0   78   66  0  0 100  0  0
 0  0      0 530612   2108 351776    0    0     0     0   59   49  0  0 100  0  0

```

### 3.2 dmesg 开机时内核检测信息

dmesg 重要的信息查看命令

查看CPU信息

```
# dmesg | grep CPU
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] 	RCU restricting CPUs from NR_CPUS=5120 to nr_cpu_ids=1.
[    0.055842] CPU: Physical Processor ID: 0
[    0.056757] mce: CPU supports 0 MCE banks
[    0.124666] smpboot: CPU0: Intel(R) Core(TM) i5-9400F CPU @ 2.90GHz (fam: 06, model: 9e, stepping: 0a)
```

查看网卡信息

```
# dmesg | grep eth0
[    1.434230] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 08:00:27:84:ec:fe
[    1.434235] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
```

### 3.3 free 查看内存使用状态

free [-b|-k|-m|-g]

- `-b`     以字节为单位显示
- `-k`     以KB为单位显示，默认值
- `-m`     以MB为单位显示
- `-g`     以GB为单位显示

缓存和缓冲的区别

简单来说缓存（cache）是加速数据从硬盘中”读取“的，而缓冲（buffer）是用来加速数据“写入”硬盘的。

### 3.4 查看CPU信息

```
# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 158
model name	: Intel(R) Core(TM) i5-9400F CPU @ 2.90GHz
stepping	: 10
cpu MHz		: 2904.000
cache size	: 9216 KB
```

### 3.5 uptime 命令

显示系统的启动时间和平均负载，也就是top命令的第一行。

w 命令也可以看到这个数据。

### 3.6 查看系统与内核相关信息

uname [-a|-r|-s]

- `-a`  查看系统所有相关信息
- `-r`  查看内核版本
- `-s `  查看内核名称

##### 判断当前系统位数

file 查看文件类型

```
# file /bin/ls
/bin/ls: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32
```

##### 查询当前Linux系统的发行版本

```
lsb_release -a
```

 

### 3.7 列出进程打开或使用的文件信息

losf  [-c|-u|-p]

- `-c`   字符串   //只列出以字符串开头的进程打开的文件
- `-u`   用户名   //只列出某个用户的进程打开的文件
- `-p `   PID       //列出某个PID进程打开的文件



## 4 系统定时任务

注意：定时任务最小识别单位是分钟。

### 4.1 crond服务管理与访问控制

crond 是定时任务服务，d的意思是daemon，守护进程。

```
# service crond restart //启动命令
# chkconfig crond on  //改为自启动命令

# chkconfig --list|grep crond //查看服务状态
```

### 4.2 用户的crontab设置

crontab  [-u username]  [选项]

-  `-u`   只有root才能进行这个任务，也即帮其他用户新建/删除crontab工作调度
- `-e`    编辑crontab定时任务
- `-l`    查询crontab定时任务
- `-r`    删除当前用户所有的crontab任务

定时任务格式：*** * * * * command**

|   项目    |         含义         |          范围           |
| :-------: | :------------------: | :---------------------: |
| 第一个“*” | 一小时当中的第几分钟 |          0-59           |
| 第二个“*” |  一天当中的第几小时  |          0-23           |
| 第三个“*” |  一个月当中的第几天  |          1-31           |
| 第四个“*” |  一年当中的第几个月  |          1-12           |
| 第五个“*” |   一周当中的星期几   | 0-7（0和7都代表星期日） |

模板：

|     时间     |                             含义                             |
| :----------: | :----------------------------------------------------------: |
| 45 22 * * *  |                  每天， 22 点 45 分执行命令                  |
|  0 17 * * 1  |                 每周一， 17 点 0 分执行命令                  |
| 0 5 1,15 * * |              每月1号和15号，凌晨5点0分执行命令               |
| 40 4 * * 1-5 |              每周一到周五，凌晨4点40分执行命令               |
| */10 4 * * * |               每天凌晨4点，每隔10分钟执行命令                |
| 0 0 1,15 * 1 | 每月1号和15号，每周一0点0分都会执行命令；<br />注意星期几和几号最好不要同时出现，容易混乱。 |

特殊符号：

| 特殊符号 |                             含义                             |
| :------: | :----------------------------------------------------------: |
|    *     | 代表任何时间。比如第一个 * 就代表一小时中每分钟都执行一次的意思。 |
|    ‘     | 代表不连续的时间。比如 “ 0 8,12,16 * * * “，<br />代表每天的8点0分，12点0分，16点0分都执行一次命令。 |
|    -     | 代表连续的时间范围。比如 ” 0 5 * * 1-6“，代表在周一到周六凌晨5点0分执行命令。 |
|   */n    | 代表每隔多久执行一次。比如 ”*/10 * * * * “，代表每隔10分钟都执行一遍命令 |

案例1：

```shell
*/5 * * * * /bin/echo "1111111" >> /home/test
5 5 * * 2 /sbin/shutdown - r now
0 5 1,10,15 * * /root/sh/autobak.sh
```

案例2：

```shell
#!/bin/bash
# Author: kiti (E-mail:kiti@163.com)
date=$(date +\%y\%m\%d)
size=$(du -sh /etc)

echo "Date : $date!" > /tmp/dbbak/dbinfo.txt
echo "Date size : $size!" >> /tmp/dbbak/dbinfo.txt

cd /tmp/dbbak
tar -zcf etc_$date.tar.gz /etc /tmp/dbbak/dbinfo.txt &>/dev/null
rm -rf /tmp/dbbak/dbinfo.txt
```

