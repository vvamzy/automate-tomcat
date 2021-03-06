#!/bin/bash

TOMCAT_9="https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.63/bin/apache-tomcat-9.0.63.tar.gz"
TOMCAT_DIR="/opt/tomcat"
clear
#Checking root/sudo user
if [ "$UID" -ne "0" ]; then
    echo "Run as root user!"
    exit 1
fi

echo ""
##Only use one command from the below.
#Check if java is installed in opt
if [ -d /opt/java ]; then
    echo "Java already Installed"
    else
    echo "Java is not installed!"
	exit 1
fi

sleep 2

echo ""

# #Checking for java as package [redhat specific]
# pkg="java*"
# if rpm -q $pkg
# then
#     echo "$pkg installed"
# else
#     echo "$pkg NOT installed"
#     exit 1
# fi

echo ""

#removing tomcat dir
if [ -d /opt/tomcat ]; then
    echo "deleting dir"
    rm -rf /opt/tomcat
    else
    echo "Fresh Install of Tomcat"
	sleep 1
fi

sleep 2
if [ -e *.tar.gz ]; then
   echo "Installer detected!"
   echo "extracting"
   tar -zvxf *.tar.gz -C /opt
   else
   echo "Downloading Tomcat 9"
   curl -O $TOMCAT_9
   echo "Download Complete"
fi
sleep 2
if [ -d /opt/apache* ]; then
    echo "Renaming Apache to Tomcat"
    sleep 2
    mv /opt/apache* /opt/tomcat
    echo ""
    else
    echo "apache folder doesn't exist!"
	exit 1
fi
sleep 2
#Giving Execute permission to bin files
echo "setting permissions"
chmod -R +x /opt/tomcat/bin/*.sh
sleep 1
#Creating Softlinks
echo "Creating tomcatup"
if [ -e $TOMCAT_DIR/bin/startup.sh ]; then
    echo "Startup.sh already exists!"
    else
    ln -s $TOMCAT_DIR/bin/startup.sh /usr/bin/tomcatup
fi

echo "Creating tomcatdown"
if [ -e $TOMCAT_DIR/bin/shutdown.sh ]; then
    echo "shutdown.sh already exists!"
    else
    ln -s $TOMCAT_DIR/bin/shutdown.sh /usr/bin/tomcatdown
fi

#changing port number [interactive]
sed -i 's/Connector port="8080" /Connector port="8090" /' /opt/tomcat/conf/server.xml

#exposing tomcat to internet
sed -i -e '21,22d' /opt/tomcat/webapps/host-manager/META-INF/context.xml
sed -i -e '21,22d' /opt/tomcat/webapps/manager/META-INF/context.xml

# #deleting last line 
# sed -i '/ </tomcat-users>/d' /opt/tomcat/conf/tomcat-users.xml
# #adding users to tomcat-users.xml
# echo "<role rolename="manager-gui"/>
# 	<role rolename="manager-script"/>
# 	<role rolename="manager-jmx"/>
# 	<role rolename="manager-status"/>
# 	<user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
# 	<user username="deployer" password="deployer" roles="manager-script"/>
# 	<user username="tomcat" password="s3cret" roles="manager-gui"/>
#     </tomcat-users>" >> /opt/tomcat/conf/tomcat-users.xml
echo ""
echo "Installation Complete!"
