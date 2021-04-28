# Linux-网络基础

## 1. 进制转换

### 1.1 二进制转十进制

```
二进制转十进制:00110110
0   0   1   1   0   1   1   0
        32  16      4   2      = 54
```

### 1.2 十进制转二进制

#### 装水桶法

```
1   1   1   1   1   1   1   1
128 64  32  16  8   4   2   1

十进制转二进制:137
1   0   0   0   1   0   0  1 
128             8          1 = 137
```

### 1.3 十六进制转十进制

```
先转为二进制:8ea
8     e (14)  a (10)
1000  1110    1010

再转为十进制:100011101010
1  0  0  0  1  1  1  0  1  0  1  0
2048       128 64 32    8     2    = 2282
```

### 1.4 十进制转十六进制

```
先转换为二进制:297 = 256 + 32 + 8 + 1
1 0 0 1 0 1 0 0 1

再转为十六进制:1 0010 1001
0001 0010 1001
1     2    9
```



## 2. 互联网概述

### 2.1 互联网概述

#### 互联网的典型应用

- WWW：万维网
  - (World Wide Web)又称全球网、环球网或万维网等，也可简称为Web
- FTP：文件传输协议
- E-MAIL：电子邮件
- HTTP:  超文本传输协议

URL：统一资源定位符

[协议]+ [域名或`IP`]:[端口] + [网页路径] + [网页名]

`http://www.lampbrother.net:80/index.html`

- `.net`      一级域名

  常见一级域名

  | 地区一级域名 |   说明   | 组织一级域名 |      说明      |
  | :----------: | :------: | :----------: | :------------: |
  |     `au`     | 澳大利亚 |    `edu`     |    教育机构    |
  |     `cn`     |   中国   |    `com`     |    商业组织    |
  |     `in`     |   印度   |    `gov`     | 非军事政府机构 |
  |     `uk`     |   英国   |    `mil`     |    军事机构    |
  |     `us`     |   美国   |    `org`     |    其他组织    |
  |              |          |    `net`     |  网络服务机构  |

  

- `lampbrother `   二级域名

  - 全球唯一

- `www`    三级域名



### 2.2 互联网接入方法

- `ADSL`：非对称数字用户环路
  - `ADSL`可以提供最高`1Mbps`的上行速率和最高`8Mbps`的下行速率。
  - 最新的`ADSL2+`技术可以提供最高`24Mbps`的下行速率，`ADSL2+`打破了`ADSL`接入方式带宽限制的瓶颈，使其应用范围更加广阔。
  - 优点
    - 使用电话线，节省了布网成本
    - 上网的同时可以打电话，节省了电话费。
  - 缺点
    - 铜线耗材昂贵
    - 带宽限制
    - 动态`IP`地址
- `FTTH`：光纤入户
  - 光纤入户的带宽更高，而光纤的原材料是二氧化硅，在自然界取之不尽用之不竭。当然也是动态`IP`地址。
- 小区宽带
  - 小区宽带是一个大局域网，所有客户都在同一个网段中。外网接口可以是`FTTH`,也可以是固定`IP`的光纤。
- 固定`IP`光纤
  - 带宽自由申请，价格最贵。因为固定`IP`地址，所以可以搭建服务器。



## 3 网络通信协议

### 3.1 OSI 七层模型

- 应用层 
- 表示层 
- 会话层 
- 传输层
- 网络层
- 数据链路层
- 物理层

### 3.2 TCP/IP 四层模型

- 应用层
  - 应用层对应于`OSI`参考模型的高层，为用户提供所需要的各种服务。
  - `FTP`、`Telnet`、`DNS`、`SMTP`、`HTTP`等。
- 传输层
  - 传输层对应于`OSI`参考模型的传输层，为应用层实体提供端到端的通信功能，保证了数据包的顺序传送及数据的完整性。
  - 该层定义了两个主要的协议：传输控制协议(`TCP`)和用户数据报协议(`UDP`)
- 网际互联层
  - 网际互联层对应于`OSI`参考模型的网络层，主要解决主机到主机的通信问题。它所包含的协议设计数据包在整个网络上的逻辑传输。
  - 该层有三个主要协议：网际协议(`IP`)、互联网组管理协议(`IGMP`)和互联网控制报文协议(`ICMP`)。
- 网络接口层
  - 网络接入层与`OSI`参考模型中的物理层和数据链路层相对应。它负责监视数据在主机和网络之间的交换。事实上，`TCP/IP`本身并未定义该层的协议，而由参与互连的各网络使用自己的物理层和数据链路层协议，然后与`TCP/IP`的网络接入层进行连接。
  - 地址解析协议(`ARP`) 工作在此层，即`OSI`参考模型的数据链路层。

### 3.3 TCP/IP 三次握手

![1610111070207](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1610111070207.png)



### 3.4 TCP/IP 模型与OSI模型的对应 

![1610110808696](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1610110808696.png)

### 3.5 TCP/IP模型与OSI模型的比较

- 共同点
  - `OSI`参考模型和`TCP/IP`参考模型都采用了层次结构的概念。
  - 都能够提供面向连接和无连接两种通信服务机制。
- 不同点
  - 前者是七层模型，后者是四层结构。
  - 对可靠性要求不同(后者更高)。
  - `OSI`模型是在协议开发前设计的，具有通用性。`TCP/IP`是先有协议集然后建立模型，不适用于非`TCP/IP`网络。

### 3.6 数据封装过程

![1610112063379](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1610112063379.png)



## 4 Linux 网络配置

### 4.1 Linux的IP地址配置

#### ifconfig 命令

- `ifconfig` #查看与配置网络状态命令
- `ifconfig eth0 192.168.0.200 netmask 255.255.255.0` #临时设置`eth0`网卡的`IP`地址与子网掩码

#### setup 工具

红帽专有图形化工具`setup`设置`IP`地址。

#### 修改网络配置文件

`vi /etc/sysconfig/network-scripts/ifcfg-eth0`

### 4.2 Linux网络配置文件

#### 网卡信息文件

`vi /etc/sysconfig/network-scripts/ifcfg-eth0`

| 参数                                          | 说明                                        |
| :-------------------------------------------- | :------------------------------------------ |
| `DEVICE=eth0`                                 | 网卡设备名                                  |
| `BOOTPROTO=none`                              | 是否自动获取`IP` (`none`、`static`、`dhcp`) |
| `HWADDR=00:0c:29:17:c4:09`                    | MAC地址                                     |
| `NM_CONTROLLED=yes`                           | 是否可以由Network Manager图形管理工具托管   |
| `ONBOOT=yes`                                  | 是否随网络服务启动，`eth0`生效              |
| `TYPE=Ethernet`                               | 类型为以太网                                |
| `UUID="44b76c8a-b59f-44d5-83fa-7f98fda86b3d"` | 唯一识别码                                  |
| `IPADDR=192.168.0.252`                        | `IP`地址                                    |
| `NETMASK=255.255.255.0`                       | 子网掩码                                    |
| `GATEWAY=192.168.0.1`                         | 网关                                        |
| `DNS1=202.106.0.20`                           | `DNS`                                       |
| `IPV6INIT=no`                                 | `IPV6`没有启用                              |
| `USERCTL=no`                                  | 不允许非root用户控制此网卡                  |

#### 主机名文件

- `vi /etc/sysconfig/network`

  ```
  NETWORKING=yes
  HOSTNAME=localhost.localdomain
  ```

- `hostname`  [主机名]   #查看与临时设置主机名命令

#### DNS 配置文件

`vi /etc/resolv.conf`

```shell
nameserver 202.106.0.20
search localhost
```

#### 各配置文件位置关系

- `/etc/sysconfig/network-scripts/ifcfg-etho`
- `/etc/sysconfig/network`
- `/etc/resolv.conf`



### 4.3 常用网络命令

#### ifconfig 命令

`ifconfig`   #查看与配置网络状态命令

#### hostname 命令

`hostname` [主机名]    #查看或设置主机名命令

#### ifdown 与 ifup命令

- `ifdown` [网卡设备名]  #禁用该网卡设备
- `ifup` [网卡设备名]  #启用该网卡设备

#### netstat 命令

`netstat` [选项]  #查询网络状态

选项：

- `-t`：列出`TCP`协议端口
- `-u`：列出`UDP`协议端口
- `-n`：不使用域名与服务名，而使用`IP`地址和端口号
- `-l`：仅列出在监听状态网络服务
- `-a`：列出所有的网络连接
- `-r`：列出路由列表，功能和route命令一致（可以看到网关地址）

状态说明：

| 套接字       | 功能                                                         |
| ------------ | ------------------------------------------------------------ |
| CLOSED       | 没有使用这个套接字                                           |
| LISTEN       | 正在监听连接                                                 |
| SYN_SENT     | 正在试图主动建立连接[发送SYN后还没有收到ACK]                 |
| SYN_RECEIVED | 处于连接的初始同步状态[收到对方的SYN，但还没收到自己发过去的SYN的ACK] |
| ESTABLISHED  | 连接已建立                                                   |
| CLOSE_WAIT   | 正在等待关闭这个套接字[被动关闭的一方收到FIN]                |
| FIN_WAIT_1   | 套接字已关闭，正在关闭连接[发送FIN，没有收到ACK也没有收到FIN] |
| CLOSING      | 套接字已关闭                                                 |
| LAST_ACK     | 正在等待本地套接字的关闭确认[被动方在CLOSE_WAIT状态下发送FIN] |
| FIN_WAIT_2   | 正在等待远程套接字关闭[在FIN_WAIT_1状态下收到发过去FIN对应的ACK] |
| TIME_WAIT    | 正在等待远程套接字的关闭传送[FIN、ACK、FIN、ACK都完毕，这是主动方的最后一个状态，在过了2ms时间后变为CLOSED状态] |

#### lsof 命令

- `-i` 显示所有连接

  ```shell
  #lsof  -i
  ```

- `-i:port`  来显示与指定端口相关的网络信息

  ```shell
  #lsof  -i:22
  ```

-  搜索`ESTABLISHED`”

  ```shell
  #lsof  -i | grep  -i ESTABLISHED
  ```

  

#### route 命令

`route -n` #査看路由列表（可以看到网关地址）

#### nslookup 命令

`nslookup` `[主机名或IP]`  #进行域名与`IP`地址解析

```
# nslookup
> server
#査看本机DNS服务器
```

#### ping 命令

`ping` [选项] [`IP`或域名]   #探测指定`IP`或域名的网络状况

- `-c` [次数]     #指定 ping 包的次数

#### telnet 命令

- `telnet` [域名或`IP`] [端口]   #远程管理与端口探测命令

- `telnet 192.168.0.252 80`

#### traceroute 命令

`traceroute` [选项] [`IP`或域名]  #路由跟踪命令

- `-n`    #使用`IP`，不使用域名，速度更快

#### wget 命令

`wget`  `[url]`  #下载命令



### 4.4 虚拟机网络参数配置

#### 配置Linux IP地址

`setup` #修改并配置`IP`地址

#### 启动网卡

- `vi /etc/sysconfig/network-scripts/ifcfg-eth0`
  - 把 `ONBOOT=no` 改为 `ONBOOT=yes`
- `service network restart`   #重启网络服务

#### 修改 UUID

只有复制镜像需要设置

- `vi /etc/sysconfig/network-scripts/ifcfg-eth0`
  - 删除MAC地址行
- `rm -rf /etc/udev/rules.d/70-persistent-net.rules`
  - 删除网卡和MAC地址绑定文件
- 重启动系统



