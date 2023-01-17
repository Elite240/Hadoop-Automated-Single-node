# HAC-a-1.0
Hadoop Interactive Automated Installation & Confiuration (single-node) script

Note: some of the commands will only run as "root" so its recommended to run the script as "root" user


This script provides interactive and automatic configuration and installation of hadoop

What the script does

  1 - Automatic Installation of Java, Perl, wget

  2 - Automatic Hadoop user creation

  3 - Adds the newly created user to the sudoers

  4 - Configures passwordless ssh login to the new user

  5 - Installs Apache Hadoop 3.3 package 

  6 - Interactive configuration of hadoop 

  7 - Prints verification information text for debugging after the configuration is done


If you experience any bugs or troubles you can message me!!

Tested on: Oracle Linux 8/9, Ubuntu 22.04

To run the script
put both .sh files in a directory preferably home directory 
run " hacs.sh " as root user 
If you are wondering what is the other file, It basically contains the XML configuration of hadoop 
