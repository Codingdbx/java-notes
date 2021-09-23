# java各版本的新特性

## Java8 新特性

Java 8(又称为jdk 1.8) 是Java语言开发的一个主要版本。Java 8是oracle公司于2014年3月发布， 可以看成是自Java5以来最具革命性的版本。Java 8为Java语言、编译器、类库、开发工具与JVM带来了大量新特性。

### 1. Lambda表达式

为什么使用Lambda表达式
Lambda是一个匿名函数， 我们可以把Lambda表达式理解为是一段可以传递的代码(将代码像数据一样进行传递)。使用它可以写出更简洁、更灵活的代码。作为一种更紧凑的代码风格， 使Java的语言表达能力得到了提升。

在Java 8中， Lambda表达式是对象， 而不是函数， 它们必须依附于一类特别的对象类型：函数式接口。

#### 语法格式一：无参，无返回值

```java
@Test
public void test() {
    Runnable r1 = new Runnable() {
        @Override
        public void run() {
      	   System.out.println("lalalalalalala");
        }
    };
    r1.run();
    
    Runnable r2=()->System.out.println("lalalalalalala");
    r2.run();
}
```

#### 语法格式二：Lambda需要一个参数， 但是没有返回值

```java
@Test
public void test() {
    Consumer<String> con = new Consumer<String>() {
        @Override
        public void accept(String s) {
        	System.out.println(s);
        }
    );
    con.accept(t:"lalalalalalal");
  
    Consumer<String> con1 = (String s) ->{
    	System.out.println(s);
    };
    con1.accept(t:"lalalalalalalala");
}
```

#### 语法格式三：类型推断

数据类型可以省略，因为可由编译器推断得出，称为“类型推断”。

```java
@Test
public void test() {
    Consumer<String> con1 = (String s) ->{
   	 	System.out.println(s);
    };
    con1.accept(t:"lalalalalalaala");        
 
    Consumer<String> con2 = (s) ->{
    	System.out.println(s);
    };
    con2.accept(t:"lalalalalalaaaala");
}
```

#### 语法格式四：Lambda若只需要一个参数时， 参数的小括号可以省略

```java
@Test
public void test() {
    Consumer<String> con1 = (s) ->{
    	System.out.println(s);
    };
    con1.accept(t:"lalalallalala");
   
    Consumer<String> con2 = s->{
   	 	System.out. println(s);
    };
    con2.accept(t:"lalalalalalalalala");
}
```

#### 语法格式五：Lambda需要两个或以上的参数， 多条执行语句， 并且可以有返回值



```java
@Test
public void test() {
    Comparator<Integer> com1 = new Comparator<Integer>() {
        @override
        public int compare(Integer o1,Integer o2) {
            System.out.println(o1);
            System.out.println(o2);
            return o1.compareTo(o2);
        }
    };
    System.out.println(com1.compare(12,21));

    Comparator<Integer> com2 = (o1,o2) ->{
        System.out.println(o1);
        System.out.println(o2);
        return o1.compareTo(o2);
    };
    System.out.println(com2.compare(12,6));
}
```

#### 语法格式六：当Lambda体只有一条语句时， return与大括号若有， 都可以省略

```java
@Test
public void test() {
    Comparator<Integer> com1 = (o1,o2) ->{
    	return o1.compareTo(o2);
    };
    System.out.println(com1.compare(12,6));
  
    Comparator<Integer> com2 = (o1,o2) ->o1.compareTo(o2);
    System.out.println(com2.compare(12,21));
}
```



### 2. 函数式(Functional) 接口

什么是函数式接口

- ==只包含一个抽象方法的接口，称为函数式接口==。
- 你可以通过Lambda表达式来创建该接口的对象。(若Lambda表达式抛出一个受检异常(即：非运行时异常)，那么该异常需要在目标接口的抽象方法上进行声明)。
- `我们可以在一个接口上使用@Functionallnterface注解， 这样做可以检查它是否是一个函数式接口。同时javadoc也会包含一条声明， 说明这个接口是一个函数式接口。`
- `在java.util.function包下定义了Java 8的丰富的函数式接口。`

如何理解函数式接口

- `Java从诞生日起就是一直倡导“一切皆对象”， 在Java里面面向对象(OOP)编程是一切。但是随着python、scala等语言的兴起和新技术的挑战， Java不得不做出调整以便支持更加广泛的技术要求， 也即java不但可以支持OOP还可以支持O OF(面向函数编程)。`
- 在函数式编程语言当中，函数被当做一等公民对待。在将函数作为一等公民的编程语言中， Lambda表达式的类型是函数。但是在Java 8中， 有所不同。==在Java 8中， Lambda表达式是对象， 而不是函数， 它们必须依附于一类特别的对象类型——函数式接口。==
- 简单的说， 在Java 8中， Lambda表达式就是一个函数式接口的实例。这就是Lambda表达式和函数式接口的关系。也就是说， 只要一个对象是函数式接口的实例， 那么该对象就可以用Lambda表达式来表示。
- `所以以前用匿名实现类表示的现在都可以用Lambda表达式来写。`

Java内置四大核心函数式接口

| `函数式接口`               | `参数类型` | `返回类型` | `用途`                                                       |
| -------------------------- | ---------- | ---------- | ------------------------------------------------------------ |
| `Consumer <T>消费型接口`   | T          | void       | `对类型为T的对象应用操作，包含方法：<br/>void accept(T t)`   |
| `Supplier<T> 供给型接口`   | `无`       | `T`        | `返回类型为T的对象， 包含方法：T get()`                      |
| `Function<T,R> 函数型接口` | `T`        | `R`        | `对类型为T的对象应用操作，<br />并返回结果。结果是R类型的对象。<br />包含方法：R apply(T t)` |
| `Predicate<T> 断定型接口`  | `T`        | `boolean`  | `确定类型为T的对象是否满足某约束，<br />并返回boolean值。包含方法：boolean test(T t)` |



### 3. 方法引用与构造器引用

#### 方法引用(Method References)

- `当要传递给Lambda体的操作， 已经有实现的方法了， 可以使用方法引用!`
- `方法引用可以看做是Lambda表达式深层次的表达。换句话说， 方法引用就是Lambda表达式， 也就是函数式接口的一个实例， 通过方法的名字来指向一个方法， 可以认为是Lambda表达式的一个语法糖。`
- `要求：实现接口的抽象方法的参数列表和返回值类型，必须与方法引用的方法的参数列表和返回值类型保持一致!`
- `格式：使用操作符“：：”将类(或对象)与方法名分隔开来。`
- `如下三种主要使用情况：`

>`对象 ：：实例方法名`
>`类 ：：静态方法名`
>`类 ：：实例方法名`

#### 构造器引用(Constructor References)

SuppLier中的 T get()
EmpLoyee的空参构造器：EmpLoyee()

```java
@Test
public void test() {
    Supplier<Employee> sup = new Supplier<Employee>() {
        @Override
        public Employee get() {
           return new Employee();
        }
    };
    
    System.out.println("*****************");
    
    Supplier<Employee> sup1 = () -> new Employee();
    System.out.println(sup1.get());
    
    System.out.println("******************");
    
    Supplier<Employee> sup2 = Employee::new;
    System.out.println(sup2.get());
}
```



### 4. 强大的Stream API

#### 什么是Stream

- `Stream到底是什么呢？是数据渠道，用于操作数据源(集合、数组等)所生成的元素序列。“==集合讲的是数据， Stream讲的是计算！==”`
- 注意
  ①Stream自己不会存储元素。
  ②Stream不会改变源对象。相反， 他们会返回一个持有结果的新Stream。
  ③Stream操作是延迟执行的。这意味着他们会等到需要结果的时候才执行。


#### Stream API说明

- `Java 8中有两大最为重要的改变。第一个是Lambda表达式； 另外一个则是Stream API。`
- `Stream API(java.util stream) 把真正的函数式编程风格引入到Java中。这是目前为止对Java类库最好的补充， 因为Stream API可以极大提供Java程序员的生产力，让程序员写出高效率、干净、简洁的代码。`
- `Stream是Java 8中处理集合的关键抽象概念， 它可以指定你希望对集合进行的操作，可以执行非常复杂的查找、过滤和映射数据等操作。使用Stream API对集合数据进行操作， 就类似于使用SQL执行的数据库查询。也可以使用Stream API来并行执行操作。简言之， Stream API提供了一种高效且易于使用的处理数据的方式。`
- `Java 8可以透明地把输入的不相关部分拿到几个CPU内核上去分别执行你的Stream操作流水线。`
- `Stream支持许多处理数据的并行操作，其思路和在数据库查询语言中的思路类似。`

#### 为什么要使用Stream API

- `实际开发中， 项目中多数数据源都来自于Mysql， Oracle等。但现在数据源可以更多了， 有Mon gDB， Red is 等， 而这些No SQL的数据就需要Java层面去处理。`
- `Stream和Collection集合的区别：Collection是一种静态的内存数据结构， 而Stream是有关计算的。前者是主要面向内存， 存储在内存中，后者主要是面向CPU， 通过CPU实现计算。`
- `例如你一个接口如果里面不仅要返回全部数据，还要返回满足某个条件的数据，用stream处理结果集就可以少操作一次数据库了，这样反而可能提高了性能，同时代码也简洁了。` 

#### 并行流与串行流

并行流就是把一个内容分成多个数据块，并用不同的线程分别处理每个数据块的流。相比较串行的流，并行的流可以很大程度上提高程序的执行效率。Java 8中将并行进行了优化， 我们可以很容易的对数据进行并行操作。Stream API 可以声明性地通过parallel() 与sequential() 在并行流与顺序流之间进行切换。

#### Stream的操作三个步骤

##### 创建Stream

一个数据源(如：集合、数组)，获取一个流。

**创建Stream方式一：通过集合**

Java 8中的Collection接口被扩展， 提供了两个获取流的方法：

> - `default Stream<E>  stream() ：返回一个顺序流`
>
> - `default Stream<E>  parallelStream() ：返回一个并行流`
>
> ```java
> @Test
> public void test() {
>     List<Employee> employees = EmployeeData.getEmpLoyees();
>     //defauLt Stream<E> stream() ：返回一个顺序流
>     Stream<Employee> stream = employees.stream();
> 
>     //default Stream<E>paralLel Stream() ：返回一个并行流
>     Stream<Employee> parallelStream = employees.parallelStream();
> }
> ```



**创建Stream方式二：通过数组**
Java 8中的Arrays的静态方法stream() 可以获取数组流：

static<T> Stream<T> stream(T[] array) ：返回一个流

重载形式，能够处理对应基本类型的数组：

> - `public static Int Stream stream(int[] array)`
> - `public static Long Stream stream(long[] array)`
> - `public static Double Stream stream(double[] array)`
>
> ```java
> @Test
> public void test() {
>     int[] arr=new int[] {1,2,3,4,5,6};
>     IntStream stream = Arrays.stream(arr);
>     
>     Employee e1 = new Employee (id: 1001, name:"Tom");
>     Employee e2 = new Employee (id: 1002, name:"Jerry");    
>     Employee[] arr1 = new Employee[]{e1, e2};
>     
>     Stream<Employee> stream1 = Arrays.stream(arr1);
> }
> ```



**创建Stream方式三：通过Stream的of()**

可以调用Stream类静态方法of() ， 通过显示值创建一个流。它可以接收任意数量的参数。
public static<T> Stream<T> of(T...values) ：返回一个流

```java
@Test
public void test() {
	Stream<Integer> stream = Stream.of(1, 2, 3, 4, 5, 6);
}
```

**创建Stream方式四：创建无限流**
可以使用静态方法Stream.iterate() 和 Stream.generate() ，创建无限流。

> `迭代`
>
> - `public static<T> Stream<T> iterate(final T seed，final UnaryOperator<T> f)`
>
> `生成`
>
> - `public static<T> Stream<T> generate(Supplier<T>s)`
>
> ```java
> @Test
> public void test() {
>     //遍历前10个偶数
>     Stream.iterate(seed:e, t->t+2).1imit(10).forEach(System.out::println);
>     //生成
>     Stream.generate(Math::random).1imit(10).forEach(System.out::println);
> }
> ```



##### 中间操作

一个中间操作链，对数据源的数据进行处理。
多个中间操作可以连接起来形成一个流水线，除非流水线上触发终止操作，否则中间操作不会执行任何的处理！而在终止操作时一次性全部处理，称为“惰性求值”。

**1-筛选与切片**

| `方法`                | `描述`                                                       |
| --------------------- | ------------------------------------------------------------ |
| `filter(Predicate p)` | `接收Lambda， 从流中排除某些元素`                            |
| `distinct()`          | `筛选， 通过流所生成元素的hashCode() 和equals() 去除重复元素` |
| `limit(long maxSize)` | `截断流，使其元素不超过给定数量`                             |
| `skip(long n)`        | `跳过元素，返回一个扔掉了前n个元素的流。若流中元素<br />不足n个，则返回一个空流。与limit(n) 互补` |

```java
@Test
public void test() {
    List<Employee> list = EmployeeData.getEmpLoyees();
    Stream<Employee> stream = list.stream();
    
    //filter(Predicate p) 一接收Lambda,从流中排除某些元素。  
    //练习：查询员工表中薪资大于7000的员工信息
    stream.filter(e->e.getSalary() >7000).forEach(System.out::println);
 
    //Limit(n) 一截断流， 使其元素不超过给定数量。
    list.stream().1imit(3).forEach(System.out::println);
  
    //skip(n)-跳过元素，返回一个扔掉了前n个元素的。若流中元素不足n个,则返回一个空流。与 Limit(n) 互补
    list.stream().skip(3).forEach(System.out::println);
	
    //筛选
    list.stream().distinct().forEach(System.out::println);

}
```



**2-映射**

| `方法`                             | `描述`                                                       |
| ---------------------------------- | ------------------------------------------------------------ |
| `map(Function f)`                  | `接收一个函数作为参数，该函数会被应用到每个<br />元素上，并将其映射成一个新的元素` |
| `map ToDouble(ToDoubleFunction f)` | `接收一个函数作为参数，该函数会被应用到每个<br />元素上， 产生一个新的DoubleStream` |
| `map ToInt(ToIntFunction f)`       | `接收一个函数作为参数，该函数会被应用到每个<br />元素上， 产生一个新的IntStream` |
| `map ToLong(ToLongFunction f)`     | `接收一个函数作为参数，该函数会被应用到每个<br />元素上， 产生一个新的LongStream` |
| `flat Map(Function f)`             | `接收一个函数作为参数，将流中的每个值都换成另<br/>一个流，然后把所有流连接成一个流` |

```java
@Test
public void test() {
    //map(Function f) 一接收一个函数作为参数， 将元素转换成其他形式或提取信息， 
    //该函数会被应用到每个元素上，并将其映射成一个新的元素
    List<String> list = Arrays.asList("aa", "bb","cc", "dd");
    list.stream().map(str->str.toUpperCase()).forEach(System.out::println);

    //练习：获取员工姓名长度大于3的员工的姓名。
    List<Employee> employees = EmployeeData.getEmpLoyees();
    Stream<String> namesStream = employees.stream().map(Employee::getName);
    namesStream.filter(name->name.length()>3).forEach(System.out::println);
    
}
```



**3-排序**

| `方法`                   | `描述`                               |
| ------------------------ | ------------------------------------ |
| `sorted()`               | `产生一个新流，其中按自然顺序排序`   |
| `sorted(Comparator com)` | `产生一个新流，其中按比较器顺序排序` |

```java
@Test
public void test 4() {
    //sorted() 一自然排序
    List<Integer> list=Arrays.as List(12, 43, 65, 34, 87, 0, -98, 7);
    list.stream().sorted().forEach(System.out::println);
    
    //抛异常， 原因：EmpLoyee没有实现Comparable接口
    //List<EmpLoyee> empLoyees = EmpLoyeeData.getEmpLoyees();
    //empLoyees.stream().sorted().forEach(System.out::printLn);
    
 
    //sorted(Comparator com) 一定制排序
    List<Employee> employees = EmployeeData.getEmpLoyees();
    employees.stream().sorted((e1,e2) ->
        int ageValue = Integer.compare(e1.getAge(), e2.getAge());
        if(ageValue!=0) {
            return ageValue;
        } else{
        	return Double.compare(e1.getSalary(),e2.getSalary());
        }
    }).forEach(System.out::println);
}
```



##### 终止操作(终端操作)

一旦执行终止操作，就执行中间操作链，并产生结果。之后，不会再被使用。

- 终端操作会从流的流水线生成结果。其结果可以是任何不是流的值，例如：List、Integer， 甚至是void。
- 流进行了终止操作后，不能再次使用。



**1-匹配与查找**

| 方法                   | 描述                     |
| ---------------------- | ------------------------ |
| allMatch(Predicate p)  | 检查是否匹配所有元素     |
| anyMatch(Predicate p)  | 检查是否至少匹配一个元素 |
| noneMatch(Predicate p) | 检查是否没有匹配所有元素 |
| find First()           | 返回第一个元素           |
| find Any()             | 返回当前流中的任意元素   |

```java
@Test
public void test() {
    List<Employee> employees = EmployeeData.getEmpLoyees();
    //aLLMatch(Predicate p) 一检查是否匹配所有元素。
    //练习：是否所有的员工的年龄都大于18
    boolean allMatch = employees.stream().allMatch(e->e.getAge() >18);
    System.out.println(allMatch);
    
    //anyMatch(Predicate p) 一检查是否至少匹配一个元素。
    //练习：是否存在员工的工资大于10000
    boolean anyMatch = employees.stream().anyMatch(e->e.getSalary() >10000);
    System.out.println(anyMatch);
    
    //none Match(Predicate p) 一检查是否没有匹配的元素.
    //练习：是否存在员工姓“雷”
    boolean noneMatch = employees.stream().noneMatch(e->e.getName().startswith("雷");
    System.out.println(noneMatch);
        
    //findFirst一返回第一个元素
    Optional<Employee> employee = employees.stream().findFirst();
    System.out.println(employee);

    //find Any一返回当前流中的任意元素
    Optional<Employee> employee1 = employees.parallelStream().findAny();
	System.out.println(employee1);
   
}
```



| 方法                | 描述                                                         |
| ------------------- | ------------------------------------------------------------ |
| count()             | 返回流中元素总数                                             |
| max(Comparator c)   | 返回流中最大值                                               |
| min(Comparator c)   | 返回流中最小值                                               |
| forEach(Consumer c) | 内部迭代(使用Collection接口需要用户去做迭代，<br/>称为外部迭代。相反， StreamAPI使用内部迭<br/>代——它帮你把迭代做了) |



```java
@Test
public void test() {
    List<Employee> employees = EmployeeData.getEmpLoyees();
    
    //count 返回流中元素的总个数
    long count = employees.stream().filter(e->e.getSalary() >5000).count();
    System.out.println(count);
    
    //max(Comparator c) 返回流中最大值
    //练习：返回最高的工资
    Stream<Double> salaryStream = employees.stream().map(e->e.getSalary());
    Optional<Double> maxSalary = salaryStream.max(Double::compare);
    System.out.println(maxSalary);
    
    //min(Comparator c) 返回流中最小值
    //练习：返回最低工资的员工
    Optional<Employee> employee = employees.stream().min((e1, e2) ->                                              Double.compare(e1.getSalary(),e2.getSalary()));
    System.out.println(employee);                       
                                                         
    //forEach(Consumer c) 内部迭代
    employees.stream().forEach(System.out::println) ;
                                                         
    //使用集合的遍历操作
    employees.forEach(System.out::println);

}

```



**2-归约**

| 方法                            | 描述                                                    |
| ------------------------------- | ------------------------------------------------------- |
| reduce(T iden,BinaryOperator b) | 可以将流中元素反复结合起来，得到一个值。返回T           |
| reduce(BinaryOperator b)        | 可以将流中元素反复结合起来，得到一个值。返回Optional<T> |

备注：map和reduce的连接通常称为map-reduce模式， 因Google用它来进行网络搜索而出名。

```java
@Test
public void test() {

    //练习1：计算1-10的自然数的和
    List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9,10);
    Integer sum = list.stream().reduce(identity:0, Integer::sum);
	System.out.println(sum);

    //练习2：计算公司所有员工工资的总和
    List<Employee> employees = EmployeeData.getEmpLoyees();
    Stream<Double> salaryStream = employees.stream().map(Employee::getSalary);
   
    //Optional<DoubLe> sumMoney = saLaryStream.reduce(DoubLe::sum);
    Optional<Double> sumMoney = salaryStream.reduce((d1,d2) ->d1+d2);
    System.out.println(sumMoney);
}
```



**3-收集**

| 方法                 | 描述                                                         |
| -------------------- | ------------------------------------------------------------ |
| collect(Collector c) | 将流转换为其他形式。接收一个Collector接口的实现， 用于<br />给Stream中元素做汇总的方法 |

- Collector接口中方法的实现决定了如何对流执行收集的操作(如收集到List、Set、Map)。

- 另外，Collectors实用类提供了很多静态方法， 可以方便地创建常见收集器实例，具体方法与实例如下表：

  | 方法             | 返回类型             | 作用                                    |
  | ---------------- | -------------------- | --------------------------------------- |
  | ==toList==       | List<T>              | 把流中元素收集到List                    |
  | ==toSet==        | Set<T>               | 把流中元素收集到Set                     |
  | ==toCollection== | Collection<T>        | 把流中元素收集到创建的集合              |
  | counting         | Long                 | 计算流中元素的个数                      |
  | summingInt       | Integer              | 对流中元素的整数属性求和                |
  | averagingInt     | Double               | 计算流中元素Integer属性的平均值         |
  | summarizingInt   | IntSummaryStatistics | 收集流中Integer属性的统计值。如：平均值 |

  ```java
  @Test
  public void test() {
      
      //练习1：查找工资大于6eee的员工， 结果返回为一个List或Set
      List<Employee> employees = EmployeeData.getEmpLoyees();
      List<Employee> employeeList = employees.stream()
          				.filter(e->e.getSalary()>6000).collect(Collectors.toList());
      employeeList.forEach(System.out::println);
  }
  ```

- 其他方法与实例如下表：

  | 方法              | 返回类型             | 作用                                                         |
  | ----------------- | -------------------- | ------------------------------------------------------------ |
  | joining           | String               | 连接流中每个字符串                                           |
  | maxBy             | Optional<T>          | 根据比较器选择最大值                                         |
  | minBy             | Optional<T>          | 根据比较器选择最小值                                         |
  | reducing          | 归约产生的类型       | 从一个作为累加器的初始值开始，<br/>利用BinaryOperator与流中元素逐<br/>个结合，从而归约成单个值 |
  | collectingAndThen | 转换函数返回的类型   | 包裹另一个收集器，对其结果转转换函数                         |
  | groupingBy        | Map<K,List<T>>       | 根据某属性值对流分组，属性为K，结果为V                       |
  | partitioningBy    | Map<Boolean,List<T>> | 根据true或false进行分区                                      |



### 5. Optional类

- 到目前为止， 臭名昭著的空指针异常是导致Java应用程序失败的最常见原因。以前， 为了解决空指针异常， Google公司著名的Guava项目引入了Optional类，Guava通过使用检查空值的方式来防止代码污染， 它鼓励程序员写更干净的代码。受到Google Guava的启发， Optional类已经成为Java 8类库的一部分。
- Optional<T>类java.util.Optional) 是一个容器类， 它可以保存类型T的值， 代表这个值存在。或者仅仅保存null， 表示这个值不存在。原来用null表示一个值不存在， 现在Optional可以更好的表达这个概念。并且可以避免空指针异常。
- Optional类的Javadoc描述如下：这是一个可以为null的容器对象。如果值存在则isPresent() 方法会返回true， 调用get() 方法会返回该对象。

Optional提供很多有用的方法， 这样我们就不用显式进行空值检测。

- 创建Optional类对象的方法：

  > Optional.of(T t) ：创建一个Optional实例， t必须非空；
  >
  > Optional.empty() ：创建一个空的Optional实例;
  > Optional.ofNullable(T t) ：==t可以为null==;

- 判断Optional容器中是否包含对象：

  >boolean isPresent() ：判断是否包含对象
  >void ifPresent(Consumer<? super  T> consumer) ：如果有值， 就执行Consumer接口的实现代码，并且该值会作为参数传给它

- 获取Optional容器的对象：

  >T get() ：如果调用对象包含值， 返回该值， 否则抛异常
  >T orElse(T other) ：如果有值则将其返回， 否则返回指定的other对象。
  >T orElseGet(Supplier<? extends T> other) ：如果有值则将其返回， 否则返回由Supplier接口实现提供的对象。
  >T orElseThrow(Supplier<? extends X> exceptionSupplier) ：如果有值则将其返回， 否则抛出由Supplier接口实现提供的异常。



```java
@Test
public void test() {
    Girl girl = new Girl();
    girl = null;
    Optional<Girl> optionalGirl = Optional.of(girl);
}

@Test
public void test2() {
    Girl girl = new Girl();
    girl = null;
    optional<Girl> optionalGirl = Optional.ofNulLable(girl)
    System.out.println(optionalGirl);
}

@Test
public void test3() {
    Girl girl = new Girl();
    girl = null; 
    //of NulLable(Tt) ：t可以为null
    Optional<Girl> optionalGirl = Optional.ofNullable(girl);
    System.out.println(optionalGirl);
    
    Girl girl1 = optionalGirl.orElse(new Girl(name:"zly"));
    System.out.println(girl1);
    
}
```



### 6. 接口增强

静态方法

默认方法

### 7. 新的时间和日期API

### 8. 其他新特性

#### 重复注解

#### 类型注解

#### 通用目标类型推断

#### JDK的更新

集合的流式操作
并发
Arrays
Number和Math
IO/NIO的改进
Reflection获取形参名
String:join()
Files

#### 新编译工具：jjs、jdeps

#### JVM中Metaspace取代PermGen空间



## Java9 新特性

Java 9 中有哪些不得不说的新特性?

> 1. `模块化系统`
>
> 2. `JShell命令`
>
> 3. `多版本兼容jar包`
>
> 4. `接口的私有方法`
>
> 5. `钻石操作符的使用升级`
> 6. `语法改进：try语句`
> 7. `String存储结构变更`
> 8. `便利的集合特性：of()`
> 9. `增强的Stream APi`
> 10. `全新的HTTP客户端API`
> 11. `Deprecated的相关API`
> 12. `javadoc的HTML5支持`
> 13. `Javascript引擎升级：Nashorn`
> 14. `java的动态编译器`



### 1. JDK 和 JRE目录结构的改变

#### JDK9的目录结构

没有名为jre的子目录。

- `bin 目录：包含所有命令。在Windows平台上， 它继续包含系统的运行时动态链接库。`
- `conf 目录：包含用户可编辑的配置文件， 例如以前位于jre\lib目录中的.properties和.policy文件。`
- `include目录：包含要在以前编译本地代码时使用的C/C++头文件。它只存在于JDK中。`
- `jmods 目录：包含 JMOD 格式的平台模块。创建自定义运行时映像时需要它。它只存在于JDK中。`
- `legal 目录：包含法律声明。`
- `lib 目录：包含非Windows平台上的动态链接本地库。其子目录和文件不应由开发人员直接编辑或使用。`



#### JDK8的目录结构

- `bin目录：包含命令行开发和调试工具， 如javac， jar 和 javadoc。`
- `include目录：包含在编译本地代码时使用的C/C++头文件。`
- `lib目录：包含JDK工具的几个JAR和其他类型的文件。它有一个tools.jar文件， 其中包含javac编译器的Java类`
- `jre/bin目录：包含基本命令， 如java命令。在Windows平台上， 它包含系统的运行时动态链接库(DLL) 。`
- `jre/lib目录：包含用户可编辑的配置文件， 如.properties 和 .policy文件。包含几个JAR。rt.jar文件包含运行时的Java类和资源文件。`

### 2. 模块化系统：Jigsaw -->Modularity

谈到Java 9大家往往第一个想到的就是Jigsaw项目。众所周知， Java已经发展超过20年(95年最初发布) ， Java和相关生态在不断丰富的同时也越来越暴露出一些问题：

- `Java运行环境的膨胀和臃肿。每次JVM启动的时候， 至少会有30~60MB的内存加载， 主要原因是JVM需要加载rt.jar， 不管其中的类是否被classloader加载， 第一步整个jar都会被JVM加载到内存当中去(而模块化可以根据模块的需要加载程序运行需要的class)`
- `当代码库越来越大，创建复杂，盘根错节的“意大利面条式代码”的几率呈指数级的增长。不同版本的类库交叉依赖导致让人头疼的问题， 这些都阻碍了Java开发和运行效率的提升。`
- `很难真正地对代码进行封装， 而系统并没有对不同部分(也就是JAR文件) 之间的依赖关系有个明确的概念。每一个公共类都可以被类路径之下任何其它的公共类所访问到， 这样就会导致无意中使用了并不想被公开访问的API。`
- `本质上讲也就是说， 用模块来管理各个package， 通过声明某个package，暴露模块(module) 的概念， 其实就是package外再裹一层， 不声明默认就是隐藏。因此，模块化使得代码组织上更安全，因为它可以指定哪些部分可以暴露，哪些部分隐藏。`
- `实现目标`
  - `模块化的主要目的在于减少内存的开销`
  - `只须必要模块， 而非全部jdk模块， 可简化各种类库和大型应用的开发和维护`
  - `改进Java SE平台， 使其可以适应不同大小的计算设备`
  - `改进其安全性，可维护性，提高性能`

### 3. Java的REPL工具：JShell命令

- `产生背景：像Python和Scala之类的语言早就有==交互式编程环境== REPL (read-evaluate-print-loop) 了， 以交互式的方式对语句和表达式进行求值。开发者只需要输入一些代码，就可以在编译前获得对程序的反馈。而之前的Java版本要想执行代码， 必须创建文件、声明类、提供测试方法方可实现。`
- `设计理念：即写即得、快速运行`
- `实现目标：Java 9中终于拥有了REPL工具：JShell。让Java可以像脚本语言一样运行， 从控制台启动 JShell， 利用 JShell在没有创建类的情况下直接声明变量， 计算表达式，执行语句。即开发时可以在命令行里直接运行Java的代码， 而无需创建Java文件， 无需跟人解释”public static void main(String] args) ”这句废话。JShell也可以从文件中加载语句或者将语句保存到文件中。JShell也可以是tab键进行自动补全和自动添加分号。`

### 4. 语法改进：接口的私有方法

Java8 中规定接口中的方法除了抽象方法之外， 还可以定义静态方法和默认的方法。一定程度上，扩展了接口的功能，此时的接口更像是一个抽象类。
在 Java9 中， 接口更加的灵活和强大， 连方法的访问权限修饰符都可以声明为private的了， 此时方法将不会成为你对外暴露的API的一部分。

### 5. 语法改进：钻石操作符使用升级

我们将能够与匿名实现类共同使用钻石操作符(diamond operator) 在Java 8
中如下的操作是会报错的：

```java
Comparator<Object> com = new Comparator<>() {
    @Override
    public int compare(Object o1， Object o2) {
  	  return 0;
    }
}
```

编译报错信息：Can not use “<>" with anonymous inner classes.

### 6. 语法改进：try语句

Java 8中， 可以实现资源的自动关闭， 但是要求执行后必须关闭的所有资源必须在try子句中初始化， 否则编译不通过。如下例所示：

```java
try(InputStreamReader reader = new InputStreamReader(System.in)) {
	//business
    
} catch(IOException e) {
	e.printStackTrace();
}
```

java 9中资源关闭操作

```java
InputStreamReader reader = new InputStreamReader(System.in);
try(reader) {
    char[] cbuf = new char[20];
    int len;
    if(( len = reader.read(cbuf)) != -1) {
        String str = new String(cbuf, 0, len);
        System.out.println(str);
    }
} catch(IOException e) {
	e.printStackTrace();
}
```



### 7. String存储结构变更

- `Motivation`
  `The current implementation of the String class stores characters in a char array, using two bytes(sixteen bits) for each character. Data gathered from many different applications indicates that strings area  major component of heap usage and, moreover, ==that most String objects contain only Latin -1 characters. Such characters require only one byte of storage，hence half of the space in the internal char arrays of such String objects is going unused.==`
- `Description`
  `We propose to ==change the internal representation of the String class from a UTF-16 char array to a byte array plus an encoding-flag field==. The new String class will store characters encoded either as ISO-8859-1/Latin-1(one byte per character) , or as UTF-16(two bytes per character) ,  based upon the contents of the string. The encoding flag will indicate which encoding is used.`



### 8. 集合工厂方法：快速创建只读集合

要创建一个只读、不可改变的集合，必须构造和分配它，然后添加元素，最后包装成一个不可修改的集合。

```java
List<String>names List = new ArrayList<>();
names List.add("Joe");
names List.add("Bob");
names List.add("Bill");
names List = Collections.unmodifiableList(names List);
System.out.println(names List);
```

缺点：我们一下写了五行。即：它不能表达为单个表达式。

如下操作不适用于jdk 8及之前版本， 适用于jdk 9

```java
Map<String,Integer> map = Collections.unmodifiableMap(new HashMap<>() {
    { 
        put("a",1);
    	put("b",2);
   		put("c",3);
	}
});
map.forEach( (k,v) -> System.out.println(k + ":" + v) );
```

java 9新特性：集合工厂方法：创建只读集合

```java
public void test() {
    List<Integer> list1 = List.of(1, 2, 3, 4, 5);
    //list1.add(6);
    System.out.println(list1);
}
```

### 9. InputStream加强

InputStream终于有了一个非常有用的方法：transferTo， 可以用来将数据直接传输到OutputStream， 这是在处理原始数据流时非常常见的一种用法， 如下示例。

```java
ClassLoader cl = this.getClass().getClassLoader();
try(InputStream is = cl.getResourceAsStream("hello.txt");
    OutputStream os = new FileOutputStream("src\\hello 1.txt") ) {
    
    is.transferTo(os); //把输入流中的所有数据直接自动地复制到输出流中
    
} catch(IOException e) {
	e.printStackTrace();	
}
```



### 10. 增强的Stream API

- `Java的Steam API是java标准库最好的改进之一， ==让开发者能够快速运算，从而能够有效的利用数据并行计算==。Java 8提供的Steam能够利用多核架构实现声明式的数据处理。`
- `在Java 9中， Stream API变得更好， Stream接口中添加了4个新的方法：==takeWhile， dropWhile， of Nullable， 还有个iterate方法的新重载方法==， 可以让你提供一个Predicate(判断条件) 来指定什么时候结束迭代。`
- `除了对Stream本身的扩展， Optional 和 Stream之间的结合也得到了改进。现在可以通过Optional的新方法stream() 将一个Optional对象转换为一个(可能是空的) Stream对象。`

### 11. Optional获取Stream的方法

Optional类中stream() 的使用

```java
List<String> list = new ArrayList<>();
list.add("Tom");
list.add("Jerry");
list.add("Tim");
Optional<List<String>> optional = Optional.ofNullable(list);
Stream<List<String>> stream = optional.stream();
stream.flatMap( x->x.stream() ).forEach(System.out：：println);
```

### 12. Javascript引擎升级：Nashorn

- `Nashorn项目在JDK 9中得到改进， 它为Java提供轻量级的Javascript运行时。Nashorn项目跟随Netscape的Rhino项目， 目的是为了在Java中实现一个高性能但轻量级的Javascript运行时。Nashorn项目使得Java应用能够嵌入Javascript。它在JDK 8中为Java提供一个Javascript引擎。`
- `JDK 9包含一个用来解析Nashorn的ECMAScript语法树的API。这个API使得IDE和服务端框架不需要依赖Nashorn项目的内部实现类， 就能够分析ECMAScript代码。`



## java10 新特性

- `2018年3月21日， Oracle官方宣布Java 10正式发布。需要注意的是Java 9和Java 10都不是LTS(Long-Term-Support) 版本。和过去的Java大版本升级不同， 这两个只有半年左右的开发和维护期。而未来的Java 11， 也就是18.9LTS， 才是Java 8之后第一个LTS版本。`
- `JDK 10一共定义了109个新特性， 其中包含12个JEP(对于程序员来讲， 真正的新特性其实就一个) ， 还有一些新API和JVM规范以及JAVA语言规范上的改动。`
- `JDK 10的12个JEP (JDK Enhancement Proposal 特性加强提议) 参阅官方文档：http://openjdk.java.net/projects/jdk/10/`

JDK 10的12个JEP

> `286：==Local Variable Type Inference 局部变量类型推断==`
> `296：Consolidate the JDK Forest into a Single Repository JDK库的合并`
> `304：Garbage-Collector Interface 统一的垃圾回收接口`
> `307：Parallel Full GC for G1 为G1提供并行的Full GC`
> `310：Application Class-Data Sharing 应用程序类数据(AppCDS) 共享`
> `312：Thread-Local Handshakes ThreadLocal 握手交互`
> `313：Remove the Native-Header Generation Tool(javah) 移除JDK中附带的javah工具`
> `314：Additional Unicode Language-Tag Extensions 使用附加的Unicode语言标记扩展`
> `316：Heap Allocation on Alternative Memory Devices 能将堆内存占用分配给用户指定的备用内存设备`
> `317：Experimental Java-Based JIT Compiler 使用基于Java的JIT编译器`
> `319：Root Certificates 根证书`
> `322：Time-Based Release Versioning 基于时间的发布版本`



### 1. 局部变量类型推断

- `产生背景：开发者经常抱怨Java中引用代码的程度。局部变量的显示类型声明， 常常被认为`
  `是不必须的，给一个好听的名字经常可以很清楚的表达出下面应该怎样继续。`
- `好处：减少了啰嗦和形式的代码，避免了信息冗余，而且对齐了变量名，更容易阅读!`
- `举例如下：`

场景一：类实例化时

>`作为Java开发者， 在声明一个变量时， 我们总是习惯了敲打两次变量类型， 第一次用于声明变量类型，第二次用于构造器。`
>
>```java
>LinkedHashSet<Integer> set = new Linked HashSet<>();
>```
>
>

场景二：返回值类型含复杂泛型结构

> `变量的声明类型书写复杂且较长，尤其是加上泛型的使用`
>
> ```java
> Iterator<Map.Entry<Integer,Student>> iterator = set.iterator();
> ```



场景三：我们也经常声明一种变量，它只会被使用一次，而且是用在下一行代码中，比如：

> ```java
> URL url = new URL("http：//www.atguigu.com");
> URLConnection connection = url.openConnection();
> Reader reader = new BufferedReader(new InputStreamReader(connection.getInputStream() ));
> ```

尽管IDE可以帮我们自动完成这些代码， 但当变量总是跳来跳去的时候， 可读性还是会受到影响，因为变量类型的名称由各种不同长度的字符组成。而且有时候开发人员会尽力避免声明中间变量，因为太多的类型声明只会分散注意力，不会带来额外的好处。

java10 var 声明变量

```java
public void test() {
    //1.局部变量不赋值，就不能实现类型推断
    //var num;
    //2.Lambda表示式中，左边的函数式接口不能声明为var
    //Supplier<DoubLe> sup = () -> Math.random();
    //vars up = () -> Math.random();
}
```

**适用于以下情况**：

1. `局部变量的初始化`

   ```java
   var list = new ArrayList<>();
   ```

   

2. `增强for循环中的索引`

   ```java
   for(var v:list) {
   	System.out.println(v);
   }
   ```

   

3. `传统for循环中`

   ```java
   for(var i=0; i<100; i++) {
   	System.out.println(i);
   }
   ```

   

**在局部变量中使用时，如下情况不适用**：

- `初始值为null`

  ```java
  var s = null;
  ```

- `Lambda表达式`

  ```java
  var r = () -> Hath.random();
  ```

- `方法引用`

  ```java
  var r = System.out::println;
  ```

- `为数组静态初始化`

  ```java
  var arr = {"a","b","c","d","e"}
  ```



**局部变量类型推断的工作原理**

在处理var时， 编译器先是查看表达式右边部分， 并根据右边变量值的类型进行推断，作为左边变量的类型，然后将该类型写入字节码当中。

注意：

- `var不是一个关键字`
  `你不需要担心变量名或方法名会与var发生冲突， 因为var实际上并不是一个关键字，而是一个类型名，只有在编译器需要知道类型的地方才需要用到它。除此之外，它就是一个普通合法的标识符。也就是说，除了不能用它作为类名，其他的都可以，但极少人会用它作为类名。`

- `这不是JavaScript`
  `首先我要说明的是， var并不会改变Java是一门静态类型语言的事实。编译器负责推断出类型，并把结果写入字节码文件，就好像是开发人员自己敲入类型一样。下面是使用IntelliJ(实际上是Fernflower的反编译器) 反编译器反编译出的代码：`

  ```java
  var url = new URL("http//www.baidu.com");
  var connection = url.openConnection();
  var reader = new BufferedReader(
  new InputStreamReader(connection.getInputStream() ));
  ```

  `反编译后`

  ```java
  URL url = new URL("http：//www.atguigu.com");
  URLConnection connection = url.openConnection();
  BufferedReader reader = new BufferedReader(
  new InputStreamReader(connection.getInputStream() ));
  ```

  `从代码来看，就好像之前已经声明了这些类型一样。事实上，这一特性只发生在编译阶段，与运行时无关，所以对运行时的性能不会产生任何影响。所以请放心， 这不是JavaScript。`



### 2. 集合新增创建不可变集合的方法

自Java 9开始， Jdk里面为集合(List/Set/Map) 都添加了==of (jdk 9新增)== 和 ==copyOf (jdk 10新增)== 方法， 它们两个都用来创建不可变的集合， 来看下它们的使用和区别。
示例1：

```java
var list1 = List.of("Java", "Python", "C");
var copy1 = List.copyOf(list1);
System.out.println(list1==copy1); //true
```

示例2：

```java
var list2 = new ArrayList<String>();
var copy2 = List.copyOf(list2);
System.out.println(list2==copy2); //false
```

示例1和2代码基本一致， 为什么一个为true， 一个为false?

结论：copyOf(Coll coll) 

> `如果参数 coll 本身就是一个只读集合， 则copyOf() 返回值即为当前的coll。`
>
> `如果参数 coll 不是一个只读集合， 则copyOf() 返回一个新的集合， 这个集合是只读的。`



## java11 新特性

北京时间2018年9月26日，Oracle官方宜布Java 11正式发布。这是Java大版本周期变化后的第一个长期支持版本，非常值得关注。从官网即可下载，最新发布的Java11将带来ZGC、HttpClient等重要特性， 一共包含17个JEP (JDK Enhancement Proposals，JDK增强提案) 。其实，总共更新不止17个，只是我们更关注如下的17个JEP更新。

> `181：Nest-Based AccessControl`
> `309：Dynamic Class-File Constants`
> `315：Improve A arch 64 Intrinsics`
> `318：Epsilon：ANo-OpGarbageCollector`
> `320：Remove the Java EE and CORBA Modules`
> `321：HTTPClient(Standard)`
> `323：Local-Variable Syntax for Lambda Parameters`
> `324：Key Agreement with Curve 25519 and Curve 448`
> `327：Unicode 10`
> `328：Flight Recorder`
> `329：ChaCha20andPoly 1305 Cryptographic Algorithms`
> `330：Launch Single-File Source-Code Programs`
> `331：Low-Overhead He apP roiling`
> `332：Transport Layer Security(TLS) 1.3`
> `333：ZGC：AScalableLow-LatencyGarbageCollector(Experimental)`
> `335：Deprecate theN as hom JavaScript Engine`
> `336：Deprecate the Pack 200 Tools and AP`

JDK 11是一个长期支持版本(LTS， Long-Term-Support)对于企业来说，选择11将意味着长期的、可靠的、可预测的技术路线图。其中免费的Open JDK 11确定将得到Open JDK社区的长期支持，LTS版本将是可以放心选择的版本。从JVM GC的角度， JDK 11引入了两种新的GC， 其中包括也许是划时代意义的ZGC， 虽然其目前还是实验特性， 但是从能力上来看， 这是JDK的一个巨大突破，为特定生产环境的苛刻需求提供了一个可能的选择。例如，对部分企业核心存储等产品，如果能够保证不超过10ms的GC暂停，可靠性会上一个大的台阶，这是过去我们进行GC调优几乎做不到的，是能与不能的问题。



### 1. 新增了一系列字符串处理方法

| `discription`          | `example`                                       |
| ---------------------- | ----------------------------------------------- |
| `判断字符串是否为空白` | `" ".isBlank();  //true`                        |
| `去除首尾空白`         | `" Javastack ".strip();  //"Javastack"`         |
| `去除尾部空格`         | `" Javastack ".stripTrailing(); //" Javastack"` |
| `去除首部空格`         | `" Javastack ".stripLeading(); //"Javastack "`  |
| `复制字符串`           | `"Java".repeat(3); //"JavaJavaJava"`            |
| `行数统计`             | `"A\nB\nC".lines().count(); // 3`               |



### 2. Optional加强

Optional也增加了几个非常酷的方法， 现在可以很方便的将一个Optional转换成一个Stream， 或者当一个空Optional时给它一个替代的。



| `新增方法`                                                   | `描述`                                                       | `version` |
| ------------------------------------------------------------ | ------------------------------------------------------------ | --------- |
| `boolean isEmpty()`                                          | `判断value是否为空`                                          | `JDK11`   |
| `ifPresentOrElse(Consumer<?super T> action,Runnable emptyAction)` | `value非空， 执行参数1功能；如果value为空，执行参数2功能`    | `JDK 9`   |
| `Optional<T> or(Supplier<? extends Optional<? extends T>> supplier)` | `value为空， 返回对应的Optional；value非空， 返回形参封装的Optional;` | `JDK 9`   |
| `Stream<T> stream()`                                         | `value非空， 返回仅包含此value的Stream； 否则， 返回一个空的Stream` | `JDK 9`   |
| `T orElse Throw()`                                           | `value非空， 返回value； 否则抛异常NoSuchElementException`   | `JDK10`   |



### 3. 局部变量类型推断升级

在var上添加注解的语法格式， 在jdk 10中是不能实现的。在JDK 11中加入了这样的语法。

错误的形式：必须要有类型， 可以加上var

```java
Consumer<String> con1=(@Deprecated t) -> System.out.println(t.toUpperCase());
```

正确的形式：使用var的好处是在使用lambda表达式时给参数加上注解。

```java
Consumer<String> con2=(@Deprecated var t) -> System.out.println(t.toUpperCase());
```



### 4. 全新的HTTP客户端API

- `HTTP， 用于传输网页的协议， 早在1997年就被采用在目前的1.1版本中。直到2015年， HTTP2才成为标准。`
- `HTTP/1.1和HTTP/2的主要区别是如何在客户端和服务器之间构建和传输数据。HTTP/1.1依赖于请求/响应周期。HTTP/2允许服务器"push”数据：它可以发送比客户端请求更多的数据。这使得它可以优先处理并发送对于首先加载网页至关重要的数据。`
- `这是Java 9开始引入的一个处理HTTP请求的的HTTP Client API， 该\API支持同步和异步， 而在Java 11中已经为正式可用状态， 你可以在java.net包中找到这个API。`
- `它将替代仅适用于blocking模式的 HttpURLConnection(HttpURLConnection是在HTTP 1.0的时代创建的， 并使用了协议无关的方法) ， 并提供对Web Socket和HTTP/2的支持。`

Sync

```java
HttpClient client = HttpClient.newHttpClient();
HttpRequest request = HttpRequest.newBuilder(URI.create("http://127.0.0.1:8080/test/") ).build();

BodyHandler<String> responseBodyHandler = BodyHandlers.ofString();
HttpResponse<String> response = client.send(request,responseBodyHandler);

String body = response.body();
System.out.println(body);
```

Async

```java
HttpClient client = HttpClient.new HttpClient();
HttpRequest request = HttpRequest.newBuilder(URI.create("http://127.0.0.1:8080/test/") ).build();

BodyHandler<String> responseBodyHandler = BodyHandlers.ofString();
CompletableFuture<HttpResponse<String>> sendAsync = client.sendAsync (request,responseBodyHandler);

sendAsync.thenApply(t->t.body()).thenAccept(System.out::println);

//HttpResponse<String> response = sendAsync.get();
//String body = response.body();
//System.out.println(body);
```



### 5. 更简化的编译运行程序


编译

```java
javac Javastack.java
```

运行

```java
java Javastack
```

在我们的认知里面， 要运行一个Java源代码必须先编译， 再运行， 两步执行动作。而在未来的Java11版本中， 通过一个java命令就直接搞定了， 如以下所示：

```java
java Javastack.java
```

一个命令编译运行源代码的注意点：

>`执行源文件中的第一个类，第一个类必须包含主方法。`
>`并且不可以使用其它源文件中的自定义类，本文件中的自定义类是可以使用的。`



### 6. 废弃Nashorn引擎

废除 Nashorn javascript 引擎， 在后续版本准备移除掉， 有需要的可以考虑使用GraalVM。

### 7. ZGC

- `GC是java主要优势之一。然而，当GC停顿太长，就会开始影响应用的响应时间。消除或者减少GC停顿时长， java将对更广泛的应用场景是一个更有吸引力的平台。此外， 现代系统中可用内存不断增长， 用户和程序员希望JVM能够以高效的方式充分利用这些内存，并且无需长时间的GC暂停时间。`
- `ZGC， A Scalable Low-Latency Garbage Collector(Experimental) ZGC， 这应该是JDK11最为瞩目的特性，没有之一。但是后面带了Experimental，说明这还不建议用到生产环境。`
- `ZGC是一个并发， 基于region， 压缩型的垃圾收集器， 只有root扫描阶段会STW(stop the world) ， 因此GC停顿时间不会随着堆的增长和存活对象的增长而变长。`

**优势**：

> 1. `GC暂停时间不会超过10ms`
> 2. `既能处理几百兆的小堆， 也能处理几个T的大堆(OMG)`
> 3. `和G1相比，应用吞吐能力不会下降超过15%`
> 4. `为未来的GC功能和利用colord指针以及Load barriers优化奠定基础`
> 5. `初始只支持64位系统`

**设计目标**：

ZGC的设计目标是：支持TB级内存容量， 暂停时间低(<10ms) ， 对整个程序吞吐量的影响小于15%。将来还可以扩展实现机制，以支持不少令人兴奋的功能， 例如多层堆(即热对象置于DRAM和冷对象置于NV Me闪存) ，或压缩堆。

### 8. 其它新特性

> 1. `Unicode 10`
> 2. `Deprecate the Pack 200 Tools and API`
> 3. `新的Epsilon垃圾收集器`
> 4. `完全支持Linux容器(包括Docker)`
> 5. `支持G1上的并行完全垃圾收集`
> 6. `最新的HTTPS安全协议TLS 1.3`
> 7. `Java Flight Recorder`



## 展望未来

在当前JDK中看不到什么?

- `一个标准化和轻量级的JSON API`
  `一个标准化和轻量级的JSON API被许多Java开发人员所青睐。但是由于资金问题无法在Java当前版本中见到， 但并不会削减掉。Java平台首席架构师Mark Reinhold在JDK 9邮件列中说：“这个JEP将是平台上的一个有用的补充， 但是在计划中， 它并不像Oracle资助的其他功能那么重要， 可能会重新考虑JDK 10或更高版本中实现。”`

- `新的货币API`

  - `对许多应用而言货币价值都是一个关键的特性， 但JDK对此却几乎没有任何支持。严格来讲， 现有的java.uti.Currency类只是代表了当前ISO 4217货币的一个数据结构，但并没有关联的值或者自定义货币。JDK对货币的运算及转换也没有内建的支持，更别说有一个能够代表货币值的标准类型了。`

  - `此前， Oracle公布的JSR 354定义了一套新的Java货币API：Java Money， 计划会在Java9中正式引入。但是目前没有出现在JDK新特性中。`

  - `不过， 如果你用的是Maven的话， 可以做如下的添加， 即可使用相关的API处理货币：`

    ```pom
    <dependency>
        <groupId>org.java money</groupId>
        <artifactId>moneta</artifactId>
        <version>0.9</version>
    </dependency>
    ```

展望

- `随着云计算和AI等技术浪潮，当前的计算模式和场景正在发生翻天覆地的变化， 不仅对Java的发展速度提出了更高要求， 也深刻影响着Java技术的发展方向。传统的大型企业或互联网应用，正在被云端、容器化应用、模块化的微服务甚至是函数(FaaS，Function-as-a-Service) 所替代。`
- `Java虽然标榜面向对象编程， 却毫不顾忌的加入面向接口编程思想， 又扯出匿名对象之概念， 每增加一个新的东西， 对Java的根本所在的面向对象思想的一次冲击。反观Python， 抓住面向对象的本质， 又能在函数编程思想方面游刃有余。Java对标C/C++， 以抛掉内存管理为卖点， 却又陷入了JVM优化的噩梦。选择比努力更重要， 选择Java的人更需要对它有更清晰的认识。`
- `Java需要在新的计算场景下， 改进开发效率。这话说的有点笼统， 我谈一些自己的体会， Java代码虽然进行了一些类型推断等改进， 更易用的集合API等，但仍然给开发者留下了过于刻板、形式主义的印象，这是一个长期的改进方向。`



