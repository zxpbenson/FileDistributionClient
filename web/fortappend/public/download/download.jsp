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
						<td width="30%"><B class="path-font">[ԪĿ¼][�ؼ�����]</B></td>   
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
				  		<strong>δ��װSSO���, ������MAC��ַ���޷���¼�����������ذ�ť��װ���</strong>
				  	</td>
				   </tr>
				   <tr class="edit-title-tr"  ishastate="true" onClick="operation_tr_has(this,1)">
					 <th class="width-150px">
						<input type="button"  value="�����¼����Ʋ鿴�ؼ����أ�" class="tab-bold-button  18x18-button none_trs"/>
					 </th>
					 <th>&nbsp;</th>
				  </tr>
				  <tr>
				  	<td colspan="2">
				  		<!--&nbsp;&nbsp;&nbsp;&nbsp;1�������¼�ؼ���<a href="Setup_sso.zip">����</a>��<br>-->
						&nbsp;&nbsp;&nbsp;&nbsp;<!--2��--->�����¼�ؼ���������Ʋ鿴���߱�׼�棩��<a href="Setup_audit_sso.zip">����</a>��<br>
                        &nbsp;&nbsp;&nbsp;&nbsp;�����¼�ؼ���������Ʋ鿴������jre�棩��<a href="Setup_audit_sso(nojre).zip">����</a>��<br>
                        &nbsp;&nbsp;&nbsp;&nbsp;�ļ��ַ��ͻ��ˡ�<a href="FileDistributionClient.1.0.1.zip">����</a>��
				  	</td>
				  </tr>
				  <tr class="edit-title-tr"  ishastate="true" onClick="operation_tr_has(this,1)">
					 <th class="width-150px">
						<input type="button"  value="˵����" class="tab-bold-button  18x18-button none_trs"/>
					 </th>
					 <th>&nbsp;</th>
				  </tr>
				  <tr>
				  	<td colspan="2">
				  		&nbsp;&nbsp;&nbsp;&nbsp;�������һ��ʹ�ñ�ϵͳ�����������ʲ�������Ա����ƹ���Ա�������ز���װ�����¼�ؼ���������Ʋ鿴���߱�׼�棩��
                        <br>&nbsp;&nbsp;&nbsp;
                        �˿ͻ��˳������ڴ������ʲ��Ŀͻ��˳��򣬲�����û����Ϳ���Ĵ������
                     <br>&nbsp;&nbsp;&nbsp;
                        ������Ļ����Ѿ���װ��java���������ص����¼�ؼ���������Ʋ鿴������jre�棩��
				  	</td>
				  </tr>
				  <tr class="edit-title-tr"  ishastate="true" onClick="operation_tr_has(this,1)">
					 <th class="width-150px">
						<input type="button"  value="ע�⣺" class="tab-bold-button  18x18-button none_trs"/>
					 </th>
					 <th>&nbsp;</th>
				  </tr>
				  <tr>
				  	<td colspan="2">
				  		&nbsp;&nbsp;&nbsp;&nbsp;�����ʹ�ù����У��С�msvcp71.dllδ�ҵ�����������ֵ�ʱ�򣬵�����ش�DLL��<a href="msvcp71.dll">����</a>����
						<br>&nbsp;&nbsp;&nbsp;&nbsp;����С�msvcr71.dllδ�ҵ�����������ֵ�ʱ���������ش�DLL��<a href="msvcr71.dll">����</a>����
						<br>&nbsp;&nbsp;&nbsp;&nbsp;DLL������ɺ󣬷���WINDOWS�ļ��и�Ŀ¼�¡����硾C:\WINDOWS����
				  	</td>
				  </tr>
				  <tr class="edit-title-tr"  ishastate="true" onClick="operation_tr_has(this,1)">
					 <th class="width-150px">
						<input type="button"  value="��֤�����أ�" class="tab-bold-button  18x18-button none_trs"/>
					 </th>
					 <th>&nbsp;</th>
				  </tr>
				  <tr>
				  	<td colspan="2">
						&nbsp;&nbsp;&nbsp;&nbsp;��֤�顾<a href="cart0.cer">����</a>��<br/>
				  	</td>
				  </tr>
				  <tr class="edit-title-tr"  ishastate="true" onClick="operation_tr_has(this,1)">
					 <th class="width-150px">
						<input type="button"  value="VPN�ͻ������أ�" class="tab-bold-button  18x18-button none_trs"/>
					 </th>
					 <th>&nbsp;</th>
				  </tr>
				  <tr>
				  	<td colspan="2">
						&nbsp;&nbsp;&nbsp;&nbsp;VPN�ͻ��ˡ�<a href="SimpVPN_Install.zip">����</a>��<br/>
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
						<td align="left" width="50px"><input type=button value='����' onclick='help_dlg()' class="tab-button 18x18-button yuan_help"></td>
    		 			<td>&nbsp;</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
</body>
