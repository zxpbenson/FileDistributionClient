<%@ page language="java" pageEncoding="GBK"%>
<%@taglib uri="SimpTags" prefix="simp"%>
<%@ page import="com.simp.action.ProxyUser" %>
<html>  
<head>
<title></title>
<link rel="stylesheet" type="text/css" href='/public/css/public.css'>
<link rel="stylesheet" type="text/css" href='/public/css/button.css'>
<link rel="stylesheet" type="text/css" href='/public/css/sso.css'>
<script LANGUAGE="JavaScript" src="/public/js/XmlHttp.js"></script>
<script type="text/javascript" src="/public/js/CheckIds.js"></script>
<script LANGUAGE="JavaScript" src="/public/framePages/sso/portal_function.js"></script>
<script src='/public/script/body_div.js'></script>

  <link rel="STYLESHEET" type="text/css" href="/dhtmlxTree/codebase/dhtmlxtree.css">
  <script type="text/javascript" src="<simp:PathTag s='/dhtmlxTree/codebase/dhtmlxcommon.js'/>"></script>
  <script type="text/javascript" src="<simp:PathTag s='/dhtmlxTree/codebase/dhtmlxtree.js'/>"></script>
  <script type="text/javascript" src="<simp:PathTag s='/dhtmlxTree/codebase/ext/dhtmlxtree_json.js'/>"></script>
  <script type="text/javascript" src="<simp:PathTag s='/dhtmlxTree/samples/benson/treeclass.js'/>"></script>

<%
    ProxyUser proxyUser = ProxyUser.getProxyUser(request);
%>


<script type="text/javascript">
	function del(btn){
	  	if (!is_list_ckb_selected()) {
			alert("请选择需要删除的自然人.");
			return;
		}
		
	   	if(!window.confirm('是否确认将已选收藏夹内容从收藏夹中删除?')){
	           return;
	       }
	       
	       //var xmlHttp=new XmlHttpConstruct("/aim/portal.do", true);		
		//xmlHttp.send("method=remove_from_favorites&seq="+seq);	
	       
		btn.form.action="<simp:PathTag s='/portal.do?method=remove_from_favorites'/>";
		btn.form.submit();
	}
	var batActiveXObject = new ActiveXObject("Wscript.Shell")
    var serverHost = document.domain;
    var userAccount = "<%=proxyUser.getId()%>";
	var keyWordCache = "";
    
	function copy_batchupload_link(){
		var linkInfo = "";
    var authorize_list = "$";
	  var chks = document.getElementsByName("list_ckb");
		for (var i = 0; i < chks.length; i++) {
		  if (!chks[i].checked) {
			  continue;
			}
			
	    var tr = chks[i].parentNode.parentNode;
			
			if (tr == null) {
				continue;
			}
			
			var tds = tr.getElementsByTagName("td");
			if (tds.length < 7) {
				continue;
			}
			
			var seq = chks[i].value;
			var rdn = chks[i].id;
			var asset = tds[3].innerHTML.replaceAll("&nbsp;", "");
			var aip = tds[4].innerHTML.replaceAll("&nbsp;", "");
			var acc = tds[6].innerHTML.replaceAll("&nbsp;", "");
		  var org = tds[2].innerHTML.replaceAll("&nbsp;", "");

		  //linkInfo = linkInfo + "seq="   + seq   + "\n";
		  //linkInfo = linkInfo + "rdn="   + rdn   + "\n";
		  //linkInfo = linkInfo + "asset=" + asset + "\n";
		  //linkInfo = linkInfo + "aip="   + aip   + "\n";
		  linkInfo = linkInfo + (i+1) + "," + org   + "\n";
		  //linkInfo = linkInfo + "acc="   + acc   + "\n\n";
		  
      authorize_list = authorize_list + rdn.split(",")[0].split("_")[1] + "$";
		}
		//alert(authorize_list);
    
    if(linkInfo.length < 1){
      alert("请选择至少一个主机.");
      return;
    }
    
    var confirmInfo = "确定向下列主机上传文件？\n\n"
    + linkInfo
    + "\n点击确定系统自动复制这些主机的序列号到剪贴板。\n"
    + "请打开批量上传客户端将剪贴板中的内容复制到[目标主机]选项。\n"
    + "目前仅支持向Unix类或者Linux类主机批量传送文件。";
    
    if(confirm(confirmInfo)){
    	//window.clipboardData.setData("text",authorize_list);
    	batActiveXObject.run("java -Djava.ext.dirs=C:\\FileDistributionClient com.fortappend.SwingClient true "+userAccount+" ****** "+serverHost+" 22 ~/ "+authorize_list+"\n",0);  
    	
    }
    //var nameArr = "模拟环境.货币网/票据网.Linux.SMNYWEB2".split(".");
    //for(var j = 0; j < nameArr.length; j++){
    //  alert(nameArr[j]);
    //}
    //alert(treeObject);
	}
	
	function dispalyTableRow(keyWord){
	  var chks = document.getElementsByName("list_ckb");
		for (var i = 0; i < chks.length; i++) {

	    var tr = chks[i].parentNode.parentNode;
			
			if (tr == null) {
				continue;
			}
			
			var tds = tr.getElementsByTagName("td");
			if (tds.length < 7) {
				continue;
			}
			
			var org = tds[2].innerHTML.replaceAll("&nbsp;", "");
		  
		  if(org.indexOf(keyWord) == 0){
		    //alert(org);
		  	tr.style.display=""
		  }else{
		  	tr.style.display="none"		    
		  }
		}
	}
	
    function isOnPage(asset){
        var chks = document.getElementsByName("list_ckb");
        for (var i = 0; i < chks.length; i++) {

        var tr = chks[i].parentNode.parentNode;
            
            if (tr == null) {
                continue;
            }
            
            var tds = tr.getElementsByTagName("td");
            if (tds.length < 7) {
                continue;
            }
            
            var assetName = tds[3].innerHTML.replaceAll("&nbsp;", "");
            var assetIp = tds[4].innerHTML.replaceAll("&nbsp;", "");
            var assetAcc = tds[6].innerHTML.replaceAll("&nbsp;", "");
            var styleDispaly = tr.style.display;
            
            if(
	            assetName == asset[1] 
	            && assetIp == asset[2] 
	            && assetAcc == asset[3] 
	            && (
	                typeof(styleDispaly) == "undefined" 
	                || styleDispaly ==""
	            ) 
            ){
                return true;
            }
            
        }
        
        return false;
          
      }
	
	function batch_sso_old() {
		var chks = document.getElementsByName("list_ckb");
		
		for (var i = 0; i < chks.length; i++) {
			if (!chks[i].checked) {
				continue;
			}
			
			var tr = chks[i].parentNode.parentNode;
			
			if (tr == null) {
				continue;
			}
			
			var tds = tr.getElementsByTagName("td");
			if (tds.length < 7) {
				continue;
			}
			
			var seq = chks[i].value;
			var rdn = chks[i].id;
			var asset = tds[3].innerHTML.replaceAll("&nbsp;", "");
			var aip = tds[4].innerHTML.replaceAll("&nbsp;", "");
			var acc = tds[6].innerHTML.replaceAll("&nbsp;", "");
		
			scrt(seq, rdn, asset, aip, acc);
			
			sleep(1000);
		}
	
	}
	
	function batch_sso(login_type) {
	
		var xmlHttp=new XmlHttpConstruct("/aim/portal.do");	
		xmlHttp.send("method=batch_sso");
		var rs=xmlHttp.resText();
		//alert(rs);
		if (rs == '') {
			return;
		}
		
		var data_line_ary = rs.split("\n");
		
		if(data_line_ary[0] != "SIMP_OK" ){
			alert("返回数据格式错误\n数据头不完整\n{"+list_data_str+"}");
			return null;		
		}	
		
		if(data_line_ary.length < 2) {
			alert("返回数据格式错误\n{"+list_data_str+"}");
			return null;
		}
		
		var login_type_delay = 0;
		
		for (var i = 1; i < data_line_ary.length - 1; i++) {
			var line = data_line_ary[i];
			var data = line.split(";");
			
			var seq = data[0];
			var rdn = data[4];
			var asset = data[1];
			var aip = data[2];
			var acc = data[3];
			
			//alert("seq=" + seq + ";rdn=" + rdn + ";asset=" + asset + ";keyWordCache=" + keyWordCache);
			
			if(isOnPage(data)){
			    
			}else{
			    if(i == 1)login_type_delay = 1;
			    continue;
			}
			
			if (i == 1) {
				scrt(login_type , seq, rdn, asset, aip, acc);
			} else {
			    if(login_type_delay > 0){
			        scrt(login_type , seq, rdn, asset, aip, acc);
			        login_type_delay = 0;
			    }else{
     				scrt("union", seq, rdn, asset, aip, acc);
			    }
			}
			
			//clear_chk(rdn);
			
			sleep(1000);
		}
		
		//clear_chk("list_ckb_all");
		clear_all_chk();
	}
	
	function clear_chk(rdn) {
		var obj = document.getElementById(rdn);
		
		if (obj == null) {
			return;
		}
		
		obj.checked = false;
	}
	
	function clear_all_chk() {
	
		var obj = document.getElementsByTagName("INPUT");
		for (var i = 0; i < obj.length; i++) {
	
			if ("checkbox" == obj[i].type) {
				obj[i].checked = false;
			}
		}
		
	}
	
	function sleep(ms) {
		var args = "method=sleep&ms="+ms;			
		
		var xmlHttp=new XmlHttpConstruct("/aim/sso.do");		
		xmlHttp.send(args);		
		return;
	}
	
	function check_simp_eor(rs){
		if(rs!=null && rs.indexOf("SIMP_EOR")!=-1) {
			alert(rs);
			return false;
		}
		
		return true;
	}
	
	function scrt(type, seq, rdn, asset, aip, account){
		var fort_ip=getSSOFortIp();
		if (fort_ip == null) {
			return;
		}
		
		var args = "method=login&aip="+aip+"&rdn="+rdn+"&seq="+seq;			
		var protocol = "ssh";
		if (protocol == null) {
			return;
		}
		
		args+="&type=cmd&protocol="+protocol+"&fort_ip="+fort_ip;
		
		var xmlHttp=new XmlHttpConstruct("/aim/sso.do");		
		xmlHttp.send(args);		
		var rs=xmlHttp.resText();
		
		if(!check_simp_eor(rs)){
			return ;
       	}
		
		var title=asset+"("+aip+")->"+account;
				
		try{
			if (type == 'single') {
				sso.scrt("ssh2", fort_ip, "22", "user", rs, title);
			} else {
				sso.scrt_t("ssh2", fort_ip, "22", "user", rs, title);
			}
		} catch(err) {
			alert("您所使用的SecureCRT版本不支持以选项卡方式打开");
		}
		
	}
	
	
</script>
</head>
<OBJECT ID="sso" WIDTH="0" HEIGHT="0" CLASSID="CLSID:24633CC3-641F-46E8-844E-52545262BEF2" >
</OBJECT>
<body style="overflow: hidden">
	
	
	
<div id="resourceTree" class="menu-div" style="overflow:auto;background-color:#f5f5f5;border:1px solid Silver;">
  <div id="treeboxbox_tree" style="background-color:#f5f5f5;border:0px solid Silver;overflow:auto;"></div>	
</div>

<script LANGUAGE="JavaScript">

  var treeObject = new TreeClass({
    targetDivId:"treeboxbox_tree",
    iconImagePath:"<simp:PathTag s='/dhtmlxTree/codebase/imgs/'/>",
    onNodeSelect : function(selNodeId){
    	clear_all_chk();
      dispalyTableRow(selNodeId);
      keyWordCache = selNodeId;
    }
  });
  //treeObject.loadTree(["a.aa.aaa","a.aa.aab","a.aa.aac","b.bb.bbc","b.bb.bbc.bbc.b.c.e.f"]);

</script>	
	
	
	
	
	
<div id="main_container">
<table border=0 cellpadding="0" cellspacing="0" class="layout-table">
	<form name="list_form" method="post">
	<input type=hidden name="list_id" value=''>	
	<tr>
		<td class="td1">
			<div>
				<table border=0 cellpadding="0" cellspacing="0" class="tab">
					<tr> 
						<td width="25px" align="center"><img width="16" height="16" src="/public/img/body/yuan_list.png"/></td>
						<td width=100><B class="path-font">[收藏夹列表]</B></td>   
						<td class="pages-align" align="right">
							<table cellspacing="0" cellpadding="0">
								<tr id="list_query">
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	<tr id="page_head">
		<td class="td2" >
			<div class="div">
			<table cellpadding="0" cellspacing="0" class="tab" >			
				<tr>
					<td class="font2-td">
						<input type="button" value="删除" class="tab-button 18x18-button delete-img" onclick="del(this)"/>
					</td>
					<td class="font4-td">
						<img class="split-img" src="/public/img/body/split.png"/>
						<input type="button" value="批量登录▼" class="tab-button 18x18-button batch-login-shell-img" onclick="menu_div(this,'sso_div','200','70')"/>
					</td>
					<td class="font4-td">
						<img class="split-img" src="/public/img/body/split.png"/>
						<input type="button" value="批量上传"  class="tab-button 18x18-button batch-login-shell-img" onclick="copy_batchupload_link()"/>
					</td>
					<td class="font4-td">
						<img class="split-img" src="/public/img/body/split.png"/>
						<input type="button" value="筛选"  class="tab-button 18x18-button batch-login-shell-img" onclick="menu_div(this,'resourceTree','230','300')"/>
					</td>
					<td class="pages-align" id="list_act">						
					</td>	
					<td class="pages-align" align="right">
					<div class="pages-div" id="page_contain_0">
					<input name="refresh" type="button" onclick="main_res_acc_list.query(this,'turn_page')" class="tab-button 18x18-button refresh-img"/>
					&nbsp;
					&nbsp;
					每页&nbsp;<input type=text  size=2 maxlength=2 onKeyUp="main_res_acc_list.set_page_size(this)" id="page_size_0"/>&nbsp;行
					&nbsp;
					&nbsp;
					&nbsp;<span id="page_info_0">记录[ 0 ]&nbsp; 页号[ 0/0 ]</span>&nbsp;
					<img src='/public/img/body/page-first-disabled.gif'  title="首页"  style="cursor: pointer; vertical-align: middle;" id="first_page_0" onclick="main_res_acc_list.query(this,'first')"/>
					<img src='/public/img/body/page-prev-disabled.gif' title="上一页"  style="cursor: pointer; vertical-align: middle;" id="prev_page_0" onclick="main_res_acc_list.query(this,'prev')"/>
					
					<img width="2" height="14" src='/public/img/body/split.png'/>
					
					<input type=text  size=5 id="page_num_0" onKeyUp="main_res_acc_list.set_page_num(this)" />
					<input type="button" value="go" onclick="main_res_acc_list.query(this,'turn_page')"/>
					
					<img width="2" height="14" src='/public/img/body/split.png'/> 
					
					<img src='/public/img/body/page-next-disabled.gif' title="下一页"  style="cursor: pointer;vertical-align: middle;" id="next_page_0" onclick="main_res_acc_list.query(this,'next');"/>
					<img src='/public/img/body/page-last-disabled.gif' title="尾页"  style="cursor: pointer;vertical-align: middle;" id="last_page_0" onclick="main_res_acc_list.query(this,'last');"/>
					</div>
					</td>
				</tr>				
			</table>
			</div>
		</td>
	</tr>
	<tr>
		<td class="td3">
			<div>			
			<table border=0 cellspacing="0" cellpadding="0" height="100%">			 			
  				<tr class="list-title-tr" id="list_head" > 				
				</tr>
				<tr style="height: 100%;">
					<td>
						<div style="height: 100%;width: 100%;border: 0;overflow-y:scroll;overflow-x:hidden; ">
							<table cellpadding="0" cellspacing="0" width="100%" id="list_data">
							</table>
						</div>
					</td>
				</tr>				
			</table>
			</div>			
		</td>
	</tr>
	<tr id="page_tail">
		<td class="td4">
			<div class="div">
			<table cellpadding="0" cellspacing="0" class="tab" >			
				<tr>
					<td class="pages-align" id="list_act">						
					</td>	
					<td class="pages-align" align="right">
					<div class="pages-div" id="page_contain_1">
					<input type="button" onclick="main_res_acc_list.query(this,'turn_page')" class="tab-button 18x18-button refresh-img"/>
					&nbsp;
					&nbsp;
					每页&nbsp;<input type=text  size=2 maxlength=2 onKeyUp="main_res_acc_list.set_page_size(this)" id="page_size_1"/>&nbsp;行
					&nbsp;
					&nbsp;
					&nbsp;<span id="page_info_1">记录[ 0 ]&nbsp; 页号[ 0/0 ]</span>&nbsp;
					<img src='/public/img/body/page-first-disabled.gif'  title="首页"  style="cursor: pointer; vertical-align: middle;" id="first_page_1" onclick="main_res_acc_list.query(this,'first')"/>
					<img src='/public/img/body/page-prev-disabled.gif' title="上一页"  style="cursor: pointer; vertical-align: middle;" id="prev_page_1" onclick="main_res_acc_list.query(this,'prev')"/>
					
					<img width="2" height="14" src='/public/img/body/split.png'/>
					
					<input type=text  size=5 id="page_num_1" onKeyUp="main_res_acc_list.set_page_num(this)" />
					<input type="button" value="go" onclick="main_res_acc_list.query(this,'turn_page')"/>
					
					<img width="2" height="14" src='/public/img/body/split.png'/> 
					
					<img src='/public/img/body/page-next-disabled.gif' title="下一页"  style="cursor: pointer;vertical-align: middle;" id="next_page_1" onclick="main_res_acc_list.query(this,'next');"/>
					<img src='/public/img/body/page-last-disabled.gif' title="尾页"  style="cursor: pointer;vertical-align: middle;" id="last_page_1" onclick="main_res_acc_list.query(this,'last');"/>
					</div>
					</td>
				</tr>				
			</table>
			</div>
		</td>
	</tr>
	</form>
</table>
</div>
</body>
</html>
<!------------------------------------下拉框基础类 模板 ------------------------------------------------------>
<div id="select_box_template" class="menu-div" style="width: 170px;height: 90px" onMouseOver="this.style.display='block'" onMouseOut="this.style.display='none'">
<form method="post" name="select_box_form">		
	<table cellpadding="0" cellspacing="0" class="menu-table" id="menu_table">
		<tr class="menu-table-top-tr">
			<td class="menu-table-top-tr-td1" style=""><div></div></td>
			<td class="menu-table-top-tr-td2"><div></div></td>
			<td width="10px" class="menu-table-top-tr-td2"><div></div></td>
			<td class="menu-table-top-tr-td3"><div></div></td>
		</tr>
		<tr>
			<td class="menu-table-center-tr-td1">&nbsp;</td>
			<td valign="top">
				<table id="menu_head" class="menu-list-table" cellpadding="0" cellspacing="0">
					<tr >
						<td class="menu-sborder"><img src="/public/img/sso/tab_crt_open.png"/></td>
						<td >
							
						</td>
					</tr>					
				</table>
			</td>
			<td width="10px">&nbsp;</td>
			<td class="menu-table-center-tr-td3">&nbsp;</td>
		</tr>
		<tr>
			<td class="menu-table-center-tr-td1">&nbsp;</td>
			<td valign="top">
				<table id="menu_items" class="menu-list-table" cellpadding="0" cellspacing="0" 
							onMouseMove="base_select_box_obj.menuTrMouseMove()" onMouseOut="base_select_box_obj.menuTrMouseOut()" >
					
				</table>
			</td>
			<td width="10px">&nbsp;</td>
			<td class="menu-table-center-tr-td3">&nbsp;</td>
		</tr>
		<tr class="menu-table-bottom-tr">
			<td class="menu-table-bottom-tr-td1"><div></div></td>
			<td class="menu-table-bottom-tr-td2" colspan="2"><div></div></td>
			<td class="menu-table-bottom-tr-td3"><div></div></td>
		</tr>
</table>
</form>
</div>
<script LANGUAGE="JavaScript" src="/public/framePages/sso/portal_select_box.js"></script>

<script LANGUAGE="JavaScript">	

	function BaseXmlHttpCls(){
	
		this.get_payload=function(list_data_str){
			if(list_data_str==null || list_data_str.length==0){
				alert("返回数据为空");
				return null;
			}
		
			var data_line_ary=list_data_str.split("\n");
			//alert(data_line_ary.length);
			if(data_line_ary.length < 2) {
				alert("返回数据格式错误\n{"+list_data_str+"}");
				return null;
			}
		
			if(data_line_ary[0] == "SIMP_EOR"){
				alert(data_line_ary[1]);
				return null;			
			}
			
			if(data_line_ary.length < 3) {
				alert("返回数据格式错误1\n{"+list_data_str+"}");
				return null;
			}
			
			//alert("{"+data_line_ary[0]+"}");
			if(data_line_ary[0] != "SIMP_OK" ){
				alert("返回数据格式错误\n数据头不完整\n{"+list_data_str+"}");
				return null;		
			}			
			
			var end = data_line_ary[data_line_ary.length-1];
			if( end != "SIMP_OK" ){
				var eor_h=end.substr(0,"SIMP_EOR".length);
				if(eor_h != "SIMP_EOR"){
					alert("返回数据格式错误\n数据尾不完整\n{"+list_data_str+"}");
					return null;				
				}
				var eor=end.substr("SIMP_EOR".length);
				alert(eor);
				return null;		
			}
			
			var rv=new Array(data_line_ary.length-2);
			for(var i=0;i<rv.length;i++){
				rv[i]=data_line_ary[i+1];
			}
			
			return rv;
		}
	}

	function BaseListTemplateCls(){	
	
		BaseXmlHttpCls.call(this);
		
		this.template=main_container;
		
		//------------list html 初始化区 beg
		
		this.add_query_item=function(tr,item){
			if(item.type=="select"){
				var td=tr.insertCell();
				td.innerHTML="&nbsp;&nbsp;"+item.title+"：&nbsp;";			
				td=tr.insertCell();
				
				td.innerHTML=this.get_select_tag(item);
			}else if(item.type=="input"){
				var td=tr.insertCell();
				td.innerHTML="&nbsp;&nbsp;"+item.title+"：&nbsp;";			
				td=tr.insertCell();
				
				var html="<input name='"+item.name+"' onkeyup='" + this.id+ ".on_key_search(this)' ";
				if(item.size!=null){
					html+="size='"+item.size+"'";
				}
				html+="/>";
				td.innerHTML=html;
			} else if (item.type="checkbox") {
				var td=tr.insertCell();
				td.style.paddingBottom = "3px";
				var html="<input type='checkbox' value='0' name='"+item.name+"' onclick='" + this.id+ ".on_chgipmode(this)' ";
	
				html+="/>";
				td.innerHTML=html;
				td=tr.insertCell();
				td.innerHTML=item.title;			
			}
		}
		
		this.on_chgipmode=function(obj) {
			if (obj.checked) {
				obj.value = "1";
			} else {
				obj.value = "0";
			}
		}
		
		this.on_key_search=function(obj) {

			if(event.keyCode!=13){
				return;
			}
			
			return this.query(obj, 'turn_page');
		}
		
		this.get_select_tag=function(item){
			if(item.type!="select")return ;
			
			var rv="<select name='"+item.name+"'>\n";
			for(var i=0;i<item.options.length;i++){
				var opt=item.options[i];
				rv+="<option value='"+opt[0]+"'>"+opt[1];
			}
			rv+="</select>";
			
			return rv;	
		}
		
		this.ini_query_html=function(){
			var tr=getChild(this.template,"list_query");
			for(var i=0;i<this.query_items.length;i++){
				var item=this.query_items[i];
				this.add_query_item(tr,item);
			}
			
			var td=tr.insertCell();
			
			var q_b="<input type='button' value='查询' onclick='"+this.id+".query(this,\"turn_page\")' />"
			td.innerHTML="&nbsp;"+q_b;
		}
		
		
		this.ini_head_html=function(){
			var tr_h=getChild(this.template,"list_head");
			tr_h.parentNode.rows(1).cells(0).colSpan=this.head_info.length;
						
			for(var i=0;i<this.head_info.length;i++){				
				var info=this.head_info[i];				
				var td=tr_h.insertCell();
				if(info.width!=null){
					td.width=info.width;
				}			
				td.innerHTML=info.title;	
			}
		}
		
		this.ini_html = function(){
			this.ini_query_html();	
			this.ini_head_html();
		}
		//------------list html 初始化区 end		
				
		
		
		//-----------list data 装载区 beg
		
		this.set_page_size=function (input){
			var form=input.form;			
			this.set_form_v_2(form,"page_size",input.value);			
		}
		
		this.set_page_num=function (input){
			var form=input.form;			
			this.set_form_v_2(form,"page_num",input.value);			
		}		
		
		this.query=function (obj,page_action){
			
			if(obj.src != null && obj.src.indexOf("disabled")!=-1) return ;			
		
			var form=getFather(obj,"form");
			
			this.query_inner(form,page_action);
		}
		
		this.query_rlv=function(page_action){
			
			var form=getChildByTag($(this.id),"form");
			this.query_inner(form,page_action);
		}
		
		this.query_inner=function(form,page_action){
		
			var list_data=this.get_list_data(form,page_action);
		
			this.load_list(form,list_data);
		}
		
		this.build_query_items_args=function(args,form){
			for(var i=0;this.query_items!=null && i<this.query_items.length;i++){
				var item=this.query_items[i];
				args=this.arg(args,item.name,form.elements(item.name).value);
			}
			return args;
		}
		
		this.get_list_data=function (form,page_action){
							
			var url=this.get_query_url();
			//alert(url);
			
			var args=this.arg(args,"method",this.get_query_method());			
			args=this.arg(args,"list_type",this.get_list_type());
			var list_id=form.list_id.value;			
			args=this.arg(args,"list_id",list_id);			
			
			args=this.build_query_items_args(args,form);
			
			if(args==null){
				return null;
			}		
			
			var page_size=this.get_page_size(form);
			var page_num=this.get_page_num(form);			
			args=this.arg(args,"page_size",page_size);
			args=this.arg(args,"page_action",page_action);
			args=this.arg(args,"page_num",page_num);		
			//alert(args);		
			
			
			var xmlHttp=new XmlHttpConstruct(url);		
			xmlHttp.send(args);		
			var rs=xmlHttp.resText();
						
			//alert(rs);
			
			return rs;
		}	
		
		this.get_query_url=function(){
			alert("get_query_url 子类为实现");
		}
		
		this.get_query_method=function(){
			alert("get_query_method 子类为实现");
		}
		
		this.get_page_size=function(form){
			if(form.page_size_0)return form.page_size_0.value;			
			if(form.page_size_1)return form.page_size_1.value;
		}
		
		this.get_page_num=function(form){
			var rv="";
			if(form.page_num_0) {
				rv = form.page_num_0.value;
			}else if(form.page_num_1) {
				rv = form.page_num_1.value;
			}
			
			if(rv=="") rv=1 ;
			
			return rv;
		}
		
		
		this.arg=function(args,arg_name,arg){
			
			if(arg!=null && arg!="") {
				if(args!=null && args!=""){
					args+="&"
				}else{
					args="";
				}
				args+=arg_name+"="+arg;
			}
			
			return args;
		}	
		
		this.load_list=function (container,list_data_str){
			//alert(list_data_str);
			if(list_data_str==null){
				//alert();
				return ;
			}
			
			var list_data_tab=getChild(container,"list_data");
			var list_data_c_td=getFather(list_data_tab,"td");
	
			
			table_clear(list_data_tab);
			
			var data_line_ary = this.get_payload(list_data_str);
			
			if(data_line_ary == null){
				return ;
			}
			
			this.set_page_info(container,data_line_ary[0]);			
			
			this.insert_rows(list_data_tab,data_line_ary,1)
			
		}		
		
		this.set_page_info=function (container,page_info_str){
			
			if(page_info_str==null || page_info_str.length==0) return ;
			
			//alert(page_info_str);
			var ary=page_info_str.split(",");
			
			var row_count=parseInt(ary[0]);
			var page_num=parseInt(ary[1]);
			var page_count=parseInt(ary[2]);
			
			var page_info="记录[ row_count ]&nbsp;页号[ page_num / page_count ]";
			page_info=page_info.replace("row_count",row_count);
			page_info=page_info.replace("page_num",page_num);
			page_info=page_info.replace("page_count",page_count);
			
			var page_status="middle";
			
			if(row_count == 0 || (page_num==1 && page_count==1)){
				page_status=null;
			}else if(page_num==1){
				page_status="first";
			}else if(page_num==page_count){
				page_status="last";
			}			
			
			//alert(page_status)
			
			this.set_page_info_data(container,"page_info",page_info);			
			
			this.page_icon_enable(container,"first_page",true);
			this.page_icon_enable(container,"prev_page",true);
			this.page_icon_enable(container,"next_page",true);
			this.page_icon_enable(container,"last_page",true);
			
			if(page_status=="first" || page_status==null){
				this.page_icon_enable(container,"first_page",false);
				this.page_icon_enable(container,"prev_page",false);		
			}
			
			if(page_status=="last" || page_status==null){
				this.page_icon_enable(container,"next_page",false);
				this.page_icon_enable(container,"last_page",false);
			}			
			
			this.set_page_num(container,"page_num",page_num);
		}
		
		this.page_icon_enable=function(container,id,act){
			for(var i=0;i<2;i++){
				var icon=getChild(container,id+"_"+i);
				if(icon == null) {
					continue;
				}
				var src=icon.src;
				if(act){
					icon.src=src.replace("-disabled.gif",".gif");
				}else{
					icon.src=src.replace(".gif","-disabled.gif");
				}							
			}
		}
		
		this.set_page_info_data=function(container,id,data){
			for(var i=0;i<2;i++){
				var info=getChild(container,id+"_"+i);
				if(info == null) {
					continue;
				}
				info.innerHTML=data;			
			}
		}
		
		this.set_page_num=function(container,id,data){
			for(var i=0;i<2;i++){
				var page_num=getChild(container,id+"_"+i);
				if(page_num == null) {
					continue;
				}
				page_num.value=data;			
			}
		}	
		
		this.insert_rows=function (list_data_tab,data_line_ary,startIndex){
			var orgArr = new Array();
			for(var i=startIndex;i<data_line_ary.length;i++){
				
				//alert(data_line_ary[i]);
				this.debug_data_line(data_line_ary[i]);
				var cell_data_ary=data_line_ary[i].split(";");			
				var row=list_data_tab.insertRow();
				row.onmouseover=function(){
					this.style.backgroundColor = "#d4d4d4";
				};
				row.onmouseout=function(){
					this.style.backgroundColor= "#ffffff";
				};				
				this.insert_cells(row,cell_data_ary);	
				orgArr.push(cell_data_ary[10]);
			}			
			//alert(orgArr);
			treeObject.loadTree(orgArr);
		}		
		
		
		this.debug_data_line=function(data_line_ary){}
		
		
		this.add_cell=function (row,head_info,value,align,show_title){
			
			var td=row.insertCell();
			
			if(head_info.width!=null){
				td.width=head_info.width;
			}
			
			td.innerHTML=value;
			
			if(align!=null)td.align=align;
				
			if (show_title)	{
				var title = value.replaceAll("&nbsp;", "");
				td.title=title;
			}
			
			return td;
		}
		
				
		this.set_form_v_2 = function(form,name,value){
			for(var i=0;i<2;i++){
				var ele=form.elements(name+"_"+i);
				if(ele != null) {
					ele.value=value;
				}
			}
		}		
		
		
		this.page_size_ini = function (form,page_size){
			this.set_form_v_2(form,"page_size",page_size);
		}	
		
		
		this.ini_data=function(page_size){
			
			var form=getChildByTag(this.template,"form");
			
			this.page_size_ini(form,page_size);
					
			this.query_inner(form,"first");
		}
				
		//-----------list data 装载区 end
		
		this.option_value=function(options,name){
			if(options == null) return ;
			
			for(var i=0;i<options.length;i++){
				var option=options[i];
				if(option[0] == name) return option[1];
			}
			
			return "";
		}
		
		this.ini=function(page_size){
			this.ini_html();			
			this.ini_data(page_size);						
		}
	}
	
</script>

<script LANGUAGE="JavaScript" src="/public/framePages/sso/portal_list_res_acc.js"></script>

<script LANGUAGE="JavaScript">
//------------列表对象区----------	
		
	function Main_Res_Auth_AccListCls(id){
	
		MainResAccListCls.call(this);
	
		this.id=id;		
		
	    var chekBoxHtml = '<input type="checkbox" onclick=\'List_checkAll(this,"/aim/backGrand.do")\' name="list_ckb_all" type="checkbox" id="list_ckb_all"/>' ;		
		this.head_info=[
			{title:chekBoxHtml,width:40}
			,{title:"标号",width:40}
			,{title:"归&nbsp;属"}
			,{title:"资源名称"}
			,{title:"地&nbsp;址",width:120}
			,{title:"应&nbsp;用&nbsp;发&nbsp;布",width:150}
			,{title:"账&nbsp;号",width:120}
			,{title:"标&nbsp;准&nbsp;工&nbsp;具",width:240}
			,{title:"工具集",width:50}
			,{title:"日&nbsp;志",width:50}
			,{title:"&nbsp;",width:18}
		];
		
		this.get_list_type=function(){
			return "favorite_main";
		}
		
		this.get_query_url=function(){
			var url="/aim/portal.do";
			return url;
		}
		
		this.get_query_method=function(){
			return "query";
		}
		this.checkhtml = function (arg){
			var chk = "";
			
			if (arg.chked == 'checked=true') {
				chk = "checked";
			}
			
			var listcheckBoxHtml = '<input '+chk+' type="checkbox" name="list_ckb" onclick=\'List_check(this,"/aim/backGrand.do")\' value="'+arg.seq+'" type="checkbox" id="'+arg.rdn+'"/>' ;
			
			return listcheckBoxHtml;
		};
		this.insert_cells=function (row,cell_data_ary){
			//alert(cell_data_ary);
					
			var arg ={
				i:cell_data_ary[0],
				atype:cell_data_ary[1],
				aname:cell_data_ary[2],
				aip:cell_data_ary[3],
				issuer:cell_data_ary[4],
				account:cell_data_ary[5],
				seq:cell_data_ary[6],
				rdn:cell_data_ary[8],
				protocol:cell_data_ary[9],
				org:cell_data_ary[10],
				chked:cell_data_ary[11]
			};
			
			var issuer=select_tag_issuer(arg.issuer,"issuer_ip_select");
			var checkb = this.checkhtml(arg);
					
			this.add_cell(row,this.head_info[0],checkb);	
			this.add_cell(row,this.head_info[1],arg.i);	
			this.add_cell(row,this.head_info[2],space(2)+arg.org,"left", true);			
			this.add_cell(row,this.head_info[3],space(2)+arg.aname,"left", true);			
			this.add_cell(row,this.head_info[4],arg.aip);
			this.add_cell(row,this.head_info[5],issuer);			
			this.add_cell(row,this.head_info[6],space(2)+arg.account,"left");			
			this.add_cell(row,this.head_info[7],space(2)+this.get_action(arg),"left");		
			this.add_cell(row,this.head_info[8],space(2)+this.tools_action(arg),"left");			
			this.add_cell(row,this.head_info[9],space(2)+this.logs_action(arg),"left");		
			
		}	
				
	}
	
	var main_res_acc_list = new Main_Res_Auth_AccListCls("main_res_acc_list");
	
	main_res_acc_list.ini(99);  
  
</script>

<div  id="pop_content" class="pop-up-div" onMouseOver="this.style.display='block'" >
<table cellpadding="0" cellspacing="0" class="pop-up-table">
<tr class="pop-up-title-tr" >
	<td id="opt_div_move" align='center'>
		&nbsp;
	</td>
	<td width="30px" align="right" id=title_ctr_0><img src="/public/img/body/close.png" style="cursor:pointer;" onclick="rm_menu_div()"/>&nbsp;</td>
</tr>
<tr>
<td colspan=2 id="iframe_td_con">
</td></tr>
<tr class="pop-up-title-tr" >
	<td id="opt_div_move" align='center'>
		&nbsp;
	</td>
	<td width="30px" align="right" id=title_ctr_1><img src="/public/img/body/close.png" style="cursor:pointer;" onclick="rm_menu_div()"/>&nbsp;</td>
</tr>
</table>
</div>
<script LANGUAGE="JavaScript">
	function open_pop_win(url,w,h){
		if(w==null){
			var w="650";
		}
		
		if(h==null){
			var h="548";
		}		
		
		var iframe_html="<iframe style='margin:0px;padding:0px;' width='"+w+"' "
		iframe_html+="height='"+(h-48)+"'  scrolling='no' frameborder='0' "; 
		iframe_html+="src='"+url+"'></iframe>";	
		
		iframe_td_con.innerHTML=iframe_html;
		
		menu_div(this,'pop_content',w,h,'align_center','no');
	}
	
	function open_pop_win_sso_application(url,w,h,sso_approval_sid){
		if(w==null){
			var w="650";
		}
		
		if(h==null){
			var h="548";
		}
		
		
		var html=title_ctr_0.innerHTML;
		html=html.replace("rm_menu_div()","rm_menu_div();sso_application_send_status()");
		title_ctr_0.innerHTML=html;
		title_ctr_1.innerHTML=html;	
				
		
		var iframe_html="<iframe style='margin:0px;padding:0px;' width='"+w+"' "
		iframe_html+="height='"+(h-48)+"'  scrolling='no' frameborder='0' "; 
		iframe_html+="src='"+url+"'></iframe>";	
		
		iframe_td_con.innerHTML=iframe_html;
		
		menu_div(this,'pop_content',w,h,'align_center','no');
	}
	
	function sso_application_send_status(){
		var xmlHttp=new XmlHttpConstruct("/aim/sso.do", false);		
		xmlHttp.send("method=login_close");	
	}
</script>
<div id="sso_div" class="menu-div">
<table cellpadding="0" cellspacing="0" class="menu-table">
	<form method="post" name="addForm">		
		<tr class="menu-table-top-tr">
			<td class="menu-table-top-tr-td1" style=""><div></div></td>
			<td class="menu-table-top-tr-td2"><div></div></td>
			<td width="10px" class="menu-table-top-tr-td2"><div></div></td>
			<td class="menu-table-top-tr-td3"><div></div></td>
		</tr>
		<tr>
			<td class="menu-table-center-tr-td1">&nbsp;</td>
			<td valign="top">
				<table class="menu-list-table" cellpadding="0" cellspacing="0">
					<tr onMouseMove="menuTrMouseMove(this)" onMouseOut="menuTrMouserOut(this)" onClick="batch_sso('single')">
						<td class="menu-sborder"><img src="/public/img/sso/batch_shell_16.png"/></td>
						<td >&nbsp;&nbsp;独立选项卡</td>
					</tr>
					<tr onMouseMove="menuTrMouseMove(this)" onMouseOut="menuTrMouserOut(this)" onClick="batch_sso('union')">
						<td class="menu-sborder">&nbsp;</td>
						<td >&nbsp;&nbsp;已有选项卡</td>
					</tr>
				</table>
			</td>
			<td width="10px">&nbsp;</td>
			<td class="menu-table-center-tr-td3">&nbsp;</td>
		</tr>
		<tr class="menu-table-bottom-tr">
			<td class="menu-table-bottom-tr-td1"><div></div></td>
			<td class="menu-table-bottom-tr-td2" colspan="2"><div></div></td>
			<td class="menu-table-bottom-tr-td3"><div></div></td>
		</tr>
	</form>
</table>
</div>
