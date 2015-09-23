<%@ page language="java" pageEncoding="GBK"%>
<%@taglib uri="SimpTags" prefix="simp"%>
<html>
<head>


<OBJECT ID="sso" WIDTH="0" HEIGHT="0" CLASSID="CLSID:24633CC3-641F-46E8-844E-52545262BEF2" >
</OBJECT>
<link rel="stylesheet" type="text/css" href='/public/css/public.css'>
<link rel="stylesheet" type="text/css" href='/public/css/button.css'>
<link rel="stylesheet" type="text/css" href='/public/css/sso.css'>

<script src='/public/script/body_div.js'></script>
<script LANGUAGE="JavaScript" src="/public/js/XmlHttp.js"></script>
<script LANGUAGE="JavaScript" src="/public/framePages/sso/portal_function.js"></script>
<script LANGUAGE="JavaScript" src="/public/framePages/sso/portal.js"></script>
<script LANGUAGE="JavaScript">

function sso_application_send_status(){
	//alert('ok');
	//g_is_sso_approval_win_opened=false;
	
	var xmlHttp=new XmlHttpConstruct("/aim/sso.do", false);		
	xmlHttp.send("method=login_close");	
	//var rs = xmlHttp.resText()+"";
	
}

var g_is_sso_approval_win_opened=false;
function sso_approval_win_close(){
	g_is_sso_approval_win_opened=false;
}

var g_interval=null;
function get_approval_status(){
	var xmlHttp=new XmlHttpConstruct("/aim/sso.do", false);		
	xmlHttp.send("method=approval_search_status");	
	var rs = xmlHttp.resText()+"";
	
	if(rs=='null'){
		clearInterval(g_interval); 
		g_interval=null;
		return ;
	}
	
	if(rs=='000'){
		return ;
	}
	
	if(!g_is_sso_approval_win_opened){
		g_is_sso_approval_win_opened=true;
		open_pop_win_sso_approval("/aim/portal/sso_approval.jsp", 650,400);
	}
}

function search_status() {
	g_interval = setInterval(get_approval_status,3000);
}	

search_status();

var tab_infos=new Array(
	{id:"left_tab",width:"20%"},
	{id:"main_tab",width:"85%"}
<%--	{id:"right_tab",width:"20%"}--%>
);

var tab_div_infos=new Array( //数组顺序 就是显示顺序
	
	{id:"last_used_div",title:"最近使用",def_tab:"left_tab",cur_tab:null,left_h:540,main_h:510,right_h:200},
<%--	{id:"flow_div",title:"工单",def_tab:"left_tab",cur_tab:null,left_h:250,main_h:318,right_h:200},--%>
	
	{id:"multi_used_div",title:"最常使用",def_tab:"main_tab",cur_tab:null,left_h:300,main_h:540,right_h:200}
	
<%--	{id:"calendar_div",title:"日历",def_tab:"right_tab",cur_tab:null,left_h:250,main_h:250,right_h:250},--%>
<%--	{id:"note_div",title:"工作计划",def_tab:"right_tab",cur_tab:null,left_h:300,main_h:500,right_h:280},--%>
<%--	{id:"notice_div",title:"公告",def_tab:"right_tab",cur_tab:null,left_h:300,main_h:500,right_h:200}--%>
);


var div_list_tmp_infos=new Array(
	{id:"multi_used_div"
		,small_list_tmp_info:{id:"multi_used_acc_small",page_size:8}
		,main_list_tmp_info:{id:"multi_used_acc_main",page_size:25}},
		
	{id:"last_used_div"
		,small_list_tmp_info:{id:"last_used_acc_small",page_size:8}
		,main_list_tmp_info:{id:"last_used_acc_main",page_size:15}}
		
<%--	{id:"flow_div",small_list_tmp_info:{id:"flow_small",page_size:8}--%>
<%--		,main_list_tmp_info:{id:"flow_main",page_size:15}},--%>
	
<%--	{id:"calendar_div",small_list_tmp_info:{id:"tom_calendar",page_size:8}--%>
<%--		,main_list_tmp_info:{id:"tom_calendar",page_size:15}},	--%>
	
<%--	{id:"note_div",small_list_tmp_info:{id:"work_project_small",page_size:8}--%>
<%--		,main_list_tmp_info:{id:"work_project_main",page_size:15}}--%>
<%--	//,{id:"notice_div"}--%>
);
</script>
</head> 

<!------------------------------------tabs DIV 模板 ------------------------------------------------------>
<div class="portal-div" style="display:none" id="div_template">
<table border="0" cellpadding="0" cellspacing="0" class="portal-table" >
	<tr class="portal-title-tr" >
		<td id="div_template_title" name="div_template_title" onMousedown="portalDrag.downObj()">&nbsp;</td>
		<td width="15px" align="center" >
			<img src='/public/img/sso/shrink.png' 
			id="div_template_img_win_act"
			onclick="div_min()"
			style="cursor:pointer;" 
			title="收缩." />&nbsp;
		</td>			
	</tr>
	<tr>
		<td colspan="2" valign="top" id="list_area">
			
		</td>
	</tr>
</table>
</div>
<script LANGUAGE="JavaScript">
	function div_max(){
		var src_obj=event.srcElement;
		var div=getFather(src_obj,"div");		
		
		var div_info=tabs.get_div_info(div);
		
		if(div_info.cur_tab == "main_tab"){
			return ;
		}
		
		
		
		div_info.cur_tab="main_tab";
		
		var tr=main_tab.insertRow(0);
		var td=tr.insertCell(0);		
		td.innerHTML=div.outerHTML;	
		
		moveContainer.rmTd(div.parentNode);			
		
		tabs.setup_div_content(td.children(0),div_info,div_info.cur_tab);
		
		
		
	}
	
	function div_min(){
		var src_obj=event.srcElement;
		var div=getFather(src_obj,"div");
		
		var div_info=tabs.get_div_info(div);
				
		if(div_info.cur_tab == div_info.def_tab){
			return ;
		}
		
		
		
		div_info.cur_tab=div_info.def_tab;
				
		var tr=$(div_info.cur_tab).insertRow(0);
		var td=tr.insertCell(0);		
		
		td.innerHTML=div.outerHTML;		
		
		moveContainer.rmTd(div.parentNode);	
		
		tabs.setup_div_content(td.children(0),div_info,div_info.cur_tab);		
		
	}
	
	

</script>
<!------------------------------------tabs ------------------------------------------------------>

<body onload="tabs.ini();" style="-moz-user-select:none;background-color: #FFFFFF;">
<table width="100%" cellspacing="5" cellpadding="0" border="0" id="portal_table">
	<tr>
		<td width="300px" valign="top">
			<table border="0" cellpadding="5" cellspacing="0" width="100%" id="left_tab" >
							
			</table>
		</td>
		<td valign="top">
			<table border="0" cellpadding="5" cellspacing="0" width="100%" id="main_tab">
							
			</table>
		</td>
		<td width="300px" valign="top">
			<table border="0" cellpadding="5" cellspacing="0" width="100%" id="right_tab">		
				
			</table>
		</td>
	</tr>
</table>

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

<!------------------------------------列表 模板 ------------------------------------------------------>
<div id="base_list_template" style="display:none">
<table border=0 cellpadding="0" cellspacing="0" class="layout-table">
	<form name="list_form" method="post">
	<input type=hidden name="list_id" value=''>
	<tr id="list_container">
		<td class="td1">
			<table cellpadding="0" cellspacing="0" class="tab">
				<tr> 
					<td width="25px" align="center"><img width="16" height="16" src='/public/img/body/yuan_list.png'/></td>
					<td width="10%"><B class="path-font" id="list_title">[]</B></td>   
					<td class="pages-align" align="right">
						<table cellspacing="0" cellpadding="0" >							
							<tr id="list_query">
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr id="page_head">
		<td class="td2" style="padding-right:0;">
			<table cellpadding="0" cellspacing="0" class="tab" style="background-color:#DFE8F6;border:1px solid #8FB4E5">			
				<tr>
					<td class="pages-align" id="list_act">						
					</td>	
					<td class="pages-align" align="right">
					<div class="pages-div" id="page_contain_0">
					</div>
					</td>
				</tr>				
			</table>
		</td>
	</tr>	
	<tr>
		<td class="td3" style="padding-right:0;overflow: hidden;">			
			<table id="tab"  align="center" cellspacing="0" cellpadding="0" height="100%">			 			
  				<tr class="list-title-tr" id="list_head">  				
				</tr>
				<tr style="height: 100%">
					<td>
						<div style="height: 100%;width: 100%;border: 0;overflow-y:scroll;overflow-x:auto; ">
							<table cellpadding="0" cellspacing="0" width="100%" id="list_data">
															
							</table>
						</div>
					</td>
				</tr>				
			</table>
			
		</td>
	</tr>	
	<tr id="page_tail">
		<td class="td2" style="padding-right:0;">
			<table cellpadding="0" cellspacing="0" class="tab" style="background-color:#DFE8F6;border:1px solid #8FB4E5">			
				<tr>	
					<td class="pages-align" align="right">
						<div class="pages-div" id="page_contain_1">
						</div>
					</td>
				</tr>				
			</table>			
		</td>
	</tr>
	</form>
</table>
</div>
<script LANGUAGE="JavaScript" src="/public/framePages/sso/portal_list_base.js"></script>
<script LANGUAGE="JavaScript" src="/public/framePages/sso/portal_list_res_acc.js"></script>
<script LANGUAGE="JavaScript">	

	var multi_used_acc_small = new SmallResAccListCls("multi_used_acc_small");
	var last_used_acc_small = new SmallResAccListCls("last_used_acc_small");
	
	var multi_used_acc_main = new MainResAccListCls("multi_used_acc_main");
	var last_used_acc_main = new MainResAccListCls("last_used_acc_main");
	
	function SmallFlowCls(id){
	
		BaseListTemplateCls.call(this);
	
		this.id=id;	
		
		this.page_info={is_main:false,head_display:false,tail_display:true};
		
		this.options_type=[
							["","全部"]
							,["10","自然人入职单"],["20","自然人变更单"]
							,["30","自然人离职单"],["40","资源(设备、应用)接入单"]
							,["50","资源账号授权单"]
							
						];
						
		this.options_status=[
							["","全部"]
							,["0","初始"],["10","待审批"]
							,["20","待执行"],["30","归档"]							
							];
							
		this.head_info=[
			{title:"标号",width:35}
			,{title:"类&nbsp;型"}
			,{title:"状态",width:80}
			,{title:"&nbsp;",width:18}
		];
			
		
		this.get_list_type=function(){
			return "flow";
		}
		
		this.get_btn=function(seq,status){
			var pop_url="/aim/portal/flow/data.do?method=modifyIni&ret=no&rdn="+seq;			
			var btn="<span onclick=\"open_pop_win('"+pop_url+"')\">"
			btn+=status;
			btn+="</span>"
			return btn;
		}
		
		this.insert_cells=function (row,cell_data_ary){
			//alert(cell_data_ary);
			var arg ={
				i:cell_data_ary[0]
				,type:this.option_value(this.options_type,cell_data_ary[1])
				,status:this.option_value(this.options_status,cell_data_ary[2])
				,seq:cell_data_ary[3]					
			};
			
			
			var cell=null;
		
			this.add_cell(row,this.head_info[0],arg.i);
			cell=this.add_cell(row,this.head_info[1],arg.type);			
			cell=this.add_cell(row,this.head_info[2],this.get_btn(arg.seq,arg.status));		
			cell.style.cursor="hand";
		}		
						
	}
	
	//var flow_small = new SmallFlowCls("flow_small");
	
	function MainFlowCls(id){
	
		SmallFlowCls.call(this);
	
		this.id=id;	
		
		this.title="流程";
		this.query_items=[
						{title:"类型",type:"select",name:"type"	,options:this.options_type	}						
						,{title:"状态",type:"select",name:"status",options:this.options_status}											
					];	
		
		this.page_info={is_main:true,head_display:true,tail_display:true};
							
		this.head_info=[
			{title:"标号",width:35}
			,{title:"时&nbsp;刻",width:180}
			,{title:"填&nbsp;单&nbsp;人",width:150}
			,{title:"类&nbsp;型"}
			,{title:"状&nbsp;态",width:150}
			,{title:"&nbsp;",width:18}
		];
				
		this.debug_data_line=function(data_line){
			//alert(data_line);
		}	
		
		this.insert_cells=function (row,cell_data_ary){
			//alert(cell_data_ary);
			var arg ={
				i:cell_data_ary[0]
				,crt_time:cell_data_ary[1]
				,crt_uid:cell_data_ary[2]
				,type:this.option_value(this.options_type,cell_data_ary[3])
				,status:this.option_value(this.options_status,cell_data_ary[4])
				,seq:cell_data_ary[5]					
			};			
			
			var cell=null;
		
			this.add_cell(row,this.head_info[0],arg.i);
			cell=this.add_cell(row,this.head_info[1],arg.crt_time);
			cell=this.add_cell(row,this.head_info[2],arg.crt_uid);
			cell=this.add_cell(row,this.head_info[3],arg.type);			
			cell=this.add_cell(row,this.head_info[4],this.get_btn(arg.seq,arg.status));		
					
			//cell.style.cursor="hand";			
			
		}
					
	}
	
	//var flow_main=new MainFlowCls("flow_main");	
	
	function SmallWorkProjectCls(id){
	
		BaseListTemplateCls.call(this);
	
		this.id=id;
		
		this.prj_date=null;
		
		this.page_info={is_main:false,head_display:false,tail_display:true};		
			
		this.head_info=[
			{title:"标号",width:35}
			,{title:"执行时刻"}
			,{title:"&nbsp;",width:18}
		];
			
		this.get_list_type=function(){
			return "work_project";
		}
		
		this.build_query_items_args=function(args,form){
			for(var i=0;this.query_items!=null && i<this.query_items.length;i++){
				var item=this.query_items[i];
				args=this.arg(args,item.name,form.elements(item.name).value);
			}
			
			if(this.prj_date==null){
				return null;
			}
			
			args=this.arg(args,"prj_date",this.prj_date);
			
			return args;
		}
		
		this.insert_cells=function (row,cell_data_ary){
			//alert(cell_data_ary);
			var arg ={
				i:cell_data_ary[0],
				prj_date:cell_data_ary[1],
				prj_time:cell_data_ary[2],
				title:cell_data_ary[3],
				seq:cell_data_ary[4]					
			};
			
			
			var cell=null;
		
			this.add_cell(row,this.head_info[0],arg.i);
			
			var pop_url="/aim/portal/work_prj/data.do?method=modifyIni&ret=no&rdn="+arg.seq;
			var prj_date_time="<span onclick=\"open_pop_win('"+pop_url+"')\">"
			prj_date_time+=arg.prj_date+" "+arg.prj_time;
			prj_date_time+="</span>"
			//alert(prj_date_time);
			cell=this.add_cell(row,this.head_info[1],prj_date_time);	
					
			cell.style.cursor="hand";
			cell.title=arg.title;
			
		}
					
	}
	
	//var work_project_small = new SmallWorkProjectCls("work_project_small");
	
	function MainWorkProjectCls(id){
	
		SmallWorkProjectCls.call(this);
	
		this.id=id;	
		
		this.page_info={is_main:true,head_display:true,tail_display:true};		
			
		this.head_info=[
			{title:"标号",width:35}
			,{title:"创建时刻",width:150}
			,{title:"执行时刻",width:150}			
			,{title:"标&nbsp;题"}
			,{title:"&nbsp;",width:18}
		];
			
		
		this.get_list_type=function(){
			return "work_project";
		}
		
		this.insert_cells=function (row,cell_data_ary){
			//alert(cell_data_ary);
			var arg ={
				i:cell_data_ary[0],
				crt_time:cell_data_ary[1],
				prj_date:cell_data_ary[2],
				prj_time:cell_data_ary[3],
				title:cell_data_ary[4],
				seq:cell_data_ary[5]					
			};
			
			
			var cell=null;
		
			this.add_cell(row,this.head_info[0],arg.i);			
			
			cell=this.add_cell(row,this.head_info[1],arg.crt_time);
			
			cell=this.add_cell(row,this.head_info[2],arg.prj_date+" "+arg.prj_time);	
			
			
			var pop_url="/aim/portal/work_prj/data.do?method=modifyIni&ret=no&rdn="+arg.seq;
			var title="<span onclick=\"open_pop_win('"+pop_url+"')\">"
			title+=arg.title;
			title+="</span>"
			cell=this.add_cell(row,this.head_info[3],title);
			cell.style.cursor="hand";		
			
		}
					
	}
	
	//var work_project_main = new MainWorkProjectCls("work_project_main");
	
</script>


<!-- -日历 -->

<div id="calendar_template" style="display:none">
<table border=1 name="tom_cal_tab" width="100%" class="tab" style="background-color:#DFE8F6;border:1px solid #8FB4E5"
	onclick="tom_cal_day_click()"	>
<tr class="td2">
	<td colspan=7 align=center>
		<table width=100%>
			<tr>
				<td onclick=tom_calendar_to("month_prev") align='center' style="cursor:hand" name="month_prev">
					<
				</td>
				<td colspan=5 align='center' >
					<select name="tom_cal_year" onchange="select_change()">			
					</select>
					<select name="tom_cal_month" onchange="select_change()">			
					</select>
				</td>
				<td  onclick=tom_calendar_to('month_next') align='center' style="cursor:hand" name="month_next">
					>
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr class="pop-up-title-tr">
	<td width=25 align='center'>日</td>
	<td width=25 align='center'>一</td>
	<td width=25 align='center'>二</td>
	<td width=25 align='center'>三</td>
	<td width=25 align='center'>四</td>
	<td width=25 align='center'>五</td>
	<td width=25 align='center'>六</td>
</tr>
<tr>
	<td colspan=7  align='center' style="cursor:hand" onclick="tom_cal_today()">本&nbsp;&nbsp;&nbsp;&nbsp;月</td>	
</tr>
</table>
</div>
<script LANGUAGE="JavaScript">
<!--
	
	function tom_calendar_to(act){
		var srcObj=event.srcElement;
		var div=getFather(srcObj,"div");
		
		eval(div.id+".to('"+act+"')");
	}
	
	function select_change(){
		var srcObj=event.srcElement;
		var div=getFather(srcObj,"div");
		
		eval(div.id+".build()");
	}
	
	function tom_cal_today(){
		var srcObj=event.srcElement;
		var div=getFather(srcObj,"div");
		
		eval(div.id+".to_today()");
	}
	
	function tom_cal_day_click(y,m,d){
		var srcObj=event.srcElement;
		var div=getFather(srcObj,"div");
		
		eval(div.id+".set_rel_prj_date('"+srcObj.year+"','"+srcObj.month+"','"+srcObj.day+"')");
	}

	function TomCalendar(id){
		
		BaseXmlHttpCls.call(this);
		
		this.template=null;
		
		this.id=id;
		
		this.cal_tab=null;
		this.cal_year_select=null;		
		this.cal_month_select=null;
		this.month_prev=null;
		this.month_next=null;
		this.today_btn=null;
		
		this.prj_of_month=null;
		
		this.set_rel_prj_date=function(y,m,d){
			var month="0"+m;
			month=month.length==3?month.substr(1):month;
			
			var d_of_m="0"+d;
			d_of_m=d_of_m.length==3?d_of_m.substr(1):d_of_m;
			
			
			var div_info=tabs.get_div_info_by_id("calendar_div");
			
			//var work_project=$("work_project_small");
			//alert(work_project);
									
			work_project_small.prj_date=y+"-"+month+"-"+d_of_m;
			work_project_main.prj_date=y+"-"+month+"-"+d_of_m;
			
			var small=$("work_project_small");
			var main=$("work_project_main");
			
			if(small){
				work_project_small.query_rlv("turn_page");
			}
			
			if(main){
				work_project_main.query_rlv("turn_page");
			}
		}
		
		this.get_prj_list_month=function(year,month){
			
			var month="0"+month;
			month=month.length==3?month.substr(1):month;
			
			
		
			var url="/aim/portal.do";
			var xmlHttp=new XmlHttpConstruct(url);		
			xmlHttp.send("method=query&list_type=work_project_month&q_y_m="+year+"-"+month);		
			var rs=xmlHttp.resText();
						
			//alert(rs);
			
			this.prj_of_month=this.get_payload(rs);
			
			//alert(this.prj_of_month.toString());
			//return rs;
		}
				
		this.build=function(){
			this.clear();
	
			var year=this.cal_year_select.value;
			var month=this.cal_month_select.value;
			
			this.get_prj_list_month(year,month);
	
			var date=new Date(year,month-1,1);			
			
			var now=new Date();
			var today=(year==now.getFullYear() && month-1 == now.getMonth())?now.getDate():-1;
	
			this.set_rel_prj_date(year,month,today);
			
			//alert(month);
			var end_of_month=31;
			switch (month)
			{
				case "2":
					end_of_month=(0==year%4 && (year%100!=0 || year%400==0)) ? 29 : 28;
					break;
				case "4":
				case "6":
				case "9":
				case "11":
					end_of_month=30;
			
			}		
	
			var beg_of_week=date.getDay();
			var tr=null;
			for(var i=0;i<42;i++){			
				
				if(i%7 == 0){
					tr=this.cal_tab.insertRow(this.cal_tab.rows.length-1);
				}
	
				var td=tr.insertCell();				
				td.style.backgroundColor="white";
				var day_of_month=i - beg_of_week +1;
					
				if(i < beg_of_week || day_of_month > end_of_month){
					td.innerHTML="&nbsp;"
				}else{
					this.build_td(td,year,month,day_of_month,today);
				}
				
			}
		}
	
		this.clear=function(){
			while(this.cal_tab.rows.length > 3){
				this.cal_tab.deleteRow(2);
			}
		}
		
		this.build_td=function(td,year,month,d_of_m,today){
			var content=d_of_m;		
			
			td.style.cursor="hand";
			td.align='center';
			td.innerHTML=content;
			
			td.year=year;
			td.month=month;
			td.day=d_of_m;
			
			if(d_of_m == today){
				td.style.color='red';	
			}	
			
			if(this.day_has_prj(year,month,d_of_m)){
				//td.style.backgroundColor='#DFE8F6';				
				td.style.backgroundColor='yellow';	
			}	
			
			return ;
		}
		
		this.day_has_prj=function(year,m,d){
			var month="0"+m;
			month=month.length==3?month.substr(1):month;
			
			var d_of_m="0"+d;
			d_of_m=d_of_m.length==3?d_of_m.substr(1):d_of_m;
			
			var date=year+"-"+month+"-"+d_of_m;
			
			for(var i=1;this.prj_of_month!=null && i<this.prj_of_month.length;i++){
				var prj_date=this.prj_of_month[i];
				//alert(prj_date + "-" + date);
				if(prj_date.indexOf(date)!=-1){
					return true;
				}
			}
			
			return false;
			
		}
		
		this.ini=function(container){
			//
			if(container!=null){
				//alert(1);
				container.innerHTML=calendar_template.outerHTML;
				container.children(0).id=this.id
				this.template=$(this.id);
				this.template.style.display="";
				
				this.cal_tab=getChildByName(this.template,"tom_cal_tab");
				this.cal_year_select=getChildByName(this.template,"tom_cal_year");		
				this.cal_month_select=getChildByName(this.template,"tom_cal_month");				
				
				//alert(this.template.innerHTML);
				
			}else{
				
				return ;
			}
			
		
			this.to_today();
			
			//alert(this.template.innerHTML);
		}
		
		this.to_today=function(){
			var date=new Date();
			
			var options_year=this.cal_year_select.options;
			while(options_year.length > 0){
				options_year.remove(0);
			}
			for(var i=0;i<5;i++){
				var option=new Option( date.getFullYear() -1 + i + " 年" , date.getFullYear() -1 + i);			
				options_year.add(option);
			}
	
			var options_month=this.cal_month_select.options;
			while(options_month.length > 0){
				options_month.remove(0);
			}
			for(var i=0;i<12;i++){
				var m=i+1;
				if(m<10){
					m+=" ";
				}
				m+="月";
				
				var option=new Option( m ,  i+1);			
				options_month.add(option);
			}
	
			this.cal_year_select.value=date.getFullYear();
			this.cal_month_select.value=date.getMonth()+1;
	
			this.build();
		}
	
		this.to=function(act){
			//alert(act);
			var year=this.cal_year_select.value;
			var month=this.cal_month_select.value;
	
			if(act=="month_prev"){
				month--;
			}
	
			if(act=="month_next"){
				month++;
			}
			
			if(month == 0){
				year--;
				month=12;
			}else if(month == 13){
				year++;
				month=1;
			}
			
			var options_year=this.cal_year_select.options;
			if(year > options_year[options_year.length-1].value){
				year = options_year[options_year.length-1].value;
				month=12;
			}else if(year < options_year[0].value){
				year = options_year[0].value;
				month=1;
			}
	
			this.cal_year_select.value=year;
			this.cal_month_select.value=month;
	
			this.build();
		}
			
	}
	
	//var tom_calendar=new TomCalendar("tom_calendar");
//-->
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
	
	function open_pop_win_sso_approval(url,w,h){
		if(w==null){
			var w="650";
		}
		
		if(h==null){
			var h="548";
		}
		
		
		var html=title_ctr_0.innerHTML;
		html=html.replace("rm_menu_div()","rm_menu_div();sso_approval_win_close()");
		title_ctr_0.innerHTML=html;
		title_ctr_1.innerHTML=html;
		
				
		
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
	
	function get_token(token, url) {
		var xmlHttp=new XmlHttpConstruct("/aim/sso.do");		
		xmlHttp.send(token);		
		var rs=xmlHttp.resText();
		
		if(rs!=null && rs.indexOf("SIMP_EOR")!=-1) {
			alert(rs);
			return;
		}
	       		
		url += "&sid=" + rs;
		
		open_pop_win(url,500,350);
	}
	
	function add_to_favorites(seq) {
		var e = event || window.event;
		var src = e.srcElement;
		
		var xmlHttp=new XmlHttpConstruct("/aim/portal.do", true);	
		if (src.src.indexOf("favorite_16.png") != -1) {
			xmlHttp.send("method=add_to_favorites&seq="+seq + "&act=0");
			src.src = "/public/img/sso/favorited_16.png";
		} else {
			xmlHttp.send("method=add_to_favorites&seq="+seq + "&act=1");	
			src.src = "/public/img/sso/favorite_16.png";
		}
	}
	
</script>
<div id="message_div" class="pop-up-div">
<jsp:include flush="true" page="message/message_div.jsp"></jsp:include>
</div>
<script type="text/javascript">
	if(form_msg.msg_count!=null){
		menu_div(this,'message_div','350','330','message_automatic','no');
	}
</script>


