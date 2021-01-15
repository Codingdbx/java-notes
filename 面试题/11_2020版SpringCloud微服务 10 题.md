## 2020版SpringCloud微服务面试题

### 1. Euraka集群之间是怎么通信的？

- Eureka 是弱数据一致性，选择了 CAP 中的 AP。
- Eureka 集群之间采用 Peer to Peer 对等模式进行数据复制。
- Eureka 通过 lastDirtyTimestamp 来解决复制冲突。
- Eureka 通过心跳机制实现数据修复。

Eureka Server 本身依赖了 Eureka Client，也就是每个 Eureka Server 是作为其他 Eureka Server 的 Client。 

Eureka Server 每当自己的信息变更后，例如 Client 向自己发起注册、续约、注销请求， 就会把自己的最新信息通知给其他 Eureka Server，保持数据同步。 

Eureka 采用的就是 **Peer to Peer** 模式。Eureka Server  复制时使用 `HEADER_REPLICATION` 这个 http header 来区分普通应用实例的正常请求。说明这是一个复制请求，这样其他 peer 节点收到请求时，就不会再对其进行复制操作。

EurekaServer6001:

```yml
eureka:
  instance:
    hostname: EurekaServer6001
  server:
    enable-self-preservation: false 
    eviction-interval-timer-in-ms: 10000 
  client:
    register-with-eureka: false
    fetch-registry: false  
    service-url: # 集群的情况下，服务端之间要互相注册，指向对方
      defaultZone: http://localhost:7001/eureka/
```

EurekaServer7001:

```yml
eureka:
  instance:
    hostname: EurekaServer7001
  server:
    enable-self-preservation: false 
    eviction-interval-timer-in-ms: 10000 
  client:
    register-with-eureka: false
    fetch-registry: false 
    service-url:  # 集群的情况下，服务端之间要互相注册，指向对方
      defaultZone: http://localhost:6001/eureka/
```

### 微服务注册中心的注册表如何更好的防止读写并发冲突？

基于纯内存的注册表

多级缓存机制 

### Eureka注册表多级缓存架构有了解过吗？

* registry   注册表缓存

  CurrentHashMap 结构，各个服务的注册、服务下线、服务故障，全部会在内存里维护和更新这个注册表。

* readOnlyCacheMap  只读缓存

  CurrentHashMap 结构的只读缓存，服务发现默认先从只读缓存获取注册信息，没有的话再从内存中获取。

* readWriteCacheMap  读写缓存

  readWriteCacheMap  与 readOnlyCacheMap  每隔大概30秒同步一次。

  

### 2. 服务调用链跟踪

Spring Cloud Sleuth 主要功能就是在分布式系统中提供追踪解决方案，并且兼容支持了 zipkin，你只需要在pom文件中引入相应的依赖即可。 

### 3. 服务熔断和服务降级Hystrix

* 服务熔断

  服务熔断的作用类似于我们家用的保险丝，当某服务出现不可用或响应超时的情况时，为了防止整个系统出现雪崩，暂时停止对该服务的调用。 

  ```java
  @SpringBootApplication
  @EnableFeignClients
  @EnableCircuitBreaker
  public class MessageCenterApplication {
   
   public static void main(String[] args) {
    new SpringApplicationBuilder(MessageCenterApplication.class)
        .web(WebApplicationType.SERVLET)
        .run(args);
   }
  }
  ```

  增加了@EnableCircuitBreaker注解，用来开启断路器功能。

  ```java
   @GetMapping("/msg/get")
   @HystrixCommand(fallbackMethod = "getMsgFallback")
   public Object getMsg() {
      String msg = messageService.getMsg();
      return msg;
   }
   
   public Object getMsgFallback() {
      return "祝您 2019 猪年大吉，'猪'事如意！";
   }
  ```

  

* 服务降级

  服务降级是从整个系统的负荷情况出发和考虑的，对某些负荷会比较高的情况，为了预防某些功能（业务场景）出现负荷过载或者响应慢的情况，在其内部暂时舍弃对一些非核心的接口和数据的请求，而直接返回一个提前准备好的fallback（退路）错误处理信息。这样，虽然提供的是一个有损的服务，但却保证了整个系统的稳定性和可用性。 

### 4. 熔断VS降级

**相同点：**

目标一致 都是从可用性和可靠性出发，为了防止系统崩溃；

用户体验类似 最终都让用户体验到的是某些功能暂时不可用；

**不同点：**

触发原因不同 服务熔断一般是某个服务（下游服务）故障引起，而服务降级一般是从整体负荷考虑；

Spring Cloud Bus

### 5. Hystrix 服务隔离

Hystrix的资源隔离策略有两种，分别为：**线程池和信号量**。

线程池隔离

```java
// 隔离策略，有THREAD和SEMAPHORE
@HystrixProperty(name="execution.isolation.strategy", value="THREAD")

//线程池核心线程数
@HystrixProperty(name = "coreSize", value = "3"),
//队列最大长度
@HystrixProperty(name = "maxQueueSize", value = "5"),
//排队线程数量阈值，默认为5，达到时拒绝，如果配置了该选项，队列的大小是该队列
@HystrixProperty(name = "queueSizeRejectionThreshold", value = "7")
```

信号量隔离

```java
// 隔离策略，有THREAD和SEMAPHORE
// THREAD - 它在单独的线程上执行，并发请求受线程池中的线程数量的限制（默认）
// SEMAPHORE - 它在调用线程上执行，并发请求受到信号量计数的限制
@HystrixProperty(name="execution.isolation.strategy", value="SEMAPHORE"),
// 设置在使用时允许到HystrixCommand.run()方法的最大请求数。默认值：10 ，SEMAPHORE模式有效。
@HystrixProperty(name="execution.isolation.semaphore.maxConcurrentRequests", value="1")
```





### 6. Ribbon 负载均衡算法 

* RoundRobinRule 轮询   

* RandomRule 随机    

* BestAvailableRule  最低并发策略，用来选取最少并发量请求的服务器。

* ZoneAvoidanceRule  区域权重策略，综合判断Server所在区域的性能和Server的可用性选择服务器。 

* AvailabilityFilteringRule 会先过滤掉多次访问故障而处于断路器跳闸状态的服务，    和并发的连接数量超过阙值的服务，然后对剩余服务列表按照轮询策略进行访问    

* WeightedResponseTimeRule   根据平均响应时间计算所有服务的权重，响应时间越快的服务权重越大被选中的概率越大。 

* RetryRule 先按照轮询策略，如果获取失败，会在指定时间内重试。    

