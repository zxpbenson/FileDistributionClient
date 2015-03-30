package com.simp.env;

public class DBEnv {

	public static void ini(){}
	
	public static String driver = "com.mysql.jdbc.Driver";
	
	public static String get_url(){
		return "jdbc:mysql://127.0.0.1/simplog?user=mysql&password=mysql&useUnicode=true&characterEncoding=utf8";
	}
	
}
