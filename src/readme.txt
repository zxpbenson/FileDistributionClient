依靠bat文件运行本工程导出生成的jar包FileDistributionClient.jar和依赖包jsch-0.1.51.jar

覆盖之前先对比堡垒机上的favorites.jsp文件和本地的favorites.jsp文件是否存在差异
将web/fortappend目录下的aim文件夹覆盖堡垒主机/usr/local/tomcat/webapps/aim文件夹
即将aim.rar解压缩，将解压缩出来的两个文件夹上传到/usr/local/tomcat/webapps/aim文件夹下

framePages/sso/favorites.jsp文件包含收藏夹树形分类筛选和JS复制批量上传主机资源描述字符串到剪贴板功能
dhtmlxTree是树形组件的第三方支持工具
手工复制的方案改为了程序自动呼起客户端并代填

部署时将FileDistributionClient文件夹放到C盘根目录下

将IE的安全选项工具 -> Internet选项 -> 安全 -> 安全级别所有ActiveX控件的选允许或者提示即可

