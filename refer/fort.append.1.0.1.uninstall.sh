#!/bin/sh

echo "FortAppend uninstal starting..."

cd /root/

if [ ! -d "/usr/local/fort_append" ]; then
  echo "FortAppend already uninstall."
  exit
fi

rm /bin/FortService

rm -r /usr/local/tomcat/webapps/aim/dhtmlxTree

mv /usr/local/fort_append/backup/list_account.jsp /usr/local/tomcat/webapps/aim/asset/

mv /usr/local/fort_append/backup/favorites.jsp /usr/local/tomcat/webapps/aim/framePages/sso/

rm /usr/local/tomcat/webapps/public/download/FileDistributionClient.1.0.1.zip

mv /usr/local/fort_append/backup/download.jsp /usr/local/tomcat/webapps/public/download/

rm -r /usr/local/fort_append

echo "FortAppend uninstall successfully."
