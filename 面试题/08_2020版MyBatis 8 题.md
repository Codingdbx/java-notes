## 2020版MyBatis 面试题

### 1. MyBatis 工作原理？

1、加载MyBatis全局配置文件（mybatis-config.xml、mapper.xml映射文件等），解析配置文件生成Configuration，和一个个MappedStatement（包括了参数映射配置、动态SQL语句、结果映射配置），其对应着<select | update | delete | insert>标签项。

2、SqlSessionFactoryBuilder通过Configuration对象生成SqlSessionFactory，用来开启SqlSession。

3、SqlSession对象完成和数据库的交互。

### 2. MyBatis 中 #{}和 ${}的区别是什么？ 

\#{}是预编译处理，${}是字符替换。 在使用 #{}时，MyBatis 会将 SQL 中的 #{}替换成“?”，配合 PreparedStatement 的 set 方法赋值，这样可以有效的防止 SQL 注入，保证程序的运行安全。 

### 3. MyBatis 有几种分页方式？ 

分页方式：逻辑分页和物理分页。 

* 逻辑分页： 

  使用 MyBatis 自带的 RowBounds 进行分页，它是一次性查询很多数据，然后在数据中再进行检索。 这样做弊端是需要消耗大量的内存，有内存溢出的风险，对数据库压力较大。

* 物理分页： 

  自己手写 SQL 分页或使用分页插件 PageHelper，去数据库查询指定条数的分页数据的形式。 

### 4. RowBounds 是一次性查询全部结果吗？为什么？ 

RowBounds 表面是在“所有”数据中检索数据，其实并非是一次性查询出所有数据，因为 MyBatis 是对 jdbc 的封装，在 jdbc 驱动中有一个 Fetch Size 的配置，它规定了每次 最多从数据库查询多少条数据，假如你要查询更多数据，它会在你执行 next()的时候，去查询更多的数据。就好比你去自动取款机取 10000 元，但取款机每次最多能取 2500 元， 所以你要取 4 次才能把钱取完。只是对于 jdbc 来说，当你调用 next()的时候会自动帮你完成查询工作。这样做的好处可以有效的防止内存溢出。

 

### 5. MyBatis 是否支持延迟加载？延迟加载的原理是什么？ 

MyBatis 支持延迟加载，设置 lazyLoadingEnabled=true 即可。 
延迟加载的原理的是调用的时候触发加载，而不是在初始化的时候就加载信息。比如调用 a. getB(). getName()，这个时候发现 a. getB() 的值为 null，此时会单独触发事先保存好的关联B对象的SQL，先查询出来 B，然后再调用 a. setB(b)，而这时候再调用 a. getB(). getName() 就有值了，这就是延迟加载的基本原理。 

### 6. 说一下 MyBatis 的一级缓存和二级缓存？ 

Mybatis中有一级缓存和二级缓存，默认情况下一级缓存是开启的，而且是不能关闭的。

* 一级缓存

  是指 SqlSession 级别的缓存，当在同一个 SqlSession 中进行相同的 SQL 语句查询时，第二次以 后的查询不会从数据库查询，而是直接从缓存中获取，一级缓存最多缓存1024条SQL。

* 二级缓存

  是指mapper 级别的缓存，可以跨 SqlSession 的缓存。对于 mapper 级别的缓存不同的 sqlsession是可以共享的。 



开启二级缓存数据查询流程：二级缓存 -> 一级缓存 -> 数据库。 

缓存更新机制：当某一个作用域(一级缓存 Session/二级缓存 Mapper)进行了 C/U/D 操作 后，默认该作用域下所有 select 中的缓存将被 clear。 

#### 一级缓存原理（sqlsession级别） 

第一次发出一个查询 sql，sql 查询结果写入 sqlsession 的一级缓存中，缓存使用的数据结构是一 个map。 

key：MapperID+offset+limit+Sql+所有的入参 
value：用户信息 
同一个 sqlsession 再次发出相同的 sql，就从缓存中取出数据。如果两次中间出现 commit 操作 （修改、添加、删除），本 sqlsession 中的一级缓存区域全部清空，下次再去缓存中查询不到所 以要从数据库查询，从数据库查询到再写入缓存。 

#### 二级缓存原理（mapper级别） 

二级缓存的范围是mapper级别（mapper同一个命名空间），mapper以命名空间为单位创建缓存数据结构，结构是map。mybatis的二级缓存是通过CacheExecutor实现的。CacheExecutor其实是 Executor 的代理对象。所有的查询操作，在 CacheExecutor 中都会先匹配缓存中是否存 在，不存在则查询数据库。 

key：MapperID+offset+limit+Sql+所有的入参 
具体使用需要配置：

 1. Mybatis全局配置中启用二级缓存配置 
  2. 在对应的Mapper.xml中配置cache节点 
  3. 在对应的select查询节点中添加useCache=true

### 7. MyBatis 有哪些执行器（Executor）？ 

MyBatis 有三种基本的 Executor 执行器： 

* SimpleExecutor：每执行一次 update 或 select 就开启一个 Statement 对象，用 完立刻关闭 Statement 对象； 
* ReuseExecutor：执行 update 或 select，以 SQL 作为 key 查找 Statement 对象， 存在就使用，不存在就创建，用完后不关闭 Statement 对象，而是放置于 Map 内供 下一次使用。简言之，就是重复使用 Statement 对象； 
* BatchExecutor：执行 update（没有 select，jdbc 批处理不支持 select），将所有 SQL 都添加到批处理中addBatch()，等待统一执行executeBatch()，它缓存了多个 Statement 对象，每个 Statement 对象都是 addBatch()完毕后，等待逐一执行 executeBatch()批处理，与 jdbc 批处理相同。 

### 8. MyBatis 分页插件的实现原理是什么？ 

分页插件的基本原理是使用 MyBatis 提供的插件接口，实现自定义插件，在插件的拦截方 法内拦截待执行的 SQL，然后重写 SQL，根据 dialect 方言，添加对应的物理分页语句和物理分页参数。 

MyBatis 如何编写一个自定义插件？ 
自定义插件实现原理 MyBatis 自 定 义 插 件 针 对 MyBatis 四 大 对 象 （ Executor 、 StatementHandler 、 ParameterHandler、ResultSetHandler）进行拦截： 

* Executor：拦截内部执行器，它负责调用 StatementHandler 操作数据库，并把结果集通过 ResultSetHandler 进行自动映射，另外它还处理了二级缓存的操作。 
* StatementHandler：拦截 SQL 语法构建的处理，它是 MyBatis 直接和数据库执行 SQL 脚本的对象，另外它也实现了 MyBatis 的一级缓存。 
* ParameterHandler：拦截参数的处理。
* ResultSetHandler：拦截结果集的处理。 



MyBatis 自定义插件实现关键是要实现 Interceptor 接口，接口包含的方法，如下： 

```java
public interface Interceptor {       
	Object intercept(Invocation invocation) throws Throwable;           
	Object plugin(Object target);        
	void setProperties(Properties properties); 
} 
```

* setProperties 方法是在 MyBatis 进行配置插件的时候可以配置自定义相关属性， 即：接口实现对象的参数配置。 
* plugin 方法是插件用于封装目标对象的，通过该方法我们可以返回目标对象本身， 也可以返回一个它的代理，可以决定是否要进行拦截进而决定要返回一个什么样的目标对象，官方提供了示例：return Plugin. wrap(target, this)。
* intercept 方法就是要进行拦截的时候要执行的方法。

自定义插件实现示例，官方插件实现：

```java
@Intercepts({@Signature(type = Executor.class, method = "query",args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class})}) 
public class TestInterceptor implements Interceptor {    
    public Object intercept(Invocation invocation) throws Throwable {      
        Object target = invocation. getTarget(); // 被代理对象
      	Method method = invocation. getMethod(); // 代理方法
      	Object[] args = invocation. getArgs(); // 方法参数
      	// do something . . . . . .  方法拦截前执行代码块
      	Object result = invocation. proceed();      
        // do something . . . . . . . 方法拦截后执行代码块
      return result;    
    }    
    public Object plugin(Object target) {      
        return Plugin. wrap(target, this);    
    } 
} 
```





























