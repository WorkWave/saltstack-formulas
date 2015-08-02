saltstack-formulas
==================

Saltstack shared formulas for Marathon Data.  

The formulas here follow guidelines provided by saltstack in [Salt Formulas installation and usage instructions](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html) for more information.

# oracle-java

Automatically downloads and installs Oracle jdk (6, 7 or 8) from the WEB-UPD8 repo.  
Tested only on Ubuntu.

Example `top.sls` usage:

    base:
      '*dev':
        - oracle-java.java7

Substitute `java6` or `java8` for other JDK's.

Note: it is possible to install more than one JDK; however, the JAVA_PATH will
be set based on the value of the pillar variable, `oracle-home.java_home`.  

To-do: Add `alternatives` install and configuration

See [web-upd8](http://www.webupd8.org/2012/01/install-oracle-java-jdk-7-in-ubuntu-via.html) for more information.

# go

Downloads and installs the Thoughtworks go server or agent.  The server will be available on the default port of 8143 (e.g., http://mygoserver:8143/go).  The state ensures that java7 is installed as a pre-requisite.

Example usage:

    base:
      'mygoserver':
        - go.server
        - go.agent

See [go](http://www.go.cd/) for more info about go.

# wso2

Installs various WSO2 products.  Each product must be downloaded to
the `files` directory in order to install, as WSO2 protects downloads via
authentication and provides no repository.

