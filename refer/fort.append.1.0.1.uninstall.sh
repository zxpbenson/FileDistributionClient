#!/bin/sh

echo "FortAppend uninstal starting..."

cd /root/

if [ ! -d "/usr/local/fort_append" ]; then
  echo "FortAppend already uninstall."
  exit
fi

#sed -i 's/StartFortService//g' /usr/local/tomcat/bin/startup.sh
mv /usr/local/fort_append/backup/startup.sh /usr/local/tomcat/bin/startup.sh

StopFortService

rm /bin/FortService
rm /bin/StartFortService
rm /bin/StopFortService

rm -r /usr/local/tomcat/webapps/aim/dhtmlxTree

mv /usr/local/fort_append/backup/list_account.jsp /usr/local/tomcat/webapps/aim/asset/

mv /usr/local/fort_append/backup/favorites.jsp /usr/local/tomcat/webapps/aim/framePages/sso/

rm /usr/local/tomcat/webapps/public/download/FileDistributionClient.1.0.1.zip

mv /usr/local/fort_append/backup/download.jsp /usr/local/tomcat/webapps/public/download/

if [ -d "/root/fort.append.1.0.1" ]; then
  rm -r /root/fort.append.1.0.1
fi

rm -r /usr/local/fort_append

echo "FortAppend uninstall successfully."
