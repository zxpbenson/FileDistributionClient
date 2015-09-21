依靠bat文件运行本工程导出生成的jar包FileDistributionClient.jar和依赖包jsch-0.1.51.jar

覆盖之前先对比堡垒机上的favorites.jsp文件和本地的favorites.jsp文件是否存在差异
将web/fortappend目录下的aim文件夹覆盖堡垒主机/usr/local/tomcat/webapps/aim文件夹
即将aim.rar解压缩，将解压缩出来的两个文件夹上传到/usr/local/tomcat/webapps/aim文件夹下

framePages/sso/favorites.jsp文件包含收藏夹树形分类筛选和JS复制批量上传主机资源描述字符串到剪贴板功能
dhtmlxTree是树形组件的第三方支持工具
手工复制的方案改为了程序自动呼起客户端并代填

部署时将FileDistributionClient文件夹放到C盘根目录下

将IE的安全选项工具 -> Internet选项 -> 安全 -> 安全级别所有ActiveX控件的选允许或者提示即可

部署客户机上的Client

部署时客户端的目录结构为

C:\FileDistributionClient
    jre
    FileDistributionClient.jar
    jsch-0.1.51.jar
    log4j-api-2.1.jar
    log4j-core-2.1.jar
    run.bat
    log4j2.xml

修改
C:\FileDistributionClient\jre\lib\security\java.policy
在
  permission java.io.FilePermission "<<ALL FILES>>", "read";
这一行后面加上
  permission java.io.FilePermission "<<ALL FILES>>", "write";
上面是针对64位jre的修改，32位的在java.policy最后一个}之前加上下面这四行，在64位环境做过验证。
    // add by benson, not sure...
  permission java.util.PropertyPermission "user.dir", "read"; 
  permission java.io.FilePermission "<<ALL FILES>>", "read";
  permission java.io.FilePermission "<<ALL FILES>>", "write";
  permission java.security.AllPermission;
---------------------------------------------------------------------
最后的部署方案是制作安装包

首先准备如下内容
C:\FileDistributionClient
    jre32
    jre64
    FileDistributionClient.jar
    jsch-0.1.51.jar
    log4j-api-2.1.jar
    log4j-core-2.1.jar
    run.bat
    log4j2.xml
然后用SmartInstallMaker打开/FileDistributionClient/refer/FileDistributionClient.smm
点击制作安装包
然后将生成的exe程序FileDistributionClient.1.0.1.exe压缩为FileDistributionClient.1.0.1.zip
再准备如下内容
C:\upload
    dhtmlxTree
    catch_pwd.jar
    FortService.jar
    FortServiceClient-1.1.0.jar
    gson-2.2.4.jar
    sqlitejdbc-v056.jar
    fort.append.s3db
    itil.control.cnf
    download.jsp
    favorites.jsp
    list_account.jsp
    FileDistributionClient.1.0.1.zip
    FortService
    StartFortService
    StopFortService
然后以root用户连接到堡垒
mkdir fort.append.1.1.0
将上面准备的文件用winscp传到/root/fort.append.1.1.0目录下
tar -czvf fort.append.1.1.0.tar fort.append.1.1.0 
生成fort.append.1.1.0.tar
最终的交付物品为
fort.append.1.1.0.tar
fort.append.1.1.0.install.sh
fort.append.1.1.0.uninstall.sh

---------------------------------------------------------------------

安装时可能会因为脚本上传改变编码
用下面的命令可以修正此问题
cat fort.append.1.1.0.install.sh | col > fort.append.1.1.0.install.filted.sh
cat fort.append.1.1.0.uninstall.sh | col > fort.append.1.1.0.uninstall.filted.sh
chmod +x fort.append.1.1.0.*.filted.sh

安装
nohup ./fort.append.1.1.0.install.filted.sh > fort.append.install.log 2>&1 &
卸载
nohup ./fort.append.1.1.0.uninstall.filted.sh > fort.append.uninstall.log 2>&1 &

设置IE
工具 -> Internet 选项 -> 安全 -> 自定义级别 -> ActiveX 控件和插件
这个项目下所有内容选启用或者允许
如果下载客户端存在卡在99%不动的情况
工具 -> Internet 选项 -> 高级 -> 检查下载程序的签名
或者用fort.simp.com域名访问就能解决此问题

