---
# MUST HAVE BEG
layout: post
disqus_identifier: 20160318-notes-of-metaprogramming-ruby # DO NOT CHANGE THE VALUE ONCE SET
title: Metaprogramming Ruby读书笔记
# MUST HAVE END

is_short: false
subtitle:
tags: 
- ruby
date: 2016-03-18 22:36:00
image: 
image_desc: 
---

静态语言，比如java，类定义是对象的一个“模板”；但是ruby不是这样的




=============Chapter 4  Thursday: Class Definitions==================
In truth, you can put any code you want in a class
definition.
class MyClass
puts 'Hello!'
end
) Hello!


在类（或者module）定义内，这个类（the class itself）就成了self。

和当前对象（current object）类似，也有当前类（current class）的概念。
在定义方法时，这个方法就会成为当前类的instance method。


用class关键字打开一个类后，这个类就成了当前类。


除了class关键字，也可以用Module#class_eval( )来改变当前类。
module_eval( )是class_eval()的别名。

class_eval()可以接收一个block，并且evaluates a block in the context of an existing class。
def add_method_to(a_class)
a_class.class_eval do
def m; 'Hello!' ; end
end
end
add_method_to String
"abc".m # => "Hello!"

instance_eval( ) only changes self, while
class_eval( ) changes both self and the current class.3 By changing the
current class, class_eval( ) effectively reopens the class, just like the class
keyword does.



Module#class_eval( ) is actually more flexible than class. You can use
class_eval( ) on any variable that references the class, while class requires
a constant
Also, class opens a new scope, losing sight of the current
bindings, while class_eval( ) has a Flat Scope


class MyClass
def method_one
def method_two; 'Hello!' ; end
end
end
obj = MyClass.new
obj.method_one
obj.method_two # => "Hello!"
Which class does method_two( ) belong to?
Or, to ask the same
question in a different way, which class is the current class when
method_two( ) is defined? In this case, the current class cannot
be the same as self, because self is not a class. Instead, the role
of the current class is taken by the class of self: MyClass.


Deciding Between instance_eval() and class_eval()
But what if you want to open an object that happens to be a
class (or module) to do something else than using def? Should
you use instance_eval( ) or class_eval( ) then?
If all you want is to change self, then both instance_eval( ) and
class_eval( ) will do the job nicely. However, you should pick the
method that best communicates your intentions. If you’re thinking
“I want to open this object, and I don’t particularly care
it’s a class,” then instance_eval( ) is fine. If you’re thinking “I want
an Open Class (31) here,” then class_eval( ) is almost certainly a
better match.


Current Class Wrap-up
• In a class definition, the current object self is the class being
defined.
• The Ruby interpreter always keeps a reference to the current class
(or module). All methods defined with def become instance methods
of the current class.
• In a class definition, the current class is the same as self—the class
being defined.
• If you have a reference to the class,


Class Instance Variables
class MyClass
@my_var = 1  # my_var是MyClass的instance variable
def self.read; @my_var; end
def write; @my_var = 2; end # my_var是MyClass的对象的instance variable
def read; @my_var; end
end
obj = MyClass.new
obj.write
obj.read # => 2
MyClass.read # => 1
上面的两个my_var变量在不同的scope中定义，属于不同的对象。

Class Instance Variables不同于Java中的“static fields”，类的对象是看不到这种变量的。


Class Variables
class C
@@v = 1
end
Class variables are different from Class Instance Variables,
because they can be accessed by subclasses and by regular
instance methods. (In that respect, they’re more similar to
Java’s static fields.)

Unfortunately, class variables have a nasty habit of surprising
you. Here’s an example:
@@v = 1
class MyClass
@@v = 2
end
@@v # => 2
You get this result because class variables don’t really belong to
classes—they belong to class hierarchies. Since @@v is defined
in the context of main, it belongs to main’s class Object. . . and to
all the descendants of Object. MyClass inherits from Object, so it
ends up sharing the same class variable.


Class#new( ) also accepts an argument (the superclass of the
new class) and a block that is evaluated in the context of the newborn
class:
c = Class.new(Array) do
def my_method
'Hello!'
end
end
Now you have a variable that references a class, but the class is still
anonymous. Do you remember the discussion about class names in
Section 1.3, Constants, on page 38? The name of a class is just a constant,
so you can assign it yourself:
MyClass = c
Interestingly, Ruby is cheating a little here. When you assign an anonymous
class to a constant, Ruby understands that you’re trying to give a
name to the class, and it does something special: it turns around to the
class and says, “Here’s your new name.” Now the constant references
the Class, and the Class also references the constant. If it weren’t for this
trick, a class wouldn’t be able to know its own name, and you couldn’t
write this:
c.name # => "MyClass"

4.3 Singleton Methods
Ruby allows you to add a method to a single object
str = "just a regular string"
def str.title?
self.upcase == self
end
str.title? # => false
str.methods.grep(/title?/) # => ["title?"]
str.singleton_methods # => ["title?"]

The Truth About Class Methods

If you’re writing code in a class definition, you can also take advantage
of the fact that self is the class itself. Then you can use self in place of
the class name to define a class method:
class MyClass
def self.yet_another_class_method; end   这里self可以换成MyClass，都是一样的
end
So, you always define a Singleton Method in the same way:
def object.method
# Method body here
end

Class Macros
class MyClass
attr_accessor :my_attribute
end
All the attr_*( ) methods are defined on class Module, so you can use them
whenever self is a module or a class. A method such as attr_accessor( ) is
called a Class Macro. Class Macros look like keywords, but they’re just Spell: Class Macro
regular class methods that are meant to be used in a class definition.


4.4 Eigenclasses
The Mystery of Singleton Methods
So far, so good. Now, what happens if you define a Singleton Method
(133) on obj?
def obj.my_singleton_method; end
If you look at Figure 4.1, you’ll notice that there’s no obvious home
for my_singleton_method( ) there. The Singleton Method can’t live in obj,
because obj is not a class. It can’t live in MyClass, because if it did,
all instances of MyClass would share it
Class methods are a special kind of Singleton Method—and just as
baffling:
def MyClass.my_class_method; end


Eigenclasses Revealed
“When you ask an object for its class,” Bill lectures, “Ruby doesn’t
always tell you the whole truth. Instead of the class that you see, an
object can have its own special, hidden class. That’s called the eigenclass
of the object.”

Ruby has a special syntax, based on the
class keyword, that places you in the scope of the eigenclass:
class << an_object
# your code here
end

If you want to get a reference to the eigenclass, you can return self out
of the scope:
obj = Object.new
eigenclass = class << obj
self
end
eigenclass.class # => Class

Also, eigenclasses have only a single instance
(that’s why they’re also called singleton classes), and they can’t be
inherited. More important, an eigenclass is where an object’s Singleton
Methods live:


Eigenclasses and instance_eval()
on page 124, you learned that
instance_eval( ) changes self, and class_eval( ) changes both self
and the current class. However, instance_eval( ) also changes
the current class: it changes it to the eigenclass of the receiver

Eigenclasses and Method Lookup
The superclass of obj’s eigenclass is D.
If an object has an eigenclass, Ruby starts looking for
methods in the eigenclass rather than the conventional class, and that’s
why you can call Singleton Methods such as obj#a_singleton_method( ).
If Ruby can’t find the method in the eigenclass, then it goes up the
ancestors chain, ending in the superclass of the eigenclass—which is
the object’s class. From there, everything is business as usual.

Eigenclasses and Inheritance
Apparently, Ruby organizes classes, eigenclasses, and superclasses in
a very purposeful pattern. The superclass of #D is #C, which is also the
eigenclass of C. By the same rule, the superclass of #C is #Object. Bill
tries to sum it all up, making things even more confusing: “The superclass
of the eigenclass is the eigenclass of the superclass. It’s easy!”

“OK,” you say, “but there must be a reason for Ruby arranging classes,
superclasses, and eigenclasses this way.” Bill confirms, “Sure, there is.
Thanks to this arrangement, you can call a class method on a subclass:”

Even if a_class_method( ) is defined on C, you can also call it on D. This
is probably what you expect, but it’s only possible because method
lookup starts in #D and goes up to #D’s superclass #C, where it finds
the method.
“Ingenious, isn’t it? Now we can finally grasp the entire object model,”
注意147页的图


The Great Unified Theory
you end up with the seven rules of the Ruby object model
1. There is only one kind of object—be it a regular object or a module.
2. There is only one kind of module—be it a regular module, a class,
an eigenclass, or a proxy class.13
3. There is only one kind of method, and it lives in a module—most
often in a class.
4. Every object, classes included, has its own “real class,” be it a
regular class or an eigenclass.
5. Every class has exactly one superclass, with the exception of BasicObject
(or Object if you’re using Ruby 1.8), which has none. This
means you have a single ancestors chain from any class up to
BasicObject.
6. The superclass of the eigenclass of an object is the object’s class.
The superclass of the eigenclass of a class is the eigenclass of the
class’s superclass. (Try repeating that three times, fast! Then look
back at Figure 4.5, on the preceding page, and it will all make
sense.)
7. When you call a method, Ruby goes “right” in the receiver’s real
class and then “up” the ancestors chain. That’s all there is to know
about the way Ruby finds methods.

Class Attributes
But what if you want to define an attribute on a class instead?”
class MyClass; end
class Class
attr_accessor :b
end
MyClass.b = 42
MyClass.b # => 42
This works, but it adds the attribute to all classes. If you want an attribute
that’s specific to MyClass, you need a different technique. Define
the attribute in the eigenclass:
class MyClass
class << self
attr_accessor :c
end
end
MyClass.c = 'It works!'
MyClass.c # => "It works!"
To understand how this works, remember that an attribute is actually
a pair of methods.15 If you define those methods in the eigenclass, they
become class methods, as if you’d written this:
def MyClass.c=(value)
@c = value
end
def MyClass.c
@c
end



“Every single day, somewhere in the
world, a Ruby programmer tries to define a class method by including
a module. I tried it myself, but it didn’t work:”
module MyModule
def self.my_method; 'hello' ; end
end
class MyClass
include MyModule
end
MyClass.my_method # NoMethodError!
“when a class includes a module, it gets
the module’s instance methods—not the class methods. Class methods
stay out of reach, in the module’s eigenclass.”
Solution
The solution to this quiz is simple and subtle at the same time. First,
define my_method( ) as a regular instance method of MyModule. Then
include the module in the eigenclass of MyClass
module MyModule
def my_method; 'hello' ; end
end
class MyClass
class << self
include MyModule
end
end
MyClass.my_method # => "hello"
my_method( ) is an instance method of the eigenclass of MyClass. As
such, my_method( ) is also a class method of MyClass. This technique
is called a Class Extension.


Class Methods and include()
Reviewing Class Extensions, you can define class methods by mixing
them into the class’s eigenclass. Class methods are just a special case
of Singleton Methods, so you can generalize this trick to any object.
In the general case, this is called an Object Extension. In the following Spell: Object Extension
example, obj is extended with the instance methods of MyModule
module MyModule
def my_method; 'hello' ; end
end
obj = Object.new
class << obj
include MyModule
end
obj.my_method # => "hello"
obj.singleton_methods # => [:my_method]

Object#extend
Class Extensions (151) and Object Extensions (151) are common enough
that Ruby provides a method just for them, named Object#extend( ):
module MyModule
def my_method; 'hello' ; end
end
obj = Object.new
obj.extend MyModule
obj.my_method # => "hello"
class MyClass
extend MyModule
end
MyClass.my_method # => "hello"
Object#extend( ) is simply a shortcut that includes a module in the
receiver’s eigenclass.


4.6 Aliases
class MyClass
def my_method; 'my_method()' ; end
alias :m :my_method
end
obj = MyClass.new
obj.my_method # => "my_method()"
obj.m # => "my_method()"

Note that alias is a keyword, not a method. That’s why there’s no comma
between the two method names.
Ruby also provides Module#alias_method( ), a method
equivalent to alias.


Around Aliases
What happens if you alias a method and then redefine it?
class String
alias :real_length :length
def length
real_length > 5 ? 'long' : 'short'
end
end
"War and Peace".length # => "long"
"War and Peace".real_length # => 13
When you redefine a method, you don’t really change the
method. Instead, you define a new method and attach an existing name
to that new method. You can still call the old version of the method as
long as you have another name that’s still attached to it.


Bill points at the code. “See how the new require( ) is wrapped around
the old require( )? That’s why this trick is called an Around Alias.” You Spell: Around Alias
can write an Around Alias in three simple steps:
1. You alias a method.
2. You redefine it.
3. You call the old method from the new method.


Two Words of Warning
You must be aware of two potential pitfalls when you use Around Alias
(155), although neither is very common in practice.

First, Around Aliases are a form of Monkeypatching (33), and as such,
they can break existing code.

The second potential problem has to do with loading. You should never
load an Around Alias twice, unless you want to end up with an exception
when you call the method. Can you see why?
=============Chapter 4  Thursday: Class Definitions==================


Chapter 5  Friday: Code That Writes Code
5.2 Kernel#eval
Kernel#eval( ) executes the code in the string Spell: String of Code
and returns the result
array = [10, 20]
element = 30
eval("array << element" ) # => [10, 20, 30]

Binding Objects
You can evaluate code in the captured scope by passing the
Binding as an additional argument to one of the eval*( ) methods:
eval "@x" , b # => 1

Ruby also provides a predefined constant named
TOPLEVEL_BINDING, which is just a Binding of the top-level
scope


Although it’s true that eval( ) always requires
a string, instance_eval( ) and class_eval( ) can take either a String of Code
or a block.
Strings of Code can even access
local variables like blocks do:7
array = ['a' , 'b' , 'c' ]
x = 'd'
array.instance_eval "self[1] = x"
array # => ["a", "d", "c"]

Here Documents

Defending Yourself from Code Injection
$SAFE global variable
$SAFE = 1
user_input = "User input: #{gets()}"
eval user_input
x = 1
) SecurityError: Insecure operation - eval

By using safe levels carefully, you can write a controlled environment
for eval( ).9 Such an environment is called a Sandbox. Let’s take a look Spell: Sandbox
at a sandbox taken from a real-life library.
The eRB Example


5.7 Hook Methods
The inherited( ) method is an instance method of Class, and Ruby calls
it when a class is inherited

More Hooks


Class Extension Mixins
It’s time to review the steps you can take to cast this spell on your own:
1. You define a module. Let’s call it MyMixin.
2. You define an inner module of MyMixin (usually named ClassMethods)
that defines some methods. These methods ultimately become
class methods.
3. You override MyMixin#included( ) to extend( ) inclusors with Class-
Methods.
Here’s how you can put it all together:
module MyMixin
def self.included(base)
base.extend(ClassMethods)
end
module ClassMethods
def x
"x()"
end
end
end

the basic idea stays the same:
you want a mixin that adds class methods (usually Class Macros (136))
to its inclusors.



Kernel#eval() and Kernel#load()



===============Chapter 2   Tuesday: Methods==========================
2.2 Dynamic Methods
how to call and define methods dynamically

Dynamic Dispatch
obj.send(:my_method, 3) # => 6
通过send()方法，可以在运行时再决定要调用的方法。这种技术叫做Dynamic Dispatch。
可以通过send()调用private方法。
public_send()可以保证private方法不会被调用。

Dynamic Method
Module#define_method()可以在运行时动态地定义方法。这种技术叫做Dynamic Method。
class MyClass
  define_method :my_method do |my_arg|
    my_arg * 3
  end # 传给define_method的block会被当作方法的body
end
obj = MyClass.new
obj.my_method(2) # => 6


Ghost Methods
如果执行时找不到方法，那么会执行method_missing()。可以在method_missing()里
响应消息，这样看起来就像这个对象真的有相关的方法一样。这些方法叫做Ghost Method。
class MyOpenStruct
def initialize
@attributes = {}
end
def method_missing(name, *args)
attribute = name.to_s
if attribute =~ /=$/
@attributes[attribute.chop] = args[0]
else
@attributes[attribute]
end
end
end
icecream = MyOpenStruct.new
icecream.flavor = "vanilla"
icecream.flavor # => "vanilla"

名字冲突
如果Ghost Method和真实的方法重名，那么只有后者才会被调用。
Ruby里的对象都是继承自Object，如果不想要继承自Object的方法，可以把它们删掉。
这样你的Ghost Method就不会和真实的方法发生重名了。
这种删掉了继承自Object的方法的类叫做Blank Slate。
Module#undef_method()可以删除包括继承来的方法在内的方法；
Module#remove_method()则不会删除继承来的方法。
Object的基类BasicObject仅仅包括如下方法，
BasicObject.instance_methods
[:==, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__]
直接继承自BasicObject的类就是Blank Slate。

书上对于method_missing()做了一个简单的性能测试（新的Ruby版本可能会有不同的结果），
结果显示利用method_missing()实现的Ghost Method的运行时间是普通方法的两倍。
一般来说，性能问题可以在真的成为瓶颈时才去考虑它。


Object中以双下划线开头的方法会被Ruby内部使用，所以不要重定义或者删除这些方法。
目前以双下划线开头的方法只有__send__()和__id__()，它们是send()和id()的别名。
class Computer
instance_methods.each do |m|
undef_method m unless m.to_s =~ /^__|method_missing|respond_to?/
end

respond_to?()
可以在respond_to?()里加上对Ghost Method的支持。这样，Ghost Method看起来会更像
一个正常的方法。
class Computer
def respond_to?(method)
@data_source.respond_to?("get_#{method}_info" ) || super
end


const_missing()
类似地，当一个常量找不到时，const_missing()会被执行。
def Object.const_missing(name)
name.to_s.downcase.gsub(/_/, ' ' ) # 如果一个常量没有定义，那么简单地给它一个值
end
MY_CONSTANT # => "my constant"



super




Dynamic Proxies
They collect method calls through method_
missing( ) and forward them to the wrapped object
The Flickr Example

class Computer
def initialize(computer_id, data_source)
@id = computer_id
@data_source = data_source
end
def method_missing(name, *args)
super if !@data_source.respond_to?("get_#{name}_info" ) =========================super
info = @data_source.send("get_#{name}_info" , args[0])
price = @data_source.send("get_#{name}_price" , args[0])
result = "#{name.to_s.capitalize}: #{info} ($#{price})"
return "* #{result}" if price >= 100
result
end
end


class Roulette
def method_missing(name, *args)
person = name.to_s.capitalize
3.times do
number = rand(10) + 1
puts "#{number}..."
end
"#{person} got a #{number}" =========
end
end
====When Ruby executes that line,
it can’t know that the number there is supposed to be a variable. As a
default, it assumes that number must be a parentheses-less method call
on self.


===============Chapter 2   Tuesday: Methods==========================

==========Chapter 1  Monday: The Object Model=============================
• An object is composed of a bunch of instance variables and a link to a class.
一个对象由一些instance variables和一个指向其class的link组成。
对象也可以有自己的方法。。。  （这个在后面章节讲到）

• The methods of an object live in the object’s class (from the point of view of the class, they’re called instance methods).
对象的方法（或者叫类的instance methods）存在于它的class里。
String.instance_methods == "abc".methods # => true
String.methods == "abc".methods # => false

• The class itself is just an object of class Class. The name of the class is just a constant.
类（class）也是一个对象，它是Class类的对象。
String.class # => Class  类是Class类的对象
类和普通的对象一样，只不过外加了一个instance methods组成的列表和一个指向superclass的link。
类名只是一个简单的常量（constant）。



类的方法，比如new()，只是`Class`类的instance methods。
和普通对象一样，需要一个引用才能调用类的方法，比如String.new()。
类名就是一个指向类的引用。

Object.class # => Class  Object的类是Class
Class.class # => Class   Class的类是Class





inherited = false
Class.instance_methods(inherited) # => [:superclass, :allocate, :new]

String.superclass # => Object
Object.superclass # => BasicObject
BasicObject.superclass # => nil


• Class is a subclass of Module. A module is basically a package of methods. In addition to that, a class can also be instantiated (with
new( )) or arranged in a hierarchy (through its superclass( )).
module可以简单认为是方法的集合。
Class继承于Module。
Class.superclass # => Module
Module.superclass # => Object
类比module多了3个方法，new(), allocate(), and superclass()。
基本上类和module可以认为是一样的。
区分类和module主要是为了可读性。一般而言，module里的方法是用来include的，而类的方法是用来继承或者instantiated的。
用module关键字来实现名字空间，代码上看也更清晰。



• Constants are arranged in a tree similar to a file system, where
the names of modules and classes play the part of directories and
regular constants play the part of files.
首字母为大写的就是常量，比如类的名字。
常量有层次结构，和文件系统的层次结构很像。

module M
class C
X = 'a constant'
end
C::X # => "a constant"
end
M::C::X # => "a constant"

module M
Y = 'another constant'
class C
::M::Y # => "another constant"    加两个:开头，表示“绝对路径”
end
end

M.constants # => [:C, :Y]
Module.constants[0..1] # => [:Object, :Module]

module M
class C
module M2
Module.nesting # => [M::C::M2, M::C, M]     当前路径。。
end
end
end


一个例子，老版本的rake没有名字空间，新版本的有
module Rake
    class Task    新版本
    
Task = Rake::Task      新老版本的兼容
FileTask = Rake::FileTask
FileCreationTask = Rake::FileCreationTask    


• Each class has an ancestors chain, beginning with the class itself and going up to BasicObject.
每个类都有一个ancestors chain，它的终点是BasicObject。

• 
执行方法需要两个步骤。一是找到这个方法，而是需要一个`self`。

to find a method, Ruby goes in the receiver’s class, and from there
it climbs the ancestors chain until it finds the method   实际上会先去找 这个object的？？？class，后面章节会讲
寻找方法时，Ruby会沿着ancestors chain去找。
MySubclass.ancestors # => [MySubclass, MyClass, Object, Kernel, BasicObject]


ancestors chain也会包括include进来的module。
当一个类（或者module）include一个module时，Ruby会创建一个匿名类来包含这个module，并把这个匿名类插入到ancestors chain里。
这个匿名类在ancestors chain中的位置位于including class之后。


每一行Ruby代码的执行都需要一个当前对象（current object），也就是`self`。
一个时刻只有一个对象可以作为`self`。
当方法调用时

irb启动后，它会创建一个叫`main`的对象，这个对象就是初始的`self`。
self # => main
self.class # => Object


在类（或者module）定义里，`self`就是切换成这个类（或者module）的引用。
class MyClass
self # => MyClass
end


Ruby里的private方法不能通过显式的receiver来调用；也就是说private方法必须以隐式的receiver来调用。
class C
def public_method
self.private_method    # 删除self就可以成功执行了
end
private
def private_method; end
end
C.new.public_method
上面的代码会报错：
NoMethodError: private method ‘private_method' called [...]



• When you call a method, the receiver takes the role of self.

• Instance variables are always assumed to be instance variables of self.

• Any method called without an explicit receiver is assumed to be a method of self.



Open Classes
class String
    def to_alphanumeric
        gsub /[^\w\s]/, ''
    end
end

In a sense, the class keyword in Ruby is more like a scope operator than a class declaration.
For class, the core job is to move you in the context of the class, where you can define methods.
class关键字没什么特殊的，ruby会“立即执行”class内的代码

open class的一个实际用例
class Numeric
    def to_money
        Money.new(self * 100)
    end
end
money gem打开了Numeric类，加了一个方法

[].methods.grep /^re/ # => [:replace, :reject, :reject!, :respond_to?, ...

Monkeypatch.   open class然后加个方法，这种做法也叫monkey patch


==============Chapter 1  Monday: The Object Model=========================



=========Chapter 3  Wednesday: Blocks=========

block可以用花括号或者`do...end`来定义。
block可以直接传递给方法；在方法内可以用`yield`来调用block。
def a_method(a, b)
    a + yield(a, b)
end
a_method(1, 2) {|x, y| (x + y) * 3 } # => 10


用`Kernel#block_given?()`可以判断有没有传入block到一个方法里。
def a_method
    return yield if block_given?
    'no block'
end
a_method # => "no block"
a_method { "here's a block!" } # => "here's a block!"




代码执行需要一个环境，包括local variables, instance variables, self等。
这些东西称之为bindings。block就是代码加上bindings。
block在定义时可以capture那个时刻的bindings。
block也可以定义自己的local variables。
def my_method
x = "Goodbye"
yield("cruel" )
end
x = "Hello"
my_method {|y| "#{x}, #{y} world" } # => "Hello, cruel world"   hello来自外面的x， cruel来自执行时传入的参数



Scope

the Kernel#local_variables( ) method
v1 = 1
class MyClass
v2 = 2
local_variables # => [:v2]   注意没有v1
def my_method
v3 = 3
local_variables
end
local_variables # => [:v2]
end
obj = MyClass.new
obj.my_method # => [:v3]
obj.my_method # => [:v3]
local_variables # => [:v1, :obj]


当代码进入到新的scope时，bindings会被替换掉。
不是所有的bindings都会被替换掉。
比如，当同一个对象的某个方法调用另一个方法时，bindings中instance variables就不会被替换。
但是当scope发生改变时，bindings中的local variables一定会被替换掉。



Ruby里有3种scope gates（scope发生改变的界限），
• Class definitions
• Module definitions
• Methods

Global Variables and Top-Level Instance Variables
Global variables can be accessed by any scope
def a_scope
$var = "some value"
end
def another_scope
$var
end
You can sometimes use a top-level instance variable in place
of a global variable
@var = "The top-level @var"
def my_method
@var
end
my_method # => "The top-level @var"


类或者module定义内的代码会被立即执行。方法定义（def）内的代码会在方法被调用到的时候被执行。


Flattening the Scope
my_var = "Success"
class MyClass  # Scope Gate
# 这里不能访问到my_var 
def my_method #Scope Gate
# 这里也不能访问到my_var
end
end


my_var = "Success"
MyClass = Class.new do
puts "#{my_var} in the class definition!" #bindings通过block传入
define_method :my_method do
puts "#{my_var} in the method!"
end
end
MyClass.new.my_method
) Success in the class definition!
Success in the method!

像Class.new()和Module#define_method()这种通过替换掉Scope Gate，使得bindings可以以
被closure（block）capture的方式“跨scope”的技术叫“flattening the scope”。


Sharing the Scope
def define_methods
shared = 0
Kernel.send :define_method, :counter do
shared
end
Kernel.send :define_method, :inc do |x|
shared += x
end
end
define_methods
counter # => 0
inc(4)
counter # => 4

通过Flat Scopes在方法间共享变量的技术叫做Shared Scope。


instance_eval()
another way to mix code and bindings at will
class MyClass
def initialize
@v = 1
end
end
obj = MyClass.new
obj.instance_eval do
self # => #<MyClass:0x3340dc @v=1>
@v # => 1
end

v = 2
obj.instance_eval { @v = v }
obj.instance_eval { @v } # => 2

可以给some_obj.instance_eval()传一个block，这个block可以capture外面scope的local variable，
同时block会把some_obj作为self（也就是说block可以访问some_obj的成员变量）。
传给instance_eval()的block叫做Context Probe。


instance_exec()和instance_eval()类似，但是它可以传参数。
C.new.instance_exec(3) {|arg| (@x + @y) * arg } # => 9


3.5 Callable Objects
at least three other places in Ruby
where you can package code:
• In a proc, which is basically a block turned object
• In a lambda, which is a slight variation on a proc
• In a method

Proc Objects
although most things in Ruby are objects,
blocks are not
虽然Ruby中的大部分东西都是对象，但是block不是对象。

A Proc is a block that has been turned into an object.
You can create a Proc by passing the block to Proc.new. Later, you can
evaluate the block-turned-object with Proc#call( ):
Proc就是block的对象形式。
把block传给Proc.new可以得到一个Proc。然后在未来某个时刻可以通过Proc#call()来执行它。这种技术叫做Deferred Evaluation。
inc = Proc.new {|x| x + 1 }
# more code...
inc.call(2) # => 3


The & Operator
This argument must
be the last in the list of arguments and prefixed by an & sign
def math(a, b)
yield(a, b)
end
def teach_math(a, b, &operation)
puts "Let's do the math:"
puts math(a, b, &operation)
end
teach_math(2, 3) {|x, y| x * y}
If you call teach_math( ) without a block, the &operation argument is
bound to nil, and the yield operation in math( ) fails.

The real meaning of the & is this: “This is a Proc that I want to
use as a block.” Just drop the &, and you’ll be left with a Proc again
参数前加&表示这个参数是个Proc。这种参数如果出现，必须在参数表的最后位置。
可以给“&参数”传block。
def my_method(&the_proc)
the_proc # the_proc是个Proc
end
p = my_method {|name| "Hello, #{name}!" } # 把一个block传给the_proc
puts p.class
puts p.call("Bill" )
Proc
Hello, Bill!


You now know a bunch of different ways to convert a block to a Proc.
But what if you want to convert it back? Again, you can use the &
operator to convert the Proc to a block
在Proc对象前加个&可以把它转换回block。
def my_method(greeting)
puts "#{greeting}, #{yield}!"
end
my_proc = proc { "Bill" }
my_method("Hello" , &my_proc) #my_proc被转换回block
) Hello, Bill!




dec = lambda {|x| x - 1 }
dec.class # => Proc
dec.call(2) # => 1
除了通过Proc.new( )来创建Proc对象，可以通过两个Kernel方法，lambda( )和proc( )，来创建Proc。
这几种方式创建的Proc对象有一些细微的差别。一般而言，可以选择这三种方法中的任何一种来创建Proc。

通过lambda( )创建的Proc叫做lambda，通过其它方式创建的Proc对象叫proc。



proc和lambda的最主要的两点区别在于对return关键字的处理和对参数的处理。
lambda中的return会从lambda返回。而proc中的return会从定义proc时的scope返回。
相比而言lambda对return的处理更直观、更自然。
假设一个lambda定义了两个参数，如果在调用时传入的参数数目不等于两个，那么Ruby会报ArgumentError的错误。
假设一个proc定义了两个参数，如果传入参数不等于两个，proc会截断（参数过多时）或者以nil补全（参数过少时）。


可以看到lambda相比proc而言更加自然、直观。所以，推荐在大部分情况下使用lambda。



Methods Revisited

通过Object#method( )可以得到方法对应的Method对象。
object = MyClass.new(1)
m = object.method :my_method
m.call # => 1


Method对象类似于lambda对象，但是和lambda对象有一点大的区别：a lambda is evaluated in
the scope it’s defined in (it’s a closure, remember?), while a Method is
evaluated in the scope of its object


Method对象可以通过Method#unbind( )和关联的对象解绑。Method#unbind( )返回一个
UnboundMethod对象，它不能直接执行。UnboundMethod对象也可以重现变成Method对象。
unbound = m.unbind
another_object = MyClass.new(2)
m = unbound.bind(another_object)
m.call

Method#to_proc可以把一个Method对象转换成Proc对象。
define_method( )可以把一个block转换成一个方法。

Callable Objects Wrap-Up
Blocks (they aren’t really “objects,” but they are still “callable”):
Evaluated in the scope in which they’re defined.
• Procs: Objects of class Proc. Like blocks, they are evaluated in the
scope where they’re defined.
• Lambdas: Also objects of class Proc but subtly different from regular
procs. They’re closures like blocks and procs, and as such
they’re evaluated in the scope where they’re defined.
• Methods: Bound to an object, they are evaluated in that object’s
scope. They can also be unbound from their scope and rebound to
the scope of another object.

3.6 Writing a Domain-Specific Language
=========Chapter 3  Wednesday: Blocks=========


object model
block



obj3.instance_variable_set("@x" , 10)




Symbols
symbols are immutable
In
most cases, symbols are used as names of things—in particular,
names of metaprogramming-related things such as methods.
easily convert a string to a symbol (by calling
either String#to_sym( ) or String#intern( )) or back (by calling
either Symbol#to_s( ) or Symbol#id2name( )).


my_object = Greeting.new("Hello" )
my_object.class # => Greeting
my_object.class.instance_methods(false) # => [:welcome]
my_object.instance_variables # => [:@text]

obj.instance_variables # => [:@v]
obj.methods.grep(/my/) # => [:my_method]

respond_to?
super if !@data_source.respond_to?("get_#{name}_info" )

load('motd.rb' )
Using load( ), however, has a side effect. The motd.rb file probably
defines variables and classes. Although variables fall out of
scope when the file has finished loading, constants don’t. As a
result, motd.rb can pollute your program with the names of its
own constants—in particular, class names.

load('motd.rb' , true)
If you load a file this way, Ruby creates an anonymous module,
uses that module as a Namespace (41) to contain all the
constants from motd.rb, and then destroys the module.

The require( )method is quite similar to load( ), but it’smeant for a
different purpose. You use load( ) to execute code, and you use
require( ) to import libraries. That’s why require( ) has no second
argument: those leftover class names are probably the reason
why you imported the file in the first place


The Kernel
As Bill is quick to show you, methods such as print( )
are actually private instance methods of module Kernel:
Kernel.private_instance_methods.grep(/^pr/) # => [:printf, :print, :proc]

The trick here is that class Object includes Kernel, so Kernel gets into
every object’s ancestors chain.

You can take advantage of this mechanism yourself: if you add a
method to Kernel, this Kernel Method will be available to all objects.
例子，The RubyGems Example






