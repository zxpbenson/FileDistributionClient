<%@ page language="java" pageEncoding="gbk"%>
<%@ page import="com.simp.env.MenuEnv" %>
<%@ page import="com.simp.action.ProxyUser" %>
<%@ page import="com.simp.business.role.Role" %>
<%@taglib uri="SimpTags" prefix="simp"%>

<html>
<head>
<title>组织结构</title>
<link rel="stylesheet" type="text/css" href="/public/css/public.css"/>
<link rel="stylesheet" type="text/css" href="/public/css/button.css" />
<script type="text/javascript" src="/public/script/right_menu.js"></script>
<script type="text/javascript" src="/public/framePages/menu.js"></script>
<script type="text/javascript" src="/public/js/XmlHttp.js"></script>

<script type="text/javascript">	
	//重写addEvent方法为元素添加事件方法时兼容IE/FF
	window.addEvent = function(o,s,fn){
     	o.attachEvent?o.attachEvent('on'+s,fn):o.addEventListener(s,fn,false);
     	return o;    
	}
	
	var RootName="<%=MenuEnv.menuName%>"
	//var RootName="目录树"
	
	//var treePath='<simp:PathTag s="/img"/>';
	var treePath="/public/img/body/tree";
	
	function RefreshTargetFrame(){
		var parent=window.parent;
		parent.frames["main"].location='<simp:PathTag s="/framePages/body.jsp"/>';
	}	
	
	
	function freshCurNode(title){
		//alert(1)
		var curNode=getCurNodeByRoot();
		//alert(2)
		if(curNode.id=="root"){
			doExpandRoot();
			return ;
		}
		//alert(3)
		if(title!=null && title!=""){
			curNode.title=title;
		}		
		
		//清空当前节点	
		clearNode(curNode);	
		//alert(4)
		//获得子节点
		var str=getChildNodesStr(curNode);
		
		if(!isOK(str)){			
			errorMsg(str);
			if(str.indexOf("10500")>0){				
				root.curTitleId="title_"+curNode.parentNode.id;
				//alert(root.curTitleId);
				freshCurNode();
				var tmpNode=getCurNodeByRoot()				
				var rs=xmlHttpSetCurNode(tmpNode.dn);
				if(!isOK(rs)){
					errorMsg(rs);
				}
			}
			return;
		}		
		//alert(str);
		curNode.isLeaf=isEmptyChildNodesStr(str);
		//建立当前节点title	
		createTitle(curNode);		
		
		if(	!curNode.isOpen	){			
			return;
		}	
		
		var list=createChildNodesList(curNode,str);	
	
		//建立子节点title
		for(var i=0;i<list.length;i++){
			createTitle(list[i]);					
		}		
	}
	
	function isEmptyChildNodesStr(str){
		return str.indexOf("{}")>0;
	}
	
	
	function xmlHttpSetCurNode(dn){
		var xmlHttp=new XmlHttpConstruct("<simp:PathTag s='/tree.do'/>");	
		xmlHttp.send("method=setCurNode&tree_node_id="+dn);		
		var rs=xmlHttp.resText()+"";	
		return rs;
	}
	
	function onClickTitle(){	
		var curNode=getCurNodeByEvent();
		
		var rs=xmlHttpSetCurNode(curNode.dn);
			
		
		if(!isOK(rs)){
			if(isEor(rs)){
				errorMsg(rs);
				return;
			}else if(rs==""){
				alert("WEB服务异常，原因: WEB服务已停止或网络异常");				
				return ;
			}
			alert("会话超时，请注销后重新登录");
			return;
		}		
		
		var rootNode=getRootNode(); 
		var title=getCurTitle(curNode);		
		if(rootNode.curTitleId!=null){
			checkNode(document.all(rootNode.curTitleId),false);
		}
		checkNode(title,true);
		rootNode.curTitleId=title.id;	
		RefreshTargetFrame();   
		
		//----------刷目标页面---------
	}
	
	function onClickExpand(){
		//alert("onClickExpand");
		var curNode=getCurNodeByEvent();
		doExpand(curNode);
			
	}	
	
	function doExpand(curNode){
		
		//清空当前节点	
		clearNode(curNode);
		
		//置接点打开状态
		curNode.isOpen=!curNode.isOpen
		
		//建立当前节点title	
		createTitle(curNode);	
		
		if(	!curNode.isOpen	){			
			return;
		}	
		
		//获得子节点
		var str=getChildNodesStr(curNode);
		if(!isOK(str)){
			errorMsg(str);
			return;
		}		
		//alert(str)		
		var list=createChildNodesList(curNode,str);
		//建立子节点title
		for(var i=0;i<list.length;i++){
			createTitle(list[i]);					
		}
	}	
	
	function doExpandRoot(){
				
		root.id="root";		
		root.dn="";
		root.title=RootName;
		root.curTitleId="title_"+root.id;	
		
		//清空当前节点	
		clearNode(root);
		
		var table=document.createElement("TABLE");
		root.insertAdjacentElement("afterBegin",table);
		table.border=0;		
		table.cellSpacing=0;
		table.cellPadding=0;		
		
		var tr = table.insertRow(table.rows.length);   //添加行标准写法 参数表示要在那行后面追加行
		tr.style.height="18px";
		
		
		var td=tr.insertCell(0);                       //添加列标准写法 第一列 
		td.style.cursor="hand";
		td.style.width="16px";
		td.onclick=onClickTitle;
		//td.innerHTML+="<img src='"+treePath+"/tree/root.gif'>";	
		td.innerHTML+="<img src='"+treePath+"/leaf.gif'>";		
		
		//td=tr.insertCell(1);
		//td.innerHTML="&nbsp;";
		
		//td=tr.insertCell(2);
		td=tr.insertCell(1);
		td.id="title_"+root.id;
		td.onclick=onClickTitle;
		
		var span=document.createElement("SPAN");
		span.style.cursor="hand";
		span.id="txt_"+td.id;
		//span.innerHTML="<pre>"+root.title+"</pre>";              //pre存在兼容问题 选择用font来兼容
		span.innerHTML="<font style='font-family:微软雅黑;font-size: 12px; color: #000000;font-weight:600;'>&nbsp;【"+root.title+"】</font>";
		
		//window.addEvent(span,"contextmenu",menu);
		//window.addEvent(span,"contextmenu",onClickTitle);   
		
		td.insertAdjacentElement("afterBegin",span);
		//span.style.cssText="font-size:12px;color:#00237C;text-decoration:none;font-weight:bold;";


		//alert(span.id);
		//td.innerHTML=root.title;
		//td.cellspacing=4;
		
		if(root.curTitleId!=null 
			&& root.curTitleId==td.id){
			checkNode(td,true);
		}
		
		
		
		//获得子节点
		var str=getChildNodesStr(root);
		if(!isOK(str)){
			errorMsg(str);
			return;
		}
		
		//alert(str);
				
		var list=createChildNodesList(root,str);
		//建立子节点title
		for(var i=0;i<list.length;i++){
			createTitle(list[i]);	
		}
		
		//checkNode(td,true);
	}

	function getChildNodesStr(curNode){
		var keyword = document.getElementById("keyword").value;
		
		var xmlHttp=new XmlHttpConstruct("<simp:PathTag s='/tree.do'/>");	
		xmlHttp.send("method=getChildNodeList&tree_node_id="+curNode.dn+"&keyword=" + keyword);		
		var rs=xmlHttp.resText()+"";
		return rs;
	}

	function createChildNodesList(parent,istr){
		
		var bgn=istr.indexOf("{");
		var end=istr.indexOf("}");
		var tmp=istr.substring(bgn+1,end);
		
		if(tmp==""){
			return new Array();
		}
		
		var records=tmp.split("\n");		
		var rv=new Array();		
		for(var i=0;i<records.length;i++){
			rv[i]=createNode(records[i],i==records.length-1);
			parent.insertAdjacentElement("beforeEnd",rv[i]);			
		}
		return rv;
	}	
	
	function createNode(record,isLast){
                //alert("aim/framePages/left.jsp createNode record=" + record);
		var fields=record.split("\t");		
		var node=document.createElement("DIV");
                
                var idStr = fields[0];
                if(idStr.lastIndexOf(",") == (idStr.length - 1)){
                  fields[0] = idStr.substring(0 , idStr.length -1 );
                }

              //alert("aim/framePages/left.jsp createNode fields[0]=" + fields[0]);

		node.id=fields[0];
		node.title=fields[1];
		node.isLeaf=fields[2]=="true";
		node.right=fields[3]=="true";
		node.isLast=isLast;
		node.isOpen=false;
		node.dn=fields[0];
		//node.style.cssText="font-size:120px;color:#00237C;text-decoration:none;font-weight:bold;";
		//node.style.cssText="width:100%; height:26px; cursor:move; line-height:26px; padding-left:5px; background:#fff; border-bottom:1px solid #99CCFF;";

		//alert(fields[0]);
		//alert(fields[1]);
		return node;		
	}
	
	function createTitle(node){
		
		var table=document.createElement("TABLE");
		node.insertAdjacentElement("afterBegin",table);
		
		table.border=0;	
		table.height=10;
		table.cellSpacing=0;
		table.cellPadding=0;
		
		//---------create vlines imgs
		var tr = table.insertRow(table.rows.length);
		tr.style.height="18px";
		
		var parent=node.parentNode;
		var td_line=0;		//第一列是否被占用
		while(parent.id!="root"){
			var td = tr.insertCell(0);
			td.style.width="16px";
			
			if(parent.isLast){
				//td.innerHTML="<img src='"+treePath+"/tree/B.gif'>";
				td.innerHTML="<span style='width:16px;'>&nbsp;</span>";
			}else{
				//td.innerHTML="<img src='"+treePath+"/tree/I.gif'>";
				td.innerHTML="<img src='"+treePath+"/elbow-line.gif'>";
			}
			parent=parent.parentNode;
			td_line++;
		}
			
		
		//-------create expand img------
		var td = tr.insertCell(0+td_line);
		td.style.width="16px";
		
		if(node.isLeaf==true){
			if(node.isLast==true){				
				//td.innerHTML="<img src='"+treePath+"/tree/L.gif'>";
				td.innerHTML="<img src='"+treePath+"/elbow-end.gif'>";
			}else{
				//td.innerHTML="<img src='"+treePath+"/tree/T.gif'>";
				td.innerHTML="<img src='"+treePath+"/elbow.gif'>";
			}
		}else{
			td.onclick=onClickExpand;
			//var mp=node.isOpen?"M":"P";
			if(node.isLast){
				//td.innerHTML="<img src='"+treePath+"/tree/L"+mp+".gif'>";
				if(node.isOpen){
					td.innerHTML="<img src='"+treePath+"/elbow-end-minus.gif'>";
				}else{
					td.innerHTML="<img src='"+treePath+"/elbow-end-plus.gif'>";
				}
				
			}else{
				if(node.isOpen){
					td.innerHTML="<img src='"+treePath+"/elbow-minus.gif'>";
				}else{
					td.innerHTML="<img src='"+treePath+"/elbow-plus.gif'>";
				}
				//td.innerHTML="<img src='"+treePath+"/tree/T"+mp+".gif'>";				
			}
		}
		
		//-------create title icon
		var td=tr.insertCell(1+td_line);
		td.style.width="16px";
		
		td.style.cursor="hand";
		td.onclick=onClickTitle;
		//td.innerHTML+="<img src='"+treePath+"/folder.gif'>";		
		if(node.isLeaf==true){
			td.innerHTML+="<img src='"+treePath+"/folder.gif'>";
		}else{
			if(node.isOpen){
				td.innerHTML="<img src='"+treePath+"/folder-open.gif'>";
			}else{
				td.innerHTML+="<img src='"+treePath+"/folder.gif'>";
			}
		}
		
		
		
		
		//---------create title text
		//var td=tr.insertCell(2+td_line);
		//td.innerHTML="&nbsp;";
		
		//td=tr.insertCell(3+td_line);
		td=tr.insertCell(2+td_line);
		td.id="title_"+node.id;
		td.onclick=onClickTitle;
		
		var span=document.createElement("SPAN");
		span.style.cursor="hand";
		span.id="txt_"+td.id;
		//span.innerHTML="<pre>"+node.title;
		span.innerHTML="<font style='font-family:微软雅黑;font-size: 12px; color: #000000;'>&nbsp;【"+node.title+"】</font>";
		
		//window.addEvent(span,"contextmenu",menu);
		//window.addEvent(span,"contextmenu",onClickTitle);
		
		td.insertAdjacentElement("afterBegin",span);
		
		//span.style.cssText="font-size:12px;color:#00237C;text-decoration:none;font-weight:bold;";
		//alert(12);
		
		if(root.curTitleId!=null 
			&& root.curTitleId==td.id){
			checkNode(td,true);
		}
		//alert(document.all(span.id).innerHTML);
	}
	
	function clearNode(curNode){
		curNode.innerHTML="";
	}	
	
	function checkNode(node,isCheck){
		if(node==null){
			return;
		}
		var txt=document.all("txt_"+node.id);
		if(isCheck){
			//node.style.color="white";
			//node.style.background="#919191";
			txt.style.color="white";
			//txt.style.backgroundColor="#fd9c13";
			txt.style.backgroundColor="#CCCCCC";
			return;
		}
			txt.style.color="";
			txt.style.background="";
	}
	
	function getRootNode(){
		var rv=document.all("root");
		if(rv==null){
			alert("root is null");
			return null;
		}
		return rv;
	}
	
	function getCurNodeByEvent(){
		var div=getParentDiv(event.srcElement);
		return div;
	}
	
	function getCurTitle(curNode){
		return document.all("title_"+curNode.id);
	}
	
	function getCurNodeByRoot(){
		
		if(root.curTitleId==null){
			return null;
		}
				
		return getParentDiv(document.all(root.curTitleId));
		
	}
	
	
	function getParentDiv(obj){
		return getParentByTagName(obj,"div");
	}
	
	function getParentTd(obj){
		return getParentByTagName(obj,"td");
	}
	
	function getParentByTagName(obj,tagName){
		while(true){
			if(obj==null || obj.tagName==tagName.toUpperCase()){
				return obj;
			}
			obj=obj.parentNode;
		}
	}	
	
	
	function groupListClick(){
		var topWindow = window.parent.frames["topFrame"];
		
		if(topWindow.topLv2Div == null) {
			return;
		}
		
		topWindow.lv2_init_class(topWindow.topLv2Div);
		
		if (topWindow.document.getElementById("isDfDiv") == null) {
			return;
		}
		
		lv2_clicked_class(topWindow.document.getElementById("isDfDiv"));
		
		topWindow.topLv2Div = topWindow.document.getElementById("isDfDiv");
		
	}
</script>
</head>
<body onload="doExpandRoot()">

<table cellpadding="0" cellspacing="0" class="layout-table">	
	<% ProxyUser proxyUser = ProxyUser.getProxyUser(request);
	
		if (proxyUser.getMenuRolesMap().get(Role.OPERATION_MENU2_META_GROUP) != null) {
	%>
	<tr>
		<td class="left-td1">
			<div>
			<table cellpadding="0" cellspacing="0" class="tab">
				<tr>
					<td class="font2-td"><input onclick="left_conf('<simp:PathTag s="/group/data.do?method=addIni"/>')" type="button" value="添加" class="tab-button 18x18-button add-img"/></td>
					<td class="font2-td"><input onclick="left_conf('<simp:PathTag s="/group/data.do?method=modifyIni"/>')" type="button" value="修改" class="tab-button 18x18-button edit-img"   /></td>
					<td class="font2-td"><input onclick="left_conf('<simp:PathTag s="/group/list.do?method=listIni"/>');groupListClick()" type="button" value="列表" class="tab-button 18x18-button list-img" /></td>
				</tr>
			</table>
			</div>
		</td>
	</tr>
	<% } %>
	<tr>
		<td class="left-td2">
			<div class="left-group-div">
				<div id="root" align="left" class="left-group-root-div">&nbsp;</div>
			</div>									
		</td>
	</tr>
	<tr>
		<td class="left-td3" onClick="rm_div()">
			<div class="div">
				<table class="tab">
					<tr> 
						<td class="pages-align" align="center" style="padding-right: 1px;padding-left:1px;">
							<input type="text" id="keyword" name="keyword" style="width:100%"/>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
</body>
</html>