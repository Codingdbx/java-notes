## 2020版SpringBoot面试题

### 1. 什么是 SpringBoot？

spring boot 是为 spring 服务的，是用来简化新 spring 应用的初始搭建以及开发过程的。

### 2. SpringBoot 有哪些优点？

* 简化spring配置
* 快速启动，独立部署

### 3. SpringBoot 中@SpringBootApplication包含的三个注解及其含义？

* @SpringBootConfiguration   本质就是 @Configuration，JavaConfig配置类。
* @EnableAutoConfiguration   开启自动配置，加载依赖、自定义的bean、classpath下有没有某个类 到IOC容器中。
* @ComponentScan   组件扫描

### 4. SpringBoot 如何把不在默认扫描范围内的包扫描到IOC容器中？

可以使用 `@ComponentScan` 额外指定待扫描的包，但是不能用在主启动类上，因为这样会覆盖掉默认的包扫描规则。 可以在其他标注了 `@Configuration ` 的地方配置 `@ComponentScan(basePackages = { "xxx.yyy"})`进行额外指定。

### 5. 如何重新加载 Spring Boot 上的更改，而无需重新启动服务器？

热部署开发工具（DevTools）。

```xml
<artifactId>spring-boot-devtools</artifactId>
```

### 6. Spring Boot 中的监视器是什么？

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```



### 如何在 Spring Boot 中禁用 Actuator 端点安全性？

### 如何在自定义端口上运行 Spring Boot 应用程序？

### 什么是 YAML？

### 如何实现 Spring Boot 应用程序的安全性？

### 如何集成 Spring Boot 和 ActiveMQ？

### 如何使用 Spring Boot 实现分页和排序？

### 什么是 Swagger？你用 Spring Boot 实现了它吗？

### 什么是 FreeMarker，Thymeleaf  模板？

### 如何使用 Spring Boot 实现异常处理？

### 什么是 CSRF 攻击？

### 什么是 WebSockets？

### 什么是 Apache Kafka？

### 我们如何监视所有 Spring Boot 微服务？