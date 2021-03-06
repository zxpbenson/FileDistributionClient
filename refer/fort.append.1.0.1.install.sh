#!/bin/sh

echo "FortAppend install starting..."

cd /root/

if [ ! -f "/root/fort.append.1.0.1.tar" ]; then
  echo "Installer resource not exists."
  exit
fi

if [ -d "/usr/local/fort_append" ]; then
  echo "FortAppend already install."
  exit
fi

mkdir -p /usr/local/fort_append/FortService
mkdir -p /usr/local/fort_append/backup
mkdir -p /usr/local/fort_append/log

if [ -d "/root/fort.append.1.0.1" ]; then
  rm -r fort.append.1.0.1
fi

tar -xvf fort.append.1.0.1.tar
cd fort.append.1.0.1

mv catch_pwd.jar /usr/local/fort_append/FortService/
mv FortService.jar /usr/local/fort_append/FortService/

cat FortService | col > /bin/FortService
chmod +x /bin/FortService

cat StartFortService | col > /bin/StartFortService
chmod +x /bin/StartFortService

cat StopFortService | col > /bin/StopFortService
chmod +x /bin/StopFortService

mv dhtmlxTree /usr/local/tomcat/webapps/aim/

mv /usr/local/tomcat/webapps/aim/asset/list_account.jsp /usr/local/fort_append/backup/
mv list_account.jsp /usr/local/tomcat/webapps/aim/asset/

mv /usr/local/tomcat/webapps/aim/framePages/sso/favorites.jsp /usr/local/fort_append/backup/
mv favorites.jsp /usr/local/tomcat/webapps/aim/framePages/sso/

mv FileDistributionClient.1.0.1.zip /usr/local/tomcat/webapps/public/download/

mv /usr/local/tomcat/webapps/public/download/download.jsp /usr/local/fort_append/backup/
mv download.jsp /usr/local/tomcat/webapps/public/download/

cd ..
rm -r fort.append.1.0.1

#cp /usr/local/tomcat/bin/startup.sh /usr/local/fort_append/backup/startup.sh
#sed -i '/#!\/bin\/sh/a\StartFortService' /usr/local/tomcat/bin/startup.sh

StartFortService

TomcatPID=`ps -ef | grep org.apache.catalina.startup.Bootstrap | grep java | awk '{print $2}'`

if [ -z $TomcatPID ] ; then
  echo "Tomcat process not exists."
else
  kill $TomcatPID
  echo "Tomcat process stop successfully."
fi

if [ -d "/usr/local/tomcat/work/Catalina" ]; then
  rm -r /usr/local/tomcat/work/Catalina
  echo "Clean Tomcat cache successfully."
fi

/usr/local/tomcat/bin/startup.sh
echo "Tomcat restart successfully."

echo "FortAppend install successfully."
