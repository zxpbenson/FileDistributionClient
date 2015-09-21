#!/bin/sh

echo "FortAppend install starting..."

cd /root/

if [ ! -f "/root/fort.append.1.1.0.tar" ]; then
  echo "Installer resource not exists."
  exit
fi

if [ -d "/usr/local/fort_append" ]; then
  echo "FortAppend already install."
  exit
fi

mkdir -p /usr/local/fort_append/bin
mkdir -p /usr/local/fort_append/lib
mkdir -p /usr/local/fort_append/backup
mkdir -p /usr/local/fort_append/log
mkdir -p /usr/local/fort_append/conf
mkdir -p /usr/local/fort_append/db

if [ -d "/root/fort.append.1.1.0" ]; then
  rm -rf fort.append.1.1.0
fi	

tar -xvf fort.append.1.1.0.tar
cd fort.append.1.1.0

#mv catch_pwd.jar /usr/local/fort_append/FortService/
#mv FortService.jar /usr/local/fort_append/FortService/
mv *.jar /usr/local/fort_append/lib/

mv fort.append.s3db /usr/local/fort_append/db/
mv itil.control.cnf /usr/local/fort_append/conf/

cat FortService | col > /bin/FortService
chmod +x /bin/FortService

cat StartFortService | col > /usr/local/fort_append/bin/StartFortService
chmod +x /usr/local/fort_append/bin/StartFortService

cat StopFortService | col > /usr/local/fort_append/bin/StopFortService
chmod +x /usr/local/fort_append/bin/StopFortService

cat StatusFortService | col > /usr/local/fort_append/bin/StatusFortService
chmod +x /usr/local/fort_append/bin/StatusFortService

cat FortServiceServer | col > /etc/init.d/FortServiceServer
chmod +x /etc/init.d/FortServiceServer

mv dhtmlxTree /usr/local/tomcat/webapps/aim/

mv /usr/local/tomcat/webapps/aim/asset/list_account.jsp /usr/local/fort_append/backup/
mv list_account.jsp /usr/local/tomcat/webapps/aim/asset/

mv /usr/local/tomcat/webapps/aim/framePages/sso/favorites.jsp /usr/local/fort_append/backup/
mv favorites.jsp /usr/local/tomcat/webapps/aim/framePages/sso/

mv FileDistributionClient.1.0.1.zip /usr/local/tomcat/webapps/public/download/

mv /usr/local/tomcat/webapps/public/download/download.jsp /usr/local/fort_append/backup/
mv download.jsp /usr/local/tomcat/webapps/public/download/

cd ..
rm -rf fort.append.1.1.0

#cp /usr/local/tomcat/bin/startup.sh /usr/local/fort_append/backup/startup.sh
#cp /usr/local/tomcat/bin/catalina.sh /usr/local/fort_append/backup/catalina.sh
#sed -i '/#!\/bin\/sh/a\StartFortService' /usr/local/tomcat/bin/catalina.sh

# *** install rccron auto start StartFortService ***
update-rc.d FortServiceServer start
#StartFortService
service FortServiceServer start

TomcatPID=`ps -ef | grep org.apache.catalina.startup.Bootstrap | grep java | awk '{print $2}'`

if [ -z $TomcatPID ] ; then
  echo "Tomcat process not exists."
else
  kill $TomcatPID
  echo "Tomcat process stop successfully."
fi

if [ -d "/usr/local/tomcat/work/Catalina" ]; then
  rm -rf /usr/local/tomcat/work/Catalina
  echo "Clean Tomcat cache successfully."
fi

/usr/local/tomcat/bin/startup.sh
echo "Tomcat restart successfully."

echo "FortAppend install successfully."
