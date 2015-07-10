<%@ page language="java" pageEncoding="GBK"%>
<%@ page import="com.simp.action.ProxyUser"%>
<%@ page import="java.util.*" %> 
<%
	String base=request.getContextPath();
	ProxyUser proxyUser=ProxyUser.getProxyUser(request);
	
	System.out.println("aim/framePages/body.jsp");
	System.out.println("proxyUser.curModule="+proxyUser.curModule);

    Enumeration requestParameterNames = request.getParameterNames();
    while(requestParameterNames.hasMoreElements()){
        String parameterName = (String)requestParameterNames.nextElement();
        Object parameterValue = request.getParameter(parameterName);
        System.out.println("request parameter parameter=" + parameterName + ", parameter=" + parameterValue);
        
    }
    
    Enumeration requestAttributeNames = request.getAttributeNames();
    while(requestAttributeNames.hasMoreElements()){
        String attributeName = (String)requestAttributeNames.nextElement();
        Object attributeValue = request.getAttribute(attributeName);
        System.out.println("request attribute attributeName=" + attributeName + ", attributeValue=" + attributeValue);
        
    }
    
    String[] valueNames = session.getValueNames();
    for(String valueName : valueNames){
        System.out.println("session valueName="+valueNames + ", value=" + session.getValue(valueName));
    }
    
    Enumeration sessionAttributeNames = session.getAttributeNames();
    while(sessionAttributeNames.hasMoreElements()){
        String attributeName = (String)sessionAttributeNames.nextElement();
        Object attributeValue = session.getAttribute(attributeName);
        System.out.println("session attribute attributeName=" + attributeName + ", attributeValue=" + attributeValue);
        
    }
	
	if (ProxyUser.Module.NULL == proxyUser.curModule) {
		proxyUser.init_meta_module();
	}
	
	if (ProxyUser.Module.PERSON_SELF == proxyUser.curModule) {
		response.sendRedirect(base+"/person/self.do?method=modifySelfIni&rdn="+proxyUser.getRdn());
	} else if (ProxyUser.Module.PERSON==proxyUser.curModule){
		response.sendRedirect(base+"/person/list.do?method=listIni");
	}else if(ProxyUser.Module.ASSET==proxyUser.curModule){
		response.sendRedirect(base+"/asset/list.do?method=listIni");
	}else if(ProxyUser.Module.ROLE==proxyUser.curModule){
		response.sendRedirect(base+"/role/list.do?method=listIni");
	}else if(ProxyUser.Module.AUDIT_INNER==proxyUser.curModule){
		response.sendRedirect(base+"/audit/inner/list.do?method=listIni");
	}else if(ProxyUser.Module.AUDIT_ACCESS==proxyUser.curModule){ 
		response.sendRedirect(base+"/audit/fort/list.do?method=listIni");
	}else if(ProxyUser.Module.AUDIT_DB==proxyUser.curModule){
		response.sendRedirect(base+"/audit/database/list.do?method=listIni");
	}else if(ProxyUser.Module.TASK==proxyUser.curModule){
		response.sendRedirect(base+"/task/list.do?method=listIni");
	} else if (ProxyUser.Module.TASK_EXEC==proxyUser.curModule) {
		response.sendRedirect(base+"/task/list.do?method=listIni");
	} else if (ProxyUser.Module.REPORT==proxyUser.curModule) {
		response.sendRedirect(base+"/report/accessReportList.do?method=query");
	} else if (ProxyUser.Module.PLUGIN==proxyUser.curModule) {
		response.sendRedirect("/public/download/download.jsp");
	} else {
		response.sendRedirect(base+"/person/list.do?method=listIni");	
	}	
%>
<html>
<head>
<title></title>
</head>

<body>
</body>
</html>
