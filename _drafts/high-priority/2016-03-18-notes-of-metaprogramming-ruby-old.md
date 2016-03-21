---
# MUST HAVE BEG
layout: post
disqus_identifier: 20151228-cannot-open-itunes-on-win7 # DO NOT CHANGE THE VALUE ONCE SET
title: Windows 7上不能打开iTunes的问题 
# MUST HAVE END

is_short: true
subtitle:
tags: 
- apple
date: 2015-12-28 10:36:00
image: 
image_desc: 
---

静态语言，比如java，类定义是对象的一个“模板”；但是ruby不是这样的


my_object = Greeting.new("Hello" )
my_object.class # => Greeting
my_object.class.instance_methods(false) # => [:welcome]
my_object.instance_variables # => [:@text]


## Chapter 1  Monday: The Object Model
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

obj.instance_variables # => [:@v]
obj.methods.grep(/my/) # => [:my_method]

Instance Variables
在对象里

where are the methods，这里的method是指instance method
String.instance_methods == "abc".methods # => true
String.methods == "abc".methods # => false
instance method 在 类 里

Classes themselves are nothing but objects
"hello".class # => String
String.class # => Class

inherited = false
Class.instance_methods(inherited) # => [:superclass, :allocate, :new]

String.superclass # => Object
Object.superclass # => BasicObject
BasicObject.superclass # => nil

Class.superclass # => Module
Module.superclass # => Object

class就比module多3个方法，new( ), allocate( ), and superclass( )， class和module基本都一样
那为什么要分别有这两个东西么？
The main reason for having both modules and classes is clarity，可了可读性
Usually, you pick a module when you
mean it to be included somewhere (or maybe to be used as
a Namespace (41)  可以用来实现名字空间), and you pick a class when you mean it to
be instantiated or inherited.


Constants
首字母是大写的就是Constants

Constants有层次结构，和目录很像

一个例子，老版本的rake没有名字空间，新版本的有
module Rake
    class Task    新版本
    
Task = Rake::Task      新老版本的兼容
FileTask = Rake::FileTask
FileCreationTask = Rake::FileCreationTask    


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

小节
What’s an object? It’s just a bunch of instance variables, plus a link to
a class.
对象就是一堆instance variables， 同时它也知道自己的class
对象也可以有自己的方法。。。

What’s a class? It’s just an object (an instance of Class), plus a list of
instance methods and a link to a superclass. Class is a subclass of
Module, so a class is also a module.
class也是一个对象，它里面存在“instance of that class”的instance methods； 

Like any object, a class has its own methods, such as new( ). These are
instance methods of the Class class. Also like any object, classes must
be accessed through references. You already have a constant reference
to each class: the class’s name.

since
Object is a class, its class must be Class. This is true of all classes,
meaning that the class of Class must be Class itself.

obj3.instance_variable_set("@x" , 10)

1.5 What Happens When You Call a Method?
When you call a method, Bill explains, Ruby does two things:
1. It finds the method. This is a process called method lookup.
2. It executes the method. To do that, Ruby needs something called
self.

Method Lookup
the concept of an ancestors chain
to find a method, Ruby goes in the receiver’s class, and from there
it climbs the ancestors chain until it finds the method   实际上会先去找 这个object的？？？class，后面章节会讲

MySubclass.ancestors # => [MySubclass, MyClass, Object, Kernel, BasicObject]

Modules and Lookup
Actually, the ancestors chain also includes modules.

module M
def my_method
'M#my_method()'
end
end
class C
include M
end
class D < C; end
D.new.my_method() # => "M#my_method()"

When you include a module in a class (or even in another module),
Ruby plays a little trick. It creates an anonymous class that wraps the
module and inserts the anonymous class in the chain, just above the
including class itself:12
D.ancestors # => [D, C, M, Object, Kernel, BasicObject]

The Kernel
As Bill is quick to show you, methods such as print( )
are actually private instance methods of module Kernel:
Kernel.private_instance_methods.grep(/^pr/) # => [:printf, :print, :proc]

The trick here is that class Object includes Kernel, so Kernel gets into
every object’s ancestors chain.

You can take advantage of this mechanism yourself: if you add a
method to Kernel, this Kernel Method will be available to all objects.
例子，The RubyGems Example

Method Execution
Every line of Ruby code is executed inside an object—the so–called current
object. The current object is also known as self
Only one object can take the role of self at a given time, but no object
holds that role for a long time.

“If you want to become a master of Ruby,” Bill warns you, “you should
always know which object has the role self at any given moment.”

You can run irb and ask Ruby itself for an
answer:
self # => main
self.class # => Object
As soon as you start a Ruby program, you’re sitting within an
object named main that the Ruby interpreter created for you.
This object is sometimes called the top-level context,

Class Definitions and self
in a class or module definition (and outside of any method),
the role of self is taken by the class or module:
class MyClass
self # => MyClass
end

What private Really Means
Private methods are governed by a
single simple rule: you cannot call a private method with an
explicit receiver. In other words, every time you call a private
method, it must be on the implicit receiver—self.

class C
def public_method
self.private_method
end
private
def private_method; end
end
C.new.public_method
) NoMethodError: private method ‘private_method' called [...]
You can make this code work by removing the self keyword.

Can object x call a private method
on object y if the two objects share the same class? The answer
is no, because no matter which class you belong to, you still
need an explicit receiver to call another object’s method

1.7 Object Model Wrap-Up
• An object is composed of a bunch of instance variables and a link
to a class.
• The methods of an object live in the object’s class (from the point
of view of the class, they’re called instance methods).
• The class itself is just an object of class Class. The name of the
class is just a constant.
• Class is a subclass of Module. A module is basically a package of
methods. In addition to that, a class can also be instantiated (with
new( )) or arranged in a hierarchy (through its superclass( )).
• Constants are arranged in a tree similar to a file system, where
the names of modules and classes play the part of directories and
regular constants play the part of files.
• Each class has an ancestors chain, beginning with the class itself
and going up to BasicObject.
• When you call a method, Ruby goes right into the class of the
receiver and then up the ancestors chain, until it either finds the
method or reaches the end of the chain.
• Every time a class includes a module, the module is inserted in
the ancestors chain right above the class itself.
• When you call a method, the receiver takes the role of self.
• When you’re defining a module (or a class), the module takes the
role of self.
• Instance variables are always assumed to be instance variables of
self.
• Any method called without an explicit receiver is assumed to be a
method of self.


Chapter 2   Tuesday: Methods

we can remove the duplication in our code with either
Dynamic Methods or method_missing( ),”

2.2 Dynamic Methods
how to call and define methods dynamically

obj.send(:my_method, 3) # => 6
With send( ), the name of the
method that you want to call becomes just a regular argument. You can
wait literally until the very last moment to decide which method to call,
while the code is running. This technique is called Dynamic Dispatch

Symbols
symbols are immutable
In
most cases, symbols are used as names of things—in particular,
names of metaprogramming-related things such as methods.
easily convert a string to a symbol (by calling
either String#to_sym( ) or String#intern( )) or back (by calling
either Symbol#to_s( ) or Symbol#id2name( )).

Privacy Matters
In particular, you can
call any method with send( ), including private methods
public_send( ) method that respects the receiver’s privacy.

Defining Methods Dynamically
You can define a method on the spot with Module#define_method( ). You
just need to provide a method name and a block, which becomes the
method body
class MyClass
define_method :my_method do |my_arg|
my_arg * 3
end
end
obj = MyClass.new
obj.my_method(2) # => 6
This technique of defining a method at
runtime is called a Dynamic Method.

class Computer
def initialize(computer_id, data_source)
@id = computer_id
@data_source = data_source
end
def self.define_component(name)
define_method(name) {           传block时花括号也是可以的
info = @data_source.send "get_#{name}_info" , @id
price = @data_source.send "get_#{name}_price" , @id
result = "#{name.to_s.capitalize}: #{info} ($#{price})"
return "* #{result}" if price >= 100
result
}
end
define_component :mouse
define_component :cpu
define_component :keyboard
end


2.3 method_missing()
class Lawyer
def method_missing(method, *args)
puts "You called: #{method}(#{args.join(', ')})"
puts "(You also passed it a block)" if block_given? ------ block given
end
end

Ghost Methods
A message that’s processed by method_missing( ) looks like a regular call
from the caller’s side but has no corresponding method on the receiver’s
side. This is named a Ghost Method

class Table
def method_missing(id,*args,&block)
return as($1.to_sym,*args,&block) if id.to_s =~ /^to_(.*)/
return rows_with($1.to_sym => args[0]) if id.to_s =~ /^rows_with_(.*)/
super
end
# ...

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
super if !@data_source.respond_to?("get_#{name}_info" )
info = @data_source.send("get_#{name}_info" , args[0])
price = @data_source.send("get_#{name}_price" , args[0])
result = "#{name.to_s.capitalize}: #{info} ($#{price})"
return "* #{result}" if price >= 100
result
end
end

Overriding respond_to?()
class Computer
def respond_to?(method)
@data_source.respond_to?("get_#{method}_info" ) || super
end

const_missing()
You can define const_missing( ) on a specific Namespace (41)
(either a module or a class). If you define it on the Object class,
then all objects inherit it, including the top-level main object:
def Object.const_missing(name)
name.to_s.downcase.gsub(/_/, ' ' )
end
MY_CONSTANT # => "my constant"

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

2.5 More method_missing()
When Methods Clash
The call to
Computer#display( ) finds a real method by that name, so it never lands
on method_missing( )

Whenever
the name of a Ghost Method clashes with the name of a real, inherited
method, the latter wins.

If you don’t need the inherited method, you
can fix the problem by removing it. To stay on the safe side, you might
want to remove most inherited methods from your proxies right away.
The result is called a Blank Slate, a class that has fewer methods than 
the Object class itself.

You can remove a method in two easy ways. The drastic Module#undef_
method( ) removes all methods, including the inherited ones. The kinder
Module#remove_method( ) removes the method from the receiver, but it
leaves inherited methods alone.

Performance Anxiety
On my computer, the benchmark shows that ghost_reverse( ) is
about twice as slow as reverse( ):

If the performance
of Ghost Methods ever turns out to be a problem, you
can sometimes find a middle ground. For example, you might
be able to arrange things so that the first call to aGhostMethod
defines a Dynamic Method (68) for the next calls. You’ll see an
example of this technique and a discussion of its trade-offs in
Chapter 8, Inside ActiveRecord, on page 206. 

Reserved Methods
Some of the methods in Object are used internally by Ruby. If
you redefine or remove them, the languagemight break in subtle
ways. To make this less likely to happen, Ruby identifies these
methods with a leading double underscore and issues a warning
if you mess with them.
At the time of writing, Ruby has two such reserved methods,
__send__( ) and __id__( ), which are synonyms for send( ) and
id( ).

refactor Computer to transform it
into a Blank Slate (84).
class Computer
instance_methods.each do |m|
undef_method m unless m.to_s =~ /^__|method_missing|respond_to?/
end

BasicObject
Starting with Ruby 1.9, Blank Slates (84) are an integral part of
the language. In previous versions of Ruby, Object used to be
the root of the class hierarchy. In Ruby 1.9, Object has a superclass
named BasicObject that provides only a handful of essential
methods:
p BasicObject.instance_methods
) [:==, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__]
By default, classes still inherit from Object. Classes that inherit
directly from BasicObject are automatically Blank Slates.


Chapter 3  Wednesday: Blocks
def a_method(a, b)
a + yield(a, b)
end
a_method(1, 2) {|x, y| (x + y) * 3 } # => 10

define a block with either curly braces or the do. . . end

The block is passed straight into the method, and the method can then
call back to the block with the yield keyword


ask Ruby whether the current call includes
a block. You can do that with the Kernel#block_given?( ) method:
def a_method
return yield if block_given?
'no block'
end
a_method # => "no block"
a_method { "here's a block!" } # => "here's a block!"


write a Ruby version of using，    加到Kernel module里的代码在神恶名地方都能用，就像关键字一样

module Kernel
def using(resource)
begin
yield
ensure   === 这个应该是ruby的异常捕捉
resource.dispose
end
end


3.3 Closures
When
code runs, it needs an environment: local variables, instance variables,
self. . . . Since these entities are basically names bound to objects, you
can call them the bindings for short. The main point about blocks is
that they are all inclusive and come ready to run. They contain both
the code and a set of bindings.

where the block picks up its bindings
When
you define the block, it simply grabs the bindings that are there at that
moment, and then it carries those bindings along when you pass the
block into a method
def my_method
x = "Goodbye"
yield("cruel" )
end
x = "Hello"
my_method {|y| "#{x}, #{y} world" } # => "Hello, cruel world"   hello来自外面的x， cruel来自执行时传入的参数

when you create the block, you capture the local bindings,
such as x.

Block-Local Variables
You can also define additional bindings inside
the block, but they disappear after the block ends




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

Some languages, such as Java and C#, allow an “inner scope” to see
variables from an “outer scope.”
That kind of nested visibility doesn’t
happen in Ruby, where scopes are sharply separated: as soon as you
enter a new scope, the previous bindings are simply replaced by a new
set of bindings.

“Whenever the program
changes scope, some bindings are replaced by a new set of bindings.”
Granted, this doesn’t happen to all the bindings each and every time.
For example, if a method calls another method on the same object,
instance variables stay in scope through the call. In general, though,
bindings tend to fall out of scope when the scope changes. In particular,
local variables change at every new scope. (That’s why they’re “local”!)


Scope Gates
There are exactly three places where a program leaves the previous
scope behind and opens a new one:
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

There is a subtle difference between class and module on one side and
def on the other. The code in a class or module definition is executed
immediately. Conversely, the code in a method definition is executed
later, when you eventually call the method.


Flattening the Scope
you want to pass bindings through a Scope Gate
you can replace class with something else that is not a Scope Gate: a
method. If you could use a method in place of class, you could capture
my_var in a closure and pass that closure to the method
my_var = "Success"
MyClass = Class.new do
# Now we can print my_var here...
puts "#{my_var} in the class definition!"
def my_method
# ...but how can we print it here?
end
end

Now, how can you pass my_var through the def Scope Gate? Once again,
you have to replace the keyword with a method. Instead of def, you can
use Module#define_method( )
my_var = "Success"
MyClass = Class.new do
puts "#{my_var} in the class definition!"
define_method :my_method do
puts "#{my_var} in the method!"
end
end
MyClass.new.my_method
) Success in the class definition!
Success in the method!
Technically, this trick should be called
nested lexical scopes, but many Ruby coders refer to it simply as “flattening
the scope,”

Sharing the Scope
通过Flat Scopes 来share a variable among a few methods
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
This smart way
to control the sharing of variables is called a Shared Scope.


3.4 instance_eval()
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
The three lines in the previous example are evaluated in the same
Flat Scope (103), so they can all access the local variable v—but the
blocks are evaluated with the object as self, so they can also access
obj’s instance variable @v. In all these cases, you can call the block that
you pass to instance_eval( ) a Context Probe, because it’s like a snippet Spell: Context Probe
of code that you dip inside an object to do something in there.

instance_exec()
Ruby 1.9 introduced a method named instance_exec( ). This is
similar to instance_eval( ), but it also allows you to pass arguments
to the block
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

A Proc is a block that has been turned into an object.
You can create a Proc by passing the block to Proc.new. Later, you can
evaluate the block-turned-object with Proc#call( ):
inc = Proc.new {|x| x + 1 }
# more code...
inc.call(2) # => 3
This technique is called a Deferred Evaluation

two Kernel Methods (51) that convert a block to
a Proc: lambda( ) and proc( )
there are
subtle differences between lambda( ), proc( ), and Proc.new( ), but in most
cases you can just use whichever one you like best
dec = lambda {|x| x - 1 }
dec.class # => Proc
dec.call(2) # => 1

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
def my_method(&the_proc)
the_proc
end
p = my_method {|name| "Hello, #{name}!" }
puts p.class
puts p.call("Bill" )
Proc
Hello, Bill!

You now know a bunch of different ways to convert a block to a Proc.
But what if you want to convert it back? Again, you can use the &
operator to convert the Proc to a block
def my_method(greeting)
puts "#{greeting}, #{yield}!"
end
my_proc = proc { "Bill" }
my_method("Hello" , &my_proc)
) Hello, Bill!


Procs vs. Lambdas
The difference between procs and lambdas
is probably the most confusing feature of Ruby, with lots of special
cases and arbitrary distinctions. There’s no need to go into all the gory
details, but you need to know, at least roughly, the important differences.
There are two differences between procs and lambdas. One has to do
with the return keyword, and the other concerns the checking of arguments.

Procs created with lambda( )
are called lambdas, while the others are simply called procs.”

Procs, Lambdas, and return
In a lambda, return just returns from the
lambda
In a proc, return behaves differently. Rather than return from the proc,
it returns from the scope where the proc itself was defined

Procs, Lambdas, and Arity
For example, a particular proc or lambda
might have an arity of two, meaning that it accepts two arguments
Now, what happens if you call this callable object with three arguments
or a single argument?
The short answer is that, in general,
lambdas tend to be less tolerant than procs (and regular blocks) when
it comes to arguments. Call a lambda with the wrong arity, and it fails
with an ArgumentError. On the other hand, a proc fits the argument list
to its own expectations:
p = Proc.new {|a, b| [a, b]}
p.call(1, 2, 3) # => [1, 2]
p.call(1) # => [1, nil]

Generally speaking, lambdas are more intuitive than procs because
they’re more similar to methods. They’re pretty strict about arity, and
they simply exit when you call return. For this reason, many Rubyists
use lambdas as a first choice, unless they need the specific features
of procs.

The Stubby Lambda
Ruby 1.9 introduces yet
another syntax for defining lambdas—the so-called “stubby
lambda” operator
p = ->(x) { x + 1 }
Notice the little arrow. The previous code is the same as the
following:
p = lambda {|x| x + 1 }
The stubby lambda is an experimental feature, and it might or
might not make its way into Ruby 2.0.

Methods Revisited
object = MyClass.new(1)
m = object.method :my_method
m.call # => 1
By calling Object#method( ), you get the method itself as a Method object,
which you can later execute with Method#call( ).

A Method object is similar
to a lambda, with an important difference: a lambda is evaluated in
the scope it’s defined in (it’s a closure, remember?), while a Method is
evaluated in the scope of its object

You can detach a method from its object with Method#unbind( ), which
returns an UnboundMethod object. You can’t execute an UnboundMethod,
but you can turn it back into a Method by binding it to an object.
unbound = m.unbind
another_object = MyClass.new(2)
m = unbound.bind(another_object)
m.call

Finally, you can convert a Method object to a Proc object by calling
Method#to_proc, and you can convert a block to a method with define_
method( ).

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


Chapter 4  Thursday: Class Definitions
In truth, you can put any code you want in a class
definition.
class MyClass
puts 'Hello!'
end
) Hello!

in a class (or module)
definition, the class itself takes the role of the current object self

The Current Class
you always have
a current object: self. Likewise, you always have a current class (or
module). When you define a method, that method becomes an instance
method of the current class.

Whenever you open a class with the class keyword (or a
module with the module keyword), that class becomes the current class

However, the class keyword has a limitation: it needs the name of a
class
You need some
way other than the class keyword to change the current class.

class_eval()
Module#class_eval( ) (also known by its alternate name, module_eval( ))
evaluates a block in the context of an existing class
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
@my_var = 1
def self.read; @my_var; end
def write; @my_var = 2; end
def read; @my_var; end
end
obj = MyClass.new
obj.write
obj.read # => 2
MyClass.read # => 1
The previous code defines two instance variables. Both happen to be
named @my_var, but they’re defined in different scopes, and they belong
to different objects.

If you come from Java, you may be tempted to think that Class Instance
Variables are similar to Java’s “static fields.” Instead, they’re just regu-
lar instance variables that happen to belong to an object of class Class.
Because of that, a Class Instance Variable can be accessed only by the
class itself—not by an instance or by a subclass


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




































