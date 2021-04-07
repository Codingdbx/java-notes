# Zookeeper 入门 

## 1.概述

Zookeeper 是一个开源的为分布式应用提供协调服务的项目，角色就像是“管理员”。

**Zookeeper = 文件系统 + 通知机制**

## 2.Zookeeper特点 

- 一个领导者（Leader），多个跟随者（Follower）组成的集群。
- 集群中只要有半数以上节点存活，Zookeeper集群就能正常服务。
- 全局数据一致：每个Server保存一份相同的数据副本，Client无论连接到哪个Server，数据都是一致的。
- 更新请求顺序进行，来自同一个Client的更新请求按其发送顺序依次执行。
- 数据更新原子性，一次数据更新要么成功，要么失败。
- 实时性，在一定时间范围内，Client能读到最新数据。 

## 3.配置参数 

- tickTime =2000：通信心跳数

  Zookeeper 服务器与客户端心跳时间，单位毫秒 。

- initLimit =10：LF 初始通信时限 

  限定集群中的Zookeeper服务器连接到Leader的时限，超过 `initLimit * tickTime`，认为连接失败。

- syncLimit =5：LF 同步通信时限 

  假如响应超过`syncLimit * tickTime`，Leader认为Follwer死掉，从服务器列表中删除Follwer。 

- dataDir：数据文件目录 + 数据持久化路径  

  主要用于保存 Zookeeper 中的数据。 

- clientPort =2181：客户端连接端口 

   监听客户端连接的端口。 

## 4.客户端命令行操作 

| 命令基本语法     | 功能描述                                                    |
| ---------------- | ----------------------------------------------------------- |
| help             | 显示所有操作命令                                            |
| ls path [watch]  | 使用 ls 命令来查看当前 znode 中所包含的内容                 |
| ls2 path [watch] | 查看当前节点数据并能看到更新次数等数据                      |
| ==create==       | 普通创建 <br />-s 含有序列<br />-e 临时（重启或者超时消失） |
| get path [watch] | 获得节点的值                                                |
| set              | 设置节点的具体值                                            |
| stat             | 查看节点状态                                                |
| delete           | 删除节点                                                    |
| rmr              | 递归删除节点                                                |



## 5.创建 ZooKeeper 客户端 

```java
@SpringBootTest
public class TestConnection {

    private static String connectString = "192.168.1.8:2181,192.168.1.9:2181,192.168.1.10:2181";

    private static int sessionTimeout = 2000;

    private ZooKeeper zkClient = null;

    @Before
    public void init() throws Exception {
        zkClient = new ZooKeeper(connectString, sessionTimeout, event -> {
                    // 收到事件通知后的回调函数（用户的业务逻辑）
                    System.out.println(event.getType() + "--" + event.getPath());
                    // 再次启动监听
                    try {
                        zkClient.getChildren("/", true);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                });
    }

    // 创建子节点
    @Test
    public void create() throws Exception {
        // 参数 1：要创建的节点的路径
        // 参数 2：节点数据
        // 参数 3：节点权限
        // 参数 4：节点的类型
        String nodeCreated = zkClient.create("/danny01", "test01".getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT);
    }

    // 获取子节点
    @Test
    public void getChildren() throws Exception {
        List<String> children = zkClient.getChildren("/", true);
        for (String child : children) {
            System.out.println(child);
        }

        // 延时阻塞
        Thread.sleep(Long.MAX_VALUE);
    }

    // 判断 znode 是否存在
    @Test
    public void exist() throws Exception {
        Stat stat = zkClient.exists("/danny", false);
        System.out.println(stat == null ? "not exist" : "exist");
    }
}
```



## 6.监听服务器节点动态上下线 

```java
public class DistributeClient {
    private static String connectString = "192.168.1.8:2181,192.168.1.9:2181,192.168.1.10:2181";
    private static int sessionTimeout = 2000;
    private ZooKeeper zk = null;
    private String parentNode = "/servers";

    // 创建到 zk 的客户端连接
    public void getConnect() throws IOException {
        zk = new ZooKeeper(connectString, sessionTimeout, event -> {
            // 再次启动监听
            try {
                getServerList();
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }

    // 获取服务器列表信息
    public void getServerList() throws Exception {
        // 1 获取服务器子节点信息，并且对父节点进行监听
        List<String> children = zk.getChildren(parentNode, true);

        // 2 存储服务器信息列表
        ArrayList<String> servers = new ArrayList<>();

        // 3 遍历所有节点，获取节点中的主机名称信息
        for (String child : children) {
            byte[] data = zk.getData(parentNode + "/" + child, false, null);
            servers.add(new String(data));
        }

        // 4 打印服务器列表信息
        System.out.println(servers);
    }

    // 业务功能
    public void business() throws Exception{
        System.out.println("client is working ...");
        Thread.sleep(Long.MAX_VALUE);
    }

    public static void main(String[] args) throws Exception {
        // 1 获取 zk 连接
        DistributeClient client = new DistributeClient();
        client.getConnect();

        // 2 获取 servers 的子节点信息，从中获取服务器信息列表
        client.getServerList();

        // 3 业务进程启动
        client.business();
    }
}

```

```java
public class DistributeServer {
    private static String connectString = "192.168.1.8:2181,192.168.1.9:2181,192.168.1.10:2181";
    private static int sessionTimeout = 2000;
    private ZooKeeper zk = null;
    private String parentNode = "/servers";

    // 创建到 zk 的客户端连接
    public void getConnect() throws IOException {
        zk = new ZooKeeper(connectString, sessionTimeout, event -> {

        });
    }

    // 注册服务器
    public void registerServer(String hostname) throws Exception{
        String create = zk.create(parentNode + "/server", hostname.getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE,
                CreateMode.EPHEMERAL_SEQUENTIAL);

        System.out.println(hostname +" is online "+ create);
    }

    // 业务功能
    public void business(String hostname) throws Exception{
        System.out.println(hostname+" is working ...");
        Thread.sleep(Long.MAX_VALUE);
    }

    public static void main(String[] args) throws Exception {
        // 1 获取 zk 连接
        DistributeServer server = new DistributeServer();
        server.getConnect();

        // 2 利用 zk 连接注册服务器信息
        server.registerServer("192.168.0.110");

        // 3 启动业务功能
        server.business("192.168.0.110");
    }
}
```

