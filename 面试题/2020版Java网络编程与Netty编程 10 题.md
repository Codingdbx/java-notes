## 2020版Java网络编程与Netty面试题

### 1. TCP/IP 参考模型

* 应用层 

  HTTP、FTP、Telnet、DNS

* 传输层

  TCP、UDP、ARP

* 网络层

  IP、ICMP

* 物理+数据链路层

  Link

### TCP 和 UDP区别？



### TCP 粘包、拆包问题？



### 2. OSI参考模型?

1.应用层 所有能产生网络流量的程序
 2.表示层 是否进行加密或压缩处理
 3.会话层 查木马 netstat -nb
 4.传输层 可靠传输 流量控制 不可靠传输
 5.网络层 选择最佳路径到达目的地 规划MAC路径
 6.数据链路层 帧的开始和结束 透明传输
 7.物理层 接口标准 电器标准

### 3. 什么是BIO？

BIO Block IO （同步阻塞式 IO），一个请求会创建一个线程去处理。

（1）服务端启动一个`ServerSocket`。

（2）客户端会启动`Socket`对服务端通信，默认服务端会对每个请求建立一个线程去处理。

（3）客户端发出请求后，会首先咨询服务端是否有线程去响应处理，没有的话会等待或者被拒绝。

（4）如果有响应，客户端会等待请求结束后，再继续执行。

### 4. 什么是NIO？

* NIO Non-blocking IO（非阻塞IO）是Jdk1.4开始提供的一套改进的输入/输出新特性。也被称为 New IO。
* NIO 相关的类都放在`java.nio`包下，并对原`java.io`包下的许多类的改写。

* NIO 由以下几个核心部分组成：
  * Channel
  * Buffer  
  * Selector  监听多个Channel通道的事件（连接请求、数据到达）

- NIO 是面向缓冲区，或者说面向块编程的。数据被读到了一个缓冲区，需要时可在缓冲区中前后移动。
- NIO 非阻塞模式，当一个线程从某通道发送请求读取数据，仅能得到可用的数据，没有可用数据时也不会阻塞读，当前线程可以干其他的事情。非阻塞写也是如此，一个线程请求写入一些数据到某通道，不需要等待它完全写入，这个线程可以同时做其他事情。
- NIO 可以用一个线程处理多个操作，1000个请求可以分配40-50个线程去处理，这就提高了处理的效率。
- HTTP2.0 使用多路复用的技术，做到同一个连接并发处理多个请求。

### 5. 什么是AIO？

Asynchronous IO 是 NIO 的升级，也叫 NIO2，实现了异步非堵塞 IO ，异步 IO 的操作基于事件和回调机制。适用于**连接数目多且连接比较长的架构**。

### 6. BIO、NIO有什么区别？ 

* BIO是面向流的，NIO是面向缓冲区的。
* BIO流是阻塞的，NIO是非阻塞模式。
* NIO的选择器允许一个单独的线程来监视多个输入通道，你可以注册多个通道使用一个选择器，然后使用一个单独的线程来“选择”通道。这些通道里已经有可以处理的输入，或者选择已准备写入的通道。这种选择机制，使得一个单独的线程很容易来管理多个通道。 

### 7. Channel Buffer  Selector  之间的关系？

1. 每个 Channel 都对应一个Buffer

2. Selector  对应一个线程，一个线程对应多个Channel 
3. 程序切换到哪个Channel 是由事件决定的，Event就是一个重要的概念
4. Selector  会根据不同的事件在各个通道 Channel 上切换
5. Buffer  本身就是一个内存块，数组结构
6. 数据的读取写入通过一个Buffer，Buffer 可以读写切换
7. Channel 是双向的，可以返回底层的操作系统的情况

### 8. 什么是零拷贝？

零拷贝：从计算机操作系统角度来说，内核缓冲区中只有一份数据（kernel buffer），没有重复的数据。零拷贝是网络编程关键，很多性能优化都离不开。

![1604812273603](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1604812273603.png)

DMA copy 又叫直接内存拷贝，不经过CPU拷贝。

* mmap(内存映射)

  mmap通过内存映射，将文件映射到到内核缓冲区，用户空间可以共享（传统IO是要经过CPU拷贝的）内核空间的数据。

* sendFile

  数据直接从内核缓冲区拷贝到协议栈。kernel buffer -->protocol engine

### 传统的NIO问题？Netty优点？

传统BIO编程难度低，可靠性差，吞吐量低。

传统NIO编程难度大，可靠性好，吞吐量高。

传统的NIO问题：

1）传统NIO类库和API复杂，使用麻烦

2）要熟悉多线程编程技术

3）开发工作量大

4）NIO bug 比如 Epoll bug，它会导致Selector空轮询。最终cpu100%，JDK1.7还没有解决。

Netty优点：

1)  使用方便，吞吐量更高

2)  安全：完整的SSL/TSL 和 StartTLS 支持



### Netty 架构设计

NioEventLoopGroup 事件循环组：

1）抽象出两个线程组，类型都是NioEventLoopGroup。线程数=cpu*2

* BossGroup 专门负责接收客户端的连接

* WorkerGroup 专门负责网络的读写

3）NioEventLoopGroup 包含多个事件循环，每一个事件循环都是NioEventLoop，一个NioEventLoop可以表示一个不断循环处理任务的线程。每个NioEventLoop都有一个Selector，用于监听其绑定的Socket网络通讯.

4）每个Boss NioEventLoop 循环执行的步骤：

* 轮询 accept 事件。
* 处理 accept 事件，与client建立连接，生成NioSocketChannel，并将其注册到某个worker NioEventLoop 上的Selector。
* 处理任务队列里的任务，即runAllTasks。

5）每个Worker NioEventLoop 循环执行的步骤:

* 轮询 read write 事件。
* 处理 read write 事件，即i/o事件，在对应的NioSocketChannel上处理。
* 处理任务队列里的任务，即runAllTasks。





### Netty 线程模型

传统阻塞I/O模型

Reactor模型：基于I/O复用模型，线程池复用模型。

* 单 Reactor 单线程
* 单 Reactor 多线程
* 主从 Reactor 多线程

Netty线程模型

主要基于主从 Reactor 多线程模型做了一定的改进。其中主从 Reactor 多线程模型有多个Reactor 。