http://www.eclipse.org/jetty/documentation/current/jetty-maven-plugin.html#using-multiple-webapp-root-directories


有两个项目， xxx，和yyy，他们都是web app （他们的pom文件里写着<packaging>war</packaging>）
xxx和yyy要一起部署；
xxx要部署到 /aaa 路径下
yyy要部署到 /bbb 路径下
因为xxx中的代码要访问yyy，而且访问时路径hard code成 "/bbb"了


## <plugin>放哪里
maven的pom文件里有很多地方可以放<plugin>，

比如，位置1
  <profiles>
    <profile>
      <id>coverage</id>
      <properties>
        <gruntTask>CI+coverage</gruntTask>
      </properties>
    </profile>
    <profile>
      <id>ldiBuild</id>
      <properties>
        <gruntTask>ldi</gruntTask>
      </properties>
    </profile>
    <profile>
      <id>grunt.build</id>
      <activation>
        <property>
          <name>ldi.releaseBuild</name>
        </property>
      </activation>
      <build>
        <plugins>
          <plugin>  ----------------位置1
          
位置2
    <pluginManagement>
      <plugins>
        <!--This plugin's configuration is used to store Eclipse m2e settings only. It has no influence on the Maven build itself.-->
        <plugin> --------------位置2
        
不能放在这两个位置上；应该直接放到  <build>下面
  <build>
    <finalName>sfa-anw</finalName>
    <sourceDirectory>${js.src}</sourceDirectory>
    <!-- http://www.eclipse.org/jetty/documentation/current/jetty-maven-plugin.html#running-more-than-one-webapp -->
    <plugins>
        <plugin>
            <groupId>org.eclipse.jetty</groupId>
            <artifactId>jetty-maven-plugin</artifactId>
            <!--<version>9.3.1-SNAPSHOT</version> -->
            <version>9.3.7.v20160115</version>
        
## 不能找到自己指定的版本
进入xxx项目，运行 mvn jetty:run，在输出发现下面的话
    [INFO] 8.1.16.v20140903
而自己再xxx的pom文件里是这么写的，
        <plugin>
            <groupId>org.eclipse.jetty</groupId>
            <artifactId>jetty-maven-plugin</artifactId>
            <version>9.3.1-SNAPSHOT</version>
也就是说maven没有运行我指定的jetty版本， 而是用了另外一个版本，8.1.16.v20140903

运行 mvn jetty:run -X  来debug，它输出更多的信息
=== -X 时 输出的信息 ===
Apache Maven 3.3.9 (bb52d8502b132ec0a5a3f4c09453c07478323dc5; 2015-11-11T00:41:47+08:00)
Maven home: C:\Program Files\apache-maven-3.3.9
Java version: 1.8.0_60, vendor: Oracle Corporation
Java home: C:\Program Files\Java\jdk1.8.0_60\jre
Default locale: en_US, platform encoding: Cp1252
OS name: "windows 7", version: "6.1", arch: "amd64", family: "dos"
[DEBUG] Created new class realm maven.api
[DEBUG] Importing foreign packages into class realm maven.api
[DEBUG]   Imported: javax.enterprise.inject.* < plexus.core
[DEBUG]   Imported: javax.enterprise.util.* < plexus.core
[DEBUG]   Imported: javax.inject.* < plexus.core
[DEBUG]   Imported: org.apache.maven.* < plexus.core
[DEBUG]   Imported: org.apache.maven.artifact < plexus.core
[DEBUG]   Imported: org.apache.maven.classrealm < plexus.core
[DEBUG]   Imported: org.apache.maven.cli < plexus.core
[DEBUG]   Imported: org.apache.maven.configuration < plexus.core
[DEBUG]   Imported: org.apache.maven.exception < plexus.core
[DEBUG]   Imported: org.apache.maven.execution < plexus.core
[DEBUG]   Imported: org.apache.maven.execution.scope < plexus.core
[DEBUG]   Imported: org.apache.maven.lifecycle < plexus.core
[DEBUG]   Imported: org.apache.maven.model < plexus.core
[DEBUG]   Imported: org.apache.maven.monitor < plexus.core
[DEBUG]   Imported: org.apache.maven.plugin < plexus.core
[DEBUG]   Imported: org.apache.maven.profiles < plexus.core
[DEBUG]   Imported: org.apache.maven.project < plexus.core
[DEBUG]   Imported: org.apache.maven.reporting < plexus.core
[DEBUG]   Imported: org.apache.maven.repository < plexus.core
[DEBUG]   Imported: org.apache.maven.rtinfo < plexus.core
[DEBUG]   Imported: org.apache.maven.settings < plexus.core
[DEBUG]   Imported: org.apache.maven.toolchain < plexus.core
[DEBUG]   Imported: org.apache.maven.usability < plexus.core
[DEBUG]   Imported: org.apache.maven.wagon.* < plexus.core
[DEBUG]   Imported: org.apache.maven.wagon.authentication < plexus.core
[DEBUG]   Imported: org.apache.maven.wagon.authorization < plexus.core
[DEBUG]   Imported: org.apache.maven.wagon.events < plexus.core
[DEBUG]   Imported: org.apache.maven.wagon.observers < plexus.core
[DEBUG]   Imported: org.apache.maven.wagon.proxy < plexus.core
[DEBUG]   Imported: org.apache.maven.wagon.repository < plexus.core
[DEBUG]   Imported: org.apache.maven.wagon.resource < plexus.core
[DEBUG]   Imported: org.codehaus.classworlds < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.* < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.classworlds < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.component < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.configuration < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.container < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.context < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.lifecycle < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.logging < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.personality < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.util.xml.Xpp3Dom < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.util.xml.pull.XmlPullParser < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.util.xml.pull.XmlPullParserException < plexus.core
[DEBUG]   Imported: org.codehaus.plexus.util.xml.pull.XmlSerializer < plexus.core
[DEBUG]   Imported: org.eclipse.aether.* < plexus.core
[DEBUG]   Imported: org.eclipse.aether.artifact < plexus.core
[DEBUG]   Imported: org.eclipse.aether.collection < plexus.core
[DEBUG]   Imported: org.eclipse.aether.deployment < plexus.core
[DEBUG]   Imported: org.eclipse.aether.graph < plexus.core
[DEBUG]   Imported: org.eclipse.aether.impl < plexus.core
[DEBUG]   Imported: org.eclipse.aether.installation < plexus.core
[DEBUG]   Imported: org.eclipse.aether.internal.impl < plexus.core
[DEBUG]   Imported: org.eclipse.aether.metadata < plexus.core
[DEBUG]   Imported: org.eclipse.aether.repository < plexus.core
[DEBUG]   Imported: org.eclipse.aether.resolution < plexus.core
[DEBUG]   Imported: org.eclipse.aether.spi < plexus.core
[DEBUG]   Imported: org.eclipse.aether.transfer < plexus.core
[DEBUG]   Imported: org.eclipse.aether.version < plexus.core
[DEBUG]   Imported: org.slf4j.* < plexus.core
[DEBUG]   Imported: org.slf4j.helpers.* < plexus.core
[DEBUG]   Imported: org.slf4j.spi.* < plexus.core
[DEBUG] Populating class realm maven.api
[INFO] Error stacktraces are turned on.
[DEBUG] Reading global settings from C:\Program Files\apache-maven-3.3.9\conf\settings.xml
[DEBUG] Reading user settings from C:\Users\I305760\.m2\settings.xml
[DEBUG] Reading global toolchains from C:\Program Files\apache-maven-3.3.9\conf\toolchains.xml
[DEBUG] Reading user toolchains from C:\Users\I305760\.m2\toolchains.xml
[DEBUG] Using local repository at C:\Users\I305760\.m2\repository
[DEBUG] Using manager EnhancedLocalRepositoryManager with priority 10.0 for C:\Users\I305760\.m2\repository
[INFO] Scanning for projects...
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for all.snapshots (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository).
[DEBUG] Could not find metadata com.sap.sbo.occ:od-parent:2.2.0-SNAPSHOT/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Using transporter WagonTransporter with priority -1.0 for http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository
[DEBUG] Using connector BasicRepositoryConnector with priority 0.0 for http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository
Downloading: http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository/com/sap/sbo/occ/od-parent/2.2.0-SNAPSHOT/maven-metadata.xml
603/603 B   
            
Downloaded: http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository/com/sap/sbo/occ/od-parent/2.2.0-SNAPSHOT/maven-metadata.xml (603 B at 6.5 KB/sec)
[DEBUG] Writing tracking file C:\Users\I305760\.m2\repository\com\sap\sbo\occ\od-parent\2.2.0-SNAPSHOT\resolver-status.properties
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for releases (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository).
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for snapshots (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository).
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for central (https://repo.maven.apache.org/maven2).
[DEBUG] Extension realms for project com.sap.sbo.occ:sfa-anw:war:2.2.0-SNAPSHOT: (none)
[DEBUG] Looking up lifecyle mappings for packaging war from ClassRealm[plexus.core, parent: null]
[DEBUG] Extension realms for project com.sap.sbo.occ:od-parent:pom:2.2.0-SNAPSHOT: (none)
[DEBUG] Looking up lifecyle mappings for packaging pom from ClassRealm[plexus.core, parent: null]
[DEBUG] Resolving plugin prefix jetty from [org.mortbay.jetty, tk.skuro, org.apache.maven.plugins, org.codehaus.mojo]
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for apache.snapshots (http://repository.apache.org/snapshots).
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for codehaus-snapshots (http://nexus.codehaus.org/snapshots/).
[DEBUG] Could not find metadata org.eclipse.jetty:jetty-maven-plugin:9.3.1-SNAPSHOT/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Failure to find org.eclipse.jetty:jetty-maven-plugin:9.3.1-SNAPSHOT/maven-metadata.xml in http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository was cached in the local repository, resolution will not be reattempted until the update interval of local nexus has elapsed or updates are forced
[DEBUG] Could not find metadata org.eclipse.jetty:jetty-maven-plugin:9.3.1-SNAPSHOT/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Failure to find org.eclipse.jetty:jetty-maven-plugin:9.3.1-SNAPSHOT/maven-metadata.xml in http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository was cached in the local repository, resolution will not be reattempted until the update interval of local nexus has elapsed or updates are forced
[WARNING] The POM for org.eclipse.jetty:jetty-maven-plugin:jar:9.3.1-SNAPSHOT is missing, no dependency information available
[WARNING] Failed to retrieve plugin descriptor for org.eclipse.jetty:jetty-maven-plugin:9.3.1-SNAPSHOT: Plugin org.eclipse.jetty:jetty-maven-plugin:9.3.1-SNAPSHOT or one of its dependencies could not be resolved: Failure to find org.eclipse.jetty:jetty-maven-plugin:jar:9.3.1-SNAPSHOT in http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository was cached in the local repository, resolution will not be reattempted until the update interval of local nexus has elapsed or updates are forced
org.apache.maven.plugin.PluginResolutionException: Plugin org.eclipse.jetty:jetty-maven-plugin:9.3.1-SNAPSHOT or one of its dependencies could not be resolved: Failure to find org.eclipse.jetty:jetty-maven-plugin:jar:9.3.1-SNAPSHOT in http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository was cached in the local repository, resolution will not be reattempted until the update interval of local nexus has elapsed or updates are forced
	at org.apache.maven.plugin.internal.DefaultPluginDependenciesResolver.resolve(DefaultPluginDependenciesResolver.java:128)
	at org.apache.maven.plugin.internal.DefaultMavenPluginManager.getPluginDescriptor(DefaultMavenPluginManager.java:179)
	at org.apache.maven.plugin.DefaultBuildPluginManager.loadPlugin(DefaultBuildPluginManager.java:83)
	at org.apache.maven.plugin.prefix.internal.DefaultPluginPrefixResolver.resolveFromProject(DefaultPluginPrefixResolver.java:138)
	at org.apache.maven.plugin.prefix.internal.DefaultPluginPrefixResolver.resolveFromProject(DefaultPluginPrefixResolver.java:121)
	at org.apache.maven.plugin.prefix.internal.DefaultPluginPrefixResolver.resolve(DefaultPluginPrefixResolver.java:85)
	at org.apache.maven.lifecycle.internal.MojoDescriptorCreator.findPluginForPrefix(MojoDescriptorCreator.java:265)
	at org.apache.maven.lifecycle.internal.MojoDescriptorCreator.getMojoDescriptor(MojoDescriptorCreator.java:219)
	at org.apache.maven.lifecycle.internal.DefaultLifecycleTaskSegmentCalculator.calculateTaskSegments(DefaultLifecycleTaskSegmentCalculator.java:103)
	at org.apache.maven.lifecycle.internal.DefaultLifecycleTaskSegmentCalculator.calculateTaskSegments(DefaultLifecycleTaskSegmentCalculator.java:83)
	at org.apache.maven.lifecycle.internal.LifecycleStarter.execute(LifecycleStarter.java:89)
	at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:307)
	at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:193)
	at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:106)
	at org.apache.maven.cli.MavenCli.execute(MavenCli.java:863)
	at org.apache.maven.cli.MavenCli.doMain(MavenCli.java:288)
	at org.apache.maven.cli.MavenCli.main(MavenCli.java:199)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:497)
	at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced(Launcher.java:289)
	at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:229)
	at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode(Launcher.java:415)
	at org.codehaus.plexus.classworlds.launcher.Launcher.main(Launcher.java:356)
Caused by: org.eclipse.aether.resolution.ArtifactResolutionException: Failure to find org.eclipse.jetty:jetty-maven-plugin:jar:9.3.1-SNAPSHOT in http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository was cached in the local repository, resolution will not be reattempted until the update interval of local nexus has elapsed or updates are forced
	at org.eclipse.aether.internal.impl.DefaultArtifactResolver.resolve(DefaultArtifactResolver.java:444)
	at org.eclipse.aether.internal.impl.DefaultArtifactResolver.resolveArtifacts(DefaultArtifactResolver.java:246)
	at org.eclipse.aether.internal.impl.DefaultArtifactResolver.resolveArtifact(DefaultArtifactResolver.java:223)
	at org.eclipse.aether.internal.impl.DefaultRepositorySystem.resolveArtifact(DefaultRepositorySystem.java:294)
	at org.apache.maven.plugin.internal.DefaultPluginDependenciesResolver.resolve(DefaultPluginDependenciesResolver.java:124)
	... 24 more
Caused by: org.eclipse.aether.transfer.ArtifactNotFoundException: Failure to find org.eclipse.jetty:jetty-maven-plugin:jar:9.3.1-SNAPSHOT in http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository was cached in the local repository, resolution will not be reattempted until the update interval of local nexus has elapsed or updates are forced
	at org.eclipse.aether.internal.impl.DefaultUpdateCheckManager.newException(DefaultUpdateCheckManager.java:231)
	at org.eclipse.aether.internal.impl.DefaultUpdateCheckManager.checkArtifact(DefaultUpdateCheckManager.java:206)
	at org.eclipse.aether.internal.impl.DefaultArtifactResolver.gatherDownloads(DefaultArtifactResolver.java:585)
	at org.eclipse.aether.internal.impl.DefaultArtifactResolver.performDownloads(DefaultArtifactResolver.java:503)
	at org.eclipse.aether.internal.impl.DefaultArtifactResolver.resolve(DefaultArtifactResolver.java:421)
	... 28 more
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for apache.snapshots (http://people.apache.org/repo/m2-snapshot-repository).
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for eclipselink (http://download.eclipse.org/rt/eclipselink/maven.repo/).
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for sonatype-nexus-snapshots (https://oss.sonatype.org/content/repositories/snapshots).
[DEBUG] Could not find metadata com.sap.sbo.occ.tool.build:build-helper:2.2.0-SNAPSHOT/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for com.sap.sbo.occ.tool.build:build-helper:2.2.0-SNAPSHOT/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Could not find metadata com.sap.sbo.occ.tool.build:build-helper:2.2.0-SNAPSHOT/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for com.sap.sbo.occ.tool.build:build-helper:2.2.0-SNAPSHOT/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Could not find metadata com.sap.sbo.occ.tool:plugin-pom:2.2.0-SNAPSHOT/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for com.sap.sbo.occ.tool:plugin-pom:2.2.0-SNAPSHOT/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Could not find metadata com.sap.sbo.occ.tool:sld-tools:2.2.0-SNAPSHOT/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for com.sap.sbo.occ.tool:sld-tools:2.2.0-SNAPSHOT/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Could not find metadata com.sap.sbo.occ.tool:sld-tools:2.2.0-SNAPSHOT/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for com.sap.sbo.occ.tool:sld-tools:2.2.0-SNAPSHOT/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Could not find metadata org.mortbay.jetty/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for org.mortbay.jetty/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Could not find metadata tk.skuro/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for tk.skuro/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Could not find metadata org.apache.maven.plugins/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for org.apache.maven.plugins/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Could not find metadata org.codehaus.mojo/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for org.codehaus.mojo/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Resolved plugin prefix jetty to org.mortbay.jetty:jetty-maven-plugin from repository local nexus
[DEBUG] Resolving plugin version for org.mortbay.jetty:jetty-maven-plugin
[DEBUG] Could not find metadata org.mortbay.jetty:jetty-maven-plugin/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for org.mortbay.jetty:jetty-maven-plugin/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Resolved plugin version for org.mortbay.jetty:jetty-maven-plugin to 8.1.16.v20140903 from repository local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository, default, releases+snapshots)
[DEBUG] === REACTOR BUILD PLAN ================================================
[DEBUG] Project: com.sap.sbo.occ:sfa-anw:war:2.2.0-SNAPSHOT
[DEBUG] Tasks:   [jetty:run]
[DEBUG] Style:   Regular
[DEBUG] =======================================================================
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building sfa-anw 2.2.0-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[DEBUG] Resolving plugin prefix jetty from [org.mortbay.jetty, tk.skuro, org.apache.maven.plugins, org.codehaus.mojo]
[WARNING] The POM for org.eclipse.jetty:jetty-maven-plugin:jar:9.3.1-SNAPSHOT is missing, no dependency information available
[WARNING] Failed to retrieve plugin descriptor for org.eclipse.jetty:jetty-maven-plugin:9.3.1-SNAPSHOT: Plugin org.eclipse.jetty:jetty-maven-plugin:9.3.1-SNAPSHOT or one of its dependencies could not be resolved: Failure to find org.eclipse.jetty:jetty-maven-plugin:jar:9.3.1-SNAPSHOT in http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository was cached in the local repository, resolution will not be reattempted until the update interval of local nexus has elapsed or updates are forced
org.apache.maven.plugin.PluginResolutionException: Plugin org.eclipse.jetty:jetty-maven-plugin:9.3.1-SNAPSHOT or one of its dependencies could not be resolved: Failure to find org.eclipse.jetty:jetty-maven-plugin:jar:9.3.1-SNAPSHOT in http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository was cached in the local repository, resolution will not be reattempted until the update interval of local nexus has elapsed or updates are forced
	at org.apache.maven.plugin.internal.DefaultPluginDependenciesResolver.resolve(DefaultPluginDependenciesResolver.java:128)
	at org.apache.maven.plugin.internal.DefaultMavenPluginManager.getPluginDescriptor(DefaultMavenPluginManager.java:179)
	at org.apache.maven.plugin.DefaultBuildPluginManager.loadPlugin(DefaultBuildPluginManager.java:83)
	at org.apache.maven.plugin.prefix.internal.DefaultPluginPrefixResolver.resolveFromProject(DefaultPluginPrefixResolver.java:138)
	at org.apache.maven.plugin.prefix.internal.DefaultPluginPrefixResolver.resolveFromProject(DefaultPluginPrefixResolver.java:121)
	at org.apache.maven.plugin.prefix.internal.DefaultPluginPrefixResolver.resolve(DefaultPluginPrefixResolver.java:85)
	at org.apache.maven.lifecycle.internal.MojoDescriptorCreator.findPluginForPrefix(MojoDescriptorCreator.java:265)
	at org.apache.maven.lifecycle.internal.MojoDescriptorCreator.getMojoDescriptor(MojoDescriptorCreator.java:219)
	at org.apache.maven.lifecycle.internal.DefaultLifecycleExecutionPlanCalculator.calculateMojoExecutions(DefaultLifecycleExecutionPlanCalculator.java:206)
	at org.apache.maven.lifecycle.internal.DefaultLifecycleExecutionPlanCalculator.calculateExecutionPlan(DefaultLifecycleExecutionPlanCalculator.java:127)
	at org.apache.maven.lifecycle.internal.DefaultLifecycleExecutionPlanCalculator.calculateExecutionPlan(DefaultLifecycleExecutionPlanCalculator.java:145)
	at org.apache.maven.lifecycle.internal.builder.BuilderCommon.resolveBuildPlan(BuilderCommon.java:96)
	at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:109)
	at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:80)
	at org.apache.maven.lifecycle.internal.builder.singlethreaded.SingleThreadedBuilder.build(SingleThreadedBuilder.java:51)
	at org.apache.maven.lifecycle.internal.LifecycleStarter.execute(LifecycleStarter.java:128)
	at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:307)
	at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:193)
	at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:106)
	at org.apache.maven.cli.MavenCli.execute(MavenCli.java:863)
	at org.apache.maven.cli.MavenCli.doMain(MavenCli.java:288)
	at org.apache.maven.cli.MavenCli.main(MavenCli.java:199)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:497)
	at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced(Launcher.java:289)
	at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:229)
	at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode(Launcher.java:415)
	at org.codehaus.plexus.classworlds.launcher.Launcher.main(Launcher.java:356)
Caused by: org.eclipse.aether.resolution.ArtifactResolutionException: Failure to find org.eclipse.jetty:jetty-maven-plugin:jar:9.3.1-SNAPSHOT in http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository was cached in the local repository, resolution will not be reattempted until the update interval of local nexus has elapsed or updates are forced
	at org.eclipse.aether.internal.impl.DefaultArtifactResolver.resolve(DefaultArtifactResolver.java:444)
	at org.eclipse.aether.internal.impl.DefaultArtifactResolver.resolveArtifacts(DefaultArtifactResolver.java:246)
	at org.eclipse.aether.internal.impl.DefaultArtifactResolver.resolveArtifact(DefaultArtifactResolver.java:223)
	at org.eclipse.aether.internal.impl.DefaultRepositorySystem.resolveArtifact(DefaultRepositorySystem.java:294)
	at org.apache.maven.plugin.internal.DefaultPluginDependenciesResolver.resolve(DefaultPluginDependenciesResolver.java:124)
	... 29 more
Caused by: org.eclipse.aether.transfer.ArtifactNotFoundException: Failure to find org.eclipse.jetty:jetty-maven-plugin:jar:9.3.1-SNAPSHOT in http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository was cached in the local repository, resolution will not be reattempted until the update interval of local nexus has elapsed or updates are forced
	at org.eclipse.aether.internal.impl.DefaultUpdateCheckManager.newException(DefaultUpdateCheckManager.java:231)
	at org.eclipse.aether.internal.impl.DefaultUpdateCheckManager.checkArtifact(DefaultUpdateCheckManager.java:206)
	at org.eclipse.aether.internal.impl.DefaultArtifactResolver.gatherDownloads(DefaultArtifactResolver.java:585)
	at org.eclipse.aether.internal.impl.DefaultArtifactResolver.performDownloads(DefaultArtifactResolver.java:503)
	at org.eclipse.aether.internal.impl.DefaultArtifactResolver.resolve(DefaultArtifactResolver.java:421)
	... 33 more
[DEBUG] Could not find metadata org.mortbay.jetty/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for org.mortbay.jetty/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Could not find metadata tk.skuro/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for tk.skuro/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Could not find metadata org.apache.maven.plugins/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for org.apache.maven.plugins/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Could not find metadata org.codehaus.mojo/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for org.codehaus.mojo/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Resolved plugin prefix jetty to org.mortbay.jetty:jetty-maven-plugin from repository local nexus
[DEBUG] Resolving plugin version for org.mortbay.jetty:jetty-maven-plugin
[DEBUG] Could not find metadata org.mortbay.jetty:jetty-maven-plugin/maven-metadata.xml in local (C:\Users\I305760\.m2\repository)
[DEBUG] Skipped remote request for org.mortbay.jetty:jetty-maven-plugin/maven-metadata.xml, locally cached metadata up-to-date.
[DEBUG] Resolved plugin version for org.mortbay.jetty:jetty-maven-plugin to 8.1.16.v20140903 from repository local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository, default, releases+snapshots)
[DEBUG] Lifecycle default -> [validate, initialize, generate-sources, process-sources, generate-resources, process-resources, compile, process-classes, generate-test-sources, process-test-sources, generate-test-resources, process-test-resources, test-compile, process-test-classes, test, prepare-package, package, pre-integration-test, integration-test, post-integration-test, verify, install, deploy]
[DEBUG] Lifecycle clean -> [pre-clean, clean, post-clean]
[DEBUG] Lifecycle site -> [pre-site, site, post-site, site-deploy]
[DEBUG] Lifecycle default -> [validate, initialize, generate-sources, process-sources, generate-resources, process-resources, compile, process-classes, generate-test-sources, process-test-sources, generate-test-resources, process-test-resources, test-compile, process-test-classes, test, prepare-package, package, pre-integration-test, integration-test, post-integration-test, verify, install, deploy]
[DEBUG] Lifecycle clean -> [pre-clean, clean, post-clean]
[DEBUG] Lifecycle site -> [pre-site, site, post-site, site-deploy]
[DEBUG] === PROJECT BUILD PLAN ================================================
[DEBUG] Project:       com.sap.sbo.occ:sfa-anw:2.2.0-SNAPSHOT
[DEBUG] Dependencies (collect): []
[DEBUG] Dependencies (resolve): [test]
[DEBUG] Repositories (dependencies): [local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository, default, releases+snapshots)]
[DEBUG] Repositories (plugins)     : [local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository, default, releases+snapshots)]
[DEBUG] --- init fork of com.sap.sbo.occ:sfa-anw:2.2.0-SNAPSHOT for org.mortbay.jetty:jetty-maven-plugin:8.1.16.v20140903:run (default-cli) ---
[DEBUG] Dependencies (collect): []
[DEBUG] Dependencies (resolve): [compile, runtime, test]
[DEBUG] -----------------------------------------------------------------------
[DEBUG] Goal:          org.apache.maven.plugins:maven-resources-plugin:2.6:resources (default-resources)
[DEBUG] Style:         Regular
[DEBUG] Configuration: <?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <buildFilters default-value="${project.build.filters}"/>
  <encoding default-value="${project.build.sourceEncoding}">UTF-8</encoding>
  <escapeString>${maven.resources.escapeString}</escapeString>
  <escapeWindowsPaths default-value="true">${maven.resources.escapeWindowsPaths}</escapeWindowsPaths>
  <includeEmptyDirs default-value="false">${maven.resources.includeEmptyDirs}</includeEmptyDirs>
  <outputDirectory default-value="${project.build.outputDirectory}"/>
  <overwrite default-value="false">${maven.resources.overwrite}</overwrite>
  <project default-value="${project}"/>
  <resources default-value="${project.resources}"/>
  <session default-value="${session}"/>
  <supportMultiLineFiltering default-value="false">${maven.resources.supportMultiLineFiltering}</supportMultiLineFiltering>
  <useBuildFilters default-value="true"/>
  <useDefaultDelimiters default-value="true"/>
</configuration>
[DEBUG] -----------------------------------------------------------------------
[DEBUG] Goal:          org.apache.maven.plugins:maven-war-plugin:2.3:manifest (add-manifest)
[DEBUG] Style:         Regular
[DEBUG] Configuration: <?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <archive>
    <manifestEntries>
      <Component-Version>N/A</Component-Version>
    </manifestEntries>
  </archive>
  <archiveClasses default-value="false">${archiveClasses}</archiveClasses>
  <cacheFile default-value="${project.build.directory}/war/work/webapp-cache.xml"/>
  <classesDirectory default-value="${project.build.outputDirectory}"/>
  <containerConfigXML>${maven.war.containerConfigXML}</containerConfigXML>
  <escapeString>${maven.war.escapeString}</escapeString>
  <escapedBackslashesInFilePath default-value="false">${maven.war.escapedBackslashesInFilePath}</escapedBackslashesInFilePath>
  <filteringDeploymentDescriptors default-value="false">${maven.war.filteringDeploymentDescriptors}</filteringDeploymentDescriptors>
  <recompressZippedFiles default-value="false"/>
  <resourceEncoding default-value="${project.build.sourceEncoding}">${resourceEncoding}</resourceEncoding>
  <useCache default-value="false">${useCache}</useCache>
  <warSourceDirectory default-value="${basedir}/src/main/webapp"/>
  <warSourceIncludes default-value="**"/>
  <webXml>${maven.war.webxml}</webXml>
  <webappDirectory default-value="${project.build.directory}/${project.build.finalName}"/>
  <workDirectory default-value="${project.build.directory}/war/work"/>
  <project default-value="${project}"/>
  <session default-value="${session}"/>
</configuration>
[DEBUG] -----------------------------------------------------------------------
[DEBUG] Goal:          org.apache.maven.plugins:maven-compiler-plugin:3.1:compile (default-compile)
[DEBUG] Style:         Regular
[DEBUG] Configuration: <?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <basedir default-value="${basedir}"/>
  <buildDirectory default-value="${project.build.directory}"/>
  <classpathElements default-value="${project.compileClasspathElements}"/>
  <compileSourceRoots default-value="${project.compileSourceRoots}"/>
  <compilerId default-value="javac">${maven.compiler.compilerId}</compilerId>
  <compilerReuseStrategy default-value="${reuseCreated}">${maven.compiler.compilerReuseStrategy}</compilerReuseStrategy>
  <compilerVersion>${maven.compiler.compilerVersion}</compilerVersion>
  <debug default-value="true">${maven.compiler.debug}</debug>
  <debuglevel>${maven.compiler.debuglevel}</debuglevel>
  <encoding default-value="${project.build.sourceEncoding}">UTF-8</encoding>
  <executable>${maven.compiler.executable}</executable>
  <failOnError default-value="true">${maven.compiler.failOnError}</failOnError>
  <forceJavacCompilerUse default-value="false">${maven.compiler.forceJavacCompilerUse}</forceJavacCompilerUse>
  <fork default-value="false">true</fork>
  <generatedSourcesDirectory default-value="${project.build.directory}/generated-sources/annotations"/>
  <maxmem>${maven.compiler.maxmem}</maxmem>
  <meminitial>${maven.compiler.meminitial}</meminitial>
  <mojoExecution>${mojoExecution}</mojoExecution>
  <optimize default-value="false">${maven.compiler.optimize}</optimize>
  <outputDirectory default-value="${project.build.outputDirectory}"/>
  <projectArtifact default-value="${project.artifact}"/>
  <showDeprecation default-value="false">true</showDeprecation>
  <showWarnings default-value="false">true</showWarnings>
  <skipMain>${maven.main.skip}</skipMain>
  <skipMultiThreadWarning default-value="false">${maven.compiler.skipMultiThreadWarning}</skipMultiThreadWarning>
  <source default-value="1.5">1.7</source>
  <staleMillis default-value="0">${lastModGranularityMs}</staleMillis>
  <target default-value="1.5">1.7</target>
  <useIncrementalCompilation default-value="true">${maven.compiler.useIncrementalCompilation}</useIncrementalCompilation>
  <verbose default-value="false">true</verbose>
  <mavenSession default-value="${session}"/>
  <session default-value="${session}"/>
</configuration>
[DEBUG] -----------------------------------------------------------------------
[DEBUG] Goal:          org.apache.maven.plugins:maven-resources-plugin:2.6:testResources (default-testResources)
[DEBUG] Style:         Regular
[DEBUG] Configuration: <?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <buildFilters default-value="${project.build.filters}"/>
  <encoding default-value="${project.build.sourceEncoding}">UTF-8</encoding>
  <escapeString>${maven.resources.escapeString}</escapeString>
  <escapeWindowsPaths default-value="true">${maven.resources.escapeWindowsPaths}</escapeWindowsPaths>
  <includeEmptyDirs default-value="false">${maven.resources.includeEmptyDirs}</includeEmptyDirs>
  <outputDirectory default-value="${project.build.testOutputDirectory}"/>
  <overwrite default-value="false">${maven.resources.overwrite}</overwrite>
  <project default-value="${project}"/>
  <resources default-value="${project.testResources}"/>
  <session default-value="${session}"/>
  <skip>${maven.test.skip}</skip>
  <supportMultiLineFiltering default-value="false">${maven.resources.supportMultiLineFiltering}</supportMultiLineFiltering>
  <useBuildFilters default-value="true"/>
  <useDefaultDelimiters default-value="true"/>
</configuration>
[DEBUG] -----------------------------------------------------------------------
[DEBUG] Goal:          org.apache.maven.plugins:maven-compiler-plugin:3.1:testCompile (default-testCompile)
[DEBUG] Style:         Regular
[DEBUG] Configuration: <?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <basedir default-value="${basedir}"/>
  <buildDirectory default-value="${project.build.directory}"/>
  <classpathElements default-value="${project.testClasspathElements}"/>
  <compileSourceRoots default-value="${project.testCompileSourceRoots}"/>
  <compilerId default-value="javac">${maven.compiler.compilerId}</compilerId>
  <compilerReuseStrategy default-value="${reuseCreated}">${maven.compiler.compilerReuseStrategy}</compilerReuseStrategy>
  <compilerVersion>${maven.compiler.compilerVersion}</compilerVersion>
  <debug default-value="true">${maven.compiler.debug}</debug>
  <debuglevel>${maven.compiler.debuglevel}</debuglevel>
  <encoding default-value="${project.build.sourceEncoding}">UTF-8</encoding>
  <executable>${maven.compiler.executable}</executable>
  <failOnError default-value="true">${maven.compiler.failOnError}</failOnError>
  <forceJavacCompilerUse default-value="false">${maven.compiler.forceJavacCompilerUse}</forceJavacCompilerUse>
  <fork default-value="false">true</fork>
  <generatedTestSourcesDirectory default-value="${project.build.directory}/generated-test-sources/test-annotations"/>
  <maxmem>${maven.compiler.maxmem}</maxmem>
  <meminitial>${maven.compiler.meminitial}</meminitial>
  <mojoExecution>${mojoExecution}</mojoExecution>
  <optimize default-value="false">${maven.compiler.optimize}</optimize>
  <outputDirectory default-value="${project.build.testOutputDirectory}"/>
  <showDeprecation default-value="false">true</showDeprecation>
  <showWarnings default-value="false">true</showWarnings>
  <skip>${maven.test.skip}</skip>
  <skipMultiThreadWarning default-value="false">${maven.compiler.skipMultiThreadWarning}</skipMultiThreadWarning>
  <source default-value="1.5">1.7</source>
  <staleMillis default-value="0">${lastModGranularityMs}</staleMillis>
  <target default-value="1.5">1.7</target>
  <testSource>${maven.compiler.testSource}</testSource>
  <testTarget>${maven.compiler.testTarget}</testTarget>
  <useIncrementalCompilation default-value="true">${maven.compiler.useIncrementalCompilation}</useIncrementalCompilation>
  <verbose default-value="false">true</verbose>
  <mavenSession default-value="${session}"/>
  <session default-value="${session}"/>
</configuration>
[DEBUG] --- exit fork of com.sap.sbo.occ:sfa-anw:2.2.0-SNAPSHOT for org.mortbay.jetty:jetty-maven-plugin:8.1.16.v20140903:run (default-cli) ---
[DEBUG] -----------------------------------------------------------------------
[DEBUG] Goal:          org.mortbay.jetty:jetty-maven-plugin:8.1.16.v20140903:run (default-cli)
[DEBUG] Style:         Regular
[DEBUG] Configuration: <?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <classesDirectory>${project.build.outputDirectory}</classesDirectory>
  <contextPath>/${project.artifactId}</contextPath>
  <daemon default-value="false">${jetty.daemon}</daemon>
  <execution>${mojoExecution}</execution>
  <pluginArtifacts>${plugin.artifacts}</pluginArtifacts>
  <project>${project}</project>
  <projectArtifacts>${project.artifacts}</projectArtifacts>
  <reload default-value="automatic">${jetty.reload}</reload>
  <scanIntervalSeconds default-value="0">${jetty.scanIntervalSeconds}</scanIntervalSeconds>
  <skip default-value="false">${jetty.skip}</skip>
  <systemPropertiesFile>${jetty.systemPropertiesFile}</systemPropertiesFile>
  <testClassesDirectory>${project.build.testOutputDirectory}</testClassesDirectory>
  <tmpDirectory>${project.build.directory}/tmp</tmpDirectory>
  <useProvidedScope default-value="false"/>
  <useTestScope default-value="false"/>
  <webAppSourceDirectory>${maven.war.src}</webAppSourceDirectory>
  <webXml>${maven.war.webxml}</webXml>
</configuration>
[DEBUG] =======================================================================
[INFO] 
[INFO] >>> jetty-maven-plugin:8.1.16.v20140903:run (default-cli) > test-compile @ sfa-anw >>>
[DEBUG] Dependency collection stats: {ConflictMarker.analyzeTime=0, ConflictMarker.markTime=0, ConflictMarker.nodeCount=7, ConflictIdSorter.graphTime=1, ConflictIdSorter.topsortTime=0, ConflictIdSorter.conflictIdCount=6, ConflictIdSorter.conflictIdCycleCount=0, ConflictResolver.totalTime=2, ConflictResolver.conflictItemCount=6, DefaultDependencyCollector.collectTime=21, DefaultDependencyCollector.transformTime=5}
[DEBUG] com.sap.sbo.occ:sfa-anw:war:2.2.0-SNAPSHOT
[DEBUG]    junit:junit:jar:4.11:test
[DEBUG]       org.hamcrest:hamcrest-core:jar:1.3:test
[DEBUG]    org.mockito:mockito-all:jar:1.9.5:test
[DEBUG]    nl.jqno.equalsverifier:equalsverifier:jar:1.1.3:test
[DEBUG]       org.objenesis:objenesis:jar:1.1:test
[DEBUG]       cglib:cglib-nodep:jar:2.2:test
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ sfa-anw ---
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for codehaus.snapshots (http://snapshots.repository.codehaus.org).
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for snapshots (http://snapshots.maven.codehaus.org/maven2).
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for central (http://repo1.maven.org/maven2).
[DEBUG] Dependency collection stats: {ConflictMarker.analyzeTime=1, ConflictMarker.markTime=0, ConflictMarker.nodeCount=77, ConflictIdSorter.graphTime=0, ConflictIdSorter.topsortTime=0, ConflictIdSorter.conflictIdCount=26, ConflictIdSorter.conflictIdCycleCount=0, ConflictResolver.totalTime=3, ConflictResolver.conflictItemCount=74, DefaultDependencyCollector.collectTime=134, DefaultDependencyCollector.transformTime=4}
[DEBUG] org.apache.maven.plugins:maven-resources-plugin:jar:2.6:
[DEBUG]    org.apache.maven:maven-plugin-api:jar:2.0.6:compile
[DEBUG]    org.apache.maven:maven-project:jar:2.0.6:compile
[DEBUG]       org.apache.maven:maven-profile:jar:2.0.6:compile
[DEBUG]       org.apache.maven:maven-artifact-manager:jar:2.0.6:compile
[DEBUG]       org.apache.maven:maven-plugin-registry:jar:2.0.6:compile
[DEBUG]    org.apache.maven:maven-core:jar:2.0.6:compile
[DEBUG]       org.apache.maven:maven-plugin-parameter-documenter:jar:2.0.6:compile
[DEBUG]       org.apache.maven.reporting:maven-reporting-api:jar:2.0.6:compile
[DEBUG]          org.apache.maven.doxia:doxia-sink-api:jar:1.0-alpha-7:compile
[DEBUG]       org.apache.maven:maven-repository-metadata:jar:2.0.6:compile
[DEBUG]       org.apache.maven:maven-error-diagnostics:jar:2.0.6:compile
[DEBUG]       commons-cli:commons-cli:jar:1.0:compile
[DEBUG]       org.apache.maven:maven-plugin-descriptor:jar:2.0.6:compile
[DEBUG]       org.codehaus.plexus:plexus-interactivity-api:jar:1.0-alpha-4:compile
[DEBUG]       classworlds:classworlds:jar:1.1:compile
[DEBUG]    org.apache.maven:maven-artifact:jar:2.0.6:compile
[DEBUG]    org.apache.maven:maven-settings:jar:2.0.6:compile
[DEBUG]    org.apache.maven:maven-model:jar:2.0.6:compile
[DEBUG]    org.apache.maven:maven-monitor:jar:2.0.6:compile
[DEBUG]    org.codehaus.plexus:plexus-container-default:jar:1.0-alpha-9-stable-1:compile
[DEBUG]       junit:junit:jar:3.8.1:compile
[DEBUG]    org.codehaus.plexus:plexus-utils:jar:2.0.5:compile
[DEBUG]    org.apache.maven.shared:maven-filtering:jar:1.1:compile
[DEBUG]       org.sonatype.plexus:plexus-build-api:jar:0.0.4:compile
[DEBUG]    org.codehaus.plexus:plexus-interpolation:jar:1.13:compile
[DEBUG] Created new class realm plugin>org.apache.maven.plugins:maven-resources-plugin:2.6
[DEBUG] Importing foreign packages into class realm plugin>org.apache.maven.plugins:maven-resources-plugin:2.6
[DEBUG]   Imported:  < maven.api
[DEBUG] Populating class realm plugin>org.apache.maven.plugins:maven-resources-plugin:2.6
[DEBUG]   Included: org.apache.maven.plugins:maven-resources-plugin:jar:2.6
[DEBUG]   Included: org.apache.maven.reporting:maven-reporting-api:jar:2.0.6
[DEBUG]   Included: org.apache.maven.doxia:doxia-sink-api:jar:1.0-alpha-7
[DEBUG]   Included: commons-cli:commons-cli:jar:1.0
[DEBUG]   Included: org.codehaus.plexus:plexus-interactivity-api:jar:1.0-alpha-4
[DEBUG]   Included: junit:junit:jar:3.8.1
[DEBUG]   Included: org.codehaus.plexus:plexus-utils:jar:2.0.5
[DEBUG]   Included: org.apache.maven.shared:maven-filtering:jar:1.1
[DEBUG]   Included: org.sonatype.plexus:plexus-build-api:jar:0.0.4
[DEBUG]   Included: org.codehaus.plexus:plexus-interpolation:jar:1.13
[DEBUG] Configuring mojo org.apache.maven.plugins:maven-resources-plugin:2.6:resources from plugin realm ClassRealm[plugin>org.apache.maven.plugins:maven-resources-plugin:2.6, parent: sun.misc.Launcher$AppClassLoader@70dea4e]
[DEBUG] Configuring mojo 'org.apache.maven.plugins:maven-resources-plugin:2.6:resources' with basic configurator -->
[DEBUG]   (f) buildFilters = []
[DEBUG]   (f) encoding = UTF-8
[DEBUG]   (f) escapeWindowsPaths = true
[DEBUG]   (s) includeEmptyDirs = false
[DEBUG]   (s) outputDirectory = E:\git\occ-server\sfa-anw\target\classes
[DEBUG]   (s) overwrite = false
[DEBUG]   (f) project = MavenProject: com.sap.sbo.occ:sfa-anw:2.2.0-SNAPSHOT @ E:\git\occ-server\sfa-anw\pom.xml
[DEBUG]   (s) resources = [Resource {targetPath: null, filtering: false, FileSet {directory: E:\git\occ-server\sfa-anw\src\main\java, PatternSet [includes: {**/*.properties}, excludes: {}]}}, Resource {targetPath: null, filtering: false, FileSet {directory: E:\git\occ-server\sfa-anw\src\main\resources, PatternSet [includes: {**/*.*}, excludes: {}]}}]
[DEBUG]   (f) session = org.apache.maven.execution.MavenSession@7cf7aee
[DEBUG]   (f) supportMultiLineFiltering = false
[DEBUG]   (f) useBuildFilters = true
[DEBUG]   (s) useDefaultDelimiters = true
[DEBUG] -- end configuration --
[DEBUG] properties used {file.encoding.pkg=sun.io, env.ACLOCAL_PATH=C:\Program Files\Git\mingw64\share\aclocal;C:\Program Files\Git\usr\share\aclocal, env.CLCACHE_DIR=C:\ccache, env.SSF_LIBRARY_PATH_64=C:\Program Files\SAP\FrontEnd\SecureLogin\lib\sapcrypto.dll, aopalliance.version=1.0, java.home=C:\Program Files\Java\jdk1.8.0_60\jre, env.HTTPS_PROXY=http://proxy.tyo.sap.corp:8080, groovy.version=2.3.4, maven.plugin.version=3.0.4, tomcat.jdbc.version=7.0.35, env.DISPLAY=needs-to-be-defined, junit.parallel.threadCount=1, classworlds.conf=C:/Program Files/apache-maven-3.3.9/bin/m2.conf, java.endorsed.dirs=C:\Program Files\Java\jdk1.8.0_60\jre\lib\endorsed, env.USERNAME=I305760, mockito.version=1.9.5, gruntTask=CI+build, sun.os.patch.level=Service Pack 1, java.vendor.url=http://java.oracle.com/, env.COMPUTERNAME=PVGD50856145A, compiler.version=3.1, mail.groupId=com.sap.sbo.occ.mail, env.PRINTER=\\cnpvglps0.pvgl.sap.corp\CN38_BW, product.name=SAP Anywhere OCC, poi.version=3.13, java.version=1.8.0_60, env.MAVEN_OPTS= -XX:MaxPermSize=1024m,-XX:PermSize=512m, java.vendor.url.bug=http://bugreport.sun.com/bugreport/, env.USERPROFILE=C:\Users\I305760, env.PLINK_PROTOCOL=ssh, swagger-core-version=1.5.0, sqljdbc.version=4.0, sonar.tests=E:\git\occ-server\sfa-anw/test/specs, user.name=I305760, env.LANG=en_US.UTF-8, sun.io.unicode.encoding=UnicodeLittle, war.version=2.3, eclipselink.weave.plugin.version=1.0.4, sun.jnu.encoding=Cp1252, java.runtime.name=Java(TM) SE Runtime Environment, env.SNC_LIB=C:\Program Files (x86)\SAP\FrontEnd\SecureLogin\lib\sapcrypto.dll, env.LOCALAPPDATA=C:\Users\I305760\AppData\Local, env.WINDOWS_TRACING_LOGFILE=C:\BVTBin\Tests\installpackage\csilogfile.log, env.SSH_ASKPASS=C:/Program Files/Git/mingw64/libexec/git-core/git-gui--askpass, env.ASL.LOG=Destination=file, geronimo.jta.version=1.1.1, env.COMMONPROGRAMW6432=C:\Program Files\Common Files, maven.source.plugin.version=2.2.1, java.specification.name=Java Platform API Specification, aspectj.version=1.6.12, user.timezone=Asia/Shanghai, janino.version=2.6.1, httpcomponent.version=4.4.1, resource.version=2.6, user.script=, path.separator=;, env.MAVEN_CMD_LINE_ARGS= jetty:run -X, deploy.version=2.7, env.PROCESSOR_IDENTIFIER=Intel64 Family 6 Model 58 Stepping 9, GenuineIntel, file.encoding=Cp1252, jar.version=2.4, env.HOME=C:\Users\I305760, sun.java.command=org.codehaus.plexus.classworlds.launcher.Launcher jetty:run -X, velocity.version=1.7, env.MANPATH=C:\Program Files\Git\mingw64\share\man;C:\Program Files\Git\usr\local\man;C:\Program Files\Git\usr\share\man;C:\Program Files\Git\usr\man;C:\Program Files\Git\share\man, env.NUMBER_OF_PROCESSORS=8, commons.beanutils.version=1.8.3, spring.amqp.version=1.1.4.RELEASE, env.APPDATA=C:\Users\I305760\AppData\Roaming, env.WINDIR=C:\WINDOWS, env.HOSTNAME=PVGD50856145A, sonar.cpd.java.minimumLines=8, fasterxml.version=2.4.2, java.io.tmpdir=C:\Users\I305760\AppData\Local\Temp\, user.language=en, ngdbc.version=1.00.68.384084, jmockit.version=1.14, line.separator=
, install.version=2.4, ngdbc.ver=1.97.2, core4j.version=0.5, sonar.surefire.reportsPath=E:\git\occ-server\sfa-anw/target, env.HISTSIZE=30000, env.COMMONPROGRAMFILES=C:\Program Files\Common Files, env.HTTP_PROXY=http://proxy.tyo.sap.corp:8080, java.vm.info=mixed mode, env.DEFLOGDIR=C:\ProgramData\McAfee\DesktopProtection, sun.desktop=windows, java.vm.specification.name=Java Virtual Machine Specification, env.SNC_LIB_64=C:\Program Files\SAP\FrontEnd\SecureLogin\lib\sapcrypto.dll, occ.groupId=com.sap.sbo.occ, project.reporting.outputEncoding=UTF-8, surefire.version=2.18.1, pitest.version=1.1.5, commons.fileupload.version=1.3.1, env.M2_HOME=C:/Program Files/apache-maven-3.3.9, env.PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC, env.USERDOMAIN_ROAMINGPROFILE=GLOBAL, sld.version=2.2.0-SNAPSHOT, env.LOGONSERVER=\\DS3PVG0000, env.PSMODULEPATH=C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\, java.awt.printerjob=sun.awt.windows.WPrinterJob, commons.digester3.version=3.2, mariadb.client.version=1.3.4.1, commons.validator.version=1.4.0, javax.mail.version=1.4.7, env.PUBLIC=C:\Users\Public, ant.version=1.7.0, env.USERDOMAIN=GLOBAL, env.CLCACHE_LOG=1, project.build.resourceEncoding=UTF-8, env.PROCESSOR_LEVEL=6, env.PROGRAMFILES(X86)=C:\Program Files (x86), commons.dbcp.version=1.4, clean.version=2.5, commons.io.version=2.4, os.name=Windows 7, java.specification.vendor=Oracle Corporation, env.TMP=C:\Users\I305760\AppData\Local\Temp, env.TERM=xterm, java.vm.name=Java HotSpot(TM) 64-Bit Server VM, jsp.api.version=2.1, env.OS=Windows_NT, java.library.path=C:\Program Files\Java\jdk1.8.0_60\bin;C:\WINDOWS\Sun\Java\bin;C:\WINDOWS\system32;C:\WINDOWS;C:\Users\I305760\bin;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\usr\local\bin;C:\Program Files\Git\usr\bin;C:\Program Files\Git\usr\bin;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\usr\bin;C:\Users\I305760\bin;C:\Program Files\apache-maven-3.3.9\bin;C:\Ruby22-x64\bin;C:\ProgramData\Oracle\Java\javapath;C:\windows\system32;C:\windows;C:\windows\system32\wbem;C:\python27\scripts;C:\hong\bin\clcache\dist;C:\python27;C:\cygwin64\bin;C:\program files (x86)\microsoft application virtualization client;C:\program files (x86)\open text\view\bin;C:\windows\system32\windowspowershell\v1.0;C:\program files (x86)\microsoft sql server\100\tools\binn;C:\program files\microsoft sql server\100\tools\binn;C:\program files\microsoft sql server\100\dts\binn;C:\program files (x86)\microsoft sql server\100\tools\binn\vsshell\common7\ide;C:\program files (x86)\microsoft visual studio 9.0\common7\ide\privateassemblies;C:\program files (x86)\microsoft sql server\100\dts\binn;C:\program files (x86)\microsoft sql server\90\tools\binn;C:\program files\perforce;C:\Program Files\Java\jdk1.8.0_60\bin;C:\Program Files\apache-maven-3.3.9\bin;C:\p4a\busmb_b1\b1anywhere\dev\c\9.01\sbo\output.x64;C:\p4a\busmb_b1\b1anywhere\dev\c\9.01\sbo\observerjni\bin.x64;C:\program files\nodejs;C:\cygwin64\usr\local\bin;C:\program files (x86)\opentext\viewer\bin;C:\p4a\p_9.01\sbo\observerjni\bin.x64;C:\p4a\p_9.01\sbo\output.x64;C:\program files (x86)\windows kits\8.0\windows performance toolkit;C:\windows\system32\windowspowershell\v1.0;C:\program files\tortoisehg;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\Program Files (x86)\QuickTime\QTSystem;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\Users\I305760\AppData\Roaming\npm;C:\Program Files\Git\usr\bin\vendor_perl;C:\Program Files\Git\usr\bin\core_perl;., env.PROGRAMW6432=C:\Program Files, env.PATH=C:\Users\I305760\bin;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\usr\local\bin;C:\Program Files\Git\usr\bin;C:\Program Files\Git\usr\bin;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\usr\bin;C:\Users\I305760\bin;C:\Program Files\apache-maven-3.3.9\bin;C:\Ruby22-x64\bin;C:\ProgramData\Oracle\Java\javapath;C:\windows\system32;C:\windows;C:\windows\system32\wbem;C:\python27\scripts;C:\hong\bin\clcache\dist;C:\python27;C:\cygwin64\bin;C:\program files (x86)\microsoft application virtualization client;C:\program files (x86)\open text\view\bin;C:\windows\system32\windowspowershell\v1.0;C:\program files (x86)\microsoft sql server\100\tools\binn;C:\program files\microsoft sql server\100\tools\binn;C:\program files\microsoft sql server\100\dts\binn;C:\program files (x86)\microsoft sql server\100\tools\binn\vsshell\common7\ide;C:\program files (x86)\microsoft visual studio 9.0\common7\ide\privateassemblies;C:\program files (x86)\microsoft sql server\100\dts\binn;C:\program files (x86)\microsoft sql server\90\tools\binn;C:\program files\perforce;C:\Program Files\Java\jdk1.8.0_60\bin;C:\Program Files\apache-maven-3.3.9\bin;C:\p4a\busmb_b1\b1anywhere\dev\c\9.01\sbo\output.x64;C:\p4a\busmb_b1\b1anywhere\dev\c\9.01\sbo\observerjni\bin.x64;C:\program files\nodejs;C:\cygwin64\usr\local\bin;C:\program files (x86)\opentext\viewer\bin;C:\p4a\p_9.01\sbo\observerjni\bin.x64;C:\p4a\p_9.01\sbo\output.x64;C:\program files (x86)\windows kits\8.0\windows performance toolkit;C:\windows\system32\windowspowershell\v1.0;C:\program files\tortoisehg;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\Program Files (x86)\QuickTime\QTSystem;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\Users\I305760\AppData\Roaming\npm;C:\Program Files\Git\usr\bin\vendor_perl;C:\Program Files\Git\usr\bin\core_perl, env.INFOPATH=C:\Program Files\Git\usr\local\info;C:\Program Files\Git\usr\share\info;C:\Program Files\Git\usr\info;C:\Program Files\Git\share\info, java.class.version=52.0, env.SHLVL=1, maven.multiModuleProjectDirectory=E:/git/occ-server/sfa-anw, sap.security.version=1.2.2, commons.collections.version=3.2.1, assembly.version=2.4, freemarker.version=2.3.16, env.HOMEDRIVE=C:, env.SYSTEMROOT=C:\WINDOWS, spring.version=4.1.2.RELEASE, env.COMSPEC=C:\WINDOWS\system32\cmd.exe, maven.test.skip=false, sun.boot.library.path=C:\Program Files\Java\jdk1.8.0_60\jre\bin, project.build.sourceEncoding=UTF-8, env.SYSTEMDRIVE=C:, jetty.server.version=7.6.3.v20120416, env.PROCESSOR_REVISION=3a09, sun.management.compiler=HotSpot 64-Bit Tiered Compilers, env.VSEDEFLOGDIR=C:\ProgramData\McAfee\DesktopProtection, user.variant=, java.awt.graphicsenv=sun.awt.Win32GraphicsEnvironment, sonar.language=js, kaptcha.version=2.3.2, feed.groupId=com.sap.sbo.occ.feed, env.HISTFILESIZE=50000, sp.groupId=com.sap.sbo.occ.sp, junit.version=4.11, joda.time.version=2.8.2, env.PROGRAMFILES=C:\Program Files, java.vm.specification.version=1.8, env.HOMELOC=CN_PVGL, env.PROGRAMDATA=C:\ProgramData, slf4j.version=1.7.6, awt.toolkit=sun.awt.windows.WToolkit, powermock.version=1.5, sun.cpu.isalist=amd64, env.MAVEN_PROJECTBASEDIR=E:/git/occ-server/sfa-anw, java.ext.dirs=C:\Program Files\Java\jdk1.8.0_60\jre\lib\ext;C:\WINDOWS\Sun\Java\lib\ext, apache.mime4j.version=0.7.2, os.version=6.1, user.home=C:\Users\I305760, geronimo.jpa.version=1.1, commons.lang.version=2.6, cometd.version=2.4.2, java.vm.vendor=Oracle Corporation, env.PKG_CONFIG_PATH=C:\Program Files\Git\mingw64\lib\pkgconfig;C:\Program Files\Git\mingw64\share\pkgconfig, logback.version=1.0.13, env.JAVA_HOME=C:/Program Files/Java/jdk1.8.0_60, env.USERDNSDOMAIN=GLOBAL.CORP.SAP, user.dir=E:\git\occ-server\sfa-anw, antrun.version=1.7, standard.version=1.1.2, env.COMMONPROGRAMFILES(X86)=C:\Program Files (x86)\Common Files, servlet.api.version=3.0.1, jsoup.version=1.7.2, env.FP_NO_HOST_CHECK=NO, env.PWD=E:/git/occ-server/sfa-anw, commons.email.version=1.3.1, env.SSF_LIBRARY_PATH=C:\Program Files (x86)\SAP\FrontEnd\SecureLogin\lib\sapcrypto.dll, sun.cpu.endian=little, javax.persistence.version=2.1.0, env.ALLUSERSPROFILE=C:\ProgramData, equalsverifier.version=1.1.3, js.src=E:\git\occ-server\sfa-anw/src/main/webapp/js, ngdbc.groupId=com.sap.db.jdbc, env.TMPDIR=C:\Users\I305760\AppData\Local\Temp, sonar.javascript.lcov.reportPath=E:\git\occ-server\sfa-anw/target/coverage/lcov.info, env.PROCESSOR_ARCHITECTURE=AMD64, java.vm.version=25.60-b23, env.HOMEPATH=\Users\I305760, org.slf4j.simpleLogger.defaultLogLevel=debug, java.class.path=C:/Program Files/apache-maven-3.3.9/boot/plexus-classworlds-2.5.2.jar, env.VS100COMNTOOLS=c:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools\, env.UATDATA=C:\WINDOWS\CCM\UATData\D9F8C395-CAB8-491d-B8AC-179A1FE1BE77, javassist.version=3.12.1.GA, os.arch=amd64, maven.build.version=Apache Maven 3.3.9 (bb52d8502b132ec0a5a3f4c09453c07478323dc5; 2015-11-11T00:41:47+08:00), env.WINDOWS_TRACING_FLAGS=3, commons.codec.version=1.6, guava.version=15.0, sun.java.launcher=SUN_STANDARD, ngdbc.artifactId=ngdbc, rabbitmq.version=3.0.1, javamelody.version=1.43.0, jstl.version=1.2, misc.library.version=2.2.0-SNAPSHOT, java.vm.specification.vendor=Oracle Corporation, file.separator=\, gson.version=2.1, java.runtime.version=1.8.0_60-b27, sun.boot.class.path=C:\Program Files\Java\jdk1.8.0_60\jre\lib\resources.jar;C:\Program Files\Java\jdk1.8.0_60\jre\lib\rt.jar;C:\Program Files\Java\jdk1.8.0_60\jre\lib\sunrsasign.jar;C:\Program Files\Java\jdk1.8.0_60\jre\lib\jsse.jar;C:\Program Files\Java\jdk1.8.0_60\jre\lib\jce.jar;C:\Program Files\Java\jdk1.8.0_60\jre\lib\charsets.jar;C:\Program Files\Java\jdk1.8.0_60\jre\lib\jfr.jar;C:\Program Files\Java\jdk1.8.0_60\jre\classes, env.EXEPATH=C:\Program Files\Git, sld.groupId=com.sap.occ.businessone, sap.lps.version=1.0.1, jackson.version=1.9.3, maven.version=3.3.9, spring.retry.version=1.0.2.RELEASE, env.TEMP=C:\Users\I305760\AppData\Local\Temp, user.country=US, env.VS80COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio 8\Common7\Tools\, env.SHELL=C:\Program Files\Git\usr\bin\bash, maven.home=C:\Program Files\apache-maven-3.3.9, eclipselink.version=2.5.2, occ.plugin.version=2.2.0-SNAPSHOT, env.ERLANG_HOME=C:\Program Files\erl5.10.1, cglib.version=2.2, java.vendor=Oracle Corporation, junit.parallel.type=none, occ.component.version=N/A, sonar.sources=E:\git\occ-server\sfa-anw/src/main/webapp, hsqldb.version=2.2.8, java.specification.version=1.8, env.MSYSTEM=MINGW64, sun.arch.data.model=64}
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[DEBUG] resource with targetPath null
directory E:\git\occ-server\sfa-anw\src\main\java
excludes []
includes [**/*.properties]
[INFO] skip non existing resourceDirectory E:\git\occ-server\sfa-anw\src\main\java
[DEBUG] resource with targetPath null
directory E:\git\occ-server\sfa-anw\src\main\resources
excludes []
includes [**/*.*]
[INFO] skip non existing resourceDirectory E:\git\occ-server\sfa-anw\src\main\resources
[DEBUG] no use filter components
[INFO] 
[INFO] --- maven-war-plugin:2.3:manifest (add-manifest) @ sfa-anw ---
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for plexus.snapshots (https://oss.sonatype.org/content/repositories/plexus-snapshots).
[WARNING] The POM for com.thoughtworks.xstream:xstream:jar:1.4.3 is invalid, transitive dependencies (if any) will not be available: 1 problem was encountered while building the effective model
[FATAL] Non-readable POM C:\Users\I305760\.m2\repository\com\thoughtworks\xstream\xstream\1.4.3\xstream-1.4.3.pom: no more data available - expected end tags </excludes></configuration></plugin></plugins></build></profile></profiles></project> to close start tag <excludes> from line 233 and start tag <configuration> from line 232 and start tag <plugin> from line 229 and start tag <plugins> from line 228 and start tag <build> from line 227 and start tag <profile> from line 222 and start tag <profiles> from line 191 and start tag <project> from line 1, parser stopped on END_TAG seen ...<exclude>**/basic/StringBuilder*</exclude>\n          ... @239:11 @ 

[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for apache.snapshots (http://people.apache.org/maven-snapshot-repository).
[DEBUG] Dependency collection stats: {ConflictMarker.analyzeTime=0, ConflictMarker.markTime=0, ConflictMarker.nodeCount=94, ConflictIdSorter.graphTime=0, ConflictIdSorter.topsortTime=0, ConflictIdSorter.conflictIdCount=29, ConflictIdSorter.conflictIdCycleCount=0, ConflictResolver.totalTime=2, ConflictResolver.conflictItemCount=86, DefaultDependencyCollector.collectTime=87, DefaultDependencyCollector.transformTime=2}
[DEBUG] org.apache.maven.plugins:maven-war-plugin:jar:2.3:
[DEBUG]    org.apache.maven:maven-plugin-api:jar:2.0.6:compile
[DEBUG]    org.apache.maven:maven-artifact:jar:2.0.6:compile
[DEBUG]    org.apache.maven:maven-model:jar:2.0.6:compile
[DEBUG]    org.apache.maven:maven-project:jar:2.0.6:compile
[DEBUG]       org.apache.maven:maven-profile:jar:2.0.6:compile
[DEBUG]       org.apache.maven:maven-artifact-manager:jar:2.0.6:compile
[DEBUG]       org.apache.maven:maven-plugin-registry:jar:2.0.6:compile
[DEBUG]    org.apache.maven:maven-core:jar:2.0.6:compile
[DEBUG]       org.apache.maven:maven-plugin-parameter-documenter:jar:2.0.6:compile
[DEBUG]       org.apache.maven.reporting:maven-reporting-api:jar:2.0.6:compile
[DEBUG]          org.apache.maven.doxia:doxia-sink-api:jar:1.0-alpha-7:compile
[DEBUG]       org.apache.maven:maven-repository-metadata:jar:2.0.6:compile
[DEBUG]       org.apache.maven:maven-error-diagnostics:jar:2.0.6:compile
[DEBUG]       commons-cli:commons-cli:jar:1.0:compile
[DEBUG]       org.apache.maven:maven-plugin-descriptor:jar:2.0.6:compile
[DEBUG]       org.codehaus.plexus:plexus-interactivity-api:jar:1.0-alpha-4:compile
[DEBUG]       classworlds:classworlds:jar:1.1:compile
[DEBUG]    org.apache.maven:maven-settings:jar:2.0.6:compile
[DEBUG]    org.apache.maven:maven-monitor:jar:2.0.6:compile
[DEBUG]    org.apache.maven:maven-archiver:jar:2.5:compile
[DEBUG]    org.codehaus.plexus:plexus-io:jar:2.0.5:compile
[DEBUG]    org.codehaus.plexus:plexus-archiver:jar:2.2:compile
[DEBUG]    org.codehaus.plexus:plexus-interpolation:jar:1.15:compile
[DEBUG]    org.codehaus.plexus:plexus-container-default:jar:1.0-alpha-9-stable-1:compile
[DEBUG]       junit:junit:jar:3.8.1:compile
[DEBUG]    com.thoughtworks.xstream:xstream:jar:1.4.3:compile
[DEBUG]    org.codehaus.plexus:plexus-utils:jar:3.0.8:compile
[DEBUG]    org.apache.maven.shared:maven-filtering:jar:1.0-beta-2:compile
[DEBUG] Created new class realm plugin>org.apache.maven.plugins:maven-war-plugin:2.3
[DEBUG] Importing foreign packages into class realm plugin>org.apache.maven.plugins:maven-war-plugin:2.3
[DEBUG]   Imported:  < maven.api
[DEBUG] Populating class realm plugin>org.apache.maven.plugins:maven-war-plugin:2.3
[DEBUG]   Included: org.apache.maven.plugins:maven-war-plugin:jar:2.3
[DEBUG]   Included: org.apache.maven.reporting:maven-reporting-api:jar:2.0.6
[DEBUG]   Included: org.apache.maven.doxia:doxia-sink-api:jar:1.0-alpha-7
[DEBUG]   Included: commons-cli:commons-cli:jar:1.0
[DEBUG]   Included: org.codehaus.plexus:plexus-interactivity-api:jar:1.0-alpha-4
[DEBUG]   Included: org.apache.maven:maven-archiver:jar:2.5
[DEBUG]   Included: org.codehaus.plexus:plexus-io:jar:2.0.5
[DEBUG]   Included: org.codehaus.plexus:plexus-archiver:jar:2.2
[DEBUG]   Included: org.codehaus.plexus:plexus-interpolation:jar:1.15
[DEBUG]   Included: junit:junit:jar:3.8.1
[DEBUG]   Included: com.thoughtworks.xstream:xstream:jar:1.4.3
[DEBUG]   Included: org.codehaus.plexus:plexus-utils:jar:3.0.8
[DEBUG]   Included: org.apache.maven.shared:maven-filtering:jar:1.0-beta-2
[DEBUG] Configuring mojo org.apache.maven.plugins:maven-war-plugin:2.3:manifest from plugin realm ClassRealm[plugin>org.apache.maven.plugins:maven-war-plugin:2.3, parent: sun.misc.Launcher$AppClassLoader@70dea4e]
[DEBUG] Configuring mojo 'org.apache.maven.plugins:maven-war-plugin:2.3:manifest' with basic configurator -->
[DEBUG]   (s) manifestEntries = {Component-Version=N/A}
[DEBUG]   (f) archive = org.apache.maven.archiver.MavenArchiveConfiguration@79d743e6
[DEBUG]   (s) archiveClasses = false
[DEBUG]   (s) cacheFile = E:\git\occ-server\sfa-anw\target\war\work\webapp-cache.xml
[DEBUG]   (s) classesDirectory = E:\git\occ-server\sfa-anw\target\classes
[DEBUG]   (f) escapedBackslashesInFilePath = false
[DEBUG]   (f) filteringDeploymentDescriptors = false
[DEBUG]   (f) recompressZippedFiles = false
[DEBUG]   (f) resourceEncoding = UTF-8
[DEBUG]   (s) useCache = false
[DEBUG]   (s) warSourceDirectory = E:\git\occ-server\sfa-anw\src\main\webapp
[DEBUG]   (s) warSourceIncludes = **
[DEBUG]   (s) webappDirectory = E:\git\occ-server\sfa-anw\target\sfa-anw
[DEBUG]   (s) workDirectory = E:\git\occ-server\sfa-anw\target\war\work
[DEBUG]   (s) project = MavenProject: com.sap.sbo.occ:sfa-anw:2.2.0-SNAPSHOT @ E:\git\occ-server\sfa-anw\pom.xml
[DEBUG]   (f) session = org.apache.maven.execution.MavenSession@7cf7aee
[DEBUG] -- end configuration --
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ sfa-anw ---
[DEBUG] Using mirror local nexus (http://cnpvgvb1od091.pvgl.sap.corp:8081/nexus/content/groups/allrepository) for apache-snapshots (http://people.apache.org/repo/m2-snapshot-repository).
[DEBUG] Dependency collection stats: {ConflictMarker.analyzeTime=0, ConflictMarker.markTime=1, ConflictMarker.nodeCount=160, ConflictIdSorter.graphTime=0, ConflictIdSorter.topsortTime=0, ConflictIdSorter.conflictIdCount=43, ConflictIdSorter.conflictIdCycleCount=0, ConflictResolver.totalTime=2, ConflictResolver.conflictItemCount=63, DefaultDependencyCollector.collectTime=243, DefaultDependencyCollector.transformTime=3}
[DEBUG] org.apache.maven.plugins:maven-compiler-plugin:jar:3.1:
[DEBUG]    org.apache.maven:maven-plugin-api:jar:2.0.9:compile
[DEBUG]    org.apache.maven:maven-artifact:jar:2.0.9:compile
[DEBUG]       org.codehaus.plexus:plexus-utils:jar:1.5.1:compile
[DEBUG]    org.apache.maven:maven-core:jar:2.0.9:compile
[DEBUG]       org.apache.maven:maven-settings:jar:2.0.9:compile
[DEBUG]       org.apache.maven:maven-plugin-parameter-documenter:jar:2.0.9:compile
[DEBUG]       org.apache.maven:maven-profile:jar:2.0.9:compile
[DEBUG]       org.apache.maven:maven-model:jar:2.0.9:compile
[DEBUG]       org.apache.maven:maven-repository-metadata:jar:2.0.9:compile
[DEBUG]       org.apache.maven:maven-error-diagnostics:jar:2.0.9:compile
[DEBUG]       org.apache.maven:maven-project:jar:2.0.9:compile
[DEBUG]          org.apache.maven:maven-plugin-registry:jar:2.0.9:compile
[DEBUG]       org.apache.maven:maven-plugin-descriptor:jar:2.0.9:compile
[DEBUG]       org.apache.maven:maven-artifact-manager:jar:2.0.9:compile
[DEBUG]       org.apache.maven:maven-monitor:jar:2.0.9:compile
[DEBUG]    org.apache.maven:maven-toolchain:jar:1.0:compile
[DEBUG]    org.apache.maven.shared:maven-shared-utils:jar:0.1:compile
[DEBUG]       com.google.code.findbugs:jsr305:jar:2.0.1:compile
[DEBUG]    org.apache.maven.shared:maven-shared-incremental:jar:1.1:compile
[DEBUG]       org.codehaus.plexus:plexus-component-annotations:jar:1.5.5:compile
[DEBUG]    org.codehaus.plexus:plexus-compiler-api:jar:2.2:compile
[DEBUG]    org.codehaus.plexus:plexus-compiler-manager:jar:2.2:compile
[DEBUG]    org.codehaus.plexus:plexus-compiler-javac:jar:2.2:runtime
[DEBUG]    org.codehaus.plexus:plexus-container-default:jar:1.5.5:compile
[DEBUG]       org.codehaus.plexus:plexus-classworlds:jar:2.2.2:compile
[DEBUG]       org.apache.xbean:xbean-reflect:jar:3.4:compile
[DEBUG]          log4j:log4j:jar:1.2.12:compile
[DEBUG]          commons-logging:commons-logging-api:jar:1.1:compile
[DEBUG]       com.google.collections:google-collections:jar:1.0:compile
[DEBUG]       junit:junit:jar:3.8.2:compile
[DEBUG] Created new class realm plugin>org.apache.maven.plugins:maven-compiler-plugin:3.1
[DEBUG] Importing foreign packages into class realm plugin>org.apache.maven.plugins:maven-compiler-plugin:3.1
[DEBUG]   Imported:  < maven.api
[DEBUG] Populating class realm plugin>org.apache.maven.plugins:maven-compiler-plugin:3.1
[DEBUG]   Included: org.apache.maven.plugins:maven-compiler-plugin:jar:3.1
[DEBUG]   Included: org.codehaus.plexus:plexus-utils:jar:1.5.1
[DEBUG]   Included: org.apache.maven.shared:maven-shared-utils:jar:0.1
[DEBUG]   Included: com.google.code.findbugs:jsr305:jar:2.0.1
[DEBUG]   Included: org.apache.maven.shared:maven-shared-incremental:jar:1.1
[DEBUG]   Included: org.codehaus.plexus:plexus-component-annotations:jar:1.5.5
[DEBUG]   Included: org.codehaus.plexus:plexus-compiler-api:jar:2.2
[DEBUG]   Included: org.codehaus.plexus:plexus-compiler-manager:jar:2.2
[DEBUG]   Included: org.codehaus.plexus:plexus-compiler-javac:jar:2.2
[DEBUG]   Included: org.apache.xbean:xbean-reflect:jar:3.4
[DEBUG]   Included: log4j:log4j:jar:1.2.12
[DEBUG]   Included: commons-logging:commons-logging-api:jar:1.1
[DEBUG]   Included: com.google.collections:google-collections:jar:1.0
[DEBUG]   Included: junit:junit:jar:3.8.2
[DEBUG] Configuring mojo org.apache.maven.plugins:maven-compiler-plugin:3.1:compile from plugin realm ClassRealm[plugin>org.apache.maven.plugins:maven-compiler-plugin:3.1, parent: sun.misc.Launcher$AppClassLoader@70dea4e]
[DEBUG] Configuring mojo 'org.apache.maven.plugins:maven-compiler-plugin:3.1:compile' with basic configurator -->
[DEBUG]   (f) basedir = E:\git\occ-server\sfa-anw
[DEBUG]   (f) buildDirectory = E:\git\occ-server\sfa-anw\target
[DEBUG]   (f) classpathElements = [E:\git\occ-server\sfa-anw\target\classes]
[DEBUG]   (f) compileSourceRoots = [E:\git\occ-server\sfa-anw\src\main\webapp\js]
[DEBUG]   (f) compilerId = javac
[DEBUG]   (f) debug = true
[DEBUG]   (f) encoding = UTF-8
[DEBUG]   (f) failOnError = true
[DEBUG]   (f) forceJavacCompilerUse = false
[DEBUG]   (f) fork = true
[DEBUG]   (f) generatedSourcesDirectory = E:\git\occ-server\sfa-anw\target\generated-sources\annotations
[DEBUG]   (f) mojoExecution = org.apache.maven.plugins:maven-compiler-plugin:3.1:compile {execution: default-compile}
[DEBUG]   (f) optimize = false
[DEBUG]   (f) outputDirectory = E:\git\occ-server\sfa-anw\target\classes
[DEBUG]   (f) projectArtifact = com.sap.sbo.occ:sfa-anw:war:2.2.0-SNAPSHOT
[DEBUG]   (f) showDeprecation = true
[DEBUG]   (f) showWarnings = true
[DEBUG]   (f) skipMultiThreadWarning = false
[DEBUG]   (f) source = 1.7
[DEBUG]   (f) staleMillis = 0
[DEBUG]   (f) target = 1.7
[DEBUG]   (f) useIncrementalCompilation = true
[DEBUG]   (f) verbose = true
[DEBUG]   (f) mavenSession = org.apache.maven.execution.MavenSession@7cf7aee
[DEBUG]   (f) session = org.apache.maven.execution.MavenSession@7cf7aee
[DEBUG] -- end configuration --
[DEBUG] Using compiler 'javac'.
[DEBUG] Source directories: [E:\git\occ-server\sfa-anw\src\main\webapp\js]
[DEBUG] Classpath: [E:\git\occ-server\sfa-anw\target\classes]
[DEBUG] Output directory: E:\git\occ-server\sfa-anw\target\classes
[DEBUG] CompilerReuseStrategy: reuseCreated
[DEBUG] useIncrementalCompilation enabled
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ sfa-anw ---
[DEBUG] Configuring mojo org.apache.maven.plugins:maven-resources-plugin:2.6:testResources from plugin realm ClassRealm[plugin>org.apache.maven.plugins:maven-resources-plugin:2.6, parent: sun.misc.Launcher$AppClassLoader@70dea4e]
[DEBUG] Configuring mojo 'org.apache.maven.plugins:maven-resources-plugin:2.6:testResources' with basic configurator -->
[DEBUG]   (f) buildFilters = []
[DEBUG]   (f) encoding = UTF-8
[DEBUG]   (f) escapeWindowsPaths = true
[DEBUG]   (s) includeEmptyDirs = false
[DEBUG]   (s) outputDirectory = E:\git\occ-server\sfa-anw\target\test-classes
[DEBUG]   (s) overwrite = false
[DEBUG]   (f) project = MavenProject: com.sap.sbo.occ:sfa-anw:2.2.0-SNAPSHOT @ E:\git\occ-server\sfa-anw\pom.xml
[DEBUG]   (s) resources = [Resource {targetPath: null, filtering: false, FileSet {directory: E:\git\occ-server\sfa-anw\src\test\java, PatternSet [includes: {**/*.properties}, excludes: {}]}}, Resource {targetPath: null, filtering: false, FileSet {directory: E:\git\occ-server\sfa-anw\src\test\resources, PatternSet [includes: {}, excludes: {}]}}]
[DEBUG]   (f) session = org.apache.maven.execution.MavenSession@7cf7aee
[DEBUG]   (f) skip = false
[DEBUG]   (f) supportMultiLineFiltering = false
[DEBUG]   (f) useBuildFilters = true
[DEBUG]   (s) useDefaultDelimiters = true
[DEBUG] -- end configuration --
[DEBUG] properties used {file.encoding.pkg=sun.io, env.ACLOCAL_PATH=C:\Program Files\Git\mingw64\share\aclocal;C:\Program Files\Git\usr\share\aclocal, env.CLCACHE_DIR=C:\ccache, env.SSF_LIBRARY_PATH_64=C:\Program Files\SAP\FrontEnd\SecureLogin\lib\sapcrypto.dll, aopalliance.version=1.0, java.home=C:\Program Files\Java\jdk1.8.0_60\jre, env.HTTPS_PROXY=http://proxy.tyo.sap.corp:8080, groovy.version=2.3.4, maven.plugin.version=3.0.4, tomcat.jdbc.version=7.0.35, env.DISPLAY=needs-to-be-defined, junit.parallel.threadCount=1, classworlds.conf=C:/Program Files/apache-maven-3.3.9/bin/m2.conf, java.endorsed.dirs=C:\Program Files\Java\jdk1.8.0_60\jre\lib\endorsed, env.USERNAME=I305760, mockito.version=1.9.5, gruntTask=CI+build, sun.os.patch.level=Service Pack 1, java.vendor.url=http://java.oracle.com/, env.COMPUTERNAME=PVGD50856145A, compiler.version=3.1, mail.groupId=com.sap.sbo.occ.mail, env.PRINTER=\\cnpvglps0.pvgl.sap.corp\CN38_BW, product.name=SAP Anywhere OCC, poi.version=3.13, java.version=1.8.0_60, env.MAVEN_OPTS= -XX:MaxPermSize=1024m,-XX:PermSize=512m, java.vendor.url.bug=http://bugreport.sun.com/bugreport/, env.USERPROFILE=C:\Users\I305760, env.PLINK_PROTOCOL=ssh, swagger-core-version=1.5.0, sqljdbc.version=4.0, sonar.tests=E:\git\occ-server\sfa-anw/test/specs, user.name=I305760, env.LANG=en_US.UTF-8, sun.io.unicode.encoding=UnicodeLittle, war.version=2.3, eclipselink.weave.plugin.version=1.0.4, sun.jnu.encoding=Cp1252, java.runtime.name=Java(TM) SE Runtime Environment, env.SNC_LIB=C:\Program Files (x86)\SAP\FrontEnd\SecureLogin\lib\sapcrypto.dll, env.LOCALAPPDATA=C:\Users\I305760\AppData\Local, env.WINDOWS_TRACING_LOGFILE=C:\BVTBin\Tests\installpackage\csilogfile.log, env.SSH_ASKPASS=C:/Program Files/Git/mingw64/libexec/git-core/git-gui--askpass, env.ASL.LOG=Destination=file, geronimo.jta.version=1.1.1, env.COMMONPROGRAMW6432=C:\Program Files\Common Files, maven.source.plugin.version=2.2.1, java.specification.name=Java Platform API Specification, aspectj.version=1.6.12, user.timezone=Asia/Shanghai, janino.version=2.6.1, httpcomponent.version=4.4.1, resource.version=2.6, user.script=, path.separator=;, env.MAVEN_CMD_LINE_ARGS= jetty:run -X, deploy.version=2.7, env.PROCESSOR_IDENTIFIER=Intel64 Family 6 Model 58 Stepping 9, GenuineIntel, file.encoding=Cp1252, jar.version=2.4, env.HOME=C:\Users\I305760, sun.java.command=org.codehaus.plexus.classworlds.launcher.Launcher jetty:run -X, velocity.version=1.7, env.MANPATH=C:\Program Files\Git\mingw64\share\man;C:\Program Files\Git\usr\local\man;C:\Program Files\Git\usr\share\man;C:\Program Files\Git\usr\man;C:\Program Files\Git\share\man, env.NUMBER_OF_PROCESSORS=8, commons.beanutils.version=1.8.3, spring.amqp.version=1.1.4.RELEASE, env.APPDATA=C:\Users\I305760\AppData\Roaming, env.WINDIR=C:\WINDOWS, env.HOSTNAME=PVGD50856145A, sonar.cpd.java.minimumLines=8, fasterxml.version=2.4.2, java.io.tmpdir=C:\Users\I305760\AppData\Local\Temp\, user.language=en, ngdbc.version=1.00.68.384084, jmockit.version=1.14, line.separator=
, install.version=2.4, ngdbc.ver=1.97.2, core4j.version=0.5, sonar.surefire.reportsPath=E:\git\occ-server\sfa-anw/target, env.HISTSIZE=30000, env.COMMONPROGRAMFILES=C:\Program Files\Common Files, env.HTTP_PROXY=http://proxy.tyo.sap.corp:8080, java.vm.info=mixed mode, env.DEFLOGDIR=C:\ProgramData\McAfee\DesktopProtection, sun.desktop=windows, java.vm.specification.name=Java Virtual Machine Specification, env.SNC_LIB_64=C:\Program Files\SAP\FrontEnd\SecureLogin\lib\sapcrypto.dll, occ.groupId=com.sap.sbo.occ, project.reporting.outputEncoding=UTF-8, surefire.version=2.18.1, pitest.version=1.1.5, commons.fileupload.version=1.3.1, env.M2_HOME=C:/Program Files/apache-maven-3.3.9, env.PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC, env.USERDOMAIN_ROAMINGPROFILE=GLOBAL, sld.version=2.2.0-SNAPSHOT, env.LOGONSERVER=\\DS3PVG0000, env.PSMODULEPATH=C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\, java.awt.printerjob=sun.awt.windows.WPrinterJob, commons.digester3.version=3.2, mariadb.client.version=1.3.4.1, commons.validator.version=1.4.0, javax.mail.version=1.4.7, env.PUBLIC=C:\Users\Public, ant.version=1.7.0, env.USERDOMAIN=GLOBAL, env.CLCACHE_LOG=1, project.build.resourceEncoding=UTF-8, env.PROCESSOR_LEVEL=6, env.PROGRAMFILES(X86)=C:\Program Files (x86), commons.dbcp.version=1.4, clean.version=2.5, commons.io.version=2.4, os.name=Windows 7, java.specification.vendor=Oracle Corporation, env.TMP=C:\Users\I305760\AppData\Local\Temp, env.TERM=xterm, java.vm.name=Java HotSpot(TM) 64-Bit Server VM, jsp.api.version=2.1, env.OS=Windows_NT, java.library.path=C:\Program Files\Java\jdk1.8.0_60\bin;C:\WINDOWS\Sun\Java\bin;C:\WINDOWS\system32;C:\WINDOWS;C:\Users\I305760\bin;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\usr\local\bin;C:\Program Files\Git\usr\bin;C:\Program Files\Git\usr\bin;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\usr\bin;C:\Users\I305760\bin;C:\Program Files\apache-maven-3.3.9\bin;C:\Ruby22-x64\bin;C:\ProgramData\Oracle\Java\javapath;C:\windows\system32;C:\windows;C:\windows\system32\wbem;C:\python27\scripts;C:\hong\bin\clcache\dist;C:\python27;C:\cygwin64\bin;C:\program files (x86)\microsoft application virtualization client;C:\program files (x86)\open text\view\bin;C:\windows\system32\windowspowershell\v1.0;C:\program files (x86)\microsoft sql server\100\tools\binn;C:\program files\microsoft sql server\100\tools\binn;C:\program files\microsoft sql server\100\dts\binn;C:\program files (x86)\microsoft sql server\100\tools\binn\vsshell\common7\ide;C:\program files (x86)\microsoft visual studio 9.0\common7\ide\privateassemblies;C:\program files (x86)\microsoft sql server\100\dts\binn;C:\program files (x86)\microsoft sql server\90\tools\binn;C:\program files\perforce;C:\Program Files\Java\jdk1.8.0_60\bin;C:\Program Files\apache-maven-3.3.9\bin;C:\p4a\busmb_b1\b1anywhere\dev\c\9.01\sbo\output.x64;C:\p4a\busmb_b1\b1anywhere\dev\c\9.01\sbo\observerjni\bin.x64;C:\program files\nodejs;C:\cygwin64\usr\local\bin;C:\program files (x86)\opentext\viewer\bin;C:\p4a\p_9.01\sbo\observerjni\bin.x64;C:\p4a\p_9.01\sbo\output.x64;C:\program files (x86)\windows kits\8.0\windows performance toolkit;C:\windows\system32\windowspowershell\v1.0;C:\program files\tortoisehg;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\Program Files (x86)\QuickTime\QTSystem;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\Users\I305760\AppData\Roaming\npm;C:\Program Files\Git\usr\bin\vendor_perl;C:\Program Files\Git\usr\bin\core_perl;., env.PROGRAMW6432=C:\Program Files, env.PATH=C:\Users\I305760\bin;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\usr\local\bin;C:\Program Files\Git\usr\bin;C:\Program Files\Git\usr\bin;C:\Program Files\Git\mingw64\bin;C:\Program Files\Git\usr\bin;C:\Users\I305760\bin;C:\Program Files\apache-maven-3.3.9\bin;C:\Ruby22-x64\bin;C:\ProgramData\Oracle\Java\javapath;C:\windows\system32;C:\windows;C:\windows\system32\wbem;C:\python27\scripts;C:\hong\bin\clcache\dist;C:\python27;C:\cygwin64\bin;C:\program files (x86)\microsoft application virtualization client;C:\program files (x86)\open text\view\bin;C:\windows\system32\windowspowershell\v1.0;C:\program files (x86)\microsoft sql server\100\tools\binn;C:\program files\microsoft sql server\100\tools\binn;C:\program files\microsoft sql server\100\dts\binn;C:\program files (x86)\microsoft sql server\100\tools\binn\vsshell\common7\ide;C:\program files (x86)\microsoft visual studio 9.0\common7\ide\privateassemblies;C:\program files (x86)\microsoft sql server\100\dts\binn;C:\program files (x86)\microsoft sql server\90\tools\binn;C:\program files\perforce;C:\Program Files\Java\jdk1.8.0_60\bin;C:\Program Files\apache-maven-3.3.9\bin;C:\p4a\busmb_b1\b1anywhere\dev\c\9.01\sbo\output.x64;C:\p4a\busmb_b1\b1anywhere\dev\c\9.01\sbo\observerjni\bin.x64;C:\program files\nodejs;C:\cygwin64\usr\local\bin;C:\program files (x86)\opentext\viewer\bin;C:\p4a\p_9.01\sbo\observerjni\bin.x64;C:\p4a\p_9.01\sbo\output.x64;C:\program files (x86)\windows kits\8.0\windows performance toolkit;C:\windows\system32\windowspowershell\v1.0;C:\program files\tortoisehg;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\Program Files (x86)\QuickTime\QTSystem;C:\WINDOWS\System32\WindowsPowerShell\v1.0;C:\Users\I305760\AppData\Roaming\npm;C:\Program Files\Git\usr\bin\vendor_perl;C:\Program Files\Git\usr\bin\core_perl, env.INFOPATH=C:\Program Files\Git\usr\local\info;C:\Program Files\Git\usr\share\info;C:\Program Files\Git\usr\info;C:\Program Files\Git\share\info, java.class.version=52.0, env.SHLVL=1, maven.multiModuleProjectDirectory=E:/git/occ-server/sfa-anw, sap.security.version=1.2.2, commons.collections.version=3.2.1, assembly.version=2.4, freemarker.version=2.3.16, env.HOMEDRIVE=C:, env.SYSTEMROOT=C:\WINDOWS, spring.version=4.1.2.RELEASE, env.COMSPEC=C:\WINDOWS\system32\cmd.exe, maven.test.skip=false, sun.boot.library.path=C:\Program Files\Java\jdk1.8.0_60\jre\bin, project.build.sourceEncoding=UTF-8, env.SYSTEMDRIVE=C:, jetty.server.version=7.6.3.v20120416, env.PROCESSOR_REVISION=3a09, sun.management.compiler=HotSpot 64-Bit Tiered Compilers, env.VSEDEFLOGDIR=C:\ProgramData\McAfee\DesktopProtection, user.variant=, java.awt.graphicsenv=sun.awt.Win32GraphicsEnvironment, sonar.language=js, kaptcha.version=2.3.2, feed.groupId=com.sap.sbo.occ.feed, env.HISTFILESIZE=50000, sp.groupId=com.sap.sbo.occ.sp, junit.version=4.11, joda.time.version=2.8.2, env.PROGRAMFILES=C:\Program Files, java.vm.specification.version=1.8, env.HOMELOC=CN_PVGL, env.PROGRAMDATA=C:\ProgramData, slf4j.version=1.7.6, awt.toolkit=sun.awt.windows.WToolkit, powermock.version=1.5, sun.cpu.isalist=amd64, env.MAVEN_PROJECTBASEDIR=E:/git/occ-server/sfa-anw, java.ext.dirs=C:\Program Files\Java\jdk1.8.0_60\jre\lib\ext;C:\WINDOWS\Sun\Java\lib\ext, apache.mime4j.version=0.7.2, os.version=6.1, user.home=C:\Users\I305760, geronimo.jpa.version=1.1, commons.lang.version=2.6, cometd.version=2.4.2, java.vm.vendor=Oracle Corporation, env.PKG_CONFIG_PATH=C:\Program Files\Git\mingw64\lib\pkgconfig;C:\Program Files\Git\mingw64\share\pkgconfig, logback.version=1.0.13, env.JAVA_HOME=C:/Program Files/Java/jdk1.8.0_60, env.USERDNSDOMAIN=GLOBAL.CORP.SAP, user.dir=E:\git\occ-server\sfa-anw, antrun.version=1.7, standard.version=1.1.2, env.COMMONPROGRAMFILES(X86)=C:\Program Files (x86)\Common Files, servlet.api.version=3.0.1, jsoup.version=1.7.2, env.FP_NO_HOST_CHECK=NO, env.PWD=E:/git/occ-server/sfa-anw, commons.email.version=1.3.1, env.SSF_LIBRARY_PATH=C:\Program Files (x86)\SAP\FrontEnd\SecureLogin\lib\sapcrypto.dll, sun.cpu.endian=little, javax.persistence.version=2.1.0, env.ALLUSERSPROFILE=C:\ProgramData, equalsverifier.version=1.1.3, js.src=E:\git\occ-server\sfa-anw/src/main/webapp/js, ngdbc.groupId=com.sap.db.jdbc, env.TMPDIR=C:\Users\I305760\AppData\Local\Temp, sonar.javascript.lcov.reportPath=E:\git\occ-server\sfa-anw/target/coverage/lcov.info, env.PROCESSOR_ARCHITECTURE=AMD64, java.vm.version=25.60-b23, env.HOMEPATH=\Users\I305760, org.slf4j.simpleLogger.defaultLogLevel=debug, java.class.path=C:/Program Files/apache-maven-3.3.9/boot/plexus-classworlds-2.5.2.jar, env.VS100COMNTOOLS=c:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools\, env.UATDATA=C:\WINDOWS\CCM\UATData\D9F8C395-CAB8-491d-B8AC-179A1FE1BE77, javassist.version=3.12.1.GA, os.arch=amd64, maven.build.version=Apache Maven 3.3.9 (bb52d8502b132ec0a5a3f4c09453c07478323dc5; 2015-11-11T00:41:47+08:00), env.WINDOWS_TRACING_FLAGS=3, commons.codec.version=1.6, guava.version=15.0, sun.java.launcher=SUN_STANDARD, ngdbc.artifactId=ngdbc, rabbitmq.version=3.0.1, javamelody.version=1.43.0, jstl.version=1.2, misc.library.version=2.2.0-SNAPSHOT, java.vm.specification.vendor=Oracle Corporation, file.separator=\, gson.version=2.1, java.runtime.version=1.8.0_60-b27, sun.boot.class.path=C:\Program Files\Java\jdk1.8.0_60\jre\lib\resources.jar;C:\Program Files\Java\jdk1.8.0_60\jre\lib\rt.jar;C:\Program Files\Java\jdk1.8.0_60\jre\lib\sunrsasign.jar;C:\Program Files\Java\jdk1.8.0_60\jre\lib\jsse.jar;C:\Program Files\Java\jdk1.8.0_60\jre\lib\jce.jar;C:\Program Files\Java\jdk1.8.0_60\jre\lib\charsets.jar;C:\Program Files\Java\jdk1.8.0_60\jre\lib\jfr.jar;C:\Program Files\Java\jdk1.8.0_60\jre\classes, env.EXEPATH=C:\Program Files\Git, sld.groupId=com.sap.occ.businessone, sap.lps.version=1.0.1, jackson.version=1.9.3, maven.version=3.3.9, spring.retry.version=1.0.2.RELEASE, env.TEMP=C:\Users\I305760\AppData\Local\Temp, user.country=US, env.VS80COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio 8\Common7\Tools\, env.SHELL=C:\Program Files\Git\usr\bin\bash, maven.home=C:\Program Files\apache-maven-3.3.9, eclipselink.version=2.5.2, occ.plugin.version=2.2.0-SNAPSHOT, env.ERLANG_HOME=C:\Program Files\erl5.10.1, cglib.version=2.2, java.vendor=Oracle Corporation, junit.parallel.type=none, occ.component.version=N/A, sonar.sources=E:\git\occ-server\sfa-anw/src/main/webapp, hsqldb.version=2.2.8, java.specification.version=1.8, env.MSYSTEM=MINGW64, sun.arch.data.model=64}
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[DEBUG] resource with targetPath null
directory E:\git\occ-server\sfa-anw\src\test\java
excludes []
includes [**/*.properties]
[INFO] skip non existing resourceDirectory E:\git\occ-server\sfa-anw\src\test\java
[DEBUG] resource with targetPath null
directory E:\git\occ-server\sfa-anw\src\test\resources
excludes []
includes []
[INFO] skip non existing resourceDirectory E:\git\occ-server\sfa-anw\src\test\resources
[DEBUG] no use filter components
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ sfa-anw ---
[DEBUG] Configuring mojo org.apache.maven.plugins:maven-compiler-plugin:3.1:testCompile from plugin realm ClassRealm[plugin>org.apache.maven.plugins:maven-compiler-plugin:3.1, parent: sun.misc.Launcher$AppClassLoader@70dea4e]
[DEBUG] Configuring mojo 'org.apache.maven.plugins:maven-compiler-plugin:3.1:testCompile' with basic configurator -->
[DEBUG]   (f) basedir = E:\git\occ-server\sfa-anw
[DEBUG]   (f) buildDirectory = E:\git\occ-server\sfa-anw\target
[DEBUG]   (f) classpathElements = [E:\git\occ-server\sfa-anw\target\test-classes, E:\git\occ-server\sfa-anw\target\classes, C:\Users\I305760\.m2\repository\junit\junit\4.11\junit-4.11.jar, C:\Users\I305760\.m2\repository\org\hamcrest\hamcrest-core\1.3\hamcrest-core-1.3.jar, C:\Users\I305760\.m2\repository\org\mockito\mockito-all\1.9.5\mockito-all-1.9.5.jar, C:\Users\I305760\.m2\repository\nl\jqno\equalsverifier\equalsverifier\1.1.3\equalsverifier-1.1.3.jar, C:\Users\I305760\.m2\repository\org\objenesis\objenesis\1.1\objenesis-1.1.jar, C:\Users\I305760\.m2\repository\cglib\cglib-nodep\2.2\cglib-nodep-2.2.jar]
[DEBUG]   (f) compileSourceRoots = [E:\git\occ-server\sfa-anw\src\test\java]
[DEBUG]   (f) compilerId = javac
[DEBUG]   (f) debug = true
[DEBUG]   (f) encoding = UTF-8
[DEBUG]   (f) failOnError = true
[DEBUG]   (f) forceJavacCompilerUse = false
[DEBUG]   (f) fork = true
[DEBUG]   (f) generatedTestSourcesDirectory = E:\git\occ-server\sfa-anw\target\generated-test-sources\test-annotations
[DEBUG]   (f) mojoExecution = org.apache.maven.plugins:maven-compiler-plugin:3.1:testCompile {execution: default-testCompile}
[DEBUG]   (f) optimize = false
[DEBUG]   (f) outputDirectory = E:\git\occ-server\sfa-anw\target\test-classes
[DEBUG]   (f) showDeprecation = true
[DEBUG]   (f) showWarnings = true
[DEBUG]   (f) skip = false
[DEBUG]   (f) skipMultiThreadWarning = false
[DEBUG]   (f) source = 1.7
[DEBUG]   (f) staleMillis = 0
[DEBUG]   (f) target = 1.7
[DEBUG]   (f) useIncrementalCompilation = true
[DEBUG]   (f) verbose = true
[DEBUG]   (f) mavenSession = org.apache.maven.execution.MavenSession@7cf7aee
[DEBUG]   (f) session = org.apache.maven.execution.MavenSession@7cf7aee
[DEBUG] -- end configuration --
[DEBUG] Using compiler 'javac'.
[INFO] No sources to compile
[INFO] 
[INFO] <<< jetty-maven-plugin:8.1.16.v20140903:run (default-cli) < test-compile @ sfa-anw <<<
[DEBUG] Dependency collection stats: {ConflictMarker.analyzeTime=0, ConflictMarker.markTime=0, ConflictMarker.nodeCount=7, ConflictIdSorter.graphTime=0, ConflictIdSorter.topsortTime=0, ConflictIdSorter.conflictIdCount=6, ConflictIdSorter.conflictIdCycleCount=0, ConflictResolver.totalTime=1, ConflictResolver.conflictItemCount=6, DefaultDependencyCollector.collectTime=0, DefaultDependencyCollector.transformTime=1}
[DEBUG] com.sap.sbo.occ:sfa-anw:war:2.2.0-SNAPSHOT
[DEBUG]    junit:junit:jar:4.11:test
[DEBUG]       org.hamcrest:hamcrest-core:jar:1.3:test
[DEBUG]    org.mockito:mockito-all:jar:1.9.5:test
[DEBUG]    nl.jqno.equalsverifier:equalsverifier:jar:1.1.3:test
[DEBUG]       org.objenesis:objenesis:jar:1.1:test
[DEBUG]       cglib:cglib-nodep:jar:2.2:test
[INFO] 
[INFO] --- jetty-maven-plugin:8.1.16.v20140903:run (default-cli) @ sfa-anw ---

=== -X 时 输出的信息， end ===
在上面的log中搜索jetty关键字，可以发现maven resolve jetty-maven-plugin 的过程
因为我开发环境下，maven设置mirro
  <mirrors>
    <mirror>
      <id>local nexus</id>
	  <url>http://cnpvgvb1od091.pvgl.xxx.com:8081/nexus/content/groups/allrepository</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>
可能是这个原因造成的

改一下plugin的版本
<plugin>
  <groupId>org.eclipse.jetty</groupId>
  <artifactId>jetty-maven-plugin</artifactId>
  <!--<version>9.3.1-SNAPSHOT</version> -->
  <version>9.3.7.v20160115</version>   --- 这样就ok了
  
### 运行多个web app
在xxx的pom里，这么写
<!-- http://www.eclipse.org/jetty/documentation/current/jetty-maven-plugin.html#running-more-than-one-webapp -->
<plugins>
<plugin>
  <groupId>org.eclipse.jetty</groupId>
  <artifactId>jetty-maven-plugin</artifactId>
  <!--<version>9.3.1-SNAPSHOT</version> -->
  <version>9.3.7.v20160115</version>
  <configuration>
    <scanIntervalSeconds>10</scanIntervalSeconds>
     <webApp>
      <contextPath>/aaa</contextPath>
    </webApp> 
    <contextHandlers>
      <contextHandler implementation="org.eclipse.jetty.maven.plugin.JettyWebAppContext">
        <war>E:\git\xxx-server\app\yyy\target\tmp\yyy-2_2_0-SNAPSHOT_war</war>
        <contextPath>/bbb</contextPath>
      </contextHandler>
    </contextHandlers>
  </configuration>
</plugin>
</plugins>
像上面这么写的话，mvn jetty:run  是可以运行的，  localhost:8080/aaa/login.html也可以访问，但是貌似 xxx app不能访问 yyy app
是<war>E:\git\xxx-server\app\yyy\target\tmp\yyy-2_2_0-SNAPSHOT_war</war> 写错了？？？
<war></war>应该指定一个war包的目录??? 指定了<war>E:\git\xxx-server\app\yyy\target\yyy.war</war>， mvn jetty：run运行就报错了； 应该允许 mvn jetty：run-war ？？？


### 传-D参数
之前在eclipse里用tomcat启动server时，在run configguration里会有一些参数，比如-Denable.redis.session.management=false 
如果用maven jetty plugin，怎么传这个参数呢？
mvn release:prepare -Darguments=-DmyProp=value     ？？？
mvn release:prepare -Darguments="-DmyProp=value -Daaa=bbb"     ？？？
http://mrhaki.blogspot.in/2008/07/passing-d-arguments-along-to-release.html
