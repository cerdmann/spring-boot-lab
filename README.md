# Developing Applications with Spring Boot and Spring Cloud

*Modified from original content by [Andrew Ripka](https://github.com/aripka-pivotal)*

## High Level Objectives
* Spring Boot project creation (Lab 1)
* Spring Actuator (Lab 1)
* Learn how to deploy an app to Pivotal Cloud Foundry (Lab 2)
* Setup a continuous delivery pipeline to deliver your app (Lab 3)

## Contents

* [Prerequisites](#prerequisites)
* [Labs](#labs)
  * [Lab 1](#lab-1)
  * [Lab 2](#lab-2)
  * [Lab 3](#lab-3)

## Prerequisites

#### Helpful knowledge:
* Spring Framework/Core
* Spring Web

#### Your local environment and supporting services:
* [Java](http://www.oracle.com/technetwork/java/javase/downloads/index.html) (Be sure to download and install the **JDK**, not the JRE.)
* An IDE
  * [Spring Tool Suite](https://spring.io/tools)
  * [IntelliJ IDEA](https://www.jetbrains.com/idea/)
  * [Atom](https://atom.io/)
* [Gradle](https://gradle.org/gradle-download/)
* [Chrome](https://www.google.com/chrome/)
  * [Postman Plugin](https://www.getpostman.com/docs/introduction)
  * [JSON Formatter Plugin](https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa)
* [Pivotal Cloud Foundry](http://pivotal.io/platform)
  * Instructor Provided
  * [Deploy](http://blog.erds.xyz/technology/install-cloud-foundry-on-azure/) your own platform
  * Sign up with [Pivotal Web Services](http://run.pivotal.io/)
* [Cloud Foundry CLI](https://github.com/cloudfoundry/cli/releases)
* [Concourse](https://concourse.ci/) continuous delivery platform
  * Instructor Provided
  * [Deploy](https://github.com/cerdmann-pivotal/azure-quickstart-templates/tree/master/concourse-ci) your own platform. *Please note that this link points to a fork of the template for Azure. I am waiting for my pull request to be merged.*
* [Github](https://github.com) Account
* [Fly CLI](https://concourse.ci/fly-cli.html) - *CLI for Concourse*

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
1. The Spring Initializer sets the port to 8080. Therefore, visit: [localhost:8080](http://localhost:8080) to view the output from your endpoint. You should see: ```Greetings from the Spring Boot Starter App!```
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
1. Ensure that it compiles and starts and then refresh the [localhost:8080](http://localhost:8080/) page to ensure it still works
1. Visit some of the Actuator endpoints to see the available metrics and information (This is where the JSON Formatter plugin comes in handy)
  * [localhost:8080/info](http://localhost:8080/info)
  * [localhost:8080/health](http://localhost:8080/health)
  * [localhost:8080/metrics](http://localhost:8080/metrics)
  * [localhost:8080/env](http://localhost:8080/env)

### Lab 2

#### Setup

* Ensure you have installed the [Cloud Foundry CLI](https://github.com/cloudfoundry/cli/releases)
* Know the *api* endpoint for the Pivotal Cloud Foundry you are targeting. It will typically look like this: ```https://api.system.pcf.pcfonazure.com```, and will be referenced in this lab as [PCF-API endpoint]
* Know the Pivotal Cloud Foundry *Apps Manager* endpoint to view the status of your apps in your browser. It will typically look like this: ```https://apps.system.pcf.pcfonazure.com```, and will be referenced in this lab as [PCF Apps Manager endpoint]
* Know your Pivotal Cloud Foundry username. It will be referenced in this lab as [PCF username]
* Know your Pivotal Cloud Foundry users password. It will be referenced in this lab as [PCF password]

#### Objectives

* Learn how to deploy an application to Pivotal Cloud Foundry

#### Steps

1. In your terminal, set the PCF-API endpoint in the Cloud Foundry CLI

    ```
    cf api [PCF-API endpoint] --skip-ssl-validation
    ```

    i.e.

    ```
    cf api https://api.system.pcf.pcfonazure.com --skip-ssl-validation
    ```

1. Login to Pivotal Cloud Foundry:

    ```
    cf login
    ```

    Follow the prompts to enter your [PCF username] and [PCF password]. When prompted for your space, select *dev*

1. Login to the Pivotal Cloud Foundry Apps Manager for a GUI view of your applications. In your browser, navigate to: [PCF Apps Manager endpoint]. Enter your [PCF username] and [PCF password] and explore the Apps Manager. Discover:
    * My Account
    * Quotas
    * Orgs and Spaces
    * Marketplace
    * Docs
    * Tools
    * Domain
    * Members
1. Jump back over to the terminal and push your app to Pivotal Cloud Foundry
    * In your terminal navigate to the root of your *lab* application that you setup in [Lab 1](#lab-1)
    * Since we previously ran the application with ```gradlew bootRun```, there will be a fat JAR file (a single artifact with bundled dependencies) in the ```./build/libs``` directory.
    * Execute the push:

      ```
      cf push lab-application --random-route -i 1 -p ./build/libs/lab-0.0.1-SNAPSHOT.jar
      ```

      Note: execute ```cf push``` with no parameters to see what the parameters for cf push mean. Also, we are using the ```--random-route``` parameter. Pivotal Cloud Foundry will create a route for your app based on the domain of the org and the application name. If you are executing this lab in a classroom with other students, then the first student to execute the push will claim the route and everyone else will error out. Random route ensures each student will have a unique route for their app.
1. Test drive your new app
    * Get the route to your app from the output of the ```cf push```:
      ![alt text](screenshots/cf-push-get-route.png "Route to application")
    * Enter the route in your browser. You should see the same result from Lab 1: ```Greetings from the Spring Boot Starter App!```
    * Think about the things that you didn't have to do:
      * You didn't provision a VM
      * You didn't install an application runtime
      * You didn't deploy an application to a VM or container
      * You didn't configure a load balancer
      * You didn't configure ssl termination
      * You didn't configure a firewall
1. Test drive some other *cf* commands
    * ```cf app lab-application```
    * ```cf scale lab-application -i 2```

      The *scale* command scales your application to 2 instances. In addition to the tasks above that you didn't have to worry about, you also didn't have to reconfigure your load balancer and update routes
    * ```cf events lab-application```
    * ```cf logs lab-application --recent```
    * ```cf restart lab-application```
    * ```cf restage lab-application```
1. View your app in the Apps Manager
    * Switch to your browser and refresh the Apps Manager. You should see your application in the dev space. You will notice that many of the options available to you on the command line are available in the gui. Discover:
      * Routes
      * Logs
      * Settings
      * Scaling
      * Environment Variables
      * Settings
      * Metrics via PCF Metrics (link found in the *Status* pane)
1. Create a manifest for your application
    * We create manifests to capture the parameters of ```cf push```. We can have different manifests depending on the environment to which we are pushing, or use it to simplify what we have to enter on the command line
    * In your terminal or IDE create a file at the root of the *lab* application named ```manifest.yml```
    * Add the following contents to the file:

      ```
      ---
      applications:
      - name: lab-application
        random-route: true
        memory: 512M
        disk: 1G
        instances: 2
        path: ./build/libs/lab-0.0.1-SNAPSHOT.jar
      ```

    * At your command line, make sure you are in the root of the *lab* application, and execute ```cf push```. Note that *cf* found the manifest file and didn't require any command line parameters

### Lab 3

#### Setup

* Ensure you have a [Github](https://github.com) account
* Know the *api* endpoint for the Pivotal Cloud Foundry you are targeting. It will typically look like this: ```https://api.system.pcf.pcfonazure.com```, and will be referenced in this lab as [PCF-API endpoint]
* Know the Pivotal Cloud Foundry *Apps Manager* endpoint to view the status of your apps in your browser. It will typically look like this: ```https://apps.system.pcf.pcfonazure.com```, and will be referenced in this lab as [PCF Apps Manager endpoint]
* Know the Concourse URI. It will be referenced in this lab as [Concourse URI]
* Know your Concourse team name. It will be referenced in this lab as [Concourse team]
* Know your Concourse username. It will be referenced in this lab as [Concourse username]
* Know your Concourse users password. It will be referenced in this lab as [Concourse password]
* Know your Pivotal Cloud Foundry CI username. It will be referenced in this lab as [PCF CI username]
* Know your Pivotal Cloud Foundry CI users password. It will be referenced in this lab as [PCF CI password]

#### Objectives

* Learn how to continuously deploy an application to Pivotal Cloud Foundry

#### Steps

1. Push our application to Github
  * We need a common location from which to pull our code. Concourse can work with any git repository, but for this workshop, we will be using Github
  * Login to your Github account and create a new repository called ```lab-application```. Initialize it with a README.md and the appropriate license. Do not add a *.gitignore* as the Spring Initializer already created one for us
  * In the root of your *lab application*, execute the following command to initialize a git repo: ```git init```
  * We will now associate our local git repo with our newly create Github repo
    * Grab the https or ssh location from the **Clone or download** button on your Github repo page
    * Execute the following command at the root of your *lab* folder:

      ```
      git remote add origin [https or ssh location from the last step]
      ```

      i.e.

      ```
      git remote add origin https://github.com/cerdmann/lab-application
      ```

    * Pull the README.md and license file from Github

      ```
      git pull origin master
      ```

      There should be no conflicts to merge.
  * Add our files to the Github repo
    * See the files that you will commit with ```git status```
    * Add the files to your commit with ```git add .``` (You can be more selective. This will add all the files to the commit)
    * Commit the files with ```git commit -m "Initial Spring Boot app commit"```
    * Push the files to Github: ```git push origin master```

1. Download and install the *fly-cli*
  * In your browser, navigate to the [Concourse URI]. You should see something that looks like this:
    ![alt text](screenshots/download-fly.png "Login page to Concourse which shows how to download fly")
  * Click on the appropriate operating system icon to download the *fly-cli* for your particular operating system
  * Install
1. In your browser, login to the Concourse web application. You will find *login* in the upper right hand corner of the screen.
  * Select your [Concourse team] form the list
  * Enter your [Concourse username] and [Concourse password]
  * Click on *login*
1. At your command line, login to the *fly-cli*

    ```
    fly -t ci login  -c [Concourse URI] -n [Concourse team]
    ```

    i.e.

    ```
    fly -t ci login  -c http://23.96.231.205:8080 -n pcf_guru_1
    ```

    We are telling the *fly-cli* to log us in, and set a target environment label (-t) as *ci*. In future commands, we will target this particular login by starting our commands with ```fly -t ci ...```
1. Create a [Concourse task](https://concourse.ci/running-tasks.html) for the build step
  * In the root directory of your *lab* application (we created in this in previous labs), create a ```ci``` directory
  * Under the ```ci``` directory, create two more directories: ```scripts``` and ```tasks```
  * Using your IDE or a command line editor, create a new file named ```build.yml``` in your ```lab/ci/tasks``` directory.
  * We want this task to execute in a container that has both the JDK and Gradle. We can define our *image_resource* with this [Docker image](https://hub.docker.com/r/brianbyers/concourse-gradle/)
  * We need to pull in our assets from the GitHub repo we just created, so we need to define that as an input
  * We will also need to output our artifact, so we need to define an output for this as well
  * To accomplish the above criteria, use your IDE or a command line editor to add the following to your ```lab/ci/tasks/build.yml``` file

    ```
    ---
    platform: linux

    image_resource:
      type: docker-image
      source:
        repository: brianbyers/concourse-gradle
        tag: "latest"

    inputs:
      - name: git-repo

    outputs:
      - name: artifact

    run:
      path: git-repo/ci/scripts/build.sh
    ```

1. Create a build script for your application
  * Using your IDE or a command line editor, create a new file named ```build.sh``` in your ```lab/ci/scripts``` directory. This script will be executed in a linux container; therefore, we do not provide an equivalent *.bat* file.
  * Enter the following text into the ```build.sh``` file:

    ```
    #!/usr/bin/env bash

    set -e

    echo "=============================================="
    echo "Beginning build of Spring Boot application"
    echo "$(java -version)"
    echo "$(gradle -version)"
    echo "=============================================="

    cd git-repo

    ./gradlew clean build

    ARTIFACT=$(cd ./build/libs && ls lab*.jar)

    cp ./build/libs/$ARTIFACT ../artifact
    cp ./manifest.yml ../artifact

    echo "----------------------------------------------"
    echo "Build Complete"
    ls -lah ../artifact
    echo "----------------------------------------------"
    ```

    We are using the *gradlew* command we used earlier to clean and build our application. After that we are grabbing the name of the fat JAR (our build artifact) and copying it and the manifest to our artifact directory.
  * **Very Important:** We need to set the bash script as executable, before we check it in. (I marked this as very imortant, because I forgot to do it while writing these steps)
    * At the command line, in the ```lab/ci/scripts``` directory, execute:

      ```
      chmod +x build.sh
      ```

1. Start the pipeline with the build step
  * Using your IDE or a command line editor, create a new file named ```pipeline.yml``` in your ```lab/ci``` directory.
  * We will need to use the [git resource](https://github.com/concourse/git-resource) and create a job for the build
  * Add the following to the ```pipeline.yml``` file in ```lab/ci```:

    ```
    resources:
      - name: git-repo
        type: git
        source:
          uri: {{git-repo}}
          branch: {{git-repo-branch}}

    jobs:
      - name: build
        plan:
          - get: git-repo
            trigger: true
          - task: build
            file: git-repo/ci/tasks/build.yml
    ```

  * You will notice both *{{git-repo}}* and *{{git-repo-branch}}* are defined as placeholders. We will create an additional credentials file which will hold these values. This enables us to check the pipeline into source control.
  * We are using the *trigger: true* to tell Concourse to check for changes to the repo
1. Create a credential file
  * We do not want this file checked into source control. This first version will not contain any sensitive information, however it will eventually contain ssh keys, api keys, and passwords.
  * Create a file outside of your *lab* application root. We need to provide values for the placeholders in the above ```pipeline.yml```. Name this file: ```concourse-config.yml```
  * Add the following to ```pipeline.yml```; making sure to replace the bracketed text with your repository's https URI:

    ```
    git-repo: [URI-OF-GITHUB-REPO]
    git-repo-branch: master
    ```

    it should look something like this:

    ```
    git-repo: https://github.com/cerdmann/lab-application.git
    git-repo-branch: master
    ```

1. Check in our files
  * Since Concourse will be pulling our tasks and scripts from the git-repo, we need to check everything in
  * At the root of your *lab* application, execute a ```git status``` to ensure our *concourse-config.yml* is not in the files that will be added. Move it to a higher directory if necessary.
  * Again, in the root of your *lab* application, execute the following commands to push your work:

    ```
    git add .
    git commit -m "Added build step to concourse pipeline."
    git push origin master
    ```

1. Push your pipeline to Concourse
  * At your command line, navigate to the root of your *lab* application. Use the fly command to push your app

    ```
    fly -t ci set-pipeline -p [name of the pipeline] -c [path to pipeline file] -l [path to credential file]
    ```

    i.e.

    ```
    fly -t ci set-pipeline -p lab-application -c ./ci/pipeline.yml -l ../concourse-config.yml
    ```
  * You will get prompted to *apply configuration*. Type *y*
1. View pipeline in browser
  * In your browser, refresh the page we logged into previously. You should see the following:

    ![alt text](screenshots/first-pipeline.png "Browser rendering of first pipeline")

1. Run the pipeline
  * When you deploy a pipeline, it will be paused
  * Start by first clicking the hamburger menu in the upper left corner; second, click the play button next to the pipeline:

    ![alt text](screenshots/start-pipeline.png "Click to start the pipeline")

  * The initial pull could take a while as it grabs the Docker image
  * Once the build box starts blinking, click on it to check on progress
