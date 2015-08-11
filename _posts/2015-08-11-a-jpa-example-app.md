---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150811-a-jpa-example-app # DO NOT CHANGE THE VALUE ONCE SET
title: A Simple Example Using JPA
# MUST HAVE END

is_short: false
subtitle:
tags: 
- java
- JPA
date: 2015-08-11 13:24:00
image: 
image_desc: 
---

In my daily work, JPA is used in a Java EE environment/container. Here is a simple example
using JPA in a Java SE environment, in which it's more easily to demonstrate usage of JPA.
Source code of this example is available on [github][1].

This example is managed by Maven, and tries to involve as little dependencies as possible.
It uses Hibernate as JPA vendor. And Mysql is taken as the database server. By passing some
options, this example also helps create corresponding schema in database.

### pom.xml
`hibernate-core` is not enough to use Hibernate as JPA provider. `hibernate-entitymanager`
should be used instead. For JPA dependency, here it use artifact `javax.persistence` from
group `org.eclipse.persistence`, not artifact `persistence-api` from group `javax.persistence`,
which is too old to use.

And logback dependency is added for logging purpose.

{% highlight xml %}
<project xmlns="http://maven.apache.org/POM/4.0.0" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.hong</groupId>
  <artifactId>plain-jpa-app</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  
  <dependencies>
    <!-- use hibernate-entitymanager, if you are using hibernate simply as jpa provider -->
    <!--  <dependency>
      <groupId>org.hibernate</groupId>
      <artifactId>hibernate-core</artifactId>
      <version>4.3.10.Final</version>
    </dependency> -->
    <dependency>
      <groupId>org.hibernate</groupId>
      <artifactId>hibernate-entitymanager</artifactId>
      <version>4.3.10.Final</version>
    </dependency>
    <dependency>
      <groupId>org.eclipse.persistence</groupId>
      <artifactId>javax.persistence</artifactId>
      <version>2.1.0</version>
    </dependency>
    <dependency>
      <groupId>joda-time</groupId>
      <artifactId>joda-time</artifactId>
      <version>2.8.1</version>
    </dependency>
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>5.1.36</version>
    </dependency>
    <dependency>
      <groupId>ch.qos.logback</groupId>
      <artifactId>logback-classic</artifactId>
      <version>1.1.3</version>
    </dependency>
  </dependencies>
</project>
{% endhighlight %}

### Entities
There are four entities in this example, `Customer`, `Product`, `OrderLine`, and `Order`.
Only list code for `OrderLine` and `Order` below. For other, please check them on github.

{% highlight java %}
package hello;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.*;

import org.joda.time.DateTime;

@Entity
// @Table can be omitted, if defaults are ok. however, specify 'name' of @Table
// is better, so that the mapping between entity and table wouldn't break 
// if we refactor Order class name later on
@Table(name = "SALES_ORDER")
public class Order {
    @Id
    @SequenceGenerator(name = "ORDER_SEQ", sequenceName = "ORDER_SEQ", allocationSize = 1)
    @GeneratedValue(generator = "ORDER_SEQ", strategy = GenerationType.AUTO)
    private Long id;
    
    // do 'optional = false' in @ManyToOne and 'nullable = false' in @JoinColumn
    // have the same effect?
    @ManyToOne(optional = false)
    @JoinColumn(name = "CUSTOMER_ID", nullable = false)
    private Customer customer;
    
    @Column(name = "AMOUNT")
    private BigDecimal amount;
    
    /*
     * https://docs.oracle.com/javaee/6/tutorial/doc/bnbqa.html
     * for 'date', jpa supports java.util.Date, java.util.Calendar, java.sql.Date, 
     * java.sql.Time, java.sql.TimeStamp. 
     * 
     * http://www.joda.org/joda-time/
     * it's said joda time the best choice before java 1.8.
     * 
     * since the app uses java 1.7, and also it needs time for jpa to support java
     * 1.8's 'date class', so we use joda time (via a converter) in this app.
     */
    @Column(name = "CREATED_TIME")
    @Convert(converter = JodaTimeConverter.class)
    private DateTime createdTime;
    
    @OneToMany(mappedBy = "parent", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    private final List<OrderLine> lines = new ArrayList<OrderLine>();
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Customer getCustomer() {
        return customer;
    }
    
    public void setCustomer(Customer customer) {
        this.customer = customer;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public DateTime getCreatedTime() {
        return createdTime;
    }
    
    public void setCreatedTime(DateTime createdTime) {
        this.createdTime = createdTime;
    }
    
    public List<OrderLine> getLines() {
        return lines;
    }
}
{% endhighlight %}

{% highlight java %}
package hello;

import java.math.BigDecimal;

import javax.persistence.*;

@Entity
@Table(name = "ORDER_LINE")
public class OrderLine {
    @Id
    @SequenceGenerator(name = "ORDER_LINE_SEQ", sequenceName = "ORDER_LINE_SEQ", allocationSize = 1)
    @GeneratedValue(generator = "ORDER_LINE_SEQ", strategy = GenerationType.AUTO)
    private Long id;
    
    @ManyToOne(optional = false)
    @JoinColumn(name = "ORDER_ID", nullable = false, updatable = false)
    private Order parent;
    
    @ManyToOne
    @JoinColumn(name = "PRODUCT_ID", nullable = false)
    private Product product;
    
    @Column(name = "QUANTITY")
    private BigDecimal quantity;
    
    @Column(name = "PRICE")
    private BigDecimal price;
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Order getParent() {
        return parent;
    }
    
    public void setParent(Order order) {
        parent = order;
    }
    
    public Product getProduct() {
        return product;
    }
    
    public void setProduct(Product product) {
        this.product = product;
    }
    
    public BigDecimal getQuantity() {
        return quantity;
    }
    
    public void setQuantity(BigDecimal quantity) {
        this.quantity = quantity;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
}
{% endhighlight %}

### Type and Converter for Date Time
It's said Joda time should be used as THE date time class prior to Java 8. Since this example
is developed in Java 7, so I take this advice.

To Use Joda time in JPA, I add a converter for it.
<!--more-->
{% highlight java %}
package hello;

import java.util.Calendar;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

import org.joda.time.DateTime;

/*
 * eclipselink has another interface called 'Converter', here we
 * use the 'standard' one
 * 
 * maybe type arguments of AttributeConverter can be omitted.
 * but currently, if omit, hibernate raises an error
 */
@Converter
public class JodaTimeConverter implements AttributeConverter<DateTime, Calendar>{

    public Calendar convertToDatabaseColumn(DateTime attribute) {
        if (attribute == null) {
            return null;
        }
        
        DateTime joda = (DateTime) attribute;
        Calendar date = Calendar.getInstance();
        date.set(joda.getYear(), joda.getMonthOfYear(), joda.getDayOfMonth(), 
                joda.getHourOfDay(), joda.getMinuteOfHour(), joda.getSecondOfMinute());
        date.set(Calendar.MILLISECOND, joda.getMillisOfSecond());
        return date;
    }

    public DateTime convertToEntityAttribute(Calendar dbData) {
        if (dbData == null) {
            return null;
        }
        
        Calendar date = (Calendar) dbData;
        return new DateTime(date.get(Calendar.YEAR), date.get(Calendar.MONTH) + 1,
                date.get(Calendar.DAY_OF_MONTH), date.get(Calendar.HOUR_OF_DAY),
                date.get(Calendar.MINUTE), date.get(Calendar.SECOND), date.get(Calendar.MILLISECOND));
    }

}
{% endhighlight %}

With this converter, `createdTime` of `Order` can be of `org.joda.time.DateTime` type.
{% highlight java %}
    @Column(name = "CREATED_TIME")
    @Convert(converter = JodaTimeConverter.class)
    private DateTime createdTime;
{% endhighlight %}

### A Simple Repository Class to Manipulate Entites
{% highlight java %}
package hello;

import java.util.List;

import javax.persistence.EntityManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class BasicRepository<T> implements Repository<T> {
    private static final Logger LOGGER = LoggerFactory.getLogger(BasicRepository.class);
    private EntityManager em;
    private Class<T> clazz;
    
    public BasicRepository(EntityManager em, Class<T> clazz) {
        this.em = em;
        this.clazz = clazz;
    }

    public T save(T entity) {
        if (entity != null) {
            em.persist(entity);
            LOGGER.info(clazz.getName() + "saved.");
        }
        return entity;
    }

    public T find(Long primaryKey) {
        if (primaryKey == null) {
            return null;
        } else {
            return em.find(clazz, primaryKey);
        }
    }

    public List<T> findAll() {
        String sqlStr = "SELECT e FROM " + clazz.getSimpleName() + " e";
        return em.createQuery(sqlStr, clazz).getResultList();
    }

    public boolean exists(Long primaryKey) {
        return find(primaryKey) != null;
    }

    public Long count() {
        String sqlStr = "SELECT COUNT(e) FROM " + clazz.getSimpleName() + " e";
        return (Long) em.createQuery(sqlStr, Long.class).getSingleResult();
    }

    public void delete(T entity) {
        em.remove(entity);
    }

}
{% endhighlight %}

### Add an Entity to Database
Below is code snippet from `MainClass`.

{% highlight java %}
    private static void run() {
        EntityManagerFactory emf = null;
        EntityManager em = null;
        
        try {
            emf = Persistence.createEntityManagerFactory("simplePU");
            em = emf.createEntityManager();
            prepareData(em);
            createOrder(em);    
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
        } finally {
            if (em != null) {
                em.close();
            }
            if (emf != null) {
                emf.close();
            }
        }
    }
    
    private static void createOrder(EntityManager em) {
        BasicRepository<Order> orderRepo = new BasicRepository<Order>(em, Order.class);
        BasicRepository<Customer> customerRepo = new BasicRepository<Customer>(em, Customer.class);
        BasicRepository<Product> productRepo = new BasicRepository<Product>(em, Product.class);
        
        List<Customer> customers = customerRepo.findAll();
        List<Product> products = productRepo.findAll();
        
        Random rand = new Random();
        
        Order order = new Order();
        order.setCreatedTime(new DateTime());
        order.setCustomer(customers.get(rand.nextInt(customers.size())));
        OrderLine line1 = new OrderLine();
        line1.setParent(order);
        line1.setProduct(products.get(rand.nextInt(products.size())));
        line1.setPrice(new BigDecimal(rand.nextInt(50)));
        line1.setQuantity(new BigDecimal(rand.nextInt(10)));
        order.getLines().add(line1);
        OrderLine line2 = new OrderLine();
        line2.setParent(order);
        line2.setProduct(products.get(rand.nextInt(products.size())));
        line2.setPrice(new BigDecimal(rand.nextInt(50)));
        line2.setQuantity(new BigDecimal(rand.nextInt(10)));
        order.getLines().add(line2);
        BigDecimal amount = BigDecimal.ZERO;
        for (OrderLine line: order.getLines()) {
            amount = amount.add(line.getPrice().multiply(line.getQuantity()));
        }
        order.setAmount(amount);
        
        EntityTransaction txn = em.getTransaction();
        try {
            txn.begin();
            orderRepo.save(order);
            txn.commit();
            LOGGER.info("create order done.");
        } catch (Exception e) {
            if (txn.isActive()) {
                txn.rollback();
                LOGGER.info("create order failed."  + e.getMessage());
            }
        }
        
    }
{% endhighlight %}

### Schema Generation from JPA Metadata
JPA and JPA providers provide APIs to help generate schema in database, drop schema,
export schema to script files, execute SQL scripts to prepare data, and etc.

Below snippet from `MainClass` is to create schema in database using standard JPA API (though it has
some hanging threads problem).
{% highlight java %}
    private static void createDB() {
        /*
         * simply call Persistence.generateSchema() will create schema, but main() method
         * never returns. some threads (relative to db connection/connect pool) will hang in there
         * and never terminate. those never-terminate threads look like below,
         * Daemon Thread [Abandoned connection cleanup thread] (Running)  
         * Thread [pool-1-thread-1] (Running)   
         * Thread [DestroyJavaVM] (Running)
         */
        Properties properties = new Properties();
        properties.put("javax.persistence.schema-generation.database.action", "create");
        properties.put("javax.persistence.schema-generation.create-source", "metadata");
        properties.put("javax.persistence.schema-generation.drop-source", "metadata");
        Persistence.generateSchema("simplePU", null);
    }
{% endhighlight %}

Below snippet is output schema, but not execute it as the above one. It's using Hibernate API.
{% highlight java %}
    private static void dropAndCreateDBViaHibernate1() {
        Properties properties = new Properties();
        properties.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQL5Dialect");
        Configuration cfg = new Configuration().setProperties(properties);
        // can also use reflection to not (hard-codely) call addAnnotatedClass() for every entity
        cfg.addAnnotatedClass(Customer.class);
        cfg.addAnnotatedClass(Order.class);
        cfg.addAnnotatedClass(OrderLine.class);
        cfg.addAnnotatedClass(Product.class);
        String[] scripts = cfg.generateSchemaCreationScript(Dialect.getDialect(cfg.getProperties()));
        LOGGER.info("len of scripts " + scripts.length);
        for (String sql: scripts) {
            LOGGER.info(sql);            
        }
        // org.hibernate.engine.jdbc.internal.FormatStyle can help do formatting
        // it has a method getFormatter(), which return Formatter
    }
{% endhighlight %}

### Others
At first, I tried to use pure standard JPA API to implement this example. However, it turned out
not possible as what I thought to be. For example, the standard `Persistence.generateSchema()` API
does not mention any hanging database connection thread problem. Here Hibernate as the provider decides
not to close the database connection thread in Java SE environment even after code is finished running
in main thead. To eliminate this problem, I have to use Hibernate API to fulfill my task. So whichever
JPA provider you pick, you have to bind with it to some extend.

[1]: https://github.com/RockHong/spring-samples/tree/master/plain-jpa-app "source codee on github"





