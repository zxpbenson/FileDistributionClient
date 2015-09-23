#!/bin/sh

echo "FortAppend uninstal starting..."

cd /root/

if [ ! -d "/usr/local/fort_append" ]; then
  echo "FortAppend already uninstall."
  exit
fi

service FortServiceServer stop
update-rc.d FortServiceServer stop

rm -rf /bin/FortService
rm -rf /etc/init.d/FortServiceServer

rm -rf /usr/local/tomcat/webapps/aim/dhtmlxTree
rm -rf /usr/local/tomcat/webapps/public/download/FileDistributionClient.1.0.1.zip

mv /usr/local/fort_append/backup/list_account.jsp       /usr/local/tomcat/webapps/aim/asset/
mv /usr/local/fort_append/backup/favorites.jsp          /usr/local/tomcat/webapps/aim/framePages/sso/
mv /usr/local/fort_append/backup/download.jsp           /usr/local/tomcat/webapps/public/download/
mv /usr/local/fort_append/backup/res_auth_list.jsp      /usr/local/tomcat/webapps/aim/framePages/sso/
mv /usr/local/fort_append/backup/tab_view.jsp           /usr/local/tomcat/webapps/aim/framePages/sso/
mv /usr/local/fort_append/backup/portal_list_res_acc.js /usr/local/tomcat/webapps/public/framePages/sso/

if [ -d "/root/fort.append.1.1.0" ]; then
  rm -rf /root/fort.append.1.1.0
fi

TomcatPID=`ps -ef | grep org.apache.catalina.startup.Bootstrap | grep java | awk '{print $2}'`

if [ -z $TomcatPID ] ; then
  echo "Tomcat process not exists."
else
  kill $TomcatPID
  echo "Tomcat process stop successfully. pid=$TomcatPID"
fi

if [ -d "/usr/local/tomcat/work/Catalina" ]; then
  rm -rf /usr/local/tomcat/work/Catalina
  echo "Clean Tomcat cache successfully."
fi

sh /usr/local/tomcat/bin/startup.sh
echo "Tomcat restart successfully."

rm -rf /usr/local/fort_append

echo "FortAppend uninstall successfully."
