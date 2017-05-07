---
# MUST HAVE BEG
layout: post
disqus_identifier: 20160818-not-define-logback-xml-in-a-lib.md # DO NOT CHANGE THE VALUE ONCE SET
title: Eclipse中的Force Return
# MUST HAVE END

is_short: true      # <!--more-->
subtitle:
tags: 
- vim
date: 2016-08-16 20:36:00
image: 
image_desc: 
---




 
I see framework defines some logback.xml files, but these framework logback.xml files conflict with application’s logback.xml.
 
Here is an example,
Framework has schema-upgrade lib, which is a dependency of sip’s own db upgrade tool. Both of them have their own logback.xml files. And they conflict. Please see below log,
https://media.smec.sap.corp/jenkins/sip/3788/sip/sip-db-ue2rh__sip-db-202.log
 
02:08:12,251 |-WARN in ch.qos.logback.classic.LoggerContext[default] - Resource [logback.xml] occurs multiple times on the classpath.
02:08:12,251 |-WARN in ch.qos.logback.classic.LoggerContext[default] - Resource [logback.xml] occurs at [jar:file:/opt/sip-db/repo/com/sap/sme/anw/schema-upgrade/3.0.13/schema-upgrade-3.0.13.jar!/logback.xml]
02:08:12,251 |-WARN in ch.qos.logback.classic.LoggerContext[default] - Resource [logback.xml] occurs at [jar:file:/opt/sip-db/repo/com/sap/sbo/occ/sip/anw-upgrade/3.0.0-SNAPSHOT/anw-upgrade-3.0.0-SNAPSHOT.jar!/logback.xml]
02:08:12,729 |-INFO in ch.qos.logback.core.joran.spi.ConfigurationWatchList@741a8937 - URL [jar:file:/opt/sip-db/repo/com/sap/sme/anw/schema-upgrade/3.0.13/schema-upgrade-3.0.13.jar!/logback.xml] is not of type file
02:08:13,346 |-INFO in ch.qos.logback.classic.joran.action.ConfigurationAction - debug attribute not set
02:08:13,395 |-INFO in ch.qos.logback.classic.joran.action.ConfigurationAction - Will scan for changes in [jar:file:/opt/sip-db/repo/com/sap/sme/anw/schema-upgrade/3.0.13/schema-upgrade-3.0.13.jar!/logback.xml]
02:08:13,399 |-INFO in ch.qos.logback.classic.joran.action.ConfigurationAction - Setting ReconfigureOnChangeTask scanning period to 2 seconds
02:08:13,483 |-INFO in ch.qos.logback.core.joran.util.ConfigurationWatchListUtil@306e95ec - Adding [jar:file:/opt/sip-db/repo/com/sap/sme/anw/schema-upgrade/3.0.13/schema-upgrade-3.0.13.jar!/logback-env.xml] to configuration watch list.
02:08:13,483 |-INFO in ch.qos.logback.core.joran.spi.ConfigurationWatchList@741a8937 - URL [jar:file:/opt/sip-db/repo/com/sap/sme/anw/schema-upgrade/3.0.13/schema-upgrade-3.0.13.jar!/logback-env.xml] is not of type file
02:08:15,404 |-INFO in ReconfigureOnChangeTask(born:1471486093369) - Empty watch file list. Disabling
02:08:16,188 |-INFO in ch.qos.logback.core.joran.action.AppenderAction - About to instantiate appender of type [ch.qos.logback.core.ConsoleAppender]
02:08:16,192 |-INFO in ch.qos.logback.core.joran.action.AppenderAction - Naming appender as [log.console]
02:08:16,205 |-INFO in ch.qos.logback.core.joran.action.NestedComplexPropertyIA - Assuming default type [ch.qos.logback.classic.encoder.PatternLayoutEncoder] for [encoder] property
02:08:16,543 |-INFO in ch.qos.logback.core.joran.action.AppenderAction - About to instantiate appender of type [com.sap.sbo.common.log.LoggerRollingFileAppender]
02:08:16,684 |-INFO in ch.qos.logback.core.joran.action.AppenderAction - Naming appender as [log.schema.upgrade]
 
 
 
Maybe as a framework library, it’s better to not specify logging configuration (logback.xml), just doing logging in java code seems enough?
 
 

 
 
 
 












[参考文档][1]

[1]: http://help.eclipse.org/neon/index.jsp?topic=%2Forg.eclipse.jdt.doc.user%2Freference%2Fviews%2Fshared%2Fref-forcereturn.htm "Eclipse force return"











