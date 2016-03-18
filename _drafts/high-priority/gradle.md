https://gradle.org/migrating-a-maven-build-to-gradle/
Gradle and Maven have fundamentally different views on how to build a project. Gradle is based on a graph of task dependencies, where the tasks do the work. Maven uses a model of fixed, linear phases to which you can attach goals (the things that do the work). Despite this, migrations can be surprisingly easy because Gradle follows many of the same conventions as Maven and dependency management works in a similar way.


http://gradle.org/getting-started-gradle-java/
https://docs.gradle.org/current/userguide/tutorial_java_projects.html
As we have seen, Gradle is a general-purpose build tool.
    不止能编java
Most Java projects are pretty similar as far as the basics go: you need to compile your Java source files, run some unit tests, and create a JAR file containing your classes. It would be nice if you didn't have to code all this up for every project. Luckily, you don't have to. Gradle solves this problem through the use of plugins. 
    不同java prj的build行为是类似的；这种重复工作可以通过plugin来完成
A plugin is an extension to Gradle which configures your project in some way, typically by adding some pre-configured tasks which together do something useful.
    啥是plugin
The Java plugin is convention based. This means that the plugin defines default values for many aspects of the project, such as where the Java source files are located.
    基于惯例

Example 44.1. Using the Java plugin
    apply plugin: 'java'

Gradle expects to find your production source code under src/main/java and your test source code under src/test/java. 
In addition, any files under src/main/resources will be included in the JAR file as resources, and any files under src/test/resources will be included in the classpath used to run the tests. 
    和maven类似
All output files are created under the build directory, with the JAR file ending up in the build/libs directory.
    build的结果
    
The Java plugin adds quite a few tasks to your project.
The most commonly used task is the build task
命令 gradle build
Some other useful tasks are:
    clean
    assemble
    check
    
44.2.2. External dependencies
In Gradle, artifacts such as JAR files, are located in a repository.
可以用maven的repo
Example 44.3. Adding Maven repository
    repositories {
        mavenCentral()
    }

Example 44.4. Adding dependencies

44.2.3. Customizing the project
The Java plugin adds a number of properties to your project. These properties have default values which are usually sufficient to get started. It's easy to change these values if they don't suit.
    可以设置一些property值
    比如java版本，项目版本等
    
44.2.4. Publishing the JAR file
 In Gradle, artifacts such as JAR files are published to repositories.
 
Example 44.9. Java example - complete build file
一个例子

44.3. Multi-project Java build
编多个java项目
To define a multi-project build, you need to create a settings file. The settings file lives in the root directory of the source tree, and specifies which projects to include in the build.
需要一个settings.gradle文件

44.3.2. Common configuration
For most multi-project builds, there is some configuration which is common to all projects.

44.3.3. Dependencies between projects
You can add dependencies between projects in the same build, 



http://rominirani.com/2014/08/12/gradle-tutorial-part-4-java-web-applications/
Gradle Tutorial : Part 4 : Java Web Applications




好处
http://gradle.org/why/polyglot-builds/
http://gradle.org/why/integrates-with-everything/
http://gradle.org/why/robust-dependency-management/
http://gradle.org/why/powerful-yet-concise-logic/
http://gradle.org/why/high-performance-builds/
http://gradle.org/why/build-reporting/



https://docs.gradle.org/current/userguide/userguide.html
用户手册
2.1. Features
At the heart of Gradle lies a rich extensible Domain Specific Language (DSL) based on Groovy. 
Gradle pushes declarative builds to the next level by providing declarative language elements that you can assemble as you like. 

The declarative language lies on top of a general purpose task graph
    task graph；

Deep API

Gradle scales very well. 

Gradle's support for multi-project build is outstanding. Project dependencies are first class citizens.

4.1. Executing multiple tasks
 For example, the command gradle compile test will execute the compile and test tasks. 
 Gradle will execute the tasks in the order that they are listed on the command-line, and will also execute the dependencies for each task. 
 Each task is executed once only, regardless of how it came to be included in the build: whether it was specified on the command-line, or as a dependency of another task, or both. Let's look at an example.
 
4.2. Excluding tasks
using the -x command-line option
> gradle dist -x test

4.3. Continuing the build when a failure occurs

4.4. Task name abbreviation
you only need to provide enough of the task name to uniquely identify the task.
You can also abbreviate each word in a camel case task name. For example, you can execute task compileTest by running gradle compTest or even gradle cT

4.5. Selecting which build to execute
When you run the gradle command, it looks for a build file in the current directory. You can use the -b option to select another build file. If you use -b option then settings.gradle file is not used.

4.6.1. Listing projects
4.6.2. Listing tasks
4.6.4. Listing project dependencies

4.7. Dry Run

5.1. Executing a build with the Wrapper
If a Gradle project has set up the Wrapper (and we recommend all projects do so)
Each Wrapper is tied to a specific version of Gradle, so when you first run one of the commands above for a given Gradle version, it will download the corresponding Gradle distribution and use it to execute the build.

5.2. Adding the Wrapper to a project
The Wrapper is something you should check into version control.

Chapter 6. The Gradle Daemon
Gradle runs on the Java Virtual Machine (JVM) and uses several supporting libraries that require a non-trivial initialization time. As a result, it can sometimes seem a little slow to start. The solution to this problem is the Gradle Daemon

6.1. Enabling the Daemon

Chapter 7. Dependency Management Basics
7.2. Declaring your dependencies
dependencies {
    compile group: 'org.hibernate', name: 'hibernate-core', version: '3.6.7.Final'
    testCompile group: 'junit', name: 'junit', version: '4.+'
}
Example 7.3. Shortcut definition of an external dependency
dependencies {
    compile 'org.hibernate:hibernate-core:3.6.7.Final'
}

7.5. Repositories
7.6. Publishing artifacts

Chapter 11. The Build Environment
11.1. Configuring the build environment via gradle.properties

Part III. Writing Gradle build scripts
14.1. Projects and tasks
Everything in Gradle sits on top of two basic concepts: projects and tasks.
14.3. A shortcut task definition
14.5. Task dependencies
14.6. Dynamic tasks
14.9. Extra task properties
14.11. Using methods
14.12. Default tasks

Chapter 15. Build Init Plugin
The Gradle Build Init plugin can be used to bootstrap the process of creating a new Gradle build. It supports creating brand new projects of different types as well as converting existing builds (e.g. An Apache Maven build) to be Gradle builds.






 




