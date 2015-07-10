#!/bin/sh
#tar -czvf fort.append.1.0.1.tar fort.append.1.0.1 
tar -xvf fort.append.1.0.1.tar
cd fort.append.1.0.1
rm -r /usr/local/fort_append
mkdir -p /usr/local/fort_append/FortService
mv catch_pwd.jar /usr/local/fort_append/FortService/
mv FortService.jar /usr/local/fort_append/FortService/
rm /bin/FortService
mv FortService /bin/
chmod +x /bin/FortService
rm -r /usr/local/tomcat/webapps/aim/dhtmlxTree
mv dhtmlxTree /usr/local/tomcat/webapps/aim/
rm /usr/local/tomcat/webapps/aim/asset/list_account.jsp
mv list_account.jsp /usr/local/tomcat/webapps/aim/asset/
rm /usr/local/tomcat/webapps/aim/framePages/sso/favorites.jsp
mv favorites.jsp /usr/local/tomcat/webapps/aim/framePages/sso/
rm /usr/local/tomcat/webapps/public/download/FileDistributionClient.1.0.1.zip
mv FileDistributionClient.1.0.1.zip /usr/local/tomcat/webapps/public/download/
rm /usr/local/tomcat/webapps/public/download/download.jsp
mv download.jsp /usr/local/tomcat/webapps/public/download/
cd ..
rm -r fort.append.1.0.1

