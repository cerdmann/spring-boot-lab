# Developing Applications with Spring Boot and Spring Cloud

## High Level Objectives
* Spring Boot project creation (Lab 1)
* Spring Actuator (Lab 1)
* Learn how to deploy an app to Pivotal Cloud Foundry (Lab 2)
* Setup a continuous delivery pipeline to build your app (Lab 3)
* Continuously delivery your app to Pivotal Cloud Foundry (Lab 4)

## Contents

* [Prerequisites](#prerequisites)
* [Labs](#labs)
  * [Lab 1](#lab-1)
  * [Lab 2](#lab-2)
  * [Lab 3](#lab-3)
  * [Lab 4](#lab-4)
  * [Lab 5](#lab-5)

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

*Modified from original content by [Andrew Ripka](https://github.com/aripka-pivotal)*

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
  * Unzip it into a local directory
1. Start up your favorite IDE and import the project
1. Edit the *build.gradle* file found in the root of the lab directory to replace this code:

  ```
  .
  .
  .
  apply plugin: 'org.springframework.boot'

  version = '0.0.1-SNAPSHOT'
  sourceCompatibility = 1.8
  .
  .
  .
  ```

  with this

  ```
  .
  .
  .
  apply plugin: 'org.springframework.boot'

  jar {
    baseName = 'lab'
    version = '0.0.1-SNAPSHOT'
  }

  sourceCompatibility = 1.8
  .
  .
  .
  ```

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
1. Open up a terminal window or command prompt and navigate to root of the directory you downloaded from Spring Initializer.
1. Depending on your operating system, perform one of the following to start the application:
  * Mac/Linux: ```./gradlew bootRun```
  * Windows: ```gradlew bootRun```
1. The Spring Initializer sets the port to 8080. Therefore, visit: [localhost:8080](http://localhost:8080) to view the output from your endpoint. You should see: ```Greetings from the Spring Boot Starter App!```
1. Now we are going to add Spring Boot Actuator for production-grade monitoring and information:
  * Open up the *build.gradle* file found at the root of your *lab* directory
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
    * Package your application with ```./gradlew clean build```
    * There will be a fat JAR file (a single artifact with bundled dependencies) in the ```./build/libs``` directory.
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
* Know the Concourse URI. It will be referenced in this lab as [Concourse URI]
* Know your Concourse team name. It will be referenced in this lab as [Concourse team]
* Know your Concourse username. It will be referenced in this lab as [Concourse username]
* Know your Concourse users password. It will be referenced in this lab as [Concourse password]

#### Objectives

* Learn how to continuously build an application with Concourse

#### Steps

1. Push our application to Github
  * We need a common location from which to pull our code. Concourse can work with any git repository, but for this workshop, we will be using Github
  * Login to your Github account and create a new repository called ```lab-application```. Initialize it with a README.md and the appropriate license. Do not add a *.gitignore* as the Spring Initializer already created one for us
  * We need to ensure line endings are handled appropriately whether you are using windows, linux, or osx
    * At the root of your *Lab* directory, create a new file called ```.gitattributes```
    * Add the following contents to the file:

      ```
      # Handle line endings automatically for files detected as text
      # and leave all files detected as binary untouched.
      * text=auto

      #
      # The above will handle all files NOT found below
      #
      # These files are text and should be normalized (Convert crlf => lf)
      *.css           text
      *.df            text
      *.htm           text
      *.html          text
      *.java          text
      *.js            text
      *.json          text
      *.jsp           text
      *.jspf          text
      *.jspx          text
      *.properties    text
      *.sh            text
      *.tld           text
      *.txt           text
      *.tag           text
      *.tagx          text
      *.xml           text
      *.yml           text

      # These files are binary and should be left untouched
      # (binary is a macro for -text -diff)
      *.class         binary
      *.dll           binary
      *.ear           binary
      *.gif           binary
      *.ico           binary
      *.jar           binary
      *.jpg           binary
      *.jpeg          binary
      *.png           binary
      *.so            binary
      *.war           binary
      ```

  * In the root of your *lab application*, execute the following command to initialize a git repo: ```git init```
  * We will now associate our local git repo with our newly create Github repo
    * Grab the https or ssh location from the **Clone or download** button on your Github repo page
    * Execute the following command at the root of your *lab* directory:

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

    When prompted, supply the [Concourse username] and [Concourse password]

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
    export TERM=${TERM:-dumb}

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
    ```

    On Windows, we need to ensure that the executable bit is flipped on a few of our files:
    ```
    git update-index --chmod=+x ci/scripts/build.sh
    git update-index --chmod=+x gradlew
    ```

    On either operating system, complete the following steps:

    ```
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
  * Once the *build* box starts blinking, click on it to check on progress
  * Examine the contents of the task steps, by clicking on *git-repo* and *build*
  * **Congratulations**, you've completed your first pipeline task

    ![alt text](screenshots/first-pipeline-successful.png "Pipeline success")

### Lab 4

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

1. Add versioning through Concourse
  * We will be using Github releases in this lab. To do, that we need to update a version number for each build of the application. Eventually this should be retrofitted into the gradle build process for our app, but we will skip that for now
  * We will be using the [semver resource](https://github.com/concourse/semver-resource) to bump our version numbers
  * To use the git driver, we need to setup a special branch of our repository to hold the version number. We will use the steps outlined in this [Stark and Wayne](https://github.com/starkandwayne/concourse-tutorial/tree/master/20_versions_and_buildnumbers#setup-with-a-git-branch) tutorial.
  * At your command line, at the root of your *lab* application, use the following commands to create an orphaned branch to hold the version information:

    ```
    git checkout --orphan version
    git rm --cached -r .
    rm -rf *
    rm .gitignore
    rm -rf .gradle
    rm .gitattributes
    touch README.md
    git add .
    git commit -m "new versioning branch"
    git push origin version
    git checkout master
    ```

  * The semver resource will pull the latest version from our new branch, increment it, and then push the new number back. Each build of the app through the pipeline will result in a new release version saved to Github releases.
  * In order to accomplish this, the semver resource needs a private key to access Github (for the pushes). Please generate an ssh key and save it to your Github account by following [these](https://help.github.com/articles/connecting-to-github-with-ssh/) steps
    * Follow the [Generating a new SSH key...](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) link.
      * Name the key *concourse* and save it in a directory higher than your *lab* application directory
      * Make sure you hit *enter* (no passphrase) when asked to *Enter your passphrase*
      * Skip the *Adding your SSH key to the ssh-agent* part
    * Follow the [Adding a new SSH key to your Github account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)
      * In the Title field, enter *Concourse versioning key* so you know the purpose of the key
    * If necessary, move the keys out of the *lab* application directory. We do not want to check those into a repository. You should have two keys, a public (\*.pub) and a private key
  * Add a semver resource to your ```pipeline.yml```. Update your ```pipeline.yml``` to look like this:

    ```
    resources:
      - name: git-repo
        type: git
        source:
          uri: {{git-repo}}
          branch: {{git-repo-branch}}

      - name: resource-version
        type: semver
        source:
          driver: git
          uri: {{git-repo-ssh-address}}
          branch: version
          file: version
          private_key: {{git-ssh-key}}
          git_user: {{git-user-email}}
          initial_version: 0.0.1

    jobs:
      - name: build
        plan:
          - get: git-repo
            trigger: true
          - get: resource-version
            params: {bump: patch}
          - task: build
            file: git-repo/ci/tasks/build.yml
          - put: resource-version
            params: {file: resource-version/version}
    ```

  * We also need to update our credential file for the new placeholders. In your concourse-config add the following, replacing the brackets with your information:

    ```
    git-repo: [URI-OF-GITHUB-REPO]
    git-repo-branch: master
    git-repo-ssh-address: [SSH-ADDRESS-OF-GITHUB-REPO]
    git-user-email: [PUT-GITHUB-EMAIL-HERE]
    git-ssh-key: |
      -----BEGIN RSA PRIVATE KEY-----
      YOUR
      MULTILINE
      GITHUB
      SSH
      KEY
      HERE
      -----END RSA PRIVATE KEY-----
    ```

    Make sure you copy your private key and indent each line 2 spaces. The SSH address can be found on the main Github page for your repo under *Clone or Download*
1. Push the new pipeline and try out the versioning
  * At your command line, from the root of your *lab* application. Execute the following command:

  ```
  fly -t ci set-pipeline -p lab-application -c ./ci/pipeline.yml -l ../concourse-config.yml
  ```

  * Go to your browser and click on the *build* box. In the upper right hand corner, you will see a **+** sign which will trigger the build. Press it
  * Go to your repo on Github and select the version branch
  * You should see a new file called *version* with 0.0.2 in it
  * Click the build box in Concourse a few times and see the version increment
1. Push your new commits to Github
  * Perform a ```git status```. Make sure your public and private keys have not made it into *lab* directory
  * Push your changes

  ```
  git add .
  git commit -m "Added semver to the pipeline"
  git push origin master
  ```

1. Push artifacts to Github releases
  * To push our artifacts to Github releases, we will use the [github-release](https://github.com/concourse/github-release-resource) resource
  * At the end of this step, we will have a versioned resource that we can push to Pivotal Cloud Foundry
  * This resource uses a Github API access key. Before we proceed we need to create one following [these](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) steps
    * Name your token *Concourse release token*
    * Only grant the token *repo* scope
    * Copy the token to the clipboard and paste it locally outside of the *lab* directory. Once you leave the page, you will not be able to see the token again. If you lose the token, please delete the old one and create a new one
  * Modify your ```pipeline.yml``` file to include the new resource and reference it from the *build* job
    * The *put* task of the job will create the release for you from various files in your *artifact* directory. We will modify the ```build.sh``` after this to ensure those files are created
    * Your ```pipeline.yml``` should look like this:

      ```
      resources:
        - name: git-repo
          type: git
          source:
            uri: {{git-repo}}
            branch: {{git-repo-branch}}

        - name: resource-version
          type: semver
          source:
            driver: git
            uri: {{git-repo-ssh-address}}
            branch: version
            file: version
            private_key: {{git-ssh-key}}
            git_user: {{git-user-email}}
            initial_version: 0.0.1

        - name: gh-release
          type: github-release
          source:
            repository: {{git-repo-name}}
            user: {{git-user}}
            access_token: {{git-access-token}}

      jobs:
        - name: build
          plan:
            - get: git-repo
              trigger: true
            - get: resource-version
              params: {bump: patch}
            - task: build
              file: git-repo/ci/tasks/build.yml
            - put: resource-version
              params: {file: resource-version/version}
            - put: gh-release
              params:
                name: artifact/release_name.txt
                tag: resource-version/number
                body: artifact/release_notes.md
                commitish: artifact/release_commitish.txt
                globs:
                - artifact/lab*.jar
                - artifact/manifest.yml
      ```

    * We need to create some files for the *params* portion of the release push
      * ```release_name.txt``` - The release name
      * ```resource-version/number``` - This will pull in the bumped version number from the semver resource
      * ```release_notes.md``` - We can pass the commit notes to the release and they can act as our release notes
      * ```artifact/release_commitish.txt``` - The commit hash to associate with the release
      * *globs* - The files to push to Github
  * We also need to update our credential file for the new placeholders. In your concourse-config add the following, replacing the brackets with your information:

    ```
    git-repo: [URI-OF-GITHUB-REPO]
    git-repo-branch: master
    git-repo-ssh-address: [SSH-ADDRESS-OF-GITHUB-REPO]
    git-user-email: [PUT-GITHUB-EMAIL-HERE]
    git-ssh-key: |
      -----BEGIN RSA PRIVATE KEY-----
      YOUR
      MULTILINE
      GITHUB
      SSH
      KEY
      HERE
      -----END RSA PRIVATE KEY-----
    git-user: [GITHUB-USER-NAME]
    git-repo-name: [GITHUB-REPO-NAME]
    git-access-token: CREATE-A-GITHUB-ACCESS-TOKEN-AND-ADD-HERE
    ```

  * We need to modify our ```build.sh``` to create the files mentioned above. Modify your ```build.sh``` to look like this:

    ```
    #!/usr/bin/env bash

    set -e
    export TERM=${TERM:-dumb}

    echo "=============================================="
    echo "Beginning build of Spring Boot application"
    echo "$(java -version)"
    echo "$(gradle -version)"
    echo "=============================================="

    cd git-repo

    ./gradlew clean build

    ARTIFACT=$(cd ./build/libs && ls lab*.jar)
    COMMIT=$(git rev-parse HEAD)

    echo $ARTIFACT > ../artifact/release_name.txt
    echo $(git log --format=%B -n 1 $COMMIT) > ../artifact/release_notes.md
    echo $COMMIT > ../artifact/release_commitish.txt

    cp ./build/libs/$ARTIFACT ../artifact
    cp ./manifest.yml ../artifact

    echo "----------------------------------------------"
    echo "Build Complete"
    ls -lah ../artifact
    echo "----------------------------------------------"
    ```

1. Push your new commits to Github
  * Perform a ```git status```. Make sure your api key did not make it into the *lab* directory
  * Push your changes

  ```
  git add .
  git commit -m "Added git-release to the pipeline"
  git push origin master
  ```

1. Push the new pipeline and try out the release
  * At your command line, from the root of your *lab* application. Execute the following command:

  ```
  fly -t ci set-pipeline -p lab-application -c ./ci/pipeline.yml -l ../concourse-config.yml
  ```

  * Go to your browser and click on the *build* box. In the upper right hand corner, you will see a **+** sign which will trigger the build. Press it
  * Go to your repo on Github and click on on *release*
  * You should see a new release with the proper version, pushed to Github from your pipeline
  * Click the build box in Concourse a few times and see new releases appear
1. We need to create a new manifest for the release for our dev process.
  * When we pull the release artifacts back from Github, the JAR will be in the root of the directory. Our current manifest looks for the artifact in the ```buid/libs``` directory. We will create a new manifest called ```concourse-dev-manifest.yml``` and place it in the root of our *lab* directory.
  * Add the following content to the new file:

    ```
    ---
    applications:
    - name: lab-application
      random-route: true
      memory: 512M
      disk: 1G
      instances: 2
      path: ./lab-0.0.1-SNAPSHOT.jar
    ```

    A better solution will be to use a script to modify the manifest based on the name of the artifact. Right now we are keeping the name of the artifact consistent. As soon as we change the name of it, the manifests will break

  * We will replace the ```manifest.yml``` we copied in the ```build.sh``` with the new file. Update your ```build.sh``` with the following:

    ```
    #!/usr/bin/env bash

    set -e
    export TERM=${TERM:-dumb}

    echo "=============================================="
    echo "Beginning build of Spring Boot application"
    echo "$(java -version)"
    echo "$(gradle -version)"
    echo "=============================================="

    cd git-repo

    ./gradlew clean build

    ARTIFACT=$(cd ./build/libs && ls lab*.jar)
    COMMIT=$(git rev-parse HEAD)

    echo $ARTIFACT > ../artifact/release_name.txt
    echo $(git log --format=%B -n 1 $COMMIT) > ../artifact/release_notes.md
    echo $COMMIT > ../artifact/release_commitish.txt

    cp ./build/libs/$ARTIFACT ../artifact
    cp ./concourse-dev-manifest.yml ../artifact

    echo "----------------------------------------------"
    echo "Build Complete"
    ls -lah ../artifact
    echo "----------------------------------------------"
    ```

1. Now we will update the pipeline and introduce the [cf](https://github.com/concourse/cf-resource) resource
  * Add the resource and create a new job which will deploy to the development space
  * We will be using information specified in the setup to this Lab for accessing Pivotal Cloud Foundry
  * When we add the new deploy job, we will trigger it off of a successful build. We want this deploy to happen automatically once the build completes. Our future pushes to stage and prod will be triggered by a click
  * We will also set both jobs up in a serial group so that they will not kick off independently
  * Modify your ```pipeline.yml``` to look like this:

    ```
    resources:
      - name: git-repo
        type: git
        source:
          uri: {{git-repo}}
          branch: {{git-repo-branch}}

      - name: resource-version
        type: semver
        source:
          driver: git
          uri: {{git-repo-ssh-address}}
          branch: version
          file: version
          private_key: {{git-ssh-key}}
          git_user: {{git-user-email}}
          initial_version: 0.0.1

      - name: gh-release
        type: github-release
        source:
          repository: {{git-repo-name}}
          user: {{git-user}}
          access_token: {{git-access-token}}

      - name: deploy-dev
        type: cf
        source:
          api: {{cf-api}}
          username: {{cf-username}}
          password: {{cf-password}}
          organization: {{cf-org}}
          space: {{cf-dev-space}}
          skip_cert_check: true

    jobs:
      - name: build
        serial_groups: [resource-version]
        plan:
          - get: git-repo
            trigger: true
          - get: resource-version
            params: {bump: patch}
          - task: build
            file: git-repo/ci/tasks/build.yml
          - put: resource-version
            params: {file: resource-version/version}
          - put: gh-release
            params:
              name: artifact/release_name.txt
              tag: resource-version/number
              body: artifact/release_notes.md
              commitish: artifact/release_commitish.txt
              globs:
              - artifact/lab*.jar
              - artifact/concourse-dev-manifest.yml

      - name: deploy-dev
        serial_groups: [resource-version]
        plan:
          - aggregate:
            - get: gh-release
              trigger: true
              passed: [build]
          - put: deploy-dev
            params:
              manifest: gh-release/concourse-dev-manifest.yml
              current_app_name: lab-application
              path: gh-release
    ```

  * Update the credential file for the new placeholders. In your concourse-config add the following, replacing the brackets with your information:

    ```
    git-repo: [URI-OF-GITHUB-REPO]
    git-repo-branch: master
    git-repo-ssh-address: [SSH-ADDRESS-OF-GITHUB-REPO]
    git-user-email: [PUT-GITHUB-EMAIL-HERE]
    git-ssh-key: |
      -----BEGIN RSA PRIVATE KEY-----
      YOUR
      MULTILINE
      GITHUB
      SSH
      KEY
      HERE
      -----END RSA PRIVATE KEY-----
    git-user: [GITHUB-USER-NAME]
    git-repo-name: [GITHUB-REPO-NAME]
    git-access-token: [CREATE-A-GITHUB-ACCESS-TOKEN-AND-ADD-HERE]
    cf-api: [PCF-API endpoint]
    cf-username: [PCF CI username]
    cf-password: [PCF CI password]
    cf-org: [CLOUD-FOUNDRY-ORG]
    cf-dev-space: [CLOUD-FOUNDRY-DEV-SPACE-NAME]
    ```

1. Push your new commits to Github
  * Push your changes

  ```
  git add .
  git commit -m "Added push to Pivotal Cloud Foundry to the pipeline"
  git push origin master
  ```

1. Push the new pipeline and try out the push to Pivotal Cloud Foundry
  * At your command line, from the root of your *lab* application. Execute the following command:

  ```
  fly -t ci set-pipeline -p lab-application -c ./ci/pipeline.yml -l ../concourse-config.yml
  ```

  * Go to your browser and click on the *build* box. In the upper right hand corner, you will see a **+** sign which will trigger the build. Press it
  * Go to the Pivotal Cloud Foundry Apps Manager API [PCF Apps Manager endpoint] in your browser. Observe the uptime of your app to see that it has recently been modified. If you are monitoring your app in the Apps Manager while Concourse is deploying it, you might see 2 applications. This is because the *cf* resource will perform a blue-green deploy of your app
  * Try modifying the message your app displays in the *HelloController*. Push the change to Github, and watch the pipeline automatically pick up your change and deploy it.
1. Next we are going to add the steps to deploy to both staging and prod
  * These will not be triggered deploys, but will require you to click on the build in the pipeline to trigger them
  * You could automate this step through slack, or with Pivotal Tracker, but for this workshop, we will rely on manually clicking to push to stage and prod
  * We are also using the same manifests from dev for stage and prod. These could be customized for each environment. You would need to add a copy step for them to your ```build.sh```
  * Modify your ```pipeline.yml``` to look like this:

    ```
    resources:
      - name: git-repo
        type: git
        source:
          uri: {{git-repo}}
          branch: {{git-repo-branch}}

      - name: resource-version
        type: semver
        source:
          driver: git
          uri: {{git-repo-ssh-address}}
          branch: version
          file: version
          private_key: {{git-ssh-key}}
          git_user: {{git-user-email}}
          initial_version: 0.0.1

      - name: gh-release
        type: github-release
        source:
          repository: {{git-repo-name}}
          user: {{git-user}}
          access_token: {{git-access-token}}

      - name: deploy-dev
        type: cf
        source:
          api: {{cf-api}}
          username: {{cf-username}}
          password: {{cf-password}}
          organization: {{cf-org}}
          space: {{cf-dev-space}}
          skip_cert_check: true

      - name: deploy-stage
        type: cf
        source:
          api: {{cf-api}}
          username: {{cf-username}}
          password: {{cf-password}}
          organization: {{cf-org}}
          space: {{cf-stage-space}}
          skip_cert_check: true

      - name: deploy-prod
        type: cf
        source:
          api: {{cf-api}}
          username: {{cf-username}}
          password: {{cf-password}}
          organization: {{cf-org}}
          space: {{cf-prod-space}}
          skip_cert_check: true

    jobs:
      - name: build
        serial_groups: [resource-version]
        plan:
          - get: git-repo
            trigger: true
          - get: resource-version
            params: {bump: patch}
          - task: build
            file: git-repo/ci/tasks/build.yml
          - put: resource-version
            params: {file: resource-version/version}
          - put: gh-release
            params:
              name: artifact/release_name.txt
              tag: resource-version/number
              body: artifact/release_notes.md
              commitish: artifact/release_commitish.txt
              globs:
              - artifact/lab*.jar
              - artifact/concourse-dev-manifest.yml

      - name: deploy-dev
        serial_groups: [resource-version]
        plan:
          - aggregate:
            - get: gh-release
              trigger: true
              passed: [build]
          - put: deploy-dev
            params:
              manifest: gh-release/concourse-dev-manifest.yml
              current_app_name: lab-application
              path: gh-release

      - name: deploy-stage
        serial_groups: [resource-version]
        plan:
          - aggregate:
            - get: gh-release
              passed: [deploy-dev]
          - put: deploy-stage
            params:
              manifest: gh-release/concourse-dev-manifest.yml
              current_app_name: lab-application
              path: gh-release

      - name: deploy-prod
        serial_groups: [resource-version]
        plan:
          - aggregate:
            - get: gh-release
              passed: [deploy-stage]
          - put: deploy-prod
            params:
              manifest: gh-release/concourse-dev-manifest.yml
              current_app_name: lab-application
              path: gh-release
    ```

  * Update the credential file for the new placeholders. In your concourse-config add the following, replacing the brackets with your information:

    ```
    git-repo: [URI-OF-GITHUB-REPO]
    git-repo-branch: master
    git-repo-ssh-address: [SSH-ADDRESS-OF-GITHUB-REPO]
    git-user-email: [PUT-GITHUB-EMAIL-HERE]
    git-ssh-key: |
      -----BEGIN RSA PRIVATE KEY-----
      YOUR
      MULTILINE
      GITHUB
      SSH
      KEY
      HERE
      -----END RSA PRIVATE KEY-----
    git-user: [GITHUB-USER-NAME]
    git-repo-name: [GITHUB-REPO-NAME]
    git-access-token: [CREATE-A-GITHUB-ACCESS-TOKEN-AND-ADD-HERE]
    cf-api: [PCF-API endpoint]
    cf-username: [PCF CI username]
    cf-password: [PCF CI password]
    cf-org: [CLOUD-FOUNDRY-ORG]
    cf-dev-space: [CLOUD-FOUNDRY-DEV-SPACE-NAME]
    cf-stage-space: [CLOUD-FOUNDRY-STAGE-SPACE-NAME]
    cf-prod-space: [CLOUD-FOUNDRY-PROD-SPACE-NAME]
    ```

1. Push your new commits to Github
  * Push your changes

  ```
  git add .
  git commit -m "Added push to Pivotal Cloud Foundry stage and prod to the pipeline"
  git push origin master
  ```

1. Push the new pipeline and try out the push to Pivotal Cloud Foundry
  * At your command line, from the root of your *lab* application. Execute the following command:

  ```
  fly -t ci set-pipeline -p lab-application -c ./ci/pipeline.yml -l ../concourse-config.yml
  ```

  * Trigger your build manually through the web app, or by making a change to your code
  * In the Concourse Web App, you will see a dotted line connecting *deply-dev* and *deploy-stage* and *deploy-prod*. This means that you must manually trigger these jobs
  * Click on the build for *deploy-stage*. Once that is finished, click on the build for *deploy-prod*
  * Go to the Pivotal Cloud Foundry Apps Manager API [PCF Apps Manager endpoint] in your browser. Observe that the app has been pushed to each space/environment. These could easily be different orgs or even completely different foundries. Try out the urls for each
  * **Congratulations**, you now have a complete pipeline to continuously deliver your applications

    ![alt text](screenshots/pipeline-complete.png "Pipeline complete")

### Lab 5

#### Setup

* Ensure you have a [Github](https://github.com) account
* Know the Concourse URI. It will be referenced in this lab as [Concourse URI]
* Know your Concourse team name. It will be referenced in this lab as [Concourse team]
* Know your Concourse username. It will be referenced in this lab as [Concourse username]
* Know your Concourse users password. It will be referenced in this lab as [Concourse password]

#### Objectives

* Learn how to write a continuous test pipeline with error slack notifications

#### Steps

1. Setup a [Slack](https://slack.com/) team.
  * We will be using Slack as a means to notify us of errors in our continuous testing pipeline
  * Enter your email address at https://slack.com and follow the verification steps to complete your setup
    * When prompted, select *Create a new team*
    * Check your email and enter a verification code
    * Enter your personal information and choose a password
    * Under *What will your team use Slack for*, select *Shared interest group* and select a size
    * Enter *Workshop* or another group name and Click *Create Team* once you approve of the urls
    * Click *I Agree*
    * Skip sending invitations
    * Skip the tutorials, and add a new channel called *testing*
1. Now that Slack is all setup, we can add a new pipeline that executes our tests. We want to run our tests continuously (or at least every minute) and do nothing if successful. However, if our test fails, we will use our Slack *testing* channel to receive notifications of the error.

1. Create a [Concourse task](https://concourse.ci/running-tasks.html) for the testing step
  * Using your IDE or a command line editor, create a new file named ```test-api.yml``` in your ```lab/ci/tasks``` directory.
  * As we will be calling our 'API', we want this task to execute in a container that has the Curl command. We can define our *image_resource* with this [Docker image](https://hub.docker.com/r/tutum/curl//)
  * To accomplish the above criteria, use your IDE or a command line editor to add the following to your ```lab/ci/tasks/test-api.yml``` file

    ```
    ---
    platform: linux

    image_resource:
      type: docker-image
      source:
        repository: tutum/curl
        tag: "latest"

    inputs:
      - name: git-repo

    run:
      path: git-repo/ci/scripts/test-api.sh
    ```

1. Create a test script for your application
  * Using your IDE or a command line editor, create a new file named ```test-api.sh``` in your ```lab/ci/scripts``` directory. This script will be executed in a linux container; therefore, we do not provide an equivalent *.bat* file.
  * Enter the following text into the ```build.sh``` file:

    ```
    #!/usr/bin/env bash

    set -e
    export TERM=${TERM:-dumb}

    echo "=============================================="
    echo "Beginning Test of API"
    echo "=============================================="

    RESPONSE_CODE=$(curl --write-out %{http_code} -k --silent --output /dev/null https://lab-application-hyperbarbarous-paperiness.app.52.176.42.10.cf.pcfazure.com/)
    echo "Response Code: "$RESPONSE_CODE

    if [ "$RESPONSE_CODE" -ne "200" ]; then
    	echo "Bad Response Code"
    	exit 1
    fi

    echo "----------------------------------------------"
    echo "Test Complete"
    echo "----------------------------------------------"
    ```

    Please notice the url about mid file. Replace this with the url to your production app that we pushed to prod in Lab 4
  * **Very Important:** We need to set the bash script as executable, before we check it in. (I marked this as very important, because I forgot to do it while writing these steps)
    * At the command line, in the ```lab/ci/scripts``` directory, execute:

      ```
      chmod +x test-api.sh
      ```

1. Create the pipeline for the test and slack notifications
  * Using your IDE or a command line editor, create a new file named ```continuous-testing.yml``` in your ```lab/ci``` directory.
  * Add the following to the ```continuous-testing.yml``` file in ```lab/ci```:

    ```
    resource_types:
      - name: slack-notification
        type: docker-image
        source:
          repository: cfcommunity/slack-notification-resource
          tag: latest

    resources:
      - name: git-repo
        type: git
        source:
          uri: {{git-repo}}
          branch: {{git-repo-branch}}

      - name: 1m
        type: time
        source: {interval: 1m}

      - name: slack-devs
        type: slack-notification
        source:
          url: {{slack-webhook}}

    jobs:
      - name: test-every-1m
        plan:
          - get: 1m
            trigger: true
          - get: git-repo
          - task: test-api
            file: git-repo/ci/tasks/test-api.yml
            on_failure:
              put: slack-devs
              params:
                text: <!here> continuous testing job failed
                channel: "#testing"
                username: concourse
                icon_url: https://avatars1.githubusercontent.com/u/7809479?v=3&s=200
                task: slack-alert
    ```

  * You will notice a resource type which is how we are defining the Slack 3rd-party resource we are using
  * We are also using a time type resource which allows us to trigger jobs at a set interval. For this exercise, we are running our test every minute to check if our production api is available
  * We are using an *on_failure* condition of the *test-api* task to trigger the slack notification

1. Update the credential file
  * We could create a new credential file for this pipeline, but let's just reuse our ```concourse-config.yml``` file.  
  * Follow the instructions [here](https://my.slack.com/services/new/incoming-webhook/) to create an incoming webhook for your Slack testing channel. Please copy the *Webhook Url* and add to the last line of your configuration file:

    ```
    git-repo: [URI-OF-GITHUB-REPO]
    git-repo-branch: master
    git-repo-ssh-address: [SSH-ADDRESS-OF-GITHUB-REPO]
    git-user-email: [PUT-GITHUB-EMAIL-HERE]
    git-ssh-key: |
      -----BEGIN RSA PRIVATE KEY-----
      YOUR
      MULTILINE
      GITHUB
      SSH
      KEY
      HERE
      -----END RSA PRIVATE KEY-----
    git-user: [GITHUB-USER-NAME]
    git-repo-name: [GITHUB-REPO-NAME]
    git-access-token: [CREATE-A-GITHUB-ACCESS-TOKEN-AND-ADD-HERE]
    cf-api: [PCF-API endpoint]
    cf-username: [PCF CI username]
    cf-password: [PCF CI password]
    cf-org: [CLOUD-FOUNDRY-ORG]
    cf-dev-space: [CLOUD-FOUNDRY-DEV-SPACE-NAME]
    cf-stage-space: [CLOUD-FOUNDRY-STAGE-SPACE-NAME]
    cf-prod-space: [CLOUD-FOUNDRY-PROD-SPACE-NAME]
    slack-webhook: https://hooks.slack.com/services/something/something/something
    ```

1. Check in our files
  * Since Concourse will be pulling our tasks and scripts from the git-repo, we need to check everything in
  * At the root of your *lab* application, execute a ```git status``` to ensure our *concourse-config.yml* is not in the files that will be added. Move it to a higher directory if necessary.
  * Again, in the root of your *lab* application, execute the following commands to push your work:

    ```
    git add .
    ```

    On Windows, we need to ensure that the executable bit is flipped on a few of our files:
    ```
    git update-index --chmod=+x ci/scripts/test-api.sh
    ```

    On either operating system, complete the following steps:

    ```
    git commit -m "Added continuous testing pipeline."
    git push origin master
    ```

1. Push your pipeline to Concourse
  * At your command line, navigate to the root of your *lab* application. Use the fly command to push your app

    ```
    fly -t ci set-pipeline -p [name of the pipeline] -c [path to pipeline file] -l [path to credential file]
    ```

    i.e.

    ```
    fly -t ci set-pipeline -p continuous-testing -c ./ci/continuous-testing.yml -l ../concourse-config.yml
    ```

  * You will get prompted to *apply configuration*. Type *y*

1. Navigate in your browser to Concourse and notice that you now have 2 pipelines.
  * Watch the pipeline execute every minute.
  * Login to the Pivotal Cloud Foundry Apps Manager with your ci username and password
  * In the production space, stop your application and wait for the pipeline to fail
  * Check your Slack, testing, channel to see your notification that something is amiss
  * **Congratulations**, you now have the means to continuously test
