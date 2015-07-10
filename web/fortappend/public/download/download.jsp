<%@ page language="java" pageEncoding="GBK"%>

<link rel="stylesheet" type="text/css" href="/public/css/public.css"/>
<link rel="stylesheet" type="text/css" href="/public/css/button.css"/>
<script src="/public/script/stretch_tr.js"></script>
<script type="text/javascript">
function help_dlg(){
	 var url = "/public/help/download/download_help.html";
	 window.showModalDialog("/public/help/download/helpFrame/help_frames.html?help_url="+url,"","dialogHeight: 600px; dialogWidth: 450px;center:yes;resizable:yes;minimize:yes;maximize:yes;");
}
</script>
<body>
<table cellpadding="0" cellspacing="0" class="layout-table">
	<tr>
		<td class="td1">
			<div>
				<table cellpadding="0" cellspacing="0" class="tab">
					<tr> 
						<td width="25px" align="center"><img width="16" height="16" src="/public/img/body/yuan_list.png"/></td>
						<td width="30%"><B class="path-font">[元目录][控件下载]</B></td>   
						<td class="pages-align" align="right">
							&nbsp;
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	<tr>
		<td class="edit-td">
			<div>  
			<form name="form" method="post" >
				<table cellspacing="0" cellpadding="2" class="edit-table">
					<tr>
				  	<td class="font-red" colspan="2">
				  		<strong>未安装SSO插件, 若绑定了MAC地址将无法登录请点击工具下载按钮安装插件</strong>
				  	</td>
				   </tr>
				   <tr class="edit-title-tr"  ishastate="true" onClick="operation_tr_has(this,1)">
					 <th class="width-150px">
						<input type="button"  value="单点登录及审计查看控件下载：" class="tab-bold-button  18x18-button none_trs"/>
					 </th>
					 <th>&nbsp;</th>
				  </tr>
				  <tr>
				  	<td colspan="2">
				  		<!--&nbsp;&nbsp;&nbsp;&nbsp;1、单点登录控件【<a href="Setup_sso.zip">下载</a>】<br>-->
						&nbsp;&nbsp;&nbsp;&nbsp;<!--2、--->单点登录控件（集成审计查看工具标准版）【<a href="Setup_audit_sso.zip">下载</a>】<br>
                        &nbsp;&nbsp;&nbsp;&nbsp;单点登录控件（集成审计查看工具无jre版）【<a href="Setup_audit_sso(nojre).zip">下载</a>】<br>
                        &nbsp;&nbsp;&nbsp;&nbsp;文件分发客户端【<a href="FileDistributionClient.1.0.1.zip">下载</a>】
				  	</td>
				  </tr>
				  <tr class="edit-title-tr"  ishastate="true" onClick="operation_tr_has(this,1)">
					 <th class="width-150px">
						<input type="button"  value="说明：" class="tab-bold-button  18x18-button none_trs"/>
					 </th>
					 <th>&nbsp;</th>
				  </tr>
				  <tr>
				  	<td colspan="2">
				  		&nbsp;&nbsp;&nbsp;&nbsp;如果您第一次使用本系统，并且您是资产操作人员或审计管理员，请下载并安装单点登录控件（集成审计查看工具标准版）。
                        <br>&nbsp;&nbsp;&nbsp;
                        此客户端程序用于打开连接资产的客户端程序，并完成用户名和口令的代填工作。
                     <br>&nbsp;&nbsp;&nbsp;
                        如果您的机器已经安装了java，请您下载单点登录控件（集成审计查看工具无jre版）。
				  	</td>
				  </tr>
				  <tr class="edit-title-tr"  ishastate="true" onClick="operation_tr_has(this,1)">
					 <th class="width-150px">
						<input type="button"  value="注意：" class="tab-bold-button  18x18-button none_trs"/>
					 </th>
					 <th>&nbsp;</th>
				  </tr>
				  <tr>
				  	<td colspan="2">
				  		&nbsp;&nbsp;&nbsp;&nbsp;如果在使用过程中，有【msvcp71.dll未找到】的情况出现的时候，点击下载此DLL【<a href="msvcp71.dll">下载</a>】。
						<br>&nbsp;&nbsp;&nbsp;&nbsp;如果有【msvcr71.dll未找到】的情况出现的时候，请点击下载此DLL【<a href="msvcr71.dll">下载</a>】。
						<br>&nbsp;&nbsp;&nbsp;&nbsp;DLL下载完成后，放在WINDOWS文件夹根目录下。例如【C:\WINDOWS】。
				  	</td>
				  </tr>
				  <tr class="edit-title-tr"  ishastate="true" onClick="operation_tr_has(this,1)">
					 <th class="width-150px">
						<input type="button"  value="根证书下载：" class="tab-bold-button  18x18-button none_trs"/>
					 </th>
					 <th>&nbsp;</th>
				  </tr>
				  <tr>
				  	<td colspan="2">
						&nbsp;&nbsp;&nbsp;&nbsp;根证书【<a href="cart0.cer">下载</a>】<br/>
				  	</td>
				  </tr>
				  <tr class="edit-title-tr"  ishastate="true" onClick="operation_tr_has(this,1)">
					 <th class="width-150px">
						<input type="button"  value="VPN客户端下载：" class="tab-bold-button  18x18-button none_trs"/>
					 </th>
					 <th>&nbsp;</th>
				  </tr>
				  <tr>
				  	<td colspan="2">
						&nbsp;&nbsp;&nbsp;&nbsp;VPN客户端【<a href="SimpVPN_Install.zip">下载</a>】<br/>
				  	</td>
				  </tr>
				</table>
			</form>
			</div>
		</td>
	</tr>
	<tr>
		<td class="td4">
			<div class="div">
				<table class="tab">
					<tr> 
						<td align="left" width="50px"><input type=button value='帮助' onclick='help_dlg()' class="tab-button 18x18-button yuan_help"></td>
    		 			<td>&nbsp;</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
</body>
