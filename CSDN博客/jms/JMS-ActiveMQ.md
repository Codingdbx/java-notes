# ActiveMQ

## 1.背景

MQ 的应用场景：

(1) 异步。调用者无需等待。

(2) 解耦。解决了系统之间耦合调用的问题。

(3) 消峰。抵御洪峰流量，保护了主业务。

## 2.消息队列基本模型

消息队列有两种模型：**队列模型**和**发布/订阅模型**。 

* 队列模型

  生产者往某个队列里面发送消息，一个队列可以存储多个生产者的消息，一个队列也可以有多个消费者， 但是消费者之间是竞争关系，即每条消息只能被一个消费者消费。

* 发布/订阅模型

  为了解决一条消息能被多个消费者消费的问题，发布/订阅模型就来了。该模型是将消息发往一个`Topic`即主题中，所有订阅了这个 `Topic` 的订阅者都能消费这条消息。 



## 3.JMS规范  

### 3.1 什么是Java消息服务

Java 消息服务指的是两个应用程序之间进行异步通信的API，它为标准协议和消息服务提供了一组通用接口，包括创建、发送、读取消息等，用于支持Java应用程序开发。在JavaEE中，当两个应用程序使用JMS进行通信时，它们之间不是直接相连的，而是通过一个共同的消息收发服务组件关联起来以达到解耦/异步削峰的效果。

### 3.2 JMS组成结构和特点

#### JMS Provider 

实现JMS接口和规范的消息中间件，也就是我们说的MQ服务器。

#### JMS Producer 

消息生产者，创建和发送JMS消息的客户端应用。

#### JMS Consumer 

消息消费者，接收和处理JMS消息的客户端应用。

#### JSM Message

##### 消息头 

- JMSDestination  消息发送的目的地，主要是指Queue和Topic。

- JMSDeliveryMode  消息持久化模式。

  - 持久模式：一条持久性的消息，应该被传送一次且被消费一次，这就意味着如果JMS提供者出现故障，该消息并不会丢失，它会在服务器恢复之后再次传递。
  - 非持久模式：一条非持久的消息：最多会传递一次，这意味着服务器出现故障，该消息将会永远丢失。 

- JMSExpiration  消息过期时间。  

  可以设置消息在一定时间后过期，默认是永不过期。消息过期时间，等于Destination的send方法中的timeToLive值加上发送时刻的GMT时间值。如果timeToLive值等于0，则JMSExpiration被设为0，表示该消息永不过期。如果发送后，在消息过期时间之后还没有被发送到目的地，则该消息被清除。

- JMSPriority  消息的优先级 。

  消息优先级，从0-9十个级别，0-4是普通消息，5-9是加急消息。JMS不要求MQ严格按照这十个优先级发送消息但必须保证加急消息要先于普通消息到达。默认是4级。 

- JMSMessageID  唯一标识，每个消息的标识由MQ产生。 

##### 消息体 

封装具体的消息数据，发送和接收的消息体类型必须一致对应。

5种消息格式：

- TxtMessage    普通字符串消息，包含一个String。
- MapMessage  一个Map类型的消息，key为Strng类型，而值为Java基本类型 。
- BytesMessage   二进制数组消息，包含一个byte[]。
- StreamMessage  Java数据流消息，用标准流操作来顺序填充和读取。
- ObjectMessage   对象消息，包含一个可序列化的Java对象。

##### 消息属性  

如果需要除消息头字段之外的值，那么可以使用消息属性。他是识别/去重/重点标注等操作，非常有用的方法。 可以将属性是为消息头的扩展，属性指定一些消息头没有包括的附加信息，比如可以在属性里指定消息选择器。它们还用于暴露消息选择器在消息过滤时使用的数据。

```java
textMessage.setStringProperty("From","ZhangSan@qq.com");
textMessage.setByteProperty("Spec", (byte) 1);
textMessage.setBooleanProperty("Invalide",true);
```

### 3.3 消息的可靠性

#### 消息的持久化

在持久性消息传送至目标时，消息服务将其放入持久性数据存储（默认是kehaDB）。如果消息服务由于某种原因导致失败，它可以恢复此消息并将此消息传送至相应的消费者。虽然这样增加了消息传送的开销，但却增加了可靠性。  

在消息生产者将消息成功发送给MQ消息中间件之后。无论是出现任何问题，如：MQ服务器宕机、消费者掉线等。都保证（topic要之前注册过，queue不用）消息消费者，能够成功消费消息。如果消息生产者发送消息就失败了，那么消费者也不会消费到该消息。

```java
// 非持久化
messageProducer.setDeliveryMode(DeliveryMode.NON_PERSISTENT);
// 持久化
messageProducer.setDeliveryMode(DeliveryMode.PERSISTENT);
```

#### 消息的订阅

消息订阅分为非持久订阅(non-durable subscription)和持久订阅(durable subscription)。

- Durable

  持久订阅时，客户端向JMS注册一个识别自己身份的ID，当这个客户端处于离线时，JMS Provider 会为这个ID 保存所有发送到主题的消息，当客户再次连接到JMS Provider时，会根据自己的ID得到所有当自己处于离线时发送到主题的消息。 

- Non-Durable

  非持久订阅只有当客户端处于激活状态，也就是和JMS Provider保持连接状态才能收到发送到某个主题的消息，而当客户端处于离线状态，这个时间段发到主题的消息将会丢失，永远不会收到。



- | 消息发送端     | 消息接收端                        | 可靠性及因素                                                 |
  | -------------- | --------------------------------- | ------------------------------------------------------------ |
  | PERSISTENT     | queue receiver/durable subscriber | 消费一次且仅消费一次。可靠性最好，但是占用服务器资源比较多。 |
  | PERSISTENT     | non-durable subscriber            | 最多消费一次。这是由于non-durable subscriber决定的，如果消费端宕机或其他问题导致与JMS服务器断开连接，等下次再联上JMS服务器时的一系列消息，不为之保留。 |
  | NON_PERSISTENT | queue receiver/durable subscriber | 最多消费一次。这是由于服务器的宕机会造成消息丢失。           |
  | NON_PERSISTENT | non-durable subscriber            | 最多消费一次。这是由于服务器的宕机造成消息丢失，也可能是由于non-durable subscriber的性质所决定。 |





#### 消息的事务性

1. 生产者开启事务后，执行commit方法，这批消息才真正的被提交。不执行commit方法，这批消息不会提交。执行rollback方法，之前的消息会回滚掉。生产者的事务机制，要高于签收机制，当生产者开启事务，签收机制不再重要。
2. 消费者开启事务后，执行commit方法，这批消息才算真正的被消费。不执行commit方法，这些消息不会标记已消费，下次还会被消费。执行rollback方法，是不能回滚之前执行过的业务逻辑，但是能够回滚之前的消息，回滚后的消息，下次还会被消费。消费者利用commit和rollback方法，甚至能够违反一个消费者只能消费一次消息的原理。
3. 消费者和生产者的事务，完全没有关联，各自是各自的事务。 
4. 消息需要需要批量提交，需要缓冲处理。
5. 保证批量业务的原子性 。

##### producer提交时的事务 

- false 

  - 只要执行send，就进入到Pending Messages 

  - 关闭事务，那第二个签收参数的设置需要有效Session.AUTO_ACKNOWLEDGE 

- true
  - 先执行send再执行commit，消息才被真正提交到队列中 

##### consumer提交时的事务

- false 
  -  只要执行receive，就会进入Messages Dequeue 
  -  关闭事务，那第二个签收参数的设置需要有效Session.AUTO_ACKNOWLEDGE 

- true
  -  先执行receive再执行commit，消息才被真正提交到队列中 

### 3.4 消息的签收机制  

#### 签收方式

- 自动签收（Session.AUTO_ACKNOWLEDGE）  

  该方式是默认的。该种方式，无需我们程序做任何操作，框架会帮我们自动签收收到的消息。

- 手动签收（Session.CLIENT_ACKNOWLEDGE）  

  手动签收。该种方式，需要我们手动调用Message.acknowledge()，来签收消息。如果不签收消息，该消息会被我们反复消费，只到被签收。  

- 允许重复消息（Session.DUPS_OK_ACKNOWLEDGE） 

  多线程或多个消费者同时消费到一个消息，因为线程不安全，可能会重复消费。该种方式很少使用到。

- 事务下的签收（Session.SESSION_TRANSACTED）   

  开始事务的情况下，可以使用该方式。该种方式很少使用到。

#### 事务和签收的关系

- 在事务性会话中，当一个事务被成功提交则消息被自动签收。如果事务回滚，则消息会被再次传送。 ==事务优先于签收，开始事务后，签收机制不再起任何作用==。  
- 非事务性会话中，消息何时被确认取决于创建会话时的应答模式。  
- 生产者事务开启，只有commit后才能将全部消息变为已消费。
- 事务偏向生产者，签收偏向消费者。也就是说，生产者使用事务更好点，消费者使用签收机制更好点。



## 4.ActiveMQ的broker

### 4.1 broker是什么

相当于一个ActiveMQ服务器实例。消息从Producer发往Broker，Broker将消息存储至本地，然后Consumer从Broker拉取消息，或者Broker推送消息至Consumer，最后消费。

### 4.2 嵌入式Broker 

ActiveMQ也支持在中通信基于嵌入的，能够无缝的集成其他应用。说白了，Broker其实就是实现了用代码的形式启动ActiveMQ将MQ嵌入到Java代码中，以便随时用随时启动，在用的时候再去启动这样能节省了资源，也保证了可用性。这种方式，我们实际开发中很少采用，因为他缺少太多了东西，如：日志，数据存储等等。



## 5.JMS开发基本步骤

- 创建一个JMS ConnectionFactory
- 通过JMS ConnectionFactory来创建JMS connection
- 启动JMS connection
- 通过connection创建JMS session
- 创建JMS destination
- 创建JMS producer,或者创建JMS message，并设置destination
- 创建JMS consumer，或者是注册一个JMS message listener
- 发送或者接受JMS message(s)
- 关闭所有的JMS资源(connection, session, producer, consumer等)
  

![1618134067808](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1618134067808.png)

### 5.1 生产者队列

```java
public class QueueProducer {

    public static void main(String[] args) throws Exception {

        //1.Create a JMS ConnectionFactory
        ConnectionFactory connectionFactory = new ActiveMQConnectionFactory("tcp://127.0.0.1:61616");

        //2.Create a JMS Connection
        Connection connection = connectionFactory.createConnection();
        connection.start();

        //3.Create a JMS Session
        //transacted  if true,must commit session
        Session session = connection.createSession(Boolean.FALSE, Session.AUTO_ACKNOWLEDGE);

        //4.Create the destination (Topic or Queue)
        Queue queue = session.createQueue("TEST.QUEUE");

        //5.Create a MessageProducer from the Session to the Topic or Queue
        MessageProducer producer = session.createProducer(queue);

        //设置传送模式 非持久化  DeliveryMode=NON_PERSISTENT
        producer.setDeliveryMode(DeliveryMode.NON_PERSISTENT);

        for (int i = 0; i <10; i++) {
            //Create a message
            TextMessage  message = session.createTextMessage();
            String text = "Hello world! From: " + Thread.currentThread().getName() + " : " + i;
            message.setText(text);

            //Tell the producer to send the message
            producer.send(message);

            System.out.println("Published:" + text);
        }
        
        // Clean up
        producer.close();
        session.close();
        connection.close();

    }
}
```

### 5.2 消费者队列

```java
public class QueueConsumer {

    public static void main(String[] args) throws Exception {

        //1.Create a JMS ConnectionFactory
        //use default pwd
        ConnectionFactory connectionFactory = new ActiveMQConnectionFactory("tcp://127.0.0.1:61616");

        //2.Create a JMS Connection
        Connection connection = connectionFactory.createConnection();
        connection.start();

        //3.Create a JMS Session

        //transacted:
        //true  session.commit()

        //acknowledgeMode:
        //AUTO_ACKNOWLEDGE 自动签收
        //CLIENT_ACKNOWLEDGE 手动签收   message.acknowledge();
        //DUPS_OK_ACKNOWLEDGE 允许副本的确认模式,而且允许重复消息
        Session session = connection.createSession(Boolean.FALSE, Session.AUTO_ACKNOWLEDGE);

        //4.Create the destination (Topic or Queue)
        Queue queue = session.createQueue("TEST.FOO");

        //5.Create a MessageConsumer from the Session to the Topic or Queue
        MessageConsumer consumer = session.createConsumer(queue);

        while (true) {
            // Wait for a message
//            Message message = consumer.receive();
            Message message = consumer.receive(1000);
            if (message == null) {
                break;
            }

            if (message instanceof TextMessage) {
                TextMessage textMessage = (TextMessage) message;
                String text = textMessage.getText();
                System.out.println("Received: " + text);
            }else  if (message instanceof MapMessage) {
                MapMessage mapMessage = (MapMessage) message;
                Enumeration mapNames = mapMessage.getMapNames();
                while (mapNames.hasMoreElements()) {
                    String str = (String)mapNames.nextElement();
                    String string = mapMessage.getString(str);
                    System.out.println("Received: " + str + "========" + string);
                }
            } else {
                System.out.println("Received: " + message);
            }
        }

        // Clean up
        consumer.close();
        session.close();
        connection.close();

    }
}
```



## 6.高级特性  

### 6.1 异步投递  

#### 什么是异步投递  

​		ActiveMQ支持同步，异步两种发送的模式将消息发送到broker，模式的选择对发送延时有巨大的影响。producer能达到怎么样的产出率（产出率=发送数据总量/时间）主要受发送延时的影响，使用异步发送可以显著提高发送的性能。

​		ActiveMQ默认使用异步发送的模式：除非明确指定使用同步发送的方式或在未使用事务的前提下发送持久化的消息，这两种情况都是同步发送的。

​		如果你没有使用事务且发送的是持久化的消息，每一次发送都是同步发送的且会阻塞producer知道broker返回一个确认，表示消息已经被安全的持久化到磁盘。确认机制提供了消息安全的保障，但同时会阻塞客户端带来了很大的延时。

​		很多高性能的应用，允许在失败的情况下有少量的数据丢失。如果你的应用满足这个特点，你可以使用异步发送来提高生产率，即使发送的是持久化的消息。

​		异步发送，它可以最大化producer端的发送效率。我们通常在发送消息量比较密集的情况下使用异步发送，它可以很大的提升Producer性能；不过这也带来了额外的问题，就是需要消耗更多的Client端内存，同时也会导致broker端性能消耗增加；此外它不能有效的确保消息的发送成功，在 userAsyncSend=true 的情况下需要容忍消息丢失的可能。

​		此处的异步是指生产者和broker之间发送消息的异步。不是指生产者和消费者之间异步。

​		异步发送可以让生产者发的更快。

​		如果异步投递不需要保证消息是否发送成功，发送者的效率会有所提高。如果异步投递还需要保证消息是否成功发送，并采用了回调的方式，发送者的效率提高不多，这种就有些鸡肋。

#### 异步发送如何确认发送成功

​		异步发送丢失消息的场景是：生产者设置userAsyncSend=true，使用producer.send(msg)持续发送消息。如果消息不阻塞，生产者会认为所有send的消息均被成功发送至MQ。如果MQ突然宕机，此时生产者端内存中尚未被发送至MQ的消息都会丢失。

​		所以，正确的异步发送方法是需要接收回调的。同步发送和异步发送的区别就在此，同步发送等send不阻塞了就表示一定发送成功了，异步发送需要客户端回执并由客户端再判断一次是否发送成功。

```java
producer.send(textMessage, new AsyncCallback() {
    public void onSuccess() {
        System.out.println("成功发送消息Id:"+msgId);
    }

    public void onException(JMSException e) {
    	System.out.println("失败发送消息Id:"+msgId);
    }
});
```



### 6.2 延迟投递和定时投递  

1.官网文档：http://activemq.apache.org/delay-and-schedule-message-delivery.html

2.四个属性

| Property name        | type   | description                                                  |
| -------------------- | ------ | ------------------------------------------------------------ |
| AMQ_SCHEDULED_DELAY  | long   | The time in milliseconds that a message will wait before being scheduled to be delivered by the broker |
| AMQ_SCHEDULED_PERIOD | long   | The time in milliseconds to wait after the start time to wait before scheduling the message again |
| AMQ_SCHEDULED_REPEAT | int    | The number of times to repeat scheduling a message for delivery |
| AMQ_SCHEDULED_CRON   | String | Use a Cron entry to set the schedule                         |

3.修改配置文件并重启： 要在activemq.xml中配置schedulerSupport属性为true 

4.代码实现

```java
// 延迟的时间
textMessage.setLongProperty(ScheduledMessage.AMQ_SCHEDULED_DELAY, delay);
// 重复投递的时间间隔
textMessage.setLongProperty(ScheduledMessage.AMQ_SCHEDULED_PERIOD, period);
// 重复投递的次数
textMessage.setIntProperty(ScheduledMessage.AMQ_SCHEDULED_REPEAT, repeat);
// 此处的意思：该条消息，等待10秒，之后每5秒发送一次，重复发送3次。
messageProducer.send(textMessage);
```



### 6.3 消息消费的重试机制

1.重试机制是什么

官网文档：http://activemq.apache.org/redelivery-policy

消费者收到消息，之后出现异常了，没有告诉broker确认收到该消息，broker会尝试再将该消息发送给消费者。尝试n次，如果消费者还是没有确认收到该消息，那么该消息将被放到死信队列中，之后broker不会再将该消息发送给消费者。

2.具体哪些情况会引发消息重发

- Client用了transaction且再session中调用了rollback

- Client用了transactions且再调用commit之前关闭或者没有commit

- Client再CLIENT_ACKNOWLEDGE的传递模式下，session中调用了recover

3.请说说消息重发时间间隔和重发次数

默认情况

间隔：1

次数：6

每秒：6

4.有毒消息Poison ACK

一个消息被redelivedred超过默认的最大重发次数（默认6次）时，消费者向MQ发一个“poison ack”表示这个消息有毒，告诉broker不要再发了。这个时候broker会把这个消息放到DLQ（死信队列）。

5.代码实现

```java
// 修改默认参数，设置消息消费重试3次
RedeliveryPolicy redeliveryPolicy = new RedeliveryPolicy();
redeliveryPolicy.setMaximumRedeliveries(3);
activeMQConnectionFactory.setRedeliveryPolicy(redeliveryPolicy);
```

### Available Properties

| Property                   | Default Value | Description                                                  |
| -------------------------- | ------------- | ------------------------------------------------------------ |
| `backOffMultiplier`        | `5`           | The back-off multiplier.                                     |
| `collisionAvoidanceFactor` | `0.15`        | The percentage of range of collision avoidance if enabled.   |
| `initialRedeliveryDelay`   | `1000L`       | The initial redelivery delay in milliseconds.                |
| `maximumRedeliveries`      | `6`           | Sets the maximum number of times a message will be redelivered before it is considered a **poisoned pill** and returned to the broker so it can go to a Dead Letter Queue. Set to `-1` for unlimited redeliveries. |
| `maximumRedeliveryDelay`   | `-1`          | Sets the maximum delivery delay that will be applied if the `useExponentialBackOff` option is set. (use value `-1` to define that no maximum be applied) (v5.5). |
| `redeliveryDelay`          | `1000L`       | The delivery delay if `initialRedeliveryDelay=0` (v5.4).     |
| `useCollisionAvoidance`    | `false`       | Should the redelivery policy use collision avoidance.        |
| `useExponentialBackOff`    | `false`       | Should exponential back-off be used, i.e., to exponentially increase the timeout. |

### 6.4 死信队列    

1.死信队列是什么

官网文档： http://activemq.apache.org/redelivery-policy

死信队列：异常消息规避处理的集合，主要处理失败的消息。

​		ActiveMQ中引入了“死信队列”（Dead Letter Queue）的概念。即一条消息在被重发多次以后（默认为6次redeliveryCounter=6），被ActiveMQ移入“死信队列”。开发人员可以在这个Queue中查看处理消息，进行人工干预。

​		 一般生产环境中在使用MQ的时候设计两个队列：一个是核心业务队列，一个是死信队列。

​		核心业务队列，就是比如上图专门用来让订单系统发送订单消息的，然后另外一个死信队列就是用来处理异常情况的。

​		假如第三方物流系统故障了，此时无法请求，那么仓储系统每次消费到一条订单消息，尝试通知发货和配送都会遇到对方的借口报错。此时仓储系统就可以把这条消息拒绝访问或者标记为处理失败。一旦标记这条消息处理失败了之后，MQ就会把这条消息转入提前设置好的一个死信队列中。然后你会看到的就是，在第三方物流系统故障期间，所有的订单消息全部处理失败，全部都会转入到死信队列。然后你的仓储系统得专门找一个后台线程，监控第三方物流系统是否正常，是否能请求，不停地监视。一旦发现对方恢复正常，这个后台线程就从死信队列消费出来处理失败的订单，重新执行发货和配送通知。 

2.死信队列的配置  

3.自动删除过期消息



### 6.5 保证消息不被重复消费 

如何保证消息不被重复消费呢？关键就是幂等。

网络延迟传输中，会造成MQ重试，在重试过程中，可能会造成重复消费。

1. 数据库的唯一约束。

   如果消息是做数据库的插入操作，可以给这个消息设一个唯一主键ID，那么即使出现重复消费的情况，就会导致主键冲突，避免数据库脏数据。

2. 消费记录，记录关键的key标识。以redis为例，给消息分配一个全局id，只要消费过该消息，将<id,message>以K-V形式写入redis服务器。消费者每次开始消费前，先去查这个消息是否消费过了。



## 性能优化

### 生产者发送效率、产出率低

因素：

1.网络延时

2.服务器性能低

优化：

1.异步投递

2.批量投递（使用事务实现）

