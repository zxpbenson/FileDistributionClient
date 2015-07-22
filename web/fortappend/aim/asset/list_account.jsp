<%@ page language="java" pageEncoding="GBK"%>
<%@ page import="com.simp.util.paging.*"%>
<%@ page import="com.simp.business.asset.Account"%>
<%@ page import="com.simp.business.asset.Asset"%>
<%@ page import="com.simp.business.asset.AssetEnv"%>
<%@ page import="com.simp.action.ProxyUser"%>
<%@ page import="com.simp.util.string.StringUtils"%>

<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.BufferedWriter"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="java.io.OutputStreamWriter"%>
<%@ page import="java.net.Socket"%>
<%@ page import="java.net.UnknownHostException"%>
<%@ page import="java.util.concurrent.Executor"%>
<%@ page import="java.util.concurrent.Executors"%>
<%//@ page import="java.util.concurrent.atomic.AtomicLong"%>

<%!

class FortServiceApiTestWorker implements Runnable{
    //private static AtomicLong counter = new AtomicLong(1);
    //private long id = counter.getAndIncrement();
    private long id = System.currentTimeMillis();
    private String ip;
    private int port;
    private String cmd;
    private Socket socket;
    private InputStream is;
    private InputStreamReader isr;
    private BufferedReader br;
    private OutputStream os;
    private OutputStreamWriter osw;
    private BufferedWriter bw;
    private String response;
    
    public FortServiceApiTestWorker(String ip, int port, String cmd){
        this.ip = ip;
        this.port = port;
        this.cmd = cmd;
    }
    
    public void run(){
        try {
            openIO();
            work();
        } catch (IOException e) {
            e.printStackTrace();
        }  catch (Exception e){
            e.printStackTrace();
        } finally {
            closeIO();
        }
    }
    
    private void openIO() throws UnknownHostException, IOException{
        socket = new Socket(ip, port);
        
        is = socket.getInputStream();
        isr = new InputStreamReader(is);
        br = new BufferedReader(isr);
        
        os = socket.getOutputStream();
        osw = new OutputStreamWriter(os);
        bw = new BufferedWriter(osw);
    }
    
    private void closeIO(){
        if(br != null)try{br.close();}catch(IOException e){}
        if(isr != null)try{isr.close();}catch(IOException e){}
        if(is != null)try{is.close();}catch(IOException e){}
        
        if(bw != null)try{bw.close();}catch(IOException e){}
        if(osw != null)try{osw.close();}catch(IOException e){}
        if(os != null)try{os.close();}catch(IOException e){}
            
        try {
            socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    private void work() throws IOException{
        System.out.println("FortServiceApiTestWorker " + id + " send request : " + cmd);
        request(cmd);
        response = br.readLine();
        System.out.println("FortServiceApiTestWorker " + id + " get response : " + response);
    }

    private void request(String request) throws IOException{
        bw.write(request);
        bw.newLine();
        bw.flush();
    }

    public String getResponse() {
        return response;
    }
    
}

%>

<%@taglib uri="SimpTags" prefix="simp"%>
<% 
      String assetType = ProxyUser.getProxyUser(request).getCurAssetType();
      String assetRdn = ProxyUser.getProxyUser(request).getCurAssetRdn();
      boolean modifyStatu = ProxyUser.getProxyUser(request).isDataProcStatusModify();
%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="/public/css/public.css">
<link rel="stylesheet" type="text/css" href="/public/css/button.css">
<script src="/public/script/body_div.js"></script>
<script src="/public/script/tab_drag.js"></script>
<script src="/public/script/public_body.js"></script>
<script src="<simp:PathTag s='/public/script/top.js'/>"></script>
<script src="/public/js/LockScreen.js"></script>
<script LANGUAGE="JavaScript" src="/public/js/XmlHttp.js"></script>
<script type="text/javascript" src="/public/js/CheckIds.js"></script>
<title>账号列表</title>
<script type="text/javascript">
	function query(){
		queryForm.action='<simp:PathTag s="/asset/listAccount.do?method=list"/>';
		lock_screen();
		queryForm.submit();
	}
	
	function quick_query() {
		if(event.keyCode==13){
			query();
		}
	}
	function del_all_btn(){
		var deleteStore = document.getElementById("deleteStore");
		var delAllTd = document.getElementById("delAll").parentNode;
		if(!deleteStore.checked){
			delAllTd.style.display="none";
			return;
		}
		delAllTd.style.display="block";
	}
	function del_all(){
		
		if(!window.confirm('确认要删除当前资源下所有账号吗?')){
            return;
        }
        
		lock_screen();
		updateForm.action='<simp:PathTag s="/asset/listAccount.do?method=delete_all"/>';
		updateForm.submit();
	}
    function del(btn,type){  
    	if (!is_list_ckb_selected()) {
			alert("请选择需要删除的账号.");
			return;
		}
		if(type!=null && type=="dbinner"){
			delInner(btn);
			return;
		}
		
    	var msg;
    	if(type=="webapp"){
    	
    		msg = "是否确认删除本地存储的资源账号？";
    	}else{
    		var ds = document.all("deleteStore");
	    	if (ds.checked == true) {
	    		msg = "是否确认删除本地存储的资源账号？";
	    	} else {
	    		msg = "[提示]:如果未选择[仅删除存储]选项，将会删除本地存储的资源账号同时，关联删除资源本身的资源账号。\n\n如果不需要删除资源账号，请选择[仅删除存储]选项。\n\n是否确认删除?"
	    	}
    	}

   	 	if(!window.confirm(msg)){
            return;
        }
        lock_screen();
		btn.form.action="?method=delete";
		btn.form.submit();
	}	
	
	function delInner(btn) {
		var ds = document.all("deleteStore");
		ds.checked = true;
	   	if(!window.confirm('是否确认删除本地存储的资源账号？')){
            return;
        }
		lock_screen();
		btn.form.action="?method=delete";
		btn.form.submit();
	}
	function connectAsset(btn,type){
		if (type=='radiusNet' || type=='localNet') {
			alert('网络设备账号不能提供双向同步功能');
			return;
		}
		
	   if(!window.confirm('双向同步将写入本地账号，同时收集目标资源的新账号！确认要同步资源吗?')){
             return;
        }
        lock_screen();
		btn.form.action="?method=connectAsset";
		btn.form.submit();
	}
	function add(btn,type){
		if (type=='radiusNet') {
			alert('网络设备账号不能提供自定义添加功能');
			return;
		}
	    btn.form.action="<simp:PathTag s='/asset/"+type+"/dataAccount.do?method=addIni'/>";
		btn.form.submit();
	}
	function edit(rdn,type){
	    //document.updateForm.action="<simp:PathTag s='/asset/"+type+"/dataAccount.do?method=modifyIni&rdn='/>"+rdn;
		document.updateForm.action="<simp:PathTag s='/asset/"+type+"/dataAccount.do?method=modifyIni'/>";
		document.updateForm.rdn.value=rdn;
		//alert(document.updateForm.rdn);
		document.updateForm.submit();
	}
	
	function back(){
		var _assetRdn= '<%=assetRdn%>';		
		var _assetType= '<%=assetType%>';
		//var _modifyStatu = <%=modifyStatu%>;
	
		if(_assetRdn!=''){
			//alert("rdn="+_assetRdn);
			//alert("type="+_assetType);
			location  = "<simp:PathTag s='/asset/"+_assetType+"/data.do?method=modifyIni&rdn='/>"+_assetRdn;
		}else{
			location = '<simp:PathTag s="/asset/list.do?method=back"/>';
		}
	}	
	function enableAllCbk(ckbEn){
		for(var i=0;i<document.all.length;i++){			
			var ckb=document.all(i);	
			if(ckb.tagName=="INPUT" 
					&& ckb.type=="checkbox" 
					&& ckb.name=="list_ckb"
					){				
				if(ckb.account_type=="share_managed" && ckb.checked && ckbEn.checked==false){
					ckb.click();
				}
				
				if(ckb.account_type=="share_managed"){
					ckb.disabled=!ckbEn.checked;
				}
																							
			}			
		}
	}
	
	function pull() {
	    if(!window.confirm('拉取操作，会将系统接管的目标资源上的账号信息覆盖掉系统存储在本地的资源账号信息。如果系统接管资源上存在多余账号，会一同拉取到系统中。\n\n请确认是否拉取？')){
             return;
        }
		updateForm.action='<simp:PathTag s="/asset/listAccount.do?method=pull"/>';
		lock_screen();
		updateForm.submit();
	}
	
	function push() {
	    if(!window.confirm('推送操作，会将系统内资源账号信息覆盖掉接管资源上的账号信息。如果系统内部存在多余账号，会一同推送到目标资源。\n\n请确认是否推送？')){
             return;
        }
		updateForm.action='<simp:PathTag s="/asset/listAccount.do?method=push"/>';
		lock_screen();
		updateForm.submit();
	}
	function open_log(){
		window.open('<simp:PathTag s="/asset/account_audit.do?method=listIni"/>',"_blank","scrollbars=no,status=yes,resizable=yes,top=0,left=0,width="+(screen.availWidth-5)+",height="+(screen.availHeight-5)+"");
	}
	function open_refer_log(rdn, asset, uname){
		var display =asset + '[' + uname + ']';
		window.open('<simp:PathTag s="/asset/account_refer_audit.do?method=list_refer_log"/>&rdn='+rdn +'&display='+display,"_blank","scrollbars=no,status=yes,resizable=yes,top=0,left=0,width="+(screen.availWidth-5)+",height="+(screen.availHeight-5)+"");
		}
	function export_asste_account() {
		document.exportform.action='<simp:PathTag s="/asset/export_account.jsp"/>';
		document.exportform.submit(); 
		rm_menu_div();
	}	
	function show_wizard(obj, content_div, width, height, div_style, div_auto, callback) {
		export_src = callback;
		menu_div(obj, content_div, width, height, div_style, div_auto);
	}
	
	function import_wizard(){
		var close_status = window.showModalDialog('<simp:PathTag s="/asset/account_wizard/wizard_frames.jsp"/>',"","dialogHeight: 360px; dialogWidth: 600px;center:yes;resizable:no;");
		
		//通知清理内存中的向导对象
		var xmlHttp=new XmlHttpConstruct('<simp:PathTag s="/asset/account_import_wizard.do"/>');		
		var method="method=cancel";
		xmlHttp.send(method);		 
	}
	
	function help_dlg(){
		 var url = "/public/help/account/account_list.html";
		 window.showModalDialog("/public/help/account/helpFrame/help_frames.html?help_url="+url,"","dialogHeight: 600px; dialogWidth: 450px;center:yes;resizable:yes;minimize:yes;maximize:yes;");
	}
	
	function show_authorization(type, rdn, name, ip) {
		document.updateForm.action="<simp:PathTag s='/asset/"+type+"/dataAccount.do?method=show_authorizations&rdn='/>"+rdn + "&name="+name+"&ip=" + ip;
		document.updateForm.submit();
	}
	function print_envelope(){
		if (!is_list_ckb_selected()) {
			alert("请选择需要打印的账号.");
			return;
		}
		
        updateForm.action="<simp:PathTag s='/sys/services/envelope/envelope_print.jsp?type=account'/>";
        updateForm.target = "_blank";
        updateForm.submit();
        updateForm.target = "";
        
	}
</script>
<jsp:include flush="true" page="/publicPage/includepage/message.jsp"></jsp:include>
</head>
<%PagingList list=(PagingList)request.getAttribute("SimpBOList");
	String name = "";
	String ip = "";
	Asset a = null;
		if (list != null) {
			a = (Asset)list.getObj();
			if (a != null) {
				name = a.getName();
				ip = a.getIp();
			}
		}

	String opt_obj_title = "";
	 if (a != null && a.getId() != null) {
	 	opt_obj_title = " "+AssetEnv.typeMap.get(a.getType()) + "资源 " +a.getName()+ " ( " + a.getIp() + " ) ";
	 }
 %>
 
<%
String userId = ProxyUser.getProxyUser(request).getId();
System.out.println("====>>>userId="+userId+";assetRdn="+a.getId());
//List[] echoListArr = new Cmd().execCmdsInProcess(new String[]{"/bin/sh"}, null, null, new String[]{"FortService Role " + userId + " " + a.getId() + " true", "exit"}, 1);
//String echo = (String)echoListArr[0].get(0);

FortServiceApiTestWorker worker = new FortServiceApiTestWorker("127.0.0.1", 9777, "Role " + userId + " " + a.getId() + " true");
worker.run();
String echo = worker.getResponse();
if(echo == null)echo = "";
%>

<body onload="del_all_btn()">
<table cellpadding="0" cellspacing="0" class="layout-table">
	<tr>
		<td class="td1">
			<div>
				<table cellpadding="0" cellspacing="0" class="tab">
					<tr> 
						<td width="25px" align="center"><img width="16" height="16" src="/public/img/body/yuan_list.png"/></td>
						<td><B class="path-font">[<%=opt_obj_title %>][账号][列表]</B></td>   
						<td class="pages-align" align="right">
							<table cellspacing="0" cellpadding="0">
							<form name="queryForm" method="post" >
								<tr>
									<td>名称：</td>
									<td class="query-padd"><input name="name_mqu" onkeyup="quick_query()" type="text" value="<simp:DataBindTag dataSrc="QueryForm.name_mqu"/>"/></td>
									<td><input type="button" class="tab-button 18x18-button search-img" value="查询" onClick="query()"/></td>
								</tr>
							</form>	
							</table>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	<form name="updateForm" method="post">
	<tr>
		<td class="td2">
			<div class="div">
				<table cellpadding="0" cellspacing="0" class="tab">				
					<tr>
					 <%-- 
						 <%if("winAD".equals(assetType)){ %>
						<td class="font2-td">
							<input type="button" value="删除" class="tab-button 18x18-button delete-img" onClick="del(this)"/>
						</td>
						 <%} else if ("dbinner".equals(assetType)) { %>
						<td class="font2-td">
									<input type="button" value="删除" class="tab-button 18x18-button delete-img" onClick="delInner(this)"/>
						</td>
						<%} else if ("otherNet".equals(assetType)) { %>
						<td class="font2-td"><input type="button" value="添加" class="tab-button 18x18-button add-img" onClick="add(this,'<%=assetType %>')"/></td>
						<td class="font2-td">
								<input type="button" value="删除" class="tab-button 18x18-button delete-img" onClick="del(this)"/>
						</td>
						<%} else{
				       		if(!"radiusNet".equals(assetType)){
				        %>
						<td class="font2-td"><input onclick="push()" type="button" value="推送" class="tab-button 18x18-button push-img" /></td>
						<td class="font2-td"><input onclick="pull()" type="button" value="拉取" class="tab-button 18x18-button pull-img"/></td>
				        		<td align="left" width="80px"><input type="button" value='双向同步' class="tab-button 18x18-button add-img" onClick="connectAsset(this,'<%=assetType %>')"/></td>	
						<td class="font2-td">
						        	<input type="button" value="添加" class="tab-button 18x18-button add-img" onClick="add(this,'<%=assetType %>')"/>
						</td>
						<td class="font2-td">
							<input type="button" value="删除" class="tab-button 18x18-button delete-img" onClick="del(this)"/>
						</td>
							<%}%>   
				        <%} %>
				        <td class="font6-td">
						<%if(!"webapp".equals(assetType)){ %>
					    <input type="checkbox" checked id="deleteStore" value='true' name="deleteStore" onClick="enableAllCbk(this)" style="vertical-align: middle;">仅删除存储
					    <%}else{ %>
					    &nbsp;
					    <input type="hidden" id="deleteStore" value='true' name="deleteStore">
					    <%} %>
						</td>
						
						<td class="font2-td"><input type='button' value='导入' class="tab-button 18x18-button import-img" onclick=''></td>
						<td class="font2-td"><input type='button' value='导出' class="tab-button 18x18-button export-img" onclick=''></td>
						<td class="font2-td"><input type='button' value='帮助' class="tab-button 18x18-button yuan_help" onclick=''></td>
						<td class="font2-td"><input type='button' value='返回' class="tab-button 18x18-button back" onclick='back()'></td>
						<td class="pages-align" align="right">
								<jsp:include flush="true" page="/publicPage/includepage/turnPage.jsp"></jsp:include>
						</td>
					--%>
						<td class="font2-td">
							<input type="button" value="添加" class="tab-button 18x18-button add-img" onClick="add(this,'<%=assetType %>')"/>
						</td>
						<td class="font2-td">
							<img class="split-img" src="/public/img/body/split.png"/>
							<input type="button" value="删除" class="tab-button 18x18-button delete-img" onClick="del(this)"/>
						</td>
						<%if(!AssetEnv.ASSET_TYPE_APPLICATION.equals(assetType) && AssetEnv.ASSET_TYPE_DP.equals(assetType)){ %>
						<td class="font6-td">	
							<img class="split-img" src="/public/img/body/split.png"/>					
					    	<input type="checkbox" checked id="deleteStore" value='true' name="deleteStore" onClick="enableAllCbk(this);del_all_btn()" style="vertical-align: middle;">仅删除存储				  					    
						</td>
						<%}else{ %>
						<input type="hidden" id="deleteStore" value='true' name="deleteStore">
						<%} %>
						<%
						
				       		if(!AssetEnv.ASSET_TYPE_RADIUS_DEVICE.equals(assetType) && !AssetEnv.ASSET_TYPE_APPLICATION.equals(assetType) && !AssetEnv.ASSET_TYPE_DB_SYSTEM.equals(assetType)&& !AssetEnv.ASSET_TYPE_DP.equals(assetType)){
				        %>
						<td class="font2-td">
							<img class="split-img" src="/public/img/body/split.png"/>
							<input onclick="push()" type="button" value="推送" class="tab-button 18x18-button push-img" onclick="push()"/>
						</td>
						<td class="font2-td">
							<img class="split-img" src="/public/img/body/split.png"/>
							<input onclick="pull()" type="button" value="拉取" class="tab-button 18x18-button pull-img" onclick="pull()"/>
						</td>
						<%} %>
<%--						<td class="font2-td">--%>
<%--							<img class="split-img" src="/public/img/body/split.png"/>--%>
<%--						<input type="button" value="导入" class="tab-button 18x18-button import-img" onClick="import_wizard()"/>--%>
<%--						</td>--%>
<%--						<td class="font2-td">--%>
<%--							<img class="split-img" src="/public/img/body/split.png"/>--%>
<%--							<input type='button' value='导出' class="tab-button 18x18-button export-img" onclick="show_wizard(this,'export_div','400','300','align_center','no',export_asste_account)">--%>
<%--						</td>--%>
						<td class="font6-td">
							<img class="split-img" src="/public/img/body/split.png"/>
							<input  type="button" value="打印密码信封" class="tab-button 18x18-button print_envelope-img" onclick='print_envelope()'/>
						</td>
						<td class="font2-td">
							<img class="split-img" src="/public/img/body/split.png"/>
							<input type="button" value="日志" class="tab-button 18x18-button log-img" onClick="open_log()"/>					
						</td>
						<td class="font2-td">
							<img class="split-img" src="/public/img/body/split.png"/>
							<input type='button' value='帮助' class="tab-button 18x18-button yuan_help" onclick='help_dlg()'>
						</td>
						<td class="font2-td">
							<img class="split-img" src="/public/img/body/split.png"/>
							<input type='button' value='返回' class="tab-button 18x18-button back" onclick='back()'>
						</td>
						<td class="pages-align" align="right">
								<jsp:include flush="true" page="/publicPage/includepage/turn_page_2.jsp"></jsp:include>
						</td>
					</tr>
				</table>			
			</div>
		</td>
	</tr>
	<tr>
		<td class="td3">
			<div>
			<input type="hidden" name="rdn" value="">
			<table id="tab"  align="center" cellspacing="0" cellpadding="0">
 			
  				<tr class="list-title-tr">
				 <td width="55px" class="bottom-line">
						<input <simp:CkbListTag level="2"/> 
			    		onclick='List_checkAll2(this,"<simp:PathTag s='/backGrand.do'/>")' 
			    		name="list_ckb_all" type=checkbox >
				 </td>
				 <td width="55px" class="bottom-line">
				    <div>序号</div>
				 </td>
				 <th>
				 <span onDblClick="on_db_lclick()" onMouseDown="mouse_down_to_resize(this)" onMouseMove="mouse_move_to_resize(this)" onMouseUp="mouse_up_to_resize(this)"  class="drag-span" id="drag1"></span> 
				   <div>名称</div>
				 </th>
				 <th>
				 <span onDblClick="on_db_lclick()" onMouseDown="mouse_down_to_resize(this)" onMouseMove="mouse_move_to_resize(this)" onMouseUp="mouse_up_to_resize(this)"  class="drag-span" id="drag1"></span> 
				   <div>归属</div>
				 </th>
				 <!--<th>
				 	<span onDblClick="on_db_lclick()" onMouseDown="mouse_down_to_resize(this)" onMouseMove="mouse_move_to_resize(this)" onMouseUp="mouse_up_to_resize(this)"  class="drag-span" id="drag1"></span> 
				    <div style="padding-top:8px">授权状态</div>
				 </th>-->
				 <th>
				 <span onDblClick="on_db_lclick()" onMouseDown="mouse_down_to_resize(this)" onMouseMove="mouse_move_to_resize(this)" onMouseUp="mouse_up_to_resize(this)"  class="drag-span" id="drag2"></span> 
				    <div>类型</div>
				 </th>
<%--				 <th>--%>
<%--				 	<span onDblClick="on_db_lclick()" onMouseDown="mouse_down_to_resize(this)" onMouseMove="mouse_move_to_resize(this)" onMouseUp="mouse_up_to_resize(this)" class="drag-span" id="drag3"></span> --%>
<%--					<div>账号状态</div>--%>
<%--				 </th>--%>
				 <th>
					<div>操作</div>
				 </th>
			  </tr>
			  <%
			  	
			  	int i=0;
			  	while(list!=null && !list.isEmpty()){
			  		Account account=(Account)list.remove(0);
			  		String parentName=account.getNamePath();
			  		
			  %>
			  <tr align="center">
				 <td>
				 	<input account_type="<%=account.getType()%>"
			    	 <%//=!"webapp".equals(assetType) && Account.TYPE_SHARE_MANAGED.equals(account.getType())?"disabled":""%>
			    	 onclick='List_check2(this,"<simp:PathTag s='/backGrand.do'/>")' 
			    	<simp:CkbListTag rdn='<%=account.getRdn()%>' level='2'/>
			    	type=checkbox name="list_ckb" value="<%=account.getRdn()%>">
			     </td>
				 <td><%=list.getIndex(i++)%></td>
				 <td style="cursor:pointer;" onClick="tr_has(this)" align="left">&nbsp;<%=account.getName()%></td>
				 <td nowrap title="<%=parentName %>" align="left">&nbsp;<%=StringUtils.get_sub_str(parentName,18)%></td>
				 <% if (AssetEnv.ASSET_TYPE_RADIUS_DEVICE.equals(account.getAssetType()) || AssetEnv.ASSET_TYPE_APPLICATION.equals(account.getAssetType())) { %>
				 	<td>--</td>
			    <% } else { %>
				 <td><simp:DataBindTag map="<%=Account.getTypeMap()%>" dataSrc="<%=account.getType()%>"/></td>
<%--				  <% if ("dbinner".equals(account.getAssetType())) {%>--%>
<%--				  	<td>-</td>--%>
<%--				    <% } else { %>--%>
<%--				 <td><simp:DataBindTag map="<%=Account.getConnectStatMap()%>" dataSrc="<%=account.getConnectStat()%>"/></td>--%>
			    <% 
			    //} 
			    }
			    %>
				 <td>
				 <% 
				  String accountRdn = account.getRdn();
				  String accountStr = accountRdn.substring(3, accountRdn.indexOf(","));
				  accountStr = ","+accountStr+",";
				  if(
				    "admin".equals(userId) || "SUCCESS:0".equals(echo) || "SUCCESS:1".equals(echo) || "SUCCESS:2".equals(echo) || (echo.startsWith("SUCCESS") && echo.indexOf(accountStr) > -1)
				  ){
				 %>
				 	<input type="button" value="修改" class="tab-button 18x18-button edit-img"  onClick="edit('<%=account.getRdn()%>','<%=account.getAssetType() %>')"/>
				 	<input type="button" value="日志" class="tab-button 18x18-button log-img" onClick="open_refer_log('<%=account.getRdn()%>','<%=a.getName()%>','<%=account.getName()%>')"/>
				 	<input type="button" value="关联授权" class="tab-button 18x18-button union-img" onClick="show_authorization('<%=account.getAssetType() %>','<%=account.getRdn() %>','<%=account.getName() %>','<%=ip %>')"/>
				 <% 
				  }else{
				 %>
				 &nbsp;
				 <% 
				  }
				 %>
				 </td>
			  </tr>
			  <tr style="display:none;">
			    <td colspan="6">&nbsp;</td>
			  </tr>
			    <%}%>
 			
			</table>
			</div>
		</td>
	</tr>
	</form>
	<tr>
		<td class="td4">
			<div class="div">
				<table class="tab">
					<tr> 
						<td class="font4-td">
							<input id="delAll" type="button" value="全部删除" class="tab-button 18x18-button delete-all-img" onClick="del_all()"/>						
						</td>
					    <%-- 
						<td class="font4-td">
							<input type="button" value="批量添加" class="tab-button 18x18-button batch-add" onClick=""/>						
						</td>
						<td class="font4-td">
							<img class="split-img" src="/public/img/body/split.png"/>
							<input type="button" value="批量修改" class="tab-button 18x18-button batch-up" onClick=""/>						
						</td>
						<td class="font4-td">
							<img class="split-img" src="/public/img/body/split.png"/>
							<input type="button" value="策略设置" class="tab-button 18x18-button policy-img" onClick=""/>						
						</td>
						<td class="font6-td">
							<img class="split-img" src="/public/img/body/split.png"/>
							<input type="button" value="访问方式设置" class="tab-button 18x18-button access-way" onClick=""/>						
						</td>
						--%>
						<td class="pages-align" align="right">
							<jsp:include flush="true" page="/publicPage/includepage/turn_page_2.jsp"></jsp:include>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
<div id="export_div" class="pop-up-div">
<jsp:include flush="true" page="./export_config_account.jsp"></jsp:include>
</div>
</body>
</html>
