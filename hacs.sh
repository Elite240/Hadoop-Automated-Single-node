#!/bin/sh

	# Installing wget and java if it is not installed on apt-get package systems

if
  command -v apt-get !=""

then

   sudo apt-get install wget openjdk-8-jdk perl -y

	# Installing wget and java if it is not installed on yum package systems

elif
  command -v yum !=""

then

  sudo yum install wget java-1.8.0-openjdk perl java-1.8.0-openjdk-devel -y
fi


#Hadoop user creation

while true

  do

    if [ $(id -u) -eq 0 ];

      then

          read -p "Enter a hadoop username : " username
          read -s -p "Enter password : " password
  
          egrep "^$username" /etc/passwd >/dev/null

    if [ $? -eq 0 ];

      then

          echo "$username exists!"

  continue

    elif
    
      pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
      
      useradd -m -p "$pass" "$username"

      [ $? -eq 0 ] && echo "$username has been added to system!" || echo "Failed to add a user!"
      
    then

  break

fi

    else
        
      echo "Only root may add a user to the system."    
  	
  continue

fi

done


#adding the new user to the sudoers file
echo "$username ALL=(ALL)  ALL" >> /etc/sudoers


# SSH CONFIGURATION (creaking a directory .ssh, generating a keygen, adding the keygen to the authorized keys file and giving permissions to the created user)
echo "Enabling passwordless SSH connection"

sudo -u $username mkdir -p /home/$username/.ssh

sudo -u $username ssh-keygen -t rsa -P '' -f /home/$username/.ssh/id_rsa

sudo -u $username cat /home/$username/.ssh/id_rsa.pub >> /home/$username/.ssh/authorized_keys

chmod 640 /home/$username/.ssh/authorized_keys

chown $username:$username /home/$username/.ssh/authorized_keys


# HADOOP INSTALLATION & EXTRACTION
read -p "Please Select Hadoop Installation Path: " HADOOP_INS

wget -P $HADOOP_INS https://dlcdn.apache.org/hadoop/common/hadoop-3.3.3/hadoop-3.3.3.tar.gz

sudo tar xzvf $HADOOP_INS/hadoop-3.3.3.tar.gz -C $HADOOP_INS

sudo rm -f $HADOOP_INS/hadoop-3.3.3.tar.gz

sudo mv $HADOOP_INS/hadoop-3.3.3 $HADOOP_INS/hadoop

sudo chown -R $username:$username $HADOOP_INS/hadoop


# Removing any old records of that contains hadoop home inside of the .bashrc file
sed -i '/HADOOP_HOME/d' /home/$username/.bashrc

sed -i '/JAVA_HOME/d' /home/$username/.bashrc

echo -e "Old Hadoop & java records have been removed\nAdding new Java records"

echo "# This is your automated java home" >> /home/$username/.bashrc


# grabbing java home and Adding java home depending on the installation package 

jh=$(readlink -f /usr/bin/javac | sed -e 's/\/bin\/javac//g')

echo "export JAVA_HOME=$jh" >> /home/$username/.bashrc

sed -n 's/# export JAVA_HOME=/export JAVA_HOME=$JAVA_HOME/1g' $HADOOP_INS/hadoop/etc/hadoop/hadoop-env.sh 



# Deleting pre-configuration string from the following files

sed -i '/configuration/d' $HADOOP_INS/hadoop/etc/hadoop/core-site.xml
sed -i '/configuration/d' $HADOOP_INS/hadoop/etc/hadoop/hdfs-site.xml
sed -i '/configuration/d' $HADOOP_INS/hadoop/etc/hadoop/mapred-site.xml
sed -i '/configuration/d' $HADOOP_INS/hadoop/etc/hadoop/yarn-site.xml



while true

  do

# Getting path input from the user and changing the configuration
    read -p "Please Enter your hadoop home (should be $HADOOP_INS/hadoop): " HADOOP_HOME
    echo "This is your current hadoop home path $HADOOP_HOME"

    yn="w"

    while [ $yn = "w" ]

    do

# Confirmation of input from the user
        read -p "Would you like to continue with the following Hadoop home path? (y/n) " yn

        if [ $yn != "y" ] && [ $yn != "Y" ] && [ $yn != "n" ] && [ $yn != "N" ]

        then

            echo "You Entered a Wrong Choice."
            yn="w"
        fi

     done

# Cases when the user input is Yes or No if yes it will write config to file if no it will ask for another path
    case $yn in

        [Yy]*) echo -e "# HADOOP AUTOMATIC CONFIGURATION USING OMAR'S SCRIPT" >> /home/$username/.bashrc ;

                echo -e "export HADOOP_HOME=$HADOOP_HOME" >> /home/$username/.bashrc ;

                echo -e "export HADOOP_INSTALL=\$HADOOP_HOME\nexport HADOOP_MAPRED_HOME=\$HADOOP_HOME\nexport HADOOP_COMMON_HOME=\$HADOOP_HOME\nexport HADOOP_HDFS_HOME=\$HADOOP_HOME\nexport YARN_HOME=\$HADOOP_HOME\nexport HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native\nexport PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin\nexport HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib/native\"" >> /home/$username/.bashrc 
                
                break;;

        [Nn]*) continue;;

      esac
  done
  
  
  
source hxc.sh




#Crating a namenode folder & datanode folder  
sudo -u $username mkdir -p {$HADOOP_HOME/data/namenode,$HADOOP_HOME/data/datanode}



# Configuration and installation output display 
source /home/$username/.bashrc  

hdfs namenode -format

sudo chown -R $username:$username $HADOOP_HOME


echo -e "\nyour Java Version is: \n" 
su - $username -c "java -version"


echo -e "\nYour Hadoop version is: \n" 
su - $username -c "hadoop version"


echo -e "\nYour Hadoop home is: \n"
sudo -u $username echo $HADOOP_HOME

su - $username -c "start-dfs.sh && start-yarn.sh"


echo "You can now use hadoop peacefully with your newly created hadoop user, enjoy your automated configuration"
#switching to the user so u can operate
su - $username