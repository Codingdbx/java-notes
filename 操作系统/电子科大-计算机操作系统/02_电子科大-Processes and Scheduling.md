# Processes and Scheduling

## 1 进程的描述与控制

进程：结构、PCB、状态



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



#### Process

- Also called a task

- Execution of an individual program

  - 进程是程序在一个数据集合上的运行过程，是系统进行资源分配和调度的一个独立单位

  - 进程是可并发执行的程序在一个数据集合上的运行过程

- Can be traced

  - list the sequence of instructions that execute

##### Characteristics of Process

- Dynamic (动态性)
- Concurrency (并发性)
- Independent (独立性)
- Asynchronous (异步性)

##### Process Structure

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

#### Reasons for Process Suspension

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

#### Suspend vs Blocked

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

### 1.6 操作系统如何管理进程资源

通过各种 tables(操作系统表)、原语操作。

#### Operating System Control Structures

操作系统控制结构

操作系统用表来记录各种信息，若干个表来管理系统资源。

- Information about the current status of each process and resource
- Tables are constructed for each entity the operating system manages
  - Memory Tables
  - I/O Tables
  - File Tables
  - Process Table

##### Memory Tables

- Allocation of main memory to processes.
  - 分配，内存
- Allocation of secondary memory to processes.
  - 分配，外存
- Protection attributes for access to shared memory regions.
  - 保护属性，共享内存区域
- Information needed to manage virtual memory.
  - 虚拟存储

##### I/O Tables

- I/O device is available or assigned.
  - 空闲可用的，已经分配的
- Status of I/O operation.
- Location in main memory being used as the source or destination of the I/O transfer.

##### File Tables

- Existence of files.
- Location on secondary memory.
- Current Status.

* Attributes.
* Sometimes this information is maintained by a file-management system.

##### Process Table

- Where process is located.
- Attributes necessary for its management.
  - Process ID
  - Process state
  - Location in memory

##### Process Location

- Process includes set of programs to be executed.
  
  包含一组程序
  
  - Data locations for local and global variables
  - Any defined constants
  - Stack
  
- Process control block(PCB).
  
  - Collection of attributes
  
- Process image. (进程映像)
  
  - Collection of program, data, stack, and attributes.

##### Process image

- User Data

* User Program
* System Stack：存放系统及过程调用地址、参数
* Process Control Block (PCB)：OS感知进程、控制进程的数据结构

![1617007949684](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1617007949684.png)

##### Process Control Block

- 简称 PCB：是OS控制和管理进程时所用的基本数据结构。

- 作用：PCB是相关进程存在于系统中的唯一标志，系统根据PCB而感知相关进程的存在。

- Process identification

  - Identifiers
    - Identifier of this process(进程ID)
    - Identifier of the process that created this process(parent process)(父进程ID)
    - User identifier (用户ID)

- Processor State Information

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

- Process Control Information 

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

#### Typical Function of an OS Kernel

操作系统内核功能 

资源管理功能（操作系统相当于电脑的资源管理器，企业会记）：

- Process Management：进程创建和终止、调度、状态转换、同步和通信、管理PCB
- Memory Management：为进程分配地址空间、数据对换、段/页式管理
- I/O Management：缓存管理、为进程分配I/O通道和设备

支撑功能：

- Interrupt handling (中断处理)
- Timing (时钟管理) 
- Primitive (原语)：Atomic Operation，原语操作：原子操作，即不可中断的操作，一定会完成
- Accounting (统计)
- Monitoring (监测)



```
操作系统内核给用户提供系列的服务，这个服务以原语的方式出现
进程切换

进程的切换
保存第一个进程的上下文，修改他的PCB
修改内存数据
启动调度程序，调度新进程进来，恢复被选择的进程的上下文

模式切换
用户进程正在运行的时候，一般正常运行在用户态下，运行过程中，如果发生系统调用，用户态切换进入系统态（为了保护系统数据不受非法篡改，需要审核，判断是否有操作权限，审核的过程就叫软中断）审核通过，用户态切换到系统态成功。

系统调用完成后，返回用户态。

进程切换的时候，需要调度程序，调度程序就是系统调用命令，需要进行模式切换。
还有中断程序，中断也是在系统态下面运行的

进程切换一定有模式切换，但是模式切换不一定有进程切换。

创建进程=分配资源，创建ID，分配PCB

```





创建进程多了之后，开销很大，负载增加了许多，管理起来较麻烦。线程是为了满足多道程序并发，降低系统开销的而设计的。

进程是资源分配单位，线程是调度单位，不在拥有大量的资源。线程是共享了进程的资源

但是线程不在分配资源，释放资源，所以系统开销就低了。还提高了并发度

线程不在考虑程序空间，数据空间，共享进程的一切资源，但可能出现并发安全问题



线程之间切换避免了进程切换，和模式切换