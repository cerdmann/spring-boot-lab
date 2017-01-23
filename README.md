# Developing Applications with Spring Boot and Spring Cloud

*Modified from original content by [Andrew Ripka](https://github.com/aripka-pivotal)*

## Contents

* [Prerequisites](#prerequisites)
* [High Level Objectives](#high-level-objectives)
* [Labs](#labs)
  * [Lab 1](#lab-1)

## Prerequisites

Helpful knowledge:
* Spring Framework/Core
* Spring Web

Your local environment:
* [Java](http://www.oracle.com/technetwork/java/javase/downloads/index.html) (Be sure to download and install the **JDK**, not the JRE.)
* An IDE
  * [Spring Tool Suite](https://spring.io/tools)
  * [IntelliJ IDEA](https://www.jetbrains.com/idea/)
  * [Atom](https://atom.io/)
* [Gradle](https://gradle.org/gradle-download/)
* [Chrome](https://www.google.com/chrome/)
  * [Postman Plugin](https://www.getpostman.com/docs/introduction)
  * [JSON Formatter Plugin](https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa)

## High Level Objectives
* Spring Boot project creation
* Spring Actuator

## Labs

### Lab 1

#### Objectives

* Learn how to create a simple Spring Boot application
* Leverage Spring Boot Actuator

#### Steps

1. Use Spring Initializer to generate a project
  * Visit the [Spring Initializer](https://start.spring.io/) site:
    ![alt text](screenshots/start.spring.io.png "start.spring.io homepage")
  * Fill out the form as follows:
    * **Generate a**: Select - *Gradle Project*
    * **with Spring Boot**: Select - *1.4.3*
    * **Group**: *com.example*
    * **Artifact**: *lab*
    * **Search for dependencies**: Type *Web* and hit Enter
  * Click on **Generate Project**. This will generate and download a zip file containing the skeleton of this Spring Boot app.
  * Unzip it into a local folder
1. Start up your favorite IDE and import the *build.gradle* file found in the root of the lab folder
1. Under **Main** -> **java** -> **com.example**, create a new java class named *HelloController*
1. Type or paste in the following code:
  ```java
  package com.example;

  import org.springframework.web.bind.annotation.RestController;
  import org.springframework.web.bind.annotation.RequestMapping;

  @RestController
  public class HelloController {

    @RequestMapping("/")
    public String index() {
      return "Greetings from the Spring Boot Starter App!";
    }
  }
  ```
1. Open up a terminal window or command prompt and navigate to root of the folder you downloaded from Spring Initializer.
1. Depending on your operating system, perform one of the following to start the application:
  * Mac/Linux: ```./gradlew bootRun```
  * Windows: ```gradlew bootRun```
1. The Spring Initializer sets the port to 8080. Therefore, visit: http://localhost:8080/ to view the output from your endpoint. You should see: ```Greetings from the Spring Boot Starter App!```
1. Now we are going to add Spring Boot Actuator for production-grade monitoring and information:
  * Open up the *build.gradle* file found at the root of your *lab* folder
  * Under dependencies, add the Actuator dependency. When you are done, the section should look like this:
    ```
    dependencies {
      compile('org.springframework.boot:spring-boot-starter-web')
      compile('org.springframework.boot:spring-boot-starter-actuator')
      testCompile('org.springframework.boot:spring-boot-starter-test')
    }
    ```
1. Restart your application at the command line using one of the *bootRun* commands in the above step
1. Ensure that it compiles and starts and then refresh the http://localhost:8080/ to ensure it still works
1. Visit some of the Actuator endpoints to see the available metrics and information (This is where the JSON Formatter plugin comes in handy)
  * http://localhost:8080/info
  * http://localhost:8080/health
  * http://localhost:8080/metrics
  * http://localhost:8080/env
