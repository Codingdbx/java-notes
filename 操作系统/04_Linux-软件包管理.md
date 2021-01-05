# Linux 软件包管理

## 1.  软件包管理简介

### 1.1 软件包分类

- 源码包
  - 脚本安装包（`install.sh`）

- 二进制包
  * RPM包
  * 系统默认包

### 1.2 源码包

####  源码包的优点

- 开源，如果有足够的能力，可以修改源代码
- 可以自由选择所需的功能
- 软件是编译安装，所以更加适合自己的系统，更加稳定也效率更高
- 卸载方便
  - 删除安装目录后无任何垃圾文件存在

#### 源码包的缺点

- 安装过程步骤较多，尤其安装较大的软件集合时( 如LAMP环境搭建)，容易出现拼写错误
- 编译过程时间较长，安装比二进制安装时间长
- 因为是编译安装，安装过程中一旦报错新手很难解决

### 1.3 RPM包

#### 二进制包的优点

- 包管理系统简单，只通过几个命令就可以实现包的安装、升级、查询和卸载
- 安装速度比源码包安装快的多

#### 二进制包的缺点

- 经过编译，不再可以看到源代码
- 功能选择不如源码包灵活
- 依赖性
  - 有些 RPM 包又依赖于其他 RPM 包



## 2. RPM包管理-rpm命令管理

### 2.1 包命名与依赖性

#### RPM包命名原则

`httpd-2.2.15-15.cl6.centos.1.i686.rpm`

- `httpd` 软件包名
- `2.2.15` 软件版本
- `15` 软件发布的次数
- `el6.centos` 适合的Linux平台
- `i686` 适合的硬件平台
- `rpm` rpm包扩展名

#### RPM包依赖性

- 树形依赖：a→b→c
- 环形依赖：a→b→c→a
- 模块依赖：模块依赖查询网站：www.rpmfind.net

#### 包全名与包名

- 包全名：操作的包是没有安装的软件包时，使用包全名。而且要注意路径。
- 包名：操作已经安装的软件包时，使用包名。是搜索/var/lib/rpm/中的数据库。

### 2.2 安装、升级、卸载

#### RPM安装

`rpm -ivh` [包全名]

- `-i` ( install)      安装
- `-v` ( verbose )    显示详细信息
- `-h` (hash)        显示进度
- `--nodeps`      不检测依赖性

#### RPM包升级

`rpm -Uvh`  [包全名]

- `-U` (upgrade)  升级

#### RPM包卸载

`rpm -e` [包名]

- `-e` (erase)  卸载
- `--nodeps`  不检查依赖性



### 2.3 查询

#### 查询是否安装

`rpm -q` [包名]

- `-q`   查询  (query)

  ```
  # rpm -q httpd
  package httpd is not installed
  ```

`rpm -qa`

- `-a` 所有  (all)

  ```
  # rpm -qa
  setup-2.8.14-20.el6.noarch
  basesystem-10.0-4.el6.noarch
  ncurses-base-5.7-3.20090208.el6.x86_64
  ```

  ```
  # rpm -qa | grep setup
  setup-2.8.14-20.el6.noarch
  ```



#### 查询软件包详细信息

 `rpm -qi` [包名]

- `-i` 查询软件信息( information)

  ```
  # rpm -qi setup
  Name        : setup                        Relocations: (not relocatable)
  Version     : 2.8.14                            Vendor: CentOS
  Release     : 20.el6                        Build Date: Mon 15 Oct 2012 05:15:31 PM CST
  Install Date: Sun 13 Dec 2020 08:02:22 PM CST      Build Host: c6b7.bsys.dev.centos.org
  Group       : System Environment/Base       Source RPM: setup-2.8.14-20.el6.src.rpm
  Size        : 665890                           License: Public Domain
  Signature   : RSA/SHA1, Tue 16 Oct 2012 12:30:05 AM CST, Key ID 0946fca2c105b9de
  Packager    : CentOS BuildSystem <http://bugs.centos.org>
  URL         : https://fedorahosted.org/setup/
  Summary     : A set of system configuration and setup files
  Description :
  The setup package contains a set of important system configuration and
  setup files, such as passwd, group, and profile.
  ```

- `-p` 查询未安装包信息(package)

  ```
  # rpm -qip zip-3.01.e16.1686.rpm
  ```

  -  查询没有安装过的包就应该使用包全名 



#### 查询包中文件安装位置

`rpm -ql` [包名]

- `-l` 列表(list)

  ```
  # rpm -ql setup
  /etc/aliases
  /etc/bashrc
  /etc/csh.cshrc
  /etc/csh.login
  /etc/environment
  /etc/exports
  ```

- `-p` 查询未安装包文件信息

  ```
  # rpm -qlp zip-3.01.e16.1686.rpm
  ```

  -  查询没有安装过的包就应该使用包全名 

#### 查询系统文件属于哪个RPM包

`rpm -qf` [系统文件名]

- `-f` 查询系统文件属于哪个软件包(file)



#### 查询软件包的依赖性

`rpm -qR` [包名]

- `-R`  查询软件包的依赖性(requires )

- `-p `   查询未安装包信息(package)

  ```
  # rpm -qRp zip-3.01.el6.i686.rpm
  ```

  - 查询没有安装过的包就应该使用包全名 



### 2.4 校验和文件提取

#### RPM包校验

`rpm -V` [已安装的包名]

- `-V` 校验指定RPM包中的文件(verify)

  - 检测RPM安装的`httpd` 服务 默认配置文件有没有被修改过

    ```  /
    # rpm -V httpd 
    S.5....T    c  /etc/httpd/conf/httpd.conf
    ```

##### 校验的内容信息

- `S`      #文件大小是否改变
- `M`      #文件的类型或文件的权限(`rwx`) 是否被改变
- `5 `      #文件`MD5`校验和是否改变(可以看成文件内容是否改变)
- `D `      #设备的中，从代码是否改变
- `L `      #文件路径是否改变
- `U`      #文件的属主(所有者)是否改变
- `G `      #文件的属组是否改变
- `T `      #文件的修改时间是否改变

##### 文件类型

- `c`     #配置文件(configuration file)
- `d`     #普通文档(documentation)
- `g`     #“鬼”文件(ghost file) ，很少见，就是该文件不应该被这个RPM包包含
- `l`     #授权文件(license file)
- `r`     #描述文件(read me)

#### RPM包中文件提取

`rpm2cpio  [包全名] | \ cpio -idv .文件绝对路径`

- `rpm2cpio`    #将rpm包转换为`cpio`格式的命令
- `cpio`    #是一个标准工具，它用于创建软件档案文件和从档案文件中提取文件 
- `\`    #这里的反斜杠，代表命令没输完，换行。
- `.`   # 点代表把指定的文件提取到当前目录下 

`cpio`  [选项] [文件|设备]

- `-i`： copy-in模式， 还原
- `-d`：还原时自动新建目录
- `-v`：显示还原过程

案例：

-  `rpm -qf /bin/ls`   #查询ls命令属于哪个软件包

-  `mv /bin/ls /tmp/ `  #造成ls命令误删除假象

- `rpm2cpio /mnt/cdrom/Packages/coreutils-8.4-l9.el6.i686.rpm | cpio -idv ./bin/ls`

  #提取RPM包中Is命令到当前目录的bin/s下

- `cp /root/bin/ls /bin/ `  #把ls命令复制会/bin/目录，修复文件丢失



## 3. RPM包管理-yum在线管理

### 3.1 IP地址配置和网络yum源

#### IP地址配置

- 临时有效

  ```
  # ifconfig eth0 192.168.110.115
  ```

- 永久有效

  ```
  # vi /etc/sysconfig/network-scripts/ifcfg-eth0
    ONBOOT='yes'  #启动网卡
  # service network restart  #重启网络服务
  ```

#### 网络yum源

`vi /etc/yum.repos.d/CentOS-Base.repo`

- `[base]`      #容器名称，一定 要放在[]中
- `name`         #容器说明，可以自己随便写
- `mirrorlist`    #镜像站点，这个可以注释掉
- `baseurl`        #我们的yum源服务器的地址。默认是`CentOS`官方的yum源服务器，是可以使用的，如果你觉得慢可以改成你喜欢的yum源地址。
- `enabled `      #此容器是否生效，如果不写或写成enable=1 都是生效，写成enable-=0就是不生效。
- `gpgcheck`    #如果是1是指RPM的数字证书生效，如果是0则不生效
- `gpgkey`      #数字证书的公钥文件保存位置。不用修改。



### 3.2 yum命令

#### 常用yum命令

查询

- `yum list`   #查询所有可用软件包列表。
- `yum search` [关键字]   #搜索服务器上所有和关键字相关的包

安装

-  `yum -y install` [包名]

  - `install`  安装

  - `-y`  自动回答yes

升级

- `yum -y update` [包名]
  - `update` 升级
  - `-y` 自动回答yes

卸载

- `yum -y remove` [包名]
  - `remove` 卸载
  - `-y` 自动回答yes

#### yum软件组管理命令

- `yum grouplist`  #列出所有可用的软件组列表
- `yum groupinstall`  [软件组名]   #安装指定软件组，组名可以由`grouplist`查询出来
- `yum groupremove`  [软件组名]   #卸载指定软件组



### 3.3 光盘yum源搭建

#### 光盘yum源搭建步骤

1. 挂载光盘 

   ```
   # mount /dev/cdrom /mnt/cdrom/
   ```

2. 让网络yum源文件失效

   ```
   # cd /etc/yum.repos.d/
   # mv CentOS-Base.repo CentOS- Base.repo.bak
   # mv CentOS-Debuginfo.repo CentOS-Debuginfo.repo.bak
   # mv CentOS-Vault.repo CentOS-Vault.repo.bak
   ```

3. 修改光盘yum源文件

   ```
   # vim CentOS-Media.repo
   ```
   
```shell
   [c6-media]
   name=CentOS-$releasever - Media
   
   #地址为你自己的光盘挂载地址
   baseurl=file:///mnt/cdrom   
   
   #注释这两个不存在的地址
   #file:///media/cdrom/
   #file:///media/cdrecorder/
   
   #把enable=0改为enabled=1，让这个yum源配置文件生效
   gpgcheck=1
   enabled=1
   gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
   ```
   
注意：这里修改文件有严格的格式要求。



## 4. 源码包管理

### 4.1 源码包和RPM包的区别

#### 安装位置

- RPM包安装位置

  | RPM包默认安装路径 |            说明            |
  | :---------------: | :------------------------: |
  |      `/etc/`      |      配置文件安装目录      |
  |    `/usr/bin/`    |    可执行的命令安装目录    |
  |    `/usr/lib/`    | 程序所使用的函数库保存位置 |
  | `/usr/share/doc/` | 基本的软件使用手册保存位置 |
  | `/usr/share/man/` |      帮助文件保存位置      |

  

- 源码包安装位置
  
  - 安装在指定位置当中，一般是`/usr/local/软件名/`

#### 安装位置不同带来的影响

- RPM包安装的服务可以使用系统服务管理命令(service) 来管理，例如RPM包安装的apache的启动方法

  - `/etc/rc.d/init.d/httpd start`

  - `service httpd start`

- 源码包安装的服务则不能被服务管理命令管理，因为没有安装到默认路径中。只能用绝对路径进行服务的管理
  - `/usr/local/apache2/bin/apachectl start`



### 4.2 源码包安装过程

#### 安装准备

- 安装C语言编译器
- 下载源码包
  - http://mirror.bit.edu.cn/apache/httpd/

#### 安装注意事项

- 源代码保存位置
  - `/usr/local/src/`
- 软件安装位置
  - `/ust/local/`
- 如何确定安装过程报错
  - 安装过程停止
  - 并出现error、 warning或no的提示

#### 源码包安装过程

- 下载源码包
- 解压缩下载的源码包
- 进入解压缩目录
- `./configure` 软件配置与检查
  - 定义需要的功能选项
  - 检测系统环境是否符合安装要求
  - 把定义好的功能选项和检测系统环境的信息都写入Makefile文件，用于后续的编辑。

- `make`   #编译
- `make install`    #编译安装

#### 源码包的卸载

- 不需要卸载命令，直接删除安装目录即可。不会遗留任何垃圾文件。



## 5. 脚本安装包与软件包选择

#### 5.1 脚本安装包

- 脚本安装包并不是独立的软件包类型，常见安装的是源码包。
- 人为把安装过程写成了自动安装的脚本，只要执行脚本，定义简单的参数，就可以成安装。
- 非常类似于Windows下软件的安装方式。

#### 5.2 Webmin的作用

- Webmin 是一个基于Web的Linux系统管理界面。可以通过图形化的方式设置用户帐号、Apache、DNS、文件共享等服务。

#### 5.3 Webmin安装过程

- 下载软件
  - http://sourceforge.net/projects/webadmin/files/webmin/
- 解压缩，并进入解压缩目录
- 执行安装脚本

