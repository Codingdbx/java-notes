# Operating System Overview

计算机操作系统 (Computer Operating System ) 前言：

- About this Module 
  - 先修课程：计算机组成原理、高级语言程序设计、数据结构
  - Key words：principles、algorithms、datastructures、technical terms 

* Learning Objectives 
  - 掌握OS设计与实现原理、算法与数据结构
  - 学会基于(英文)文献的研究型学习/研究方法 
* Recommended Readings
  - 《Operating System Internals and Design principles》
  - 《 Applied Operating System Concepts》
* 关于学时
  - 64个学时



## 1 OS Overview

![1611232677292](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1611232677292.png)

## 2 Abstract

- 关于现代操作系统的四种基本观点（What's OS）
- 现代操作系统功能和非功能性需求（按软件工程的观点分析OS的结构）
- 操作系统的发展、类型及特征
- 现代操作系统体系结构基础知识

## 3 Learning Objectives

By the end of this chapter you should be able to：

- Explain what's OS
- Analyze the functional and non functional requirements of OS 
  - 分析OS的功能性与非功能性需求
- Technical Terms: 
  - Simple Batch Systems & BatchMultiprogramming
    - 简单批处理系统（单道批处理系统）
      - 单道（一个进程或一个线程）
      - 批处理（有一批作业在外存等待处理，进入内存后只能 one by one 的处理）
    - 多道批处理系统
  - Uniprogramming & Multiprogramming
    - 单道程序设计技术（一个系统只允许一个进程）
    - 多道程序设计技术
  - Time Sharing
    - 分时系统（一个进程运行一段时间切换另一个进程）
- 2 Different Concepts
  - Concurrency & Parallelism
    - 并发
    - 并行
- General Architecture of OS
  - 操作系统一般体系结构
- Modes of Execution
  - Single-Mode
  - Multi-mode
  - Dual-Mode
- Microkernels
  - 微核结构



## 4 What's OS

### 4.1 OS 结构图

![1611292727290](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1611292727290.png)

### 4.2 关于现代OS的四种基本观点

- User/Computer Interface：该观点认为OS是计算机用户使用计算机
  系统的接口，它为计算机用户提供了方便的工作环境。
- Virtual Machine：该观点认为OS是建立在计算机硬件平台上的虚拟机，它为应用软件提供了许多比计算机硬件功能更强或没有的功能。

- Resource Manager：该观点认为OS是计算机系统中各类资源的管理
  者，它负责分配、回收以及控制系统中的各种软硬件资源。
- Job Organizer：该观点认为OS是计算机系统工作流程的组织者，它负责协调在系统中运行的各个应用软件的运行程序。

## 5 OS 的系统需求 

软件系统的系统需求，所谓软件系统的系统需是指，人们从软件系统的外部对软件系统提出的诸多期望。

功能性需求：

- 软件系统能提供的服务

非功能性需求：

- 软件系统在提供这些服务时，需要满足的限制条件
- 软件系统具有适应某些变化的能力

### 5.1 OS 的功能性需求

- 计算机用户需要的 `User Interface`（用户命令）
  - 由OS实现的所有用户命令所构成的集合常被人们称为OS的 Interface（用户接口），也称为命令接口。
- 应用软件需要的 `System Call`（系统调用）
  - 由OS实现的所有系统调用所构成的集合被人们称为程序接口或应用编程接口（Application Programming Interface, API）。

#### User Interface

- 用户命令：指计算机用户要求计算机系统为其工作的指示。
- 命令的表示形式
  - 字符形式
  - 菜单形式
  - 图形形式
- 命令的使用方式
  - 脱机使用方式（off-line）
  - 联机使用方式（on-line）

注意：脱机和联机的区别是否在系统的控制下执行

#### System Call

- System Call：指由OS实现的应用软件在运行过程中可以引用的System Service。
- 当前两种常用的API
  - POSIX.1：Linux
  - WIN32API ：Windows

注意：程序接口事实上定义了一台虚拟计算机。该虚拟计算机包含一组抽象概念以及与这组抽象概念相关的系统服务。

### 5.2 OS 的非功能性需求

- Performance (性能) or Efficiency (效率)
  - maximize throughput
  - minimize response time
  - in the case of time sharing
  - accommodate as many users as possible
- Fairness(公平性)
  - give equal and fair access to all processes
- Reliability(可靠性)
- Security(安全性)
- Scalability(可伸缩性)
- Extensibility(可扩展性)
- Portability(可移植性)

### 5.3 OS 对硬件平台的依赖 

- Timer     计时器
- I/O Interrupts       IO中断
- DMA or Channel       直接存储/存取
- Privileged Instructions         硬件支撑的特权指令
- Memory Protection Mechanism       存储保护机制

MMU解释：Memory Manager Unit  

存储管理单元是用来做地址转换的，每条指令（代码）都必须要把虚拟地址转换为内存中的实际地址，而且硬件必须支持此功能。

## 6 基本概念

### 6.1 Job（作业）

- Job 是指计算机用户在一次上机过程中要求计算机系统为其所做工作的集合，作业中的每项相对独立的工作称为作业步。
- 通常，人们用一组命令来描述作业，其中每个命令定义一个作业步。
- 作业的基本类型
  - Off-line Job：计算机用户不能在此类作业被计算机系统处理时改变已定义好的作业步。
  - On-line Job：计算机用户可以在此类作业被计算机系统处理时随时改变其作业步。

### 6.2 Job Control language (JCL)

- Specialtype of programminglanguage
- Provides instruction to the monitor（监控程序）
  - what compiler to use
  - what data to use

### 6.4 Thread & Process

- Thread：是指程序的一次相对独立的运行过程。在现代OS中，线程是系统调度的最小单位。
- Process：是指系统分配资源的基本对象。在现代OS中，进程仅仅是系统中拥有资源的最小实体。不过在传统OS中，进程同时也是系统调度的最小单位。

### 6.5 Virtual Memory & File

- Virtual Memory：简单地说，就是进程的逻辑地址空间。它是现代OS对计算机系统中多级物理存储体系进行高度抽象的结果。
- File：简单地说，就是命名了的字节流。它是现代OS对计算机系统中种类繁多的外部设备进行高度抽象的结果。

虚拟内存：就是说把外存的一部分空间虚拟为内存使用。

## 7 OS 的演变、类型及特征 

Ease of Evolution of an Operating System

- Fixes
- New Services
- Hardware Upgrade Plus New Types of Hardware
- Efficieney

### 7.1 Serial Processing(串行处理)

- No operating system
- Machines run from a console with display lights and toggle switches, input device, and printer
- Two main problems:
- Scheduling: waste processing time
  - Setup time: Setup included loading the compiler, source program, saving compiled program, and loading and linking

### 7.2 Simple Batch Systems(简单批处理系统)

![1611301846878](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1611301846878.png)

- Monitors(监督程序): Software that controls the running programs
  - Resident monitor is in main memory and available for execution

- Batch jobs together
- Program branches back to monitor when finished

### 7.3 Uniprogramming(单道程序设计)

- Processor(处理器) must wait for I/O instruction to complete before proceeding(推进)
- Be inefficient

### 7.4 Multiprogramming(多道程序设计)

一个支持Multiprogramming的系统允许多道程序同时准备运行。当正在运行的那道程序因为某种原因（比如等待输入或输出数据）暂时不能继续运行时，系统将自动地启动另一道程序运行。一旦原因消除（比如数据已经到达或数据已经输出完毕），暂时停止运行的那道程序在将来某个时候还可以被系统重新启动继续运行。

When one job needs to wait for I/O, the processor can switch to the other job.

#### 多道批处理系统的实例 

| Example         | JOB1          | JOB2      | JOB3      |
| --------------- | ------------- | --------- | --------- |
| Type of job     | Heavy compute | Heavy I/O | Heavy I/O |
| Duration        | 5 min         | 15 min    | 10 min    |
| Memory required | 50K           | 100K      | 80K       |
| Need disk       | No            | No        | Yes       |
| Need terminal   | No            | Yes       | No        |
| Need printer    | No            | No        | Yes       |

#### 多道系统带来的问题 

Difficulties with Multiprogramming

- Improper synchronization(同步)
  - ensure a process waiting for an I/O device receives the signal
- Failed mutual exclusion(互斥)
- Nondeterminate program operation(不确定性)
  - program should only depend on input to it
- Deadlocks(死锁)

### 7.5 分时系统

Time Sharing(分时系统)

- Using multiprogramming to handle multiple interactive(交互) jobs
- Processor's time is shared among multiple users
- Multiple users simultaneously(同时) access the system through terminals

#### Batch Multiprogramming vs Time Sharing

多道批处理系统与分时系统比较

| 项目                                     | Batch Multiprogramming                              | Time Sharing                     |
| ---------------------------------------- | --------------------------------------------------- | -------------------------------- |
| Principal objective(主要目标)            | Maximize processor use                              | Minimize response time           |
| Source of directives to operating system | Job control language commands provided with the job | Commands entered at the terminal |

### 7.6 现代操作系统 

现代OS的基本类型，按硬件平台系统结构分类:

- 单机0S
- 并行0S
- 网络0S
- 分布式OS

#### 单机0S操作系统的特征 

按功能特征分类：

- Batch Processing OS (批处理系统)
- Time Sharing OS (分时系统)
- Real Time OS (实时系统)

现代0S的两个基本特征：

- 任务共行
  - 从宏观上看，任务共行是指系统中有多个任务同时运行。
    - Task Parallelism：多处理机系统中的任务并行，即多个任务在多个处理机上同时运行。
  - 从微观上看，任务共行是指单处理机系统中的任务并发。
    - Task Concurrency：多个任务在单个处理机上交替运行。
- 资源共享
  - 从宏观上看，资源共享是指多个任务可以同时使用系统中的软硬件资源
  - 从微观上看，资源共享是指多个任务可以交替互斥地使用系统中的某个资源

#### 任务管理模型

所谓 Task 模型是指，计算机系统在某个资源集合上所做的一次相对独立的计算过程。

- 在现代0S中，任务用`线程`和`进程`这两个基本概念共同表示，在传统0S中，任务仅仅用`进程`这一基本概念表示。
- 在现代0S中，任务管理模型用`线程状态转换图`表示，在传统0S中，任务管理模型用`进程状态转换图`表示。

#### 资源管理模式

所谓 Resource  模型是指，由程序和数据组成的软件资源以及包含CPU、存储器、I/O设备等在内的硬件资源。

- 通常情况下，系统用`竞争模式`管理软件资源，为此，系统将为共享同一软件资源的多个任务提供互斥机制。

- 对于硬件资源，系统常常用`分配模式`加以管理。该模式可以描述为：

  申请--分配--使用--释放--回收

## 8 OS Architecture

Operating System Architecture  （操作系统体系结构）

### 8.1 一种常见的OS总体结构风格

- 大多数现代OS其总体结构包含两类子系统
  - 一是用户接口子系统，用户接口子系统提供计算机用户需求的用户命令。
  - 二是基础平台子系统，基础平台子系统提供应用软件需求的系统调用。
- 用户接口子系统与基础平台子系统之间的相互关系具有单向性。
  - 具体地说，用户接口子系统在实现各种用户命令时能够引用基础平台子系统所提供的各种系统调用。
  - 但基础平台子系统在实现各种系统调用时不会引用用户接口子系统所提供的各种用户命令。

![1611670723226](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1611670723226.png)



### 8.2 OS基础平台子系统结构风格

#### 常见的基础平台子系统结构风格（一）

- Layered Structural Style (分层结构风格)
- Hierarchical Structural Style (分级结构风格)
- Modular Structural Style (分块结构风格)

分层结构风格的结构特征：

- 使用分层结构风格的基础平台子系统结构包含若干layer(层)。其中，每一层实现一组基本概念以及与其相关的基本属性。
- 层与层之间的相互关系，所有各层的实现不依赖其以上各层所提供的概念及其属性，只依赖其==直接下层==所提供的概念及属性。

分级结构风格的结构特征：

- 使用分级结构风格的基础平台子系统结构包含若干level(级)。其中，每一级实现一组基本概念以及与其相关的基本属性。
- 级与级之间的相互关系，所有各级的实现不依赖其以上各级所提供的概念及属性，只依赖其==以下各级==所提供的概念及属性。

分块结构风格的结构特征：

- 使用分块结构风格的基础平台子系统结构包含若干module(模块)。其中，每一块实现一组基本概念以及与其相关的基本属性。
- 块与块之间的相互关系，所有各块的实现均可以==任意引用其它各块==所提供的概念及属性。

##### 分层、分级、分块结构风格的关系

- 分层结构风格是一种特殊的分级结构风格
- 分级结构风格是一种特殊的分块结构风格

##### 分层、分块结构风格的比较 

- 分层结构风格
  - 有利于实现基础平台子系统的可维护性，可扩展性、可移植性、部件可重用性等业功能性需求
  - 不利于提高基础平台子系纯的时间和空间效率
  - 构造一个纯粹的分层结构将非常困难
- 分块结构风格
  - 构造一个分块结构是一种切合实际的做法
  - 有利于生成高效、紧凑的基础平台子系统可执行代码
  - 不利于实现基础平台子系统的灵活性

注：相对于分层结构风格以及分块结构风格，分级结构风格的长处和不足介于两者之间。



#### 常见的基础平台子系统结构风格（二）





### 8.3 双模式基础平台子系统结构风格

```


```



CPU是主要负责计算的， 它有多个核心（4核，6核，都是模拟出来的），本质上还是只有一个CPU在执行计算。

分时系统：按时间切片来（每个10秒），时间一到就切换下一个任务（切换时会发生中断），中断也会消耗性能，不能一直中断。

资源共享：磁盘读写，如果一个磁盘只有一个磁头，那么只能并发读写，如果一个磁盘有多个磁头（每个磁道有一个磁头），那么就可以实现并行读写。





```










```



```

```

