# Processes and Scheduling

## 1 进程的描述与控制

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

### 1.2 Process States

#### 进程的并发执行

案例：

假设内存中有3个进程A、B、C，他们的程序代码已全部装入内存。若A、C两进程需要执行12条指令，B进程需要执行4条指令，且B进程执行到第4条指令处必须等待 I/O。如何跟踪他们的执行过程?

![1612684306532](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1612684306532.png)

分派程序 (Dispatcher)：把处理器分派给程序

程序计数器(Program Counter)

调度程序(scheduler)

![1612684232784](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1612684232784.png)



#### 进程的2状态

- Running(执行) 

- Not-running(非执行)  

注意：

- 并非所有进程只要 Not-running 就处于 ready (就绪)，有的需要 blocked (阻塞) 等待I/O完成

- Not-running又可分为 ready 和 blocked 两种状态

  - ready 等待CPU
  - blocked 等待I/O

  

![1612701241769](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1612701241769.png)



#### 进程的5状态

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

#### 进程状态转换图

![1612702997512](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1612702997512.png)



- Null -- New：新创建进程首先处于新状态
- New -- Ready：OS接纳新状态进程为就绪进程
- Ready -- Running：OS只能从就绪进程中选一个进程执行
- Running -- Exit：执行状态的进程执行完毕，或被取消，则转换为退出状态
- Ruming -- Ready：分时系统中，时间片用完，或优先级高的进程到来，将终止优先级低的进程的执行
- Running -- Blocked：执行进程需要等待某事件发生。通常因进程需要的系统调用不能立即完成，而阻塞
- Blocked -- Ready：当阻塞进程等待的事件发生，就转换为就绪状态
- Ready -- Exit：某些系统允许父进程在任何情况下终止其子进程。若一个父进程终止，其子孙进程都必须终止。
- Blocked -- Exit：同前

#### Using Two Queues

![1612703774353](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1612703774353.png)

![1612703999050](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1612703999050.png)

#### 交换技术

