set fdc_account=%1%
set fdc_ip=%2%
set fdc_port=%3%
set fdc_target_path=%4%
set fdc_asset_cn_arr=%5%

set fdc_base_dir=C:\\FileDistributionClient\\
set classpath=.;%fdc_base_dir%\jre\lib\rt.jar;%fdc_base_dir%jsch-0.1.51.jar;%fdc_base_dir%log4j-api-2.1.jar;%fdc_base_dir%log4j-core-2.1.jar;%fdc_base_dir%FileDistributionClient.jar;
set path=.;%fdc_base_dir%;%fdc_base_dir%jre\bin\;

::java  com.fortappend.SwingClient true zhangke 192.168.82.16 22 ~/ $00521B692$1351713120505256$
java  com.fortappend.SwingClient true %fdc_account% %fdc_ip% %fdc_port% %fdc_target_path% %fdc_asset_cn_arr%

pause