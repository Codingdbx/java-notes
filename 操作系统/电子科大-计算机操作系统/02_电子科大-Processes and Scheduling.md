# Processes and Scheduling

## 1 进程的描述与控制

进程：结构、PCB、状态。



### 1.1 进程概念与多进程并发执行 

#### 程序顺序执行时的特征

- 顺序性
- 封闭性
- 可再现性
  

#### 程序并发执行时的特征

- 间断性
- 非封闭性（进程之间互相有影响）
- 不可再现性

#### 程序并发执行条件（Bernstein条件）

Bernstein条件：就是讲两个过程如果有数据冲突(Data hazard)，那么就没法并发执行。

公式：`R(S1)`∩`W(S2)`∪`W(S1)`∩`R(S2)`∪`W(S1)`∩`W(S2)`={} 

举个例子：

```
S1: a=x+y；
S2: b=z+1；
S3: c=a-b；
S4: w=c+1；
```

那么它们的读集和写集分别如下：

```
R(S1)={x,y}, W(S1)={a}
R(S2)={z},   W(S2)={b}
R(S3)={a,b}, W(S3)={c}
R(S4)={c},   W(S4)={w}
```

套公式，是否等于空集，就能判断这四个语句能否并发执行了~



#### 进程 Process

- Also called a task

- Execution of an individual program

  - 进程是程序在一个数据集合上的运行过程，是系统进行资源分配和调度的一个独立单位

  - 进程是可并发执行的程序在一个数据集合上的运行过程

- Can be traced

  - list the sequence of instructions that execute

#### 进程特点 Characteristics of Process

- Dynamic (动态性)
- Concurrency (并发性)
- Independent (独立性)
- Asynchronous (异步性)

#### 进程结构 Process Structure

- Programs
- Datas
- PCB (Process Control Block) 进程控制块

### 1.2 Process States 进程的两状态和五状态

#### 进程的顺序执行与并发执行

案例：

假设内存中有3个进程A、B、C，他们的程序代码已全部装入内存。若A、C两进程需要执行12条指令，B进程需要执行4条指令，且B进程执行到第4条指令处必须等待 I/O。如何跟踪他们的执行过程?

![1612684306532](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1612684306532.png)

分派程序 (Dispatcher)：把处理器分派给程序

程序计数器(Program Counter)

调度程序(scheduler)

![1612684232784](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1612684232784.png)

#### 进程的两状态

- Running(执行) 

- Not-running(非执行)  

注意：

- 并非所有进程只要 Not-running 就处于 ready (就绪)，有的需要 blocked (阻塞) 等待I/O完成

- Not-running又可分为 ready 和 blocked 两种状态

  - ready 等待CPU
  - blocked 等待I/O

  

![1612701241769](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1612701241769.png)



#### 进程的五状态

- Running (执行)
  - 占用处理机(单处理机环境中，某一时刻仅一个进程占用处理机)
  - 一个CPU某一时刻，最多只有一个进程处于Running状态
- Ready (就绪)
  - 准备执行
- Blocked (阻塞)
  - 等待某事件发生才能执行，如等待I/O完成等
- New (新状态)
  - 进程已经创建，但未被OS接纳为可执行进程
- Exit (退出)
  - 因停止或取消，被OS从执行状态释放



![1612702997512](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1612702997512.png)



- Null --> New：新创建进程首先处于新状态
- New --> Ready：OS接纳新状态进程为就绪进程
- Ready --> Running：OS只能从就绪进程中选一个进程执行
- Running --> Exit：执行状态的进程执行完毕，或被取消，则转换为退出状态
- Ruming --> Ready：分时系统中，时间片用完，或优先级高的进程到来，将终止优先级低的进程的执行
- Running --> Blocked：执行进程需要等待某事件发生。通常因进程需要的系统调用不能立即完成，而阻塞
- Blocked --> Ready：当阻塞进程等待的事件发生，就转换为就绪状态
- Ready --> Exit：某些系统允许父进程在任何情况下终止其子进程。若一个父进程终止，其子孙进程都必须终止。
- Blocked -- Exit：同前

#### Using Two Queues

![1612703774353](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1612703774353.png)

多个阻塞队列：不同的事件，阻塞的原因不同，就进入不同的队列。

![1612703999050](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1612703999050.png)

### 1.3 交换技术

Swapping：对换技术、交换技术

将内存中暂时不能运行的进程，或暂时不用的数据和程序，`Swapping-out`到外存，以腾出足够的内存空间，把已具备运行条件的进程，或进程所需要的数据和程序，`Swapping-in`内存。

### 1.4 进程的挂起

现代操作系统进程不只5状态，有些是7状态。挂起是其中一个状态。

Suspended Processes

- Processor is faster than I/O so all 

  processes could be waiting for I/O

- Swap these processes to disk to free up more memory

- Blocked state becomes suspend state when swapped to disk

意义：处理器空闲时，通过交换技术，使进程挂起状态。

#### 挂起的原因 Reasons for Process Suspension

- **Swapping:** The operating system needs to release sufficient main memory to bring in a process that is ready to execute.
- **Other OS reason:** The operating system may supend a background or utility process or a process that is supected of causing a problem.
- **Interactive user request:** A user may wish to suspend execution of a program for purposes of debugging or in connection with the use of a resource.
- **Timing:** A process may be executed periodically (e.g, an accounting or system monitoring process) and may be suspended while waiting for the next time interval.
- **Parent process request: **A parent process may wish to suspend execution of a descendent to examine or modify the supended process,or to coordinate the activity of various descendents.

#### 被挂起进程的特征

- 不能立即执行。

- 可能是等待某事件发生。若是，则阻塞条件独立于挂起条件，即使阻塞事件发生，该进程也不能执行。

  即阻塞解除后，也不能立马执行，阻塞和挂起是两个独立的过程。

- 使之挂起的进程为：自身、其父进程、OS。

- 只有挂起它的进程才能使之由挂起状态转换为其他状态。

#### 挂起与阻塞 Suspend vs Blocked

- 是否只能挂起阻塞进程?

  不是，只不过阻塞的时候，在内存阻塞不如到外存阻塞，效果一样，且不占用内存。

- 如何激活一个挂起进程?

  挂起实际就是一个I/O过程，基于交换技术

- 区分两个概念

  - 进程是否等待事件，阻塞与否。
  - 进程是否被换出内存，挂起与否。

- 4种状态组合

  - Ready：进程在内存，准备执行。
  - Blocked：进程在内存，等待事件。
  - Ready，Suspend：进程在外存，只要调入内存即可执行。
  - Blocked，Suspend：进程在外存，调入内存等待事件发生才可执行。

注意：处理机可调度执行的进程有两种

- 新创建的进程

- 或换入一个以前挂起的进程

  通常为避免增加系统负载，系统会换入一个以前挂起的进程执行。

#### 进程7状态转换图

Add Two Suspend States

![1616834052772](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1616834052772.png)

### 1.5 具有挂起状态的进程状态转换

- `Blocked`-->`Blocked,Suspend`：OS通常将阻塞进程换出，以腾出内存空间。
- `Blocked,Suspend`-->`Ready,Suspend`：当`Blocked,Suspend`，进程等待的事件发生时，可以将其转换为`Ready,Suspend`。
- `Ready,Suspend`-->`Ready`：OS需要调入一个进程执行时。
- `Ready`-->`Ready,Suspend`：一般OS挂起阻塞进程。但有时也会挂起就绪进程，释放足够的内存空间。
- `New`-->`Ready,Suspend` (New-->Ready)：新进程创建后，可以插入到 `Ready` 队列或`Ready,Suspend`队列。若无足够的内存分配给新进程，则需要`New` --> `Ready,Suspend`。
- `Blocked,Suspend`-->`Blocked`：当`Blocked,Suspend`队列中有一个进程的阻塞事件可能会很快发生，则可将一个`Blocked,Suspend`进程换入内存，变为`Blocked`。
- `Running`-->`Ready,Suspend`：当执行进程的时间片用完时，会转换为`Ready`。或一个高优先级的`Blocked,`
  `Suspend`进程正好变为非阻塞状态，OS可以将执行进程转换为`Ready,Suspend`状态。
- `AIl`-->`Exit`：通常，`Running`-->`Exit`。但某些OS中，父进程可以终止其子进程，使任何状态的进程都可转换为退出状态。

注意：只要是supend，就有内外存交换。

## 2 操作系统如何管理进程资源

通过各种 tables(操作系统表)、原语操作。

### 2.1 操作系统控制结构 Operating System Control Structures

操作系统用表来记录各种信息，若干个表来管理系统资源。

- Information about the current status of each process and resource
- Tables are constructed for each entity the operating system manages
  - Memory Tables
  - I/O Tables
  - File Tables
  - Process Table

#### Memory Tables

- Allocation of main memory to processes.
  - 分配，内存
- Allocation of secondary memory to processes.
  - 分配，外存
- Protection attributes for access to shared memory regions.
  - 保护属性，共享内存区域
- Information needed to manage virtual memory.
  - 虚拟存储

#### I/O Tables

- I/O device is available or assigned.
  - 空闲可用的，已经分配的
- Status of I/O operation.
- Location in main memory being used as the source or destination of the I/O transfer.

#### File Tables

- Existence of files.
- Location on secondary memory.
- Current Status.

* Attributes.
* Sometimes this information is maintained by a file-management system.

#### Process Table

- Where process is located.
- Attributes necessary for its management.
  - Process ID
  - Process state
  - Location in memory

#### Process Location

- Process includes set of programs to be executed.
  
  包含一组程序
  
  - Data locations for local and global variables
  - Any defined constants
  - Stack
  
- Process control block(PCB).
  
  - Collection of attributes
  
- Process image. (进程映像)
  
  - Collection of program, data, stack, and attributes.

#### Process image

- User Data

* User Program
* System Stack：存放系统及过程调用地址、参数
* Process Control Block (PCB)：OS感知进程、控制进程的数据结构

![1617007949684](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1617007949684.png)

### 2.2 进程控制块 Process Control Block

简称 PCB：是OS控制和管理进程时所用的基本数据结构。

作用：PCB是相关进程存在于系统中的唯一标志，系统根据PCB而感知相关进程的存在。

#### Process identification

- Identifiers
  - Identifier of this process(进程ID)
  - Identifier of the process that created this process(parent process)(父进程ID)
  - User identifier (用户ID)



#### Processor State Information

- User-Visible Registers (用户可见寄存器)   现代计算机多级存储体系最高一级就是用户可见寄存器

  - A user-visible register is one that may be referenced by means of the machine language that the processor executes. (处理器可以直接访问的)
  - Typically, there are from 8 to 32 of these registers, although some ==RISC== implementations have over 100. (CPU用硬件实现的少量经典指令集)

- Control and Status Registers (控制和状态寄存器)

  There are a variety of processor registers that are employed to control the operation of the processor. These include：

  - Program counter: Contains the address of the next instruction to be fetched

    程序计数器

  - Condition codes: Result of the most recent arithmetic or logical operation (e.g,sign, zero,carry,equal, overflow)

    条件代码寄存器

  - Status information: Includes interrupt enabled/disabled flags, execution mode

    状态信息

- Stack Pointers (堆栈指针)

  - Each process has one or more last-in-first-out(LIFO) system stacks associated with it. A stack is used to store parameters and calling addresses for procedure and system calls.

    先进后出 堆栈  存储一些过程调用参数

  - The stack pointer points to the top of the stack.

    堆栈指针 指向它的栈顶



#### Process Control Information 

- Scheduling and State Information (调度和状态信息)

  - Process state: defines the readiness of the process to be scheduled for execution (e.g, running, ready,waiting, halted).

    记录进程的状态

  - Priority: One or more fields may be used to describe the scheduling priority of the process.

    优先级

  - Scheduling-related information: This will depend on the scheduling algorithm used.

  - Event: Identity of event the process is awaiting before it can be resumed.

    记录什么事件  恢复之前

- Data Structuring

  - A process may be linked to other process in a queue, ring, or some other structure

    进程之间是有关系的

  - A process may exhibit a parent-child (creator-created) relationship with another process

    展示 父子关系

  - The process control block may contain pointers to other processes to support these structures

    通过指针实现这种关系

- Interprocess Communication (进程之间的通信)

  - Various fags, signals, and messages may be associated with tommunication between two independent processes.

    标志 信号 消息

- Process Privileges (进程的一些特权保护)

  - Processes are granted privileges in terms of the memory that may be accessed and the types of
    instructions that may be executed.

    授予 特权 关于

- Memory Management

  - This section may include pointers to `segment and/or page tables` that describe the virtual memory assigned to this process.

    内存是分段划分还是分页划分

- Resource Ownership and Utilization (资源被占用和使用)

  - Resources controlled by the process may be indicated,such as opened files. A history of utilization of the processor or other resources may also be included; this information may be needed by the scheduler.

### 2.3 操作系统内核功能  Typical Function of an OS Kernel

#### 资源管理功能

操作系统相当于电脑的资源管理器，企业会计

- Process Management：进程创建和终止、调度、状态转换、同步和通信、管理PCB
- Memory Management：为进程分配地址空间、数据对换、段/页式管理
- I/O Management：缓存管理、为进程分配I/O通道和设备

#### 支撑功能

- Interrupt handling (中断处理)
- Timing (时钟管理) 
- Primitive (原语)：Atomic Operation，原语操作：原子操作，即不可中断的操作，一定会完成
- Accounting (统计)
- Monitoring (监测)

## 3 原语 Process Control Primitives

操作系统内核给用户提供系列的服务，这个服务以原语 PCP 的方式出现。

- Process Switch    进程切换

- Create and Terminate    创建与终止

- Block and Wakeup    阻塞与唤醒

- Suspend and Activate    挂起与激活

### 3.1 进程切换 Process Switch

什么时候进行进程切换（When to Switch a Process）

- Clock interrupt
  - process has executed for the maximum allowable time slice (时间片)
- I/O interrupt
- Memory fault (存储访问失效)
  - memory address is in virtual memory so it must be brought into main memory
- Trap (陷阱)
  - error occurred
  - may cause process to be moved to Exit state
- Supervisor call (管理程序调入)
  - such as file open

进程切换时的状态变化（Change of Process State）

- Save context of processor including program counter and other registers

  保存处理器上下文，包括程序计数器和其他寄存器

- Update the PCB of the process that is currently running

  更新当前正在运行的进程的PCB数据

- Move PCB to appropriate queue-ready, blocked 

  将PCB移至适当的队列就绪状态，阻塞

- Select another process for execution

  启动调度程序，调度其他进程执行

- Update the PCB of the process selected

  更新被选择进程的PCB数据

- Update memory-management data structures

  更新内存管理的数据结构

- Restore context of the selected process

   恢复被选择执行的进程的上下文 

#### 进程切换与模式切换

- 进程的切换
  - 保存第一个进程的上下文，修改他的PCB，修改内存数据，启动调度程序，调度新进程进来，恢复被选择的进程的上下文。
- 模式切换
  - 用户进程正在运行的时候，一般正常运行在用户态下，运行过程中，如果发生系统调用，用户态切换进入系统态（为了保护系统数据不受非法篡改，需要审核，判断是否有操作权限，审核的过程就叫软中断）审核通过，用户态切换到系统态成功。系统调用完成后，返回用户态。
- 进程切换的时候，需要调度程序，调度程序就是系统调用命令，需要进行模式切换。还有中断程序，中断也是在系统态下面运行的。
- 进程切换一定有模式切换，但是模式切换不一定有进程切换。

总结：

- Process Switch，是作用于进程之间的一种操作。当分派程序收回当前进程的CPU并准备把它分派给某个就绪进程时，该操作将被引用。

- Mode Switch，是进程内部所引用的一种操作。当进程映像所包含的程序引用核心子系统所提供的系统调用时，该操作将被引用。

  

### 3.2 进程的创建 Process Creation

1.Submission of a batch job

2.User logs on

3.Created to provide a service such as printing

4.Process creates another process

#### 创建原语 creat() 

1. 为进程分配一个唯一标识号ID：主进程表中增加一个新的表项
2. 为进程分配空间：用户地址空间、用户栈空间、PCB空间。若共享已有空间，则应建立相应的链接。
3. 初始化PCB：进程标识、处理机状态信息、进程状态
4. 建立链：若调度队列是链表，则将新进程插入到就绪或(就绪，挂起)链表

总结：创建进程 = 分配资源，创建ID，分配PCB

### 3.3 进程的终止 Process Termination

- Batch job issues Halt instruction （暂停指令）
- User logs off
- Quit an application
- Error and fault conditions

终止原因 Reasons for Process Termination：

- Normal completion    正常结束
- Time limit eceeded     超时终止，执行时间超过预计时间
- Memory unavaitable   内存不足,无法为进程分配所需的内存空间
- Bounds violation      越界访问
- Protection error    企图使用未允许用的数据，或操作方式错
- Arithmetic error    计算错，如除零，或企图存储硬件允许的最大数
- Time ovrrun          超时等待某事件发生
- I/O failure    如找不到文件或多次重试仍无法读写文件，或无效操作
- Invalid instruction      企图执行不存在的指令
- Privileged instruction    企图执行特权指令
- Data misuse      数据类型不符，或未初始化
- Operating system intervention   操作员或OS干预，如发生死锁的时候
- Parent terminates so child processes terminate 父进程终止
- Parent request   进程自己要求

#### 终止原语 destroy() 

1. 根据被终止进程的标识符ID，找到其PCB，读出该进程的状态
2. 若该进程为执行状态，则终止其执行，调度新进程执行
3. 若该进程有子孙进程，则立即终止其所有子孙进程
4. 将该进程的全部资源，或归还给其父进程，或归还给系统
5. 将被终止进程的 PCB 从所在的队列中移出，等待其它程序来搜集信息

僵尸进程  zombie ：僵死状态，不能够运行了。但PCB还在，还会存活一会儿供其他进程使用，比如统计数据。

### 3.4 进程的阻塞与唤醒 Process Block and Wakeup

阻塞的原因：

- 请求系统服务

- 启动某种操作：如I/O

- 新数据尚未到达

- 无新工作可做

#### 阻塞原语 block()

当出现阻塞事件，进程调用阻塞原语将自己阻塞。状态变为“阻塞状态”，并进入相应事件的阻塞队列。

#### 唤醒原语 wakeup()

当阻塞进程期待的事件发生，有关进程调用唤醒原语，将等待该事件的进程唤醒。状态变为Ready，插入就绪队列。

### 3.5 进程的挂起与激活 Process Suspend and Active 

#### 挂起原语 suspend()

当出现挂起事件，系统利用挂起原语将指定进程或阻塞状态进程挂起。进程从内存换到外存，状态改变：

Ready-->Ready,Suspend，插入相应队列。

#### 激活原语 active()

当激活事件发生，系统利用激活原语将指定进程激活。进程从外存换入到内存，状态改变：
Ready,Suspend-->Ready。Blocked,Suspend-->Blocked，插入相应队列。

注意：从外存把进程装回内存来，但不一定是原来的空间了。



## 4 线程 Thread

### 4.1 线程概述

- An execution state (running, ready, etc.)
- Saved thread context when not running.
- Has an execution stack.
- Some per-thread static storage for local variables.
- Access to the memory and resources of its process.
  - all threads of a process share this.

####  Benefits of Threads 

- Takes less time to create a new thread than a  process. 

   创建过程，只需要很少的资源，所以很快

- Less time to terminate a thread than a process.

- Less time to switch between two threads within the same process.

  同一进程内的线程切换，开销小

- Since threads within the same process share memory and files, they can communicate with each other without invoking the kernel.

#### Threads feature

- Suspending a process involves suspending all threads of the process
  - since all threads share the same address space.
- Termination of a process, terminates all threads within the process.

#### Thread States

- Key states for a thread
  - Running
  - Ready
  - Blocked

- Operations associated with a change in thread state.
  - Spawn(派生)，Spawn another thread
  - Block
  - Unblock
  - Finish

#### 多线程 Multithreading

- Operating system supports multiple threads of execution within a single process.

- MS-DOS supports a single thread.

- UNIX supports multiple user processes but only supports one thread per process.

  以前传统unix系统是单进程单线程，可以有多个进程现代unix，多用户多进程，一个进程里可以有多线程

- Windows 2000, Solaris, Linux, Mach, and OS/2 support multiple threads.

#### 线程与进程的关系

主要还是程序、数据、PCB。

![1619532680242](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1619532680242.png)



### 4.2 线程状态与线程分类

#### 线程状态  Thread States

- Key states for a thread: Running, Ready, Blocked.
- Operations associated with a change in thread state.
  - Spawn(派生), Spawn another thread
  - Block
  - Unblock
  - Finish

#### 线程分类 Thread Types

User-Level Threads

- All thread management is done by the application
- The kernel is not aware of the existence of threads
- 描述此类线程的数据结构以及控制此类线程的原语在核外子系统中实现

Kernel-Level Threads

- W2K, Linux, and OS/2 are examples of this approach
- Kernel maintains context information for the process and the threads
- Scheduling is done on a thread basis 调度是基于线程完成的
- 描述此类线程的数据结构以及控制此类线程的原语在核心子系统中实现

Combined Approaches 组合类型

- Example is Solaris
- Thread creation done in the user space
- Bulk(大批) of scheduling and synchronization of threads done in the user space 用户空间可以完成调度与同步



创建进程多了之后，开销很大，负载增加了许多，管理起来较麻烦。线程是为了满足多道程序并发，降低系统开销的而设计的。

进程是资源分配单位，线程是调度单位，不在拥有大量的资源。线程是共享了进程的资源

但是线程不在分配资源，释放资源，所以系统开销就低了。还提高了并发度

线程不在考虑程序空间，数据空间，共享进程的一切资源，但可能出现并发安全问题

线程之间切换避免了进程切换，和模式切换



## 5 进程调度 Scheduling

必须要从队列里面选择哪个作业的时候，才会有调度以及调度算法。

### Learning objectives 学习目标

By the end of this lecture you should be able to：

- Explain what's Response Time(响应时间)，Turnaround time (周转时间)，Deadlines(截止时间)，Throughput(吞吐量)。
- 理解：进程调度的目标、类型、原则。
- 理解：Decision Mode: Nonpreemptive(非剩本) & Preemptive (剩本)。
- 研究经典进程调度算法：
  - FCFS
  - Round Robin(轮转)
  - Shortest Process Next
  - Shortest Remaining Time
  - Highest Response Ratio Next
  - Feedback
- 理解：Real-Time Systems 及类型。
- 理解掌握：Real-Time Scheduling, Deadline Scheduling, Rate Monotonic Scheduling(速度单调)。

### Process Scheduling 进程调度

- Types of scheduling
  - 按0S的类型划分
    - 批处理调度、分时调度、实时调度、多处理机调度
  - 按调度的层次划分
    - Long-term scheduling(长程调度)
    - Medium-term scheduling(中程调度)
    - Short-term scheduling(短程调度)
- Scheduling Criteria (标准)
- Scheduling Algorithms
- Real-Time Scheduling

注意：

长程调度：作业从外存到内存。 new --> ready

中程调度：suspend --> ready

短程调度：ready --> running

![1622620507335](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1622620507335.png)

### Types of scheduling(调度类型)

#### Long-term scheduling

又称为高级调度、作业调度，它为被调度作业或用户程序创建进程、分配必要的系统资源，并将新创建的进程插入就绪队列，等待Short-term scheduling。

- Determines which programs are admitted to the system for processing

  这取决于调度算法，如FCFS、短作业优先、基于优先权、响应比高者优先等调度算法

- How may programs are admitted to the system ?

  Controls the degree of multiprogramming

- When does the scheduler be invoked?

  - Each time a job terminates

  - Processor is idle exceeds a certain threshold 阈值

#### Medium-term scheduling

又称为中级调度，它调度换出到磁盘的进程进入内存，准备执行。

- 中程调度配合对换技术使用。
- 其目的是为了提高内存的利用率和系统吞吐量。
- 在多道程序度允许的情况下，从外存选择一个挂起状态的进程调度到内存(换入)。

#### Short-term scheduling

又称为进程调度，低级调度，调度内存中的就绪进程执行。

* Known as the dispatcher：决定就绪队列 which 进程将获得处理机
* Executes most frequently  频繁地
* Invoked when an event occurs
- Clock interrupts
- l/O interrupts
- Operating system calls
- Signals(信号)

### Scheduling Criteria (调度标准)

User-oriented 面向用户：

#### Response Time(响应时间)

- Elapsed time between the submission(提交) of a request until there is output

- 常用于评价分时系统的性能

#### Turnaround time (周转时间)

- 是指从作业提交给系统开始，到作业完成为止的这段时间间隔(也称为作业周转时间)
- 常用于评价批处理系统的性能

#### Deadlines (截止时间)

- 是指某任务必须开始执行的最迟时间(Starting deadline)，或必须完成的最迟时间(Completion deadline)
- 常用于评价实时系统的性能。

System-oriented 面向系统：

#### Throughput(吞吐量)

- 单位时间内系统所完成的作业数
- 用于评价批处理系统的性能

#### Processor utilization(处理机利用率)

- This is the percentage of time that the processor is busy.
- Effective and efficient utilization of the processor.

#### Balancing Resource(资源平衡)

- Keep the resources of the system busy.
- 适用于长程调度和中程调度.

#### Fairness (公平性)

- Process should be treated the same, and no process should suffer starvation.

#### Priorities(优先级)

- Scheduler will always choose a process of higher priority over one of lower priority.
- Have multiple Ready queues to represent each level of priority.
- Lower-priority may suffer starvation.
  - allow a process to change its priority based on its age (生存期)or execution history.



### Scheduling Algorithms(调度算法)

#### Decision Mode(决策模式)

- Nonpreemptive(非剥夺方式）
  - Once a process is in the running state, it will continue until it terminates or blocks itself for I/O.
  - 主要用于批处理系统.
  - 不会中断.

- Preemptive(剥夺方式)
  - Currently running process may be interrupted and moved to the Ready state by the operating system.
  - Allows for better service since any one process cannot monopolize the processor for very long.
  - 主要用于实时性要求较高的实时系统及性能要求较高的批处理系统和分时系统.
  - 会中断.

#### Algorithms(算法)

- First-Come-First-Served 先到先服务
- Round Robin (Virtual round robin)  轮询调度算法
- Shortest Process Next  短进程优先 
- Shortest Remaining Time  最短剩余时间优先调度 
- Highest Response Ratio Next  最高响应比优先算法
- Feedback  排队算法

##### First-Come-First-Served (FCFS)

- Each process joins the Ready queue.
- When the current process ceases(停止) to execute, the oldest process in the Ready queue is selected.
- 非剥夺方式：一旦占有就要执行完，不会中断，执行完后下个进程才能执行.
- 计算进程的平均周转时间.
- A short process may have to wait a very long time before it can execute.
- Favors CPU-bound processes.
  - I/O processes have to wait until CPU-bound process completes.



### Real-Time Systems 实时系统

- Correctness of the system depends not only on the logical result of the computation but also on
  the time at which the results are produced.

- Tasks or processes attempt to control or react to events that take place in the outside world.

- These events occur in "real time" and process must be able to keep up with them.

#### Real-Time Systems 实时系统应用

- Control of laboratory experiments
- Process control plants
- Robotics

* Air traffic control
* Telecommunications
* Military command and control systems

- 实时控制系统，指要求进行实时控制的系统。用于生产过程的控制，实时采集现场数据，并对所采集的数据进行及时处理。如飞机的自动驾驶系统，以及导弹的制导系统等。

- 实时信息处理系统，指能对信息进行实时处理的系统。典型的实时信息处理系统有：飞机订票系统、情报检索系统等。

#### Real-time Task 实时任务

- 按任务执行时是否呈现周期性来划分
  - periodic  (周期性)实时任务
  - aperiodic (非周期性)实时任务，必须联系着一个deadline
- 根据对截止时间的要求来划分
  - hard real-time task(硬实时任务)，系统必须满足任务对截止时间的要求，否则可能出现难以预测的结
    果。
  - soft real-time task(软实时任务)

### Scheduling Types 调度类型

- Scheduling of a Real-Time Process 实时进程的调度

- Real-Time Scheduling 实时调度

- Deadine Scheduling 截止时间调度

- Rate Monotonic Scheduling  速率单调调度

#### Scheduling of a Real-Time Process 

实时进程的调度

##### Round Robin Preemptive Scheduler 

(基于时间片的轮转调度法)

- 响应时间在秒级。
- 广泛应用于分时系统，也可用于一般的实时信息处理系统。
- 不适合于要求严格的实时控制系统。

##### Priority-driven Nonpreemptive Scheduler 

(基于优先级非剥夺调度法)

- 为实时任务赋予较高的优先级，将它插入就绪队列队首，只要正在执行的进程释放Processor，则立即调度该实时任务执行。
- 响应时间一般在数百毫秒至数秒范围。
- 多用于多道批处理系统，也可以用于要求不太严格的实时系统。

##### Priority-driven Preemptive Scheduler

 (基于优先级的剥夺调度法)

- 当实时任务到达后，可以在时钟中断时，剥夺正在执行的低优先级进程的执行，调度执行高优先级的任务。
- 响应时间较短，一般在几十毫秒或几毫秒。

##### Immediate Preemptive Scheduler

 (立即剥夺调度法)

- 要求操作系统具有快速响应外部事件的能力。一旦出现外部中断，只要当前任务未处于临界区，便立即剥夺其执行，把处理机分配给请求中断的紧迫任务。
- 调度时延可以降至100微秒，甚至更低。

#### Real-Time Scheduling 

实时调度

- Static table-driven (静态表驱动调度法)
  - Determines(确定) at run time when a task begins execution.

- Static priority-driven preemptive (静态优先级剥夺调度法)
  - Traditional priority-driven scheduler is used.

- Dynamic planning-based (动态计划调度法)

- Dynamic best effort (动态最大努力调度法)

##### Static table-driven approaches

- 用于调度周期性实时任务。
- 按照任务周期到达的时间、执行时间、完成截止时间(ending deadline)以及任务的优先级，制订调度表，调度实时任务。
- 最早截止时间优先(EDF)调度算法即属于此类。
- 此类算法不灵活，任何任务的调度申请改动都会引起调度表的修改。

##### Statie priority-driven preemptive approaches

- 此类算法多用于非实时多道程序系统。
- 优先级的确定方法很多，例如在分时系统中，可以对I/O bound (密集型)和 processor bound的进程赋予不同的优先级。
- 实时系统中一般根据对任务的限定时间赋予优先级，例如速度单调算法(RM)即是为实时任务赋予静态优先级。

##### Dynamic planning-based approaches

- 当实时任务到达以后，系统为新到达的任务和正在执行的任务动态创建一张调度表。
- 在当前执行进程不会错过其截止时间的条件下，如果也能使新到达任务在截止时间内完成，则立即调度执行新任务。

##### Dynamic best effort approaches

实现简单，广泛用于非周期性实时任务调度。当任务到达时，系统根据其属性赋予优先级，优先级高的先调度。例如最早截止时间优先EDF调度算法就采用了这种方法。这种算法总是尽最大努力尽早调度紧迫任务，因此称为“最大努力调度算法”缺点在于，当任务完成，或截止时间到达时，很难知道该任务是否满足其约束时间。

#### Deadline Scheduling

截止时间调度

- Information used
  - Ready time
  - Starting deadline
  - Completion deadine
  - Processing time
  - Resource requirements
  - Priority
  - Subtask scheduler：一个任务可以分解出强制子任务(mandatory subtask)和非强制子任务(optional subtask)。只有强制子任务拥有硬截止时间(hard deadline)。

**Which task to schedule next?**

Scheduling tasks with the earliest deadline minimized the fraction of tasks that miss their deadines.

用最早的截止日期安排任务可以最大限度地减少错过截止日期的任务的比例。

**What sort of preemption is allonwed?**

- When starting deadlines are specified, then a nonpreemtive(非抢占式) scheduler makes sense.

  在执行完强制子任务或临界区后，阻塞自己。

- For a system with completion deadlines, a preemptive strategy is most appropriate.

##### Earliest Deadline

最早截止时间优先算法，简称ED

- 常用调度算法
- 若指定任务的Starting deadlines，则采用Nonpreemption，当某任务的开始截止时间到达时，正在执行的任务必须执行完其强制部分或临界区，释放CPU，调度开始截止时间到的任务执行。

##### Periodic tasks with completion deadlines

周期性任务实时调度算法

- 由于此类任务是周期性的、可预测的，可采用静态表驱动之最早截止时间优先调度算法，使系统中的任务都能按要求完成。

- 举例：周期性任务A和B，指定了它们的完成截止时间，任务A每隔20毫秒完成一次，任务B每隔50
  毫秒完成一次。任务A每次需要执行10毫秒，任务B每次需要执行25毫秒。

##### Aperiodic tasks with starting deadlines

非周期性任务实时调度算法

- 可以采用 最早截止时间优先调度算法 或 允许CPU空闲的EDF调度算法。
- Earliest Deadline with Unuforced Ide Times (允许CPU空闲的EDF调度算法)，指优先调度最早截止时间的任务，并将它执行完毕才调度下一个任务。即使选定的任务未就绪，允许CPU空闲等待，也不能调度其他任务。尽管CPU的利用率不高，但这种调度算法可以保证系统中的任务都能按要求完成。

##### Rate Monotonic Scheduling

速度单调调度算法

* Assigns priorities to tasks on the basis of their periods.
* Highest-priority task is the one with the shortest period.
* Period(任务周期)，指一个任务到达至下一任务到达之间的时间范围。
* Rate(任务速度)，即周期(以秒计)的倒数，以赫兹为单位。

Rate Monotonic Scheduling
(速度单调调度算法)

- 任务周期的结束，表示任务的硬截止时间。任务的执行时间不应超过任务周期。
- CPU的利用率 = 任务执行时间/任务周期
- 在RMS调度算法中，如果以任务速度为参数，则优先级函数是一个单调递增的函数。



## 6 进程并发控制

Learning objectives 并发学习的目标

- Concurrency Control

- Mutual Exclusion and Synchronization
- Deadlock And Starvation

By the end of this lecture you should be able to:

- Esplain what's Concurreney, Synchronization, Mutual exclusion, Deadlock, Starvation, Critical sections

- 掌握 Requirements for Mutual Exclusion
- 掌握 Approaches of Mutual Exclusion: Software Approaches & Hardware Suppot: Semaphores, Monitors, Message Passing

- 区别掌握 Types and meanings of Semaphores
- 掌握3个经典问题的解决方法：Produer/Consumer Problem, Readers/Writers Problem, Dining Philosophers Problem

- 理解 Conditions for Deadlock, Deadlock Prevention, Deadlock Avoidance, Deadlock Detection, Strategies once Deadlock Detected(检测到死锁后的策略), Banker's Algorithm (Safe State `vs` Unsafe State)

Design Issues of Concurrency

涉及到的并发问题 

- Communication among processes

- Sharing/Competing of resources

- Synchronization of multiple processes

- Allocation of processor time

Difficulties with Concurrency

并发挑战

- Sharing global resources

- Management of allocation of resources

- Programming errors difficult to locate

Operating System Concerns

- Keep track of active processes: PCB  
- Allocate and deallocate resources
  - Processor time: scheduling
  - Memory: virtual memory
  - Files
  - I/O devices
  - Protect data and resources
  - Result of process must be independent of the speed of execution of other concurrent processes.

Process Interaction

进程交互

- Processes unaware of each other
  - Competition
  - Mutual exclusion, Deadlock, Starvation
- Processes indirectly aware of each other
  - Cooperation by sharing
  - Mutual esclusion, Deadlock, Starvation, Data coherence(一致性)
- Process directly aware of each other
  - Cooperation by communication
  - Deadlock, Starvation

### 临界资源、临界区与互斥

##### Competition Among Processes for Resources

- Mutual Exclusion(互斥)
  - Critical sections (临界区)
  - Only one program at a time is allowed inits critical section.
  - Eg. Only one process at a time is allowed to send command to the printer (critical resource).

- Deadlock
- Starvation

##### Cooperation Among Processes by Sharing

进程之间通过共享合作

- Writing must be mutually exclusive.

  写之间必须互斥，读写必须互斥。读读不需要互斥

- Critical sections are used to provide data integrity (数据完整性)

##### Cooperation Among Processes by Communication

进程之间通过通信来合作

- Messages are passed 
  - Mutual exclusion is not a control requirement.

- Possible to have deadlock
  - Each process waiting for a message from the other process
- Possible to have starvation
  - Two processes sending message to each other while another process waits for a message.
    3个进程，2个进程之间非常活跃，另外一个总是等待。

### 互斥的要求

Requirements for Mutual Exclusion

- Only one process at a time is allowed in the critical section for a resource.

- A process that halts(停止) in its non-critical section must do so without interfering(干扰) with other processes.  进程在非临界区终止了，也不能影响其他进程。
- No deadlock or starvation.
- A process must not be delayed access to a critical section when there is no other process using it.  一个进程不能被延迟访问临界区，当没有其他进程使用临界区的时候。
- No assumptions are made about relative process speeds or number of processes. 不能假设其他进程的速度，和进程数量。
- A process remains inside its critical section for a finite(有限) time only. 进程在临界区之间有限时间。



### 实现互斥的方法

Approaches of Mutual Exclusion，5种方法

- Sofoware Approaches
- Hardware Support
- Semaphores
- Monitors 管程
- Message Passing

#### Software Approaches 

软件方式实现互斥

- Memory access level 内存访问级别 (0,1)

* Access to the same location in main memory are serialized(串行化) by some sort of memory arbiter( 内存仲裁器).

* Dekker's Algorithm  德克尔算法

* Peterson's Algorithm 彼得森算法

  

#### Hardware Support

硬件方式实现互斥 

Mutual Exclusion: Hardware Support

##### Interrupt Disabling

 屏蔽中断 

- A process runs until it invokes an operating-system service or until it is interrupted.

- Disabling interrupts guarantees mutual exclusion.

- 方法带来的问题：

  - The price of this approach is high  代价很高

  - Multiprocessing 多进程系统，Disabling interrupts on one processor will not guarantee mutual exchusion.

##### Special Machine Instruction

专用机器指令

- Performed in a single instruetion cycle
- Not subject to interference from other instructions (避免冲突)

- Reading and writing
- Reading and testing

专用机器指令好处：一个机器指令过程中不会有中断点

**Test and Set Instruction** 

这是一条指令，不是几行代码。

```shell
function testset(vari:integer): boolean;
    begin
    if i=0 then
    	begin
            i:=1;
            testset := true;
   	 	end
    else testset :=false;
end.
```

**Exchange Instruction** 

```shell
procedure exchange(var r :register, var m :memory);
var temp;
begin
    temp :=m;
    m :=r;
    r :=temp;
end.
```

Mutual Exclusion Machine Instructions

机器指令实现互斥的优缺点

Advantages

- Applicable to any number of processes on either a single processor or multiple processors sharing main memory.
- It is simple and therefore easy to verify.
- It can be used to support multiple critical sections.

Disadvantages
- Busy-waiting is employed. 忙等，占用处理器时间

  下个进程又进不去临界区，又回到就绪队列，下次还会被调用。

- Starvation is possible.

  - when a process leaves a critical section and more than one process is waiting.

- Deadlock is possible.
  - If a low priority process has the critical region and a higher priority process needs, the higher
  priority process will obtain(获得) the processor to wait for the critical region.

#### Semaphores

信号量

- Wait operation decrements the semaphore value
- wait(s)：s-1
- wait操作：申请资源且可能阻塞自己(s<0)
- Signal operation increments semaphore value
  - signal(s)：s+1
  - signal操作：释放资源并唤醒阻塞进程(s<0)

信号量的定义

 - Special variable called a semaphore is used for signaling.
- If a process is waiting for a signal, it is blocked until that signal is sent.
- Wait and Signal operations can not be interrupted.
- Queue is used to hold processes waiting on the semaphore.
- Semaphore is a variable that has an integer value.
  - May be initialized to a nonnegative number (非负整数).
  - Wait and Signal are primitives (atomic, cannot be interrupted and each routine can be treated as an indivisible step).

信号量的类型

- 信号量分为：互斥信号量和资源信号量。
- 互斥信号量用于申请或释放资源的使用权，常初始化为1。
- 资源信号量用于申请或归还资源，可以初始化为大于1的正整数，表示系统中某类资源的可用个数。
- wait 操作用于申请资源(或使用权)，进程执行wait原语时，可能会阻塞自己。
- signal 操作用于释放资源(或归还资源使用权)，进程执行signal原语时，有责任唤醒一个阻塞进程。

##### wait/signal Operations

```shell
type semaphore = record
count :integer;
queue :list of process
end;
vars s: semaphore;

wait(s):
s.count := s.count-1;
if s.count < 0
    then begin
    block P;
    insert P into s.queue;
    end;

signal(s):
s.count := s.count+1;
if s.count <= 0
    then begin
    wakeup the first P;
    remove the P from s.queue;
    end;
```

利用信号量实现互斥的通用模式：

```shell
program mutualesclusion;
const n=..;               #进程数
var s: semaphore(:=1);    #定义信号量s, s.count初始化为1
procedure P(i:integer);
begin
    repeat
        wait(s);
        <临界区>;
        signal(s);
        <其余部分>
    forever
end;

begin    				  #主程序
    parbegin
        P(1); P(2);..P(n)
    parend
end;
```

##### Mutual Exclusion:Semaphores

1.互斥信号量：申请/释放使用权，常初始化为1。
2.资源信号量：申请/归还资源，资源信号量可以初始化为一个正整数(表示系统中某类资源的可用个数)，s.count的意义为:

- s.count>0：表示还可执行，wait(s) 而不会阻塞的进程数(可用资源数)
- s.count<0：表示 s.queue 队列中阻塞进程的个数(被阻塞进程数)

##### s.count 的取值范围

- 当仅有两个并发进程共享临界资源时，互斥信号量仅能取值0，1，-1。
  其中，
  - s.count=1，表示无进程进入临界区
  - s.count=0，表示已有一个进程进入临界区
  - s.count=-1，则表示已有一进程正在等待进入临界区

- 当用s来实现n个进程的互斥时，s.count的取值范围为1~ -(n-1)。

总结：操作系统内核以系统调用形式提供 wait 和 signal 原语，应用程序通过该系统调用实现进程间的互斥。
工程实践证明，利用信号量方法实现进程互斥是高效的，一直被广泛采用。

##### Producer/Consumer Problem

- One or more producers are generating data and placing data in a buffer.

- A single consumer is taking items out of the buffer one at time.

- Only one producer or consumer may access the buffer at any one time.



任务及要求

- buffer不能并行操作(互斥)，即某时刻只允许一个实体(producer or consumer)访问buffer。
- 控制producer and consumer同步读/写buffer，即不能向满buffer写数据；不能在空buffer中取数据。

如果不控制生产者/消费者

![1623840575966](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1623840575966.png)

- 指针in和out初始化指向缓冲区的第一个存储单元。
- 生产者通过in指针向存储单元存放数据，一次存放一条数据，且in指针向后移一个位置。
- 消费者从缓冲区中逐条取走数据，一次取一条数据，相应的存储单元变为“空”。每取走一条数据，out指针向后移一个存储单元位置。
- 试想，如果不控制生产者与消费者，将会产生什么结果?

生产者/消费者必须互斥

- 生产者和消费者可能同时进入缓冲区，甚至可能同时读/写一个存储单元，将导致执行结果不确定。
- 这显然是不允许的。必须使生产者和消费者互斥进入缓冲区。即，某时刻只允许一个实体(生产者或消费者)访问缓冲区，生产者互斥消费者和其它任何生产者。

生产者/消费者必须同步

- 生产者不能向满缓冲区写数据，消费者也不能在空缓冲区中取数据，即生产者与消费者必须同步。

生产者/消费者问题解决流程：利用信号量实现生产者/消费者同步与互斥

```shell
program producer_consumer;
const sizeofbuffer=...;   		 #缓冲区大小
var s: semaphore(:=1);           #互斥信号量s，初始化为1
var n: semaphore(:=0);           	  #资源信号量n，数据单元，初始化为0
var e: semaphore(:=sizeofbuffer);      #资源信号量e，空存储单元

procedure producer;
begin
    repeat
        	生产一条数据;
        wait(e);
        wait(s);
        	存入一条数据;
        signal(s);
        signal(n);
    forever
end;

procedure consumer;
begin
    repeat
        wait(n);
        wait(s);
       		取一条数据;
        signal(s);
        signal(e);
        	消费数据;
    forever
end;

#主程序
begin           		
    parbegin
    	producer; consumer;
    parend
end;
```

注意：

1. 进程应该先申请资源信号量，再申请互斥信号量，顺序不能颠倒。
2. 对任何信号量的wait与signal操作必须配对。同一进程中的多对wait与signal语句只能嵌套，不能交叉。
3. 对同一个信号量的wait与signal可以不在同一个进程中。
4. wait与signal语句不能颠倒顺序，wait语句一定先于signal语句。

##### Readers/Writers Problem

- Any number of readers may simultaneously read the file.

- Only one writer at a time may write to the file.

- If a writer is writing to the file, no reader may read it.

可用于解决多个进程共享一个数据区(文件、内存区、一组寄存器等)，其中若干读进程只能读数据，若干写进程只能写数据等实际问题。

读者优先的解决流程：

- Readers have priority：指一旦有读者正在读数据，允许多个读者同时进入读数据，只有当全部读者退出，才允许写者进入写数据。

- Writers are subject to starvation    写者易于导致饥饿

```shell
program readers_writers;
const readcount:integer;    #统计读者个数
var x,wsem:semaphore(:=1);  #互斥信号量，初始化为1

#reader
procedure reader;
begin
    repeat
        wait(x);
        readcount :=readcount+1;
        if readcount=1 then wait(wsem);
            signal(x);
            读数据;
            wait(x);
            readcount :=readcount-1;
        if readcount =0 then signal(wsem);
        signal(x);
    forever
end;

#writer
procedure writer,
begin
    repeat
        wait(wsem);
        	写数据;
        signal(wsem);
    forever
end;

#主程序
begin
    readcount :=0;
    parbegin
    reader; writer;
    parend
end;
```

写者优先的解决流程：

- Writers have priority：指只要有一个writer申请写数据，则不再允许新的reader进入读数据。

```shell
program readers_writers;
const readcount,writecount: integer;
var x,y,z,rsem,wsem: semaphore(:=1);

#reader
procedure reader;
begin
    repeat
        wait(z);
        wait(rsem);
        wait(x);
        readcount := readcount+1;
        if readcount =1 then wait(wsem);
        signal(x);
        signal(rsem);
        signal(z);
        读数据;
        wait(x);
        readcount :=readcount-1;
        if readcount =0 then singal(wsem);
        signal(x);
    forever
end;

#writer
procedure writer;
begin
    repeat
        wait(y);
        writecount :=writecount+1;
        if writecount =1 then wait(rsem);
        signal(y);
        wait(wsem);
        写数据:
        signal(wsem);
        wait(y);
        writecount :=writecount-1;
        if writecount =0 then signal(rsem);
        signal(y);
    forever
end;

#主程序
begin          
readcount :=0; writecount:=0;
parbegin
reader; writer;
parend
end;
```

##### Summary of Mutual Exclusion

1. 利用 wait、signal原语对Semaphore互操作实现，powerful and flexible。
2. 可用软件方法实现互斥，如Dekker算法、Peterson算法等(但增加处理负荷)。
3. 可用硬件或固件方法实现互斥，如屏蔽中断、Test and Set 指令等(属于可接受的忙等)。

#### Monitors

管程的方法

- 用信号量实现互斥，编程容易出错(wait，signal的出现顺序和位置非常重要)。

- Support at Programming-language level。
- 管程是用并发 pascal、pascal plus、 Modula-2、Modula-3 等语言编写的程序，现在已形成了许多库函数。管程可以锁定任何对象，如链表或链表的元素等。
- 用管程实现互斥比用信号量实现互斥，更简单、方便。

管程是一个封装好的对象

* Monitor is a software module，由若干过程、局部于管程的数据、初始化语句(组)组成
* Chief characteristics 主要特点
- Local data variables are accessible only by the monitor.
- Process enters monitor by invoking one of its procedures.
- Only one process may be executing in the monitor at  a time.

#### Message Passing

消息传递

- Enforce mutual exclusion
- Exchange information
  - send (destination, message)
  - receive (source, message)

##### Synchronization

- Sender and receiver may or may not be blocked (waiting for message).
- Blocking send, blocking receive
  - Both sender and receiver are blocked until message is delivered.
  - Called a rendezvous (紧密同步，汇合).
-  Nonblocking send, blocking receive
  - Sender continues processing such as sending messages as quickly as possible.
  - Receiver is blocked until the requested message arrives.
- Nonblocking send, nonblocking receive
  - Neither party is required to wait

##### Addressing

寻址

- Direct addressing
  - Send primitive includes a specific identifier of the destination process.
  - Receive primitive could know ahead of time which process a message is expected.
  - Receive primitive could use source parameter to return a value when the receive operation has been performed.
- Indirect addressing
  - messages are sent to a shared data structure consisting of queues.
  - queues are called mailboxes.
  - one process sends a message to the mailbox and the other process picks up the message from the mailbox.

##### Message Format

- Header
  - Messape Type
  - Destinaton ID
  - Source ID
  - Message Length
  - Control Informaton
- Body
  - Message Contents

##### Mutual Exclusion

- 若采用 Nonblocking send, blocking receive
- 多个进程共享邮箱`mutex`。若进程申请进入临界区，首先申请从`mutex`邮箱中接收一条消息。若邮箱空，则进程阻塞；若进程收到邮箱中的消息，则进入临界区，执行完毕退出，并将该消息放回邮箱`mutex`。该消息 as a token在进程间传递。

利用消息传递实现互斥的通用模式：

```shell
program mutualexclusion;
const n=...;			#进程数

#P
procedure P(i:integer);
var msg:message;
begin
    repeat
        receive(mutex,msg);     #从邮箱接收一条消息
        <临界区>;
        send(mutex,msg);        #将消息发回到邮箱
        <其余部分>
    forever
end;

#主程序
begin
    create_mailbox(mutex);   #创建邮箱
    send(mutex,null);       #用户初始化，向邮箱发送一条空消息
    parbegin
        P(1);
        P(2);
        ...
        P(n)
    parend
end;
```

##### Producer/Consumer Problem

利用消息传递解决生产者消费者问题：

- 解决有限buffer Producer/Consumer Problem
- 设两个邮箱：
  - Mayconsume：Producer存放数据，供Consumer取走(即buffer数据区)
  - Mayproduce：存放空消息的buffer空间

```shell
program mutualexclusion;
const capacity =...;    #消息缓冲区大小
const null =...;   		#空消息

#producer
procedure producer;
var pmsg:message;
begin
    while true do
    begin
        receive(mayproduce,pmsg);
        pmsg:=produce;
        send(mayconsume,pmsg);
    end
end;

#consumer
procedure consumer
var cmsg:message;
begin
    while true do
    begin
        receive(mayconsume,cmsg);
        consume(cmsg);
        send(mayproduce,null);
    end
end;

#主程序
begin
create_mailbox(mayproduce);
create_mailbox(mayconsume);
for i=1 to capacity do send(mayproduce,null);
    parbegin
        producer;
        consumer;
    parend
end;
```



## 7 进程死锁

Deadlock And Starvation

- 产生死锁与饥饿的原因
- 解决死锁的方法
- 死锁/同步的经典问题：哲学家进餐问题

Deadlock

- Permanent blocking of a set of(一组进程) processes that either compete for system resources or communicate with each other. 因为相互竞争系统资源或是通信原因，造成的永久性的阻塞。
- No efficient solution.
- Involve conflicting needs for resources by two or more processes. 涉及两个或多个进程对资源的冲突需求。

**案例：单进程死锁，互相竞争，占有对方的资源**

Eg.Process P and Q compete two resources, Their general forms are：

```
Process P        Process  Q
...              ...
Get A            Get B
...              ...
Get B            Get A
...              ...
Release A        Release B
...              ...
Release B        Release A
```

### Reusable Resources（可重用资源）

- Used by one process at a time and not depleted (耗尽) by that use.
- Processes obtain resources that they later release for reuse by other processes.
- Processors, I/O channels, main and secondary memory, files, databases, and semaphores.
- Deadlock occurs if each process holds one resource and requests the other.

**Example of Deadlock:**

Space is available for allocation of 200K bytes，and the following sequence of events occur.

```
P1                      P2
...                     ...        
Request 80K bytes;      Request 70K bytes;
...                     ...
Request 60K bytes;      Request 80K bytes;
```

### Consumable Resources(可消耗资源)

- Created(produced) and destroyed(consumed) by a process.
- Interrupts, signals, messages, and information in I/O buffers.

**Example of Deadlock:**

Deadlock occurs if receive is blocking.

```java
P1                    P2
...                   ...
Receive(P2);          Receive(P1);
...                   ...
Send(P2,M1);          Send(P1,M2);
```

此类死锁是由于设计失误造成的，很难发现，且潜伏期较长。

### Conditions for Deadlock

- Mutual exclusion (互斥)
  - only one process may use a resource at a time.
- Hold-and-wait (保持并等待)
  - A process may hold allocated resources while awaiting assignment of other resources.

- No preemption(不剥夺)
  - No resource can be forcibly removed from a process holding it.
- Circular wait (环路等待)
  - A closed chain of processes exists, such that each process holds at least one resource needed by the next process in the chain.
- 条件 `Mutual exclusion`、`Hold-and-wait`、`No preemption`是死锁产生的必要条件，而非充分条件。
- 条件 `Circular wait` 是前3个条件产生的结果。

### Deadlock Prevention(预防死锁)

间接方法，禁止前3个条件之一的发生：

1. 互斥：
   - 是某些系统资源固有的属性，不能禁止。
2. 禁止“保持并等待”条件：
   - 要求进程一次性地申请其所需的全部资源。若系统中没有足够的资源可分配给它，则进程阻塞。
3. 禁止“不剥夺“条件：
   - ① 若一个进程占用了某些系统资源，又申请新的资源，则不能立即分配给它。必须让它首先释放出已占用资源，然后再重新申请。
   - ② 若一个进程申请的资源被另一个进程占有，OS 可以剥夺低优先权进程的资源分配给高优先权的进程(要求此类可剥夺资源的状态易于保存和恢复，否则不能剥夺)。

```






```

