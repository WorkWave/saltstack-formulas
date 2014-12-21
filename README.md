saltstack-formulas
==================

Saltstack shared formulas.  See [Salt Formulas installation and usage instructions](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html) for more information.

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

# wso2

Installs various WSO2 products.  Note that each product must be downloaded to
the `files` directory in order to install, as WSO2 protects downloads via
authentication and provides no repository.
