//------------列表对象区----------
	
	function SmallResAccListCls(id){
	
		BaseListTemplateCls.call(this);
	
		this.id=id;				
		
		this.page_info={is_main:false,head_display:false,tail_display:true};
							
		this.head_info=[
			{title:"标号",width:35}
			,{title:"地&nbsp;址",width:110}
			,{title:"账&nbsp;号"}
			,{title:"&nbsp;",width:18}
		];
		
		this.get_list_type=function(){
			return "acc";
		}
		
		this.insert_cells=function (row,cell_data_ary){
			var arg ={
				i:cell_data_ary[0],
				atype:cell_data_ary[1],
				aip:cell_data_ary[2],
				issuer:cell_data_ary[3],
				account:cell_data_ary[4],
				seq:cell_data_ary[5],
				rdn:cell_data_ary[7],
				protocol:cell_data_ary[8]	
			};
			
			
			var cell=null;
		
			this.add_cell(row,this.head_info[0],arg.i);
			cell=this.add_cell(row,this.head_info[1],arg.aip);
			
			
			var url="/aim/portal/sso_tools.jsp?rdn="+arg.rdn;			
			
			var acc="<span onclick=\"open_pop_win('"+url+"',500,350)\">";
			acc+=space(1)+arg.account;
			acc+="</span>"
			cell=this.add_cell(row,this.head_info[2],acc,"left");
			cell.style.cursor="hand";			
			
		}			
	}
	

	
	function MainResAccListCls(id){
	
		SmallResAccListCls.call(this);
	
		this.id=id;	
		
		this.options_type=[
						["","全部"],["unix","unix主机"],["aix","Aix主机"],["solaris","Solaris主机"],["linux","Linux主机"],["windows","windows主机"]
						,["winADC","windows域控制器"],["winAD","windows域内主机"]
						,["db","数据库"],["radiusNet","网络设备(radius)"]
						,["localNet","网络设备(local)"],["otherNet","网络设备(其他)"]
						,["application","应用系统"],["middleware", "中间件"]
						,["dp","自动化部署平台"]
					];
						
		
		this.title="授权账号";
		this.query_items=[
						{title:"资源类型",type:"select",name:"type",options:this.options_type	}		
						
						,{title:"资源名称",type:"input",name:"asset",size:15}
						
						,{title:"精确查询-&gt;",type:"checkbox",name:"exact"}
						,{title:"资源IP",type:"input",name:"aip",size:15}
						
						,{title:"账号",type:"input",name:"account",size:10}
					];
		
		
		
		this.page_info={is_main:true,head_display:true,tail_display:true};
		//this.list_act="<input type='button' value='操作' \>"
		
					
		this.head_info=[
			{title:"标号",width:40}
			,{title:"名&nbsp;称"}
			,{title:"地&nbsp;址",width:110}
			,{title:"应&nbsp;用&nbsp;发&nbsp;布",width:150}
			,{title:"账&nbsp;号",width:100}
			,{title:"标&nbsp;准&nbsp;工&nbsp;具",width:170}
			,{title:"工具集",width:50}
			,{title:"日&nbsp;志",width:50}
			,{title:"收藏夹",width:50}
			,{title:"&nbsp;",width:18}
		];
		
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
				fav:cell_data_ary[10]
			};
			
			var issuer=select_tag_issuer(arg.issuer,"issuer_ip_select");
					
			this.add_cell(row,this.head_info[0],arg.i);			
			this.add_cell(row,this.head_info[1],space(2)+arg.aname,"left", true);			
			this.add_cell(row,this.head_info[2],arg.aip);
			this.add_cell(row,this.head_info[3],issuer);			
			this.add_cell(row,this.head_info[4],space(2)+arg.account,"left");			
			this.add_cell(row,this.head_info[5],space(2)+this.get_action(arg),"left");		
			this.add_cell(row,this.head_info[6],space(2)+this.tools_action(arg),"left");			
			this.add_cell(row,this.head_info[7],space(2)+this.logs_action(arg),"left");		
			this.add_cell(row,this.head_info[8],space(2)+this.fav_action(arg),"left");
		}
		
		this.get_action=function (arg){			
			
			var html="";
			
			
			if(arg.atype=="unix" || arg.atype=="aix" || arg.atype=="solaris" || arg.atype=="linux"){			
				html+=this.unix_action(arg);
				//html+=space(4);
			}else if(arg.atype.indexOf("win")!=-1){
				html+=this.win_action(arg);
				//html+=space(4);
			}else if(arg.atype.indexOf("Net")!=-1){
				html+=this.net_action(arg);
				//html+=space(4);
			}else if(arg.atype.indexOf("db")!=-1){
				html+=this.db_action(arg);
				//html+=space(4);
			}else if(arg.atype.indexOf("application")!=-1){
				html+=this.application_action(arg);
				//html+=space(4);
			} else if(arg.atype.indexOf("dp")!=-1){
				html+=this.application_action(arg); 
			} else if(arg.atype.indexOf("middleware")!=-1){
				html+=this.application_action(arg);
				//html+=space(4);
			}else{
				alert(arg.atype);
			}
			
			return html;			
		}
		
		this.unix_action=function(arg){
			var html="";
			//var show_sid = false;
			
			if(arg.protocol.indexOf("ssh")!=-1 || arg.protocol.indexOf("telnet")!=-1){
				html += this.scrt_action(arg);
				html += this.xshell_action(arg);
				//show_sid = true;
			}
				
			if(arg.protocol.indexOf("xwin")!=-1 || arg.protocol.indexOf("vnc")!=-1){
				html += this.rdp_action(arg);
			}
			
			if(arg.protocol.indexOf("sftp")!=-1 || arg.protocol.indexOf("ftp")!=-1){
				html += this.xftp_action(arg);
			}
			
			//if (show_sid) {
			//	html += this.cmd_sid_action(arg);
			//}
			
			return html;
		}
		
		this.win_action=function(arg){
			var html="";
			//var show_sid = false;
			
			if (arg.protocol.indexOf("rdp")!=-1 || arg.protocol.indexOf("vnc")!=-1) {
				html += this.rdp_action(arg);
				//show_sid = true;
			}
			
			if(arg.protocol.indexOf("sftp")!=-1 || arg.protocol.indexOf("ftp")!=-1 || arg.protocol.indexOf("smb")!=-1){
				html += this.xftp_action(arg);
			}
			
			//if (show_sid) {
			//	html += this.rdp_sid_action(arg);
			//}
			
			return html;			
		}
		
		this.net_action=function(arg){
			var html="";
			html += this.scrt_action(arg);
			
			return html;		
		}
		
		this.db_action=function(arg){
			var html="";
			//alert(arg.protocol);
			
			if (arg.protocol.indexOf("db2_") == 0) {
				return this.db2_action(arg);
			}
			
			if (arg.protocol.indexOf("informix_") == 0) {
				return this.informix_action(arg);
			}
			
			switch(arg.protocol){
				case "oracle":
					return this.oracle_action(arg);
				case "mssql":
					return this.mssql_action(arg);
				case "mssql2005":
					return this.mssql2005_action(arg);
				case "mssql2008":
					return this.mssql2008_action(arg);
				case "mysql":
					return this.mysql_action(arg);
				case "sybase":
					return this.sybase_action(arg);
				break;
			}
			
			return html;	
		}
		
		this.application_action=function(arg){
			var html="";
			//alert(arg.protocol);
			
			switch(arg.protocol){
				case "common_web":
					html= app_icon('sso_ie.png',"main_list_app_open", "broswer", arg,2);
					break;
				case "broswer_com":
					html= app_icon('sso_ie.png',"main_list_app_open", "broswer_com", arg,2);
					break;
				case "broswer_dialog":
					html= app_icon('sso_ie.png',"main_list_app_open", "broswer_dialog", arg,2);
					break;
				case "symantec_netbackup":
					html= app_icon('sso_nbu.png',"main_list_app_open", arg.protocol, arg,2);
					break;
				case "brocade_switch":
					html= app_icon('sso_brocade_sw.png',"main_list_app_open", arg.protocol, arg,2);
					break;
				case "postgre_pgadmin":
					html= app_icon('sso_postgre.png',"main_list_app_open", arg.protocol, arg,2);
					break;
				case "tivoli_enter_potail":
					html=  app_icon('sso_tivoli.png',"main_list_app_open", arg.protocol, arg,2);
					break;
				case "minzu_hsrcp":
					html=  app_icon('sso_minzu_hsrcp.png',"main_list_app_open", arg.protocol, arg,2);
					break;
				case "sap_logon":
					html=  app_icon('sso_sap.png',"main_list_app_open", arg.protocol, arg,2);
					break;
				case "remote_admin":
					html=  app_icon('sso_remote_admin.png',"main_list_app_open", arg.protocol, arg,2);
					break;
				case "dameware":
					html=  app_icon('sso_dameware_dwrcc.png',"main_list_app_open", "dame_ware_dwrcc", arg,2);
					break;
				case "as400_os":
					html=  app_icon('sso_pcom_pcsfe.png',"main_list_app_open", "pcom_pcsfe", arg,2);
					break;
				case "vnc":
					html=  app_icon('sso_vnc.png',"main_list_app_open", "appagent_vnc", arg,2);
					break;
				case "weblogic":
					html= app_icon('sso_ie.png',"main_list_app_open", "broswer", arg,2);
					break;
				case "symantec_veritas_cluster_manager":
					html=  app_icon('veritas_cluster_manager_console.png',"main_list_app_open", "symantec_veritas_cluster_manager", arg,2);
					break;
				case "ibm_xiv_gui":
					html=  app_icon('xivgui.png',"main_list_app_open", "ibm_xiv_gui", arg,2);
					break;
				case "netstor_vtl300g2":
					html=  app_icon('vtl.png',"main_list_app_open", "netstor_vtl300g2", arg,2);
					break;
				case "vSphere_Client":
					html=  app_icon('vmware_vsphere.png',"main_list_app_open", "vSphere_Client", arg,2);
					break;
				case "action_request_system":
					html = this.action_request_system_action(arg);
					break;
				case "lotus_notes":
					html=  app_icon('sso_lotus_notes.png',"main_list_app_open", "lotus_notes", arg,2);
					break;
			}
			
			return html;	
		}
		
		this.oracle_action=function(arg){
			var rv="";
			
			rv+=this.icon('sso_plsql.png',"plsql_select_box_obj",arg,2,"plsql");	
			
			rv+=this.icon('sso_toad.png',"toad_select_box_obj",arg,2,"toad");
			
			rv+=app_icon('sso_sqldeveloper.png',"main_list_app_open", "sql_developer", arg,2);
			rv+=app_icon('sso_oracle_emc.png',"main_list_app_open", "oracle_emc", arg,2);
			
			//rv+=app_icon('sso_sqlplus.png',"main_list_app_open", "sqlplus", arg,2);
			
			return rv;
		}

		this.mssql_action=function(arg){
			var rv="";
			
			rv+=app_icon('sso_mssql_analyse.png',"main_list_app_open", "mssql_2000_query", arg,2);
			rv+=app_icon('sso_mysql_em.png',"main_list_app_open", "mssql_2000_em", arg,2);
			
			return rv;
		}
		
		this.mssql2005_action=function(arg){
			var rv="";
			
			rv+=app_icon('sso_mssql_express.png',"main_list_app_open", "mssql_2005_studio", arg,2);
			
			return rv;
		}
		
		this.mssql2008_action=function(arg){
			var rv="";
			
			rv+=app_icon('sso_mssql_express.png',"main_list_app_open", "mssql_2008_studio", arg,2);
			
			return rv;
		}	
		
		this.mysql_action=function(arg){
			var rv="";
			
			rv+=app_icon('mysql-front.png',"main_list_app_open", "mysql_front", arg,2);
			
			return rv;
		}
		
		this.sybase_action=function(arg){
			var rv="";
			
			rv+=app_icon('sso_dbisqlg.png',"main_list_app_open", "sybase_dbisqlg", arg,2);
			rv+=app_icon('sso_sybase.png',"main_list_app_open", "sybase_central", arg,2);
			return rv;
		}
		
		this.db2_action=function(arg){
			var rv="";
			/*
			if (arg.protocol == 'db2_unix') {
				rv+=this.scrt_action(arg);
			}
			*/
			
			rv+=app_icon('sso_toad.png',"main_list_app_open", "db2toad", arg,2);
			rv+=app_icon('sso_db2center.png',"main_list_app_open", "db2cc", arg,2);
			rv+=app_icon('que.png',"main_list_app_open", "db2_quest_central", arg,2);
			
			return rv;
		}
		
		this.informix_action=function(arg){
			var rv="";
			/*
			if (arg.protocol == 'db2_unix') {
				rv+=this.scrt_action(arg);
			}
			*/
			
			rv+=app_icon('sso_winsql.png',"main_list_app_open", "winsql", arg,2);
			
			return rv;
		}
		
		this.action_request_system_action=function(arg) {
			var rv = app_input("text", "bmc_app_port", "width:40px;", 2);
			
			rv+=action_request_system_app_icon('bmc_remedy_alert.png',"main_list_bmc_open", "bmc_remedy_alert", arg,2);
			rv+=action_request_system_app_icon('bmc_remedy_user.png',"main_list_bmc_open", "bmc_remedy_user", arg,2);
			
			return rv;
		}
		
		this.cmd_sid_action=function(arg){
			var fort_ip = getSSOFortIp();
			
			var token = "method=login&aip="+arg.aip+"&rdn="+arg.rdn+"&seq="+arg.seq;	
			token += "&type=cmd&protocol=ssh&fort_ip="+fort_ip;
				
			var url="/aim/portal/sso_sid.jsp?protocol=ssh&fort_ip=" + fort_ip;			
			var rv="<img style='cursor:hand' src='/public/img/sso/sso_sid.png' ";
			rv+="width='28' height='28' ";
			rv+="onClick=\"get_token('"+token+"','"+url+"')\" title='获取会话号'>";
			return rv;
		}
		
		this.rdp_sid_action=function(arg) {
			var fort_ip = getSSOFortIp();
			
			var token = "method=login&aip="+arg.aip+"&rdn="+arg.rdn+"&seq="+arg.seq;	
			token += "&type=graphic&protocol=rdp&fort_ip="+fort_ip;
			
			var url="/aim/portal/sso_sid.jsp?protocol=rdp&fort_ip=" + fort_ip;			
			var rv="<img style='cursor:hand' src='/public/img/sso/sso_sid.png' ";
			rv+="width='28' height='28' ";
			rv+="onClick=\"get_token('"+token+"','"+url+"')\" title='获取会话号'>";
			return rv;
		}
		this.scrt_action=function(arg){
			var rv="method=login&aip="+this.aip+"&rdn="+this.rdn+"&seq="+this.seq	
			var rv=this.icon('sso_crt.png',"scrt_select_box_obj",arg,2,"scrt");
			return rv;
		}
		this.xshell_action=function(arg){
			var rv="method=login&aip="+this.aip+"&rdn="+this.rdn+"&seq="+this.seq	
			var rv=this.icon('sso_xshell.png',"xshell_select_box_obj",arg,2,"xshell");
			return rv;
		}
		
		this.rdp_action=function(arg){
			var rv=this.icon('sso_rdp.png',"rdp_select_box_obj",arg,2,"mstsc");
			return rv;
		}
		
		this.xftp_action=function(arg){
			var rv=this.icon('sso_ftp.png',"xftp_select_box_obj",arg,2,"xftp");
			return rv;
		}		
		
		this.tools_action=function(arg){
			
		
			//var rv=this.icon('sso_ftp.png',"sso_tools_box_obj",arg);
			
			var url="/aim/portal/sso_tools.jsp?rdn="+arg.rdn;			
			var rv="<img style='cursor:hand' src='/public/img/sso/tools.png' ";
			rv+="width='28' height='28' style='cursor:hand' ";
			rv+="onClick=\"open_pop_win('"+url+"',500,350)\" >";
			return rv;
		}
		
		/*
		this.fav_action=function(arg){
			var disabled = '';
			
			var url = "/public/img/sso/favorited_16.png";
			if (arg.fav == '1') {
				url = "/public/img/sso/favorite_16.png";
				disabled = 'disabled';
			}
			
			var rv="<img style='cursor:hand' title='添加到收藏夹' src='"+url+"' ";
			rv+="width='28' height='28' "+disabled+" ";
			rv+="onClick=\"add_to_favorites('"+arg.seq+"')\" >";
			return rv;
		}
		*/
		
		this.fav_action=function(arg){
			var url = "/public/img/sso/favorited_16.png";
			if (arg.fav == '1') {
				url = "/public/img/sso/favorite_16.png";
			}
			
			var rv="<img style='cursor:hand' title='添加到收藏夹' src='"+url+"' ";
			rv+="width='28' height='28' ";
			rv+="onClick=\"add_to_favorites('"+arg.seq+"')\" >";
			return rv;
		}
		
		this.logs_action=function(arg){
			
			var url="/aim/audit/fort/list_of_person.do?method=list&aip="+arg.aip+"&account="+arg.account+"&type="+arg.atype;			
			var rv="<img style='cursor:hand' src='/public/img/sso/sso_log.png' ";
			rv+="width='28' height='28' ";
			rv+="onClick=\"open_pop_win('"+url+"',1000,528)\" >";
			return rv;
		}
		
		this.icon=function(img_src,obj_id,arg,space_count,title){
			var rv="<img title='"+title+"' style='cursor:hand'src='/public/img/sso/"+img_src+"' width='28' height='28' onClick=\""+obj_id+".show('"+arg.seq+"','"+arg.rdn+"','"+arg.aname+"','"+arg.aip+"','"+arg.protocol+"','"+arg.account+"')\">";
			if(space_count!=null){
				rv+=space(space_count);
			}
			return rv;
		}		
	}
	
	
	