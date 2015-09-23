<%@ page language="java" pageEncoding="GBK"%>
<%@taglib uri="SimpTags" prefix="simp"%>

<%@ page import="com.simp.action.ProxyUser"%>

<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.BufferedWriter"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="java.io.OutputStreamWriter"%>
<%@ page import="java.net.Socket"%>
<%@ page import="java.net.UnknownHostException"%>
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
<%
String userId = ProxyUser.getProxyUser(request).getId();
System.out.println("====>>>userId="+userId);

String itilFilter = "0";
String whiteList = "";
String itilAuth = "";

FortServiceApiTestWorker workerForItilFilter = new FortServiceApiTestWorker("127.0.0.1", 9777, "Config itil_filter true");
workerForItilFilter.run();
itilFilter = workerForItilFilter.getResponse();
if(itilFilter == null)itilFilter = "0";

if("1".equals(itilFilter)){
    FortServiceApiTestWorker workerForWhiteList = new FortServiceApiTestWorker("127.0.0.1", 9777, "Config white_list true");
    workerForWhiteList.run();
    whiteList = workerForWhiteList.getResponse();
    if(whiteList == null)whiteList = "";
    String[] whiteListArr = whiteList.split(",");
    if(whiteListArr == null)whiteListArr = new String[0];
    boolean inWhiteList = false;
    for(String whiteName : whiteListArr){
        if(whiteName.equals(userId)){
            inWhiteList = true;
            break;
        }
    }
    if(!inWhiteList){
        FortServiceApiTestWorker workerForItilAuth = new FortServiceApiTestWorker("127.0.0.1", 9777, "{\"personAccount\":\"" + userId + "\",\"operation\":\"getItilAuthorization\",\"fortEnv\":\"true\"}");
        workerForItilAuth.run();
        itilAuth = workerForItilAuth.getResponse();
        if(itilAuth == null)itilAuth = "";
    }
}
%>

<html>  
<head>
<title></title>
<link rel="stylesheet" type="text/css" href='/public/css/public.css'>
<link rel="stylesheet" type="text/css" href='/public/css/button.css'>
<link rel="stylesheet" type="text/css" href='/public/css/sso.css'>
<script LANGUAGE="JavaScript" src="/public/js/XmlHttp.js"></script>
<script LANGUAGE="JavaScript" src="/public/framePages/sso/portal_function.js"></script>
<script src='/public/script/body_div.js'></script>

<script>
var fa_userId = "<%=userId%>";
var fa_itilFilter = "<%=itilFilter%>";
var fa_whiteList = "<%=whiteList%>";
var fa_itilAuth = "<%=itilAuth%>";

function faStrToDate(fDate){  
    var fullDate = fDate.split(" ")[0].split("-");  
    var fullTime = fDate.split(" ")[1].split(":");  
    return new Date(fullDate[0], fullDate[1]-1, fullDate[2], (fullTime[0] != null ? fullTime[0] : 0), (fullTime[1] != null ? fullTime[1] : 0), (fullTime[2] != null ? fullTime[2] : 0));  
}

function itilAuthJudge(ip, resAccount){
    if(fa_itilFilter == "0")return true;//Itil过滤关闭，可以单点登录
    var whiteNameArr = fa_whiteList.split(",");
    for(var index = 0; index < whiteNameArr.length; index++){
        if(whiteNameArr[index] == fa_userId){
            return true;//在Itil过滤白名单中，可以单点登录
        }
    }
    var itilAuthArr = fa_itilAuth.split(";");
    for(var index = 0; index < itilAuthArr.length; index++){
        if(itilAuthArr[index].indexOf(fa_userId+","+ip+","+resAccount+",") == 0){
            var authParmArr = itilAuthArr[index].split(",");
            var startDatetime = faStrToDate(authParmArr[3]);
            var endDatetime = faStrToDate(authParmArr[4]);
            var currentDatetime = new Date();
            if(startDatetime.getTime() <= currentDatetime.getTime() && currentDatetime.getTime() <= endDatetime.getTime()){
                return true;//有Itil授权，可以单点登录
            }
        }
    }
    return false;//没有Itil授权，不可以单点登录
}
</script>



</head>
<OBJECT ID="sso" WIDTH="0" HEIGHT="0" CLASSID="CLSID:24633CC3-641F-46E8-844E-52545262BEF2" >
</OBJECT>
<body>
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
						<td width=100><B class="path-font">[授权列表]</B></td>   
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
		/*
		this.add_query_item=function(tr,item){
			var td=tr.insertCell();
			td.innerHTML="&nbsp;&nbsp;"+item.title+"：&nbsp;";			
			
			td=tr.insertCell();
		
			if(item.type=="select"){
				td.innerHTML=this.get_select_tag(item);
			}else if(item.type=="input"){
				var html="<input name='"+item.name+"' onkeyup='" + this.id+ ".on_key_search(this)' ";
				if(item.size!=null){
					html+="size='"+item.size+"'";
				}
				html+="/>";
				td.innerHTML=html;
			}
		}
		*/
		
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
			}			
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
		
					
		this.head_info=[
			{title:"标号",width:40}
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
			return "acc_main";
		}
		
		this.get_query_url=function(){
			var url="/aim/portal.do";
			return url;
		}
		
		this.get_query_method=function(){
			return "query";
		}
		
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
				org:cell_data_ary[10]
			};
			
			var issuer=select_tag_issuer(arg.issuer,"issuer_ip_select");
					
			this.add_cell(row,this.head_info[0],arg.i);	
			this.add_cell(row,this.head_info[1],space(2)+arg.org,"left", true);			
			this.add_cell(row,this.head_info[2],space(2)+arg.aname,"left", true);			
			this.add_cell(row,this.head_info[3],arg.aip);
			this.add_cell(row,this.head_info[4],issuer);			
			this.add_cell(row,this.head_info[5],space(2)+arg.account,"left");			
			
         if("undefined" == typeof itilAuthJudge){//alert(1);
             this.add_cell(row,this.head_info[6],space(2)+this.get_action(arg),"left");      
             this.add_cell(row,this.head_info[7],space(2)+this.tools_action(arg),"left");            
         }else{//alert(2);
             if(itilAuthJudge(arg.aip, arg.account)){//alert(3);
                 this.add_cell(row,this.head_info[6],space(2)+this.get_action(arg),"left");      
                 this.add_cell(row,this.head_info[7],space(2)+this.tools_action(arg),"left");            
             }else{//alert(4);
                 this.add_cell(row,this.head_info[6],space(2),"left");      
                 this.add_cell(row,this.head_info[7],space(2),"left");            
             }
         }
			
			
			this.add_cell(row,this.head_info[8],space(2)+this.logs_action(arg),"left");		
			
		}	
				
	}
	
	var main_res_acc_list = new Main_Res_Auth_AccListCls("main_res_acc_list");
	
	main_res_acc_list.ini(20);

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
