# Linux 服务管理

## 1 服务简介与分类

### 1.1 服务的分类

![1608344907978](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1608344907978.png)

Linux服务：

- RPM包默认安装的服务
  - 独立的服务
  - 基于 `xinetd` 服务
    -  FTP、Telnet、SSH 服务
- 源码包安装的服务

区别：RPM包安装的服务安装简单，快速，看不到源代码。源码包安装复杂，时间长，一旦有错误不容易解决。



#### 启动与自启动

- 服务启动：就是在当前系统中让服务运行并提供功能。
- 服务自启动：自启动是指让服务在系统开机或重启动之后，随着系统的启动而自动启动服务。

#### 查询已安装的服务

- RPM包安装的服务

  - `chkconfig --list`  #查看服务自启动状态，可以看到所有RPM包安装的服务

    ```
    # chkconfig --list
    auditd         	0:off	1:off	2:on	3:on	4:on	5:on	6:off
    blk-availability	0:off	1:on	2:on	3:on	4:on	5:on	6:off
    crond          	0:off	1:off	2:on	3:on	4:on	5:on	6:off
    ```

- 源码包安装的服务

  - 查看服务安装位置，一般是 `/usr/local/` 下

#### RPM安装服务和源码包安装服务的区别

RPM安装服务和源码包安装服务的主要区别就是安装位置的不同

- RPM包安装在默认位置中。

- 源码包安装在指定位置，一般是 `/usr/local/`



## 2 RPM包安装服务的管理

`srevice`，`chkconfig` 命令之所以可以管理RPM包安装的软件，是因为 `srevice` 命令会搜索固定的目录下 `/etc/rc.d/init.d/`。而 `/etc/rc.d/init.d/` 与 `/etc/init.d/`是一样的，它们是软链接（快捷方式）。

### 2.1 独立服务的管理

#### RPM包安装服务的位置

- RPM包安装在默认位置中

- `/etc/init.d/`      //启动脚本位置

  - ```
    # ll /etc/rc.d/init.d/
    total 136
    -rwxr-xr-x. 1 root root  3378 Jun 22  2012 auditd
    -r-xr-xr-x. 1 root root  1340 Feb 22  2013 blk-availability
    -rwxr-xr-x. 1 root root  2793 Jul 19  2011 crond
    -rw-r--r--. 1 root root 18216 Jan  9  2013 functions
    -rwxr-xr-x. 1 root root  5829 Jan  9  2013 halt
    ```

- `/etc/sysconfig/`     //初始化环境配置文件位置

- `/etc/`      //配置文件位置

- `/etc/xinetd.conf`   //`xinetd` 配置 文件

- `/etc/xinetd.d/`       //基于`xinetd`服务的启动脚本

- `/var/lib/`      //服务产生的数据放在这里

- `/var/log/`      //日志

#### 独立服务的启动

- `/etc/init.d/独立服务名`    `start|stop|status|restart`
- `service 独立服务名`  `start|stop|restart|status`

#### 独立服务的自启动

- `chkconfig [--level 运行级别] [独立服务名] [on|off]`

  - ```
    # chkconfig --level 2345 auditd on
    ```

- 修改 `/etc/rc.d/rc.local` 文件

  - ```shell
    # vi /etc/rc.d/rc.local
    
    #!/bin/sh
    #
    # This script will be executed *after* all the other init scripts.
    # You can put your own initialization stuff in here if you don't
    # want to do the full Sys V style init stuff.
    touch /var/lock/subsys/local
    /etc/rc.d/init.d/httpd start  //增加自启动程序
    ```

    

- 使用`ntsysv`命令管理自启动



### 2.2 基于`xinetd`服务的管理

#### 安装 `xinetd` 与 `telnet`

```
[root@localhost ~]# yum -y install xinetd
[root@localhost ~]# yum -y install telnet-server
```

#### `xinetd` 服务的启动

`vi /etc/xinetd.d/telnet`

```shell
[root@localhost ~]# vi /etc/xinetd.d/telnet
service telnet{
	flags = REUSE  #标志为REUSE，设定TCP/IP socket可重用
	socket type = stream #使用TCP协议数据包
	wait = no   #允许多个连接同时连接
	user = root  #启动服务的用户为root
	server = /usr/sbin/in.telnetd #服务的启动程序
	log_on_failure += USERID  #登陆失败后，记录用户的ID
	disable = no  #服务不启动
}
```

#### 重启`xinetd`服务

```
[root@localhost ~]# service xinetd restart
```

#### `xinetd`服务的自启动

- `chkconfig telnet on`
- `ntsysv`



## 3 源码包安装服务的管理

### 3.1 源码包安装服务的启动

- 使用绝对路径，调用启动脚本来启动。不同的源码包的启动脚本不同。可以查看源码包的安装说明，查看启动脚本的方法。
  - `/usr/local/apache2/bin/apachectl start|stop`

### 3.2 源码包服务的自启动

`vi /etc/rc.d/rc.local`  

```shell
#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.

touch /var/lock/subsys/local
/usr/local/apache2/bin/apachectl start
```

### 3.3 让源码包服务被服务管理命令识别

- 让源码包的apache服务能被service命令管理启动

  - ```
    # ln -s /usr/local/apache2/bin/apachectl /etc/init.d/apache
    ```

- 让源码包的apache服务能被`chkconfig`与`ntsysv`命令管理自启动

  - ```shell
    #指定httpd脚本可以被chkconfig命令管理。格式是: chkconfig:运行级别 启动顺序 关闭顺序
    #说明，内容随意
    # vi /etc/init.d/apache
    # chkconfig: 35 86 76
    # description: source package apache
    ```



## 4 服务管理总结

### 4.1 常见服务的作用

|    服务名称     |                           功能简介                           | 建议 |
| :-------------: | :----------------------------------------------------------: | :--: |
|     `acpid`     | 电源管理接口。如果是笔记本用户建议开启，<br />可以监听内核的相关电源事件。 | 开启 |
|    `anacron`    | 系统的定时任务程序。`cron` 的一个子系统，如果定时任务错关闭<br/>过了执行时间，可以通过 `anacron` 继续唤醒执行。 | 关闭 |
|   `alsasound`   |           Ales声卡驱动。如果使用`alsa`声卡，开启。           | 关闭 |
|     `apmd`      |  电源管理模块。如果支持`acpid`，就不需要`apmd`，可以关闭。   | 关闭 |
|      `atd`      | 指定系统在特定时间执行某个任务，只能执行一次。如果需要<br />则开启，但我们一般使用`crond`来进行循环定时任务。 | 关闭 |
|    `auditd`     | 审核子系统。如果开启了此服务，`SELinux`的审核信息会写入<br/>`/var/1og/audit/udit.log` 文件，如果不开启，审核信息会<br/>记录在`syslog`中。 | 开启 |
|    `autofs`     | 让服务器可以自动挂载网络中的其他服务器的共享数据，一般<br/>用来自动挂载 NFS 服务。如果没有 NFS 服务建议关闭。 | 关闭 |
| `avahi-daemon`  | `Avahi` 是`zeroconf` 协议的实现。它可以在<br/>没有 `DNS` 服务的局域网里发现基于`zeroconf` 协议的设<br/>备和服务。除非有兼容设备或使用`zeroconf` 协议，否则关闭。 | 关闭 |
|   `bluetooth`   |    蓝牙设备支持。一般不会在服务器上启用蓝牙设备，关闭它。    | 关闭 |
|     `capi`      |                仅对使用`ISND`设备的用户有用。                |      |
| `chargen-dgram` | 使用 `UDP`协议的 `chargen server` 。主要功能是提供类似远程<br/>打字的功能。 | 关闭 |
|   `cpuspeed`    | 可以用来调整CPU的频率。当闲置时可以自动降低CPU频率<br/>来节省电量。 | 开启 |
|     `crond`     | 系统的定时任务，一般的Linux服务器都需要定时任务帮助<br/>系统维护。建议开启。 | 开启 |



