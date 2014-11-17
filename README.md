saltstack-formulas
==================

Saltstack shared formulas.

# oracle-java

Automatically downloads and installs Oracle jdk6 from the WEB-UPD8 repo.  
Tested only on Ubuntu.  Currently supports only JDK6, but easy to 
replicate for JDK7 which is also available from WEB-UPD8.

# wso2

Installs various WSO2 products.  Note that each product must be downloaded to
the `files` directory in order to install, as WSO2 protects downloads via
authentication and provides no repository.
