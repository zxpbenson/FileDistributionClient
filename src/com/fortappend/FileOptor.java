package com.fortappend;

import java.io.File;

import javax.swing.JTextArea;

public class FileOptor {
	
	JSCHClient sc = new JSCHClient();
	private boolean realEnv;
	private JTextArea console;
	
	public FileOptor( boolean realEnv, JTextArea console){
		this.realEnv = realEnv;
		this.console = console;
	}
	
	private void consoleAppend(String text){
		this.console.append(text);
		this.console.append("\n");
		this.console.setCaretPosition(this.console.getDocument().getLength());
	}
//	account,
//	password,
//	fortIp,
//	fortPort,
//	targetPath,
//	targetResource,
//	uploadFilePath,
	
//	检查是否能够连接到堡垒机
//	校验用户身份
//  解析目标主机描述串
//	校验描述串中的主机和账号该用户是否都有授权
//	校验描述串中的主机和账号是否都能取到密码
//	上传文件到堡垒暂存
//	从堡垒纷发到描述串中的各个主机
	
	public void batchUpload(String[] formData){
		try{
		    connect(formData[2], FortEnv.fortRoot, realEnv?FortEnv.fortRootPwd_real:FortEnv.fortRootPwd, Integer.parseInt(formData[3]));
		    
		    //validateUser(formData[0], formData[1]);

		    //String[][] assetCnAndAccountCnArr = decodeResource(formData[5]);
		    
		    //validateAuthorizaion(assetCnAndAccountCnArr, formData[0]);
		    
		    cleanTemp(formData[0]);
		    
		    String[][] assetCnAndAccountCnArr = getAssetCnAndAccountByAuthorization(formData[0],formData[5]);
		    
		    String[][] assetArr = getAsset(assetCnAndAccountCnArr);
		    
		    String tempFilePath = uploadFile(formData[0], formData[6]);
		
		    distributeFile(tempFilePath, assetArr, formData[4]);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			sc.close();
		}
	}
	
	public String[][] getAssetCnAndAccountByAuthorization(String account, String authorizationString) throws Exception{
		authorizationString = authorizationString.substring(1);
		authorizationString = authorizationString.substring(0, authorizationString.length() - 1);
		
		String[] authorizationArr = authorizationString.split("\\$");

		String[][] assetCnAndAccountArr = new String[authorizationArr.length][];
		
		for(int index = 0; index < authorizationArr.length; index++){
			String command = "FortService Authorization get "+account+" "+authorizationArr[index]+" "+realEnv+" - -\n";
			String echo = sc.shell(command);
			String result = getLine(echo, 1);
			if(result.startsWith("ASSET_SEQ_NUM")){
				String[] assetCnAndAccountStr = result.split(" ");
				String[] assetCnAndAccount = new String[2];
				assetCnAndAccountArr[index] = assetCnAndAccount;
				assetCnAndAccount[1] = assetCnAndAccountStr[0].replace("ASSET_SEQ_NUM:", "");
				assetCnAndAccount[0] = assetCnAndAccountStr[1].replace("ASSET_ACCOUNT:", "");
			}else{
				consoleAppend(echo);
				consoleAppend("账号["+account+"]的授权["+authorizationArr[index]+"]不存在;");
				throw new Exception();
			}
		}
		
		consoleAppend("解析[目标主机]描述字符串完毕;");
		
		return assetCnAndAccountArr;
	}
	
//	private String[][] decodeResource(String targetResource) throws Exception{
//		String[] hostArr = targetResource.split(",");
//		String[][] assetCnAndAccountCn = new String[hostArr.length][2];
//		for(int index = 0; index < hostArr.length; index++){
//			String hostStr = hostArr[index];
//			String[] hostCnAndAccountArr = hostStr.split("@");
//			assetCnAndAccountCn[index][0] = hostCnAndAccountArr[0];
//			assetCnAndAccountCn[index][1] = hostCnAndAccountArr[1];
//			consoleAppend("解析[目标主机"+(index+1)+"]主机ID["+hostCnAndAccountArr[1]+"]账号["+hostCnAndAccountArr[0]+"];");
//		}
//		consoleAppend("解析[目标主机]描述字符串完毕;");
//		return assetCnAndAccountCn;
//	}
	
	private void connect(String ip, String user, String pwd, int port) throws Exception{
		String echo = null;
		try {
			consoleAppend("尝试连接至堡垒...");
			sc.connect(ip, user, pwd, port);
			consoleAppend("连接成功;");
			echo = sc.shell("sh\n");
			//consoleAppend(echo);
			System.out.println(echo);
		} catch (Exception e) {
            consoleAppend("连接失败;"+e.getMessage());
			System.out.println(echo);
			throw e;
		}
	}
	
	private void validateUser(String account, String password) throws Exception{
		String command = "FortService Person "+account+" "+password+" "+realEnv+"\n";
		String echo = sc.shell(command);
		String result = getLine(echo, 1);
		if(result.endsWith("true")){
			consoleAppend("[认证账号("+account+")][认证密码(***)]认证通过;");
		}else{
			consoleAppend(echo);
			consoleAppend("[认证账号]或者[认证密码]不正确;");
			throw new Exception();
		}
	}
	
	private void cleanTemp(String account) throws Exception{
		String command = "rm -r /tmp/fort_append/"+account + "\n";
		consoleAppend("开始清理账户["+account+"]的缓存...");
		String echo = sc.shell(command);
		
		consoleAppend("清理缓存成功;");
	}
	
//	private void validateAuthorizaion(String[][] assetCnAndAccountCnArr, String account) throws Exception{
//		for(String[] assetCnAndAccountCn : assetCnAndAccountCnArr){
//			String command = "FortService Authorization "+account+" "+assetCnAndAccountCn[1]+" "+assetCnAndAccountCn[0]+" "+realEnv+"\n";
//			String echo = sc.shell(command);
//			String result = getLine(echo, 1);
//			if(result.endsWith("true")){
//				consoleAppend("[认证账号("+account+")]在资源["+assetCnAndAccountCn[0]+"@"+assetCnAndAccountCn[1]+"]上的授权认证通过;");
//			}else{
//				consoleAppend(echo);
//				consoleAppend("[认证账号("+account+")]在资源["+assetCnAndAccountCn[0]+"@"+assetCnAndAccountCn[1]+"]上的授权认证不通过;");
//				throw new Exception();
//			}
//		}
//	}
	
	//asset[[CN, ASSET_IP, ASSET_PORT, ACCOUNT, DECRYPTION_PASSWORD]]
	private String[][] getAsset(String[][] assetCnAndAccountCnArr) throws Exception{
		String[][] assetArr = new String[assetCnAndAccountCnArr.length][];
		
		for(int index = 0; index < assetCnAndAccountCnArr.length; index++){
			String[] assetCnAndAccountCn = assetCnAndAccountCnArr[index];
			String[] asset = new String[5];
			assetArr[index] = asset;
			asset[0] = assetCnAndAccountCn[1];//CN
			asset[3] = assetCnAndAccountCn[0];//ACCOUNT
			
			String command = "FortService Asset "+assetCnAndAccountCn[1]+" "+assetCnAndAccountCn[0]+" "+realEnv+"\n";
			String echo = sc.shell(command);
			String result = getLine(echo, 1);
			if(result.startsWith("ASSET_IP")){
				consoleAppend("获取资源["+assetCnAndAccountCn[0]+"@"+assetCnAndAccountCn[1]+"]连接信息成功;");
				String[] connInfo = result.split(" ");
				asset[1] = connInfo[0].replace("ASSET_IP:", "");
				asset[2] = connInfo[1].replace("ASSET_PORT:", "");
				asset[4] = connInfo[2].replace("DECRYPTION_PASSWORD:", "");
			}else{
				consoleAppend(echo);
				consoleAppend("获取资源["+assetCnAndAccountCn[0]+"@"+assetCnAndAccountCn[1]+"]连接信息失败;");
				throw new Exception();
			}
			
		}
		return assetArr;
	}
	
	private long localFileSize;
	private String uploadFile(String account, String localFilePath) throws Exception{
		File file = new File(localFilePath);
		if(!file.exists() || file.isDirectory()){
			consoleAppend("本地文件["+localFilePath+"]不存在或者是个文件夹;");
			throw new Exception();
		}
		localFileSize = file.length();
		String tempFilePath = "/tmp/fort_append/"+account+"/"+System.currentTimeMillis();
		consoleAppend("开始将本地文件["+localFilePath+"]缓存至堡垒机...");
		sc.close(2);
		sc.uploadFile(localFilePath, tempFilePath, file.getName(), true, false);
		consoleAppend("缓存成功;");
		return tempFilePath+"/"+file.getName();
	}
	
	private void distributeFile(String tempFilePath, String[][] assetArr, String targetPath) throws Exception{
		for(String[] asset : assetArr){
			
//			try{
//				boolean check = checkDiskSpaceAndWRight(asset, targetPath);
//				sc.close(2);
//				if(!check){
//					consoleAppend("检查["+asset[3]+"@"+asset[1]+"]失败,跳过文件纷发;");
//					continue;
//				}
//			}catch(Exception e){
//				sc.close(2);
//				consoleAppend("检查["+asset[3]+"@"+asset[1]+"]发生异常,跳过文件纷发;异常信息为:" + e.getMessage());
//				continue;
//			}
			
			String command = "scp -P "+asset[2]+" "+tempFilePath+" "+asset[3]+"@"+asset[1]+":"+targetPath+"\n";
			consoleAppend(command);
			
			String echo = sc.shell(command, "UTF-8", 0, new String[]{"# ", "password: ", "Password: ", "lost connection", "Connection refused"}, new PromptMatcher(){
				public boolean match(String echo, String prompt){
					if( echo.endsWith(prompt))return true;
					echo = echo.trim();
					prompt = prompt.trim();
					System.out.println("echo===="+echo);
					System.out.println("prompt===="+prompt);
					return echo.endsWith(prompt);
				}
			});
			System.out.println("命令发送完毕");
			Thread.sleep(300);
			
			boolean addKnownhost = false;
			if(echo.indexOf("Are you sure you want to continue connecting")>0){
				echo = sc.shell("yes\n");
				System.out.println(echo);
				//consoleAppend(echo);
				addKnownhost = true;
			}
			
			Thread.sleep(300);
			
			boolean pwdInput = false;
			if(echo.endsWith("password: ")){
				echo = sc.shell(asset[4]+"\n", "UTF-8", 0, "# ");
				System.out.println(echo);
				//consoleAppend(echo);
				pwdInput = true;
			}
			
			Thread.sleep(300);
			
			if(!(addKnownhost|| pwdInput)){
				System.out.println(echo);
				//consoleAppend(echo);
			}
			
			if(echo.indexOf("Connection refused")>0){
				System.out.println(echo);
				consoleAppend("Connection refused");
			}
		}
		consoleAppend("文件全部分发完毕;");
	}
	
	//检查磁盘剩余空间 df -l | grep -n '/$' | awk '{print $4}'
    //检查对目标路径当前用户是否有写权限
	private boolean checkDiskSpaceAndWRight(String[] asset, String targetPath) throws Exception{
		String command = "ssh "+ asset[3]+"@" + asset[1] + "\n";
		String echo =  sc.shell(command);
		boolean addKnownhost = false;
		if(echo.indexOf("Are you sure you want to continue connecting")>0){
			echo = sc.shell("yes\n");
			addKnownhost = true;
		}
		
		Thread.sleep(300);
		
		boolean pwdInput = false;
		if(echo.endsWith("password: ")){
			echo = sc.shell(asset[4]+"\n", "UTF-8", 0, "# ");
			pwdInput = true;
		}
		
		Thread.sleep(300);
		
		if(!(addKnownhost|| pwdInput)){
			System.out.println(echo);
			//consoleAppend(echo);
		}
		
		if(echo.indexOf("Connection refused")>0){
			System.out.println(echo);
			consoleAppend("target host Connection refused");
			return false;
		}
		
		command = "df -k | grep -n '/$' | awk '{print $4}'\n";
		echo = sc.shell(command);
		
		String[] lineArr = echo.split(""+(char)13);
		long totalFreeSpace = 0;
		for(String oneLine : lineArr){
			try{
				totalFreeSpace  += Long.valueOf(oneLine.trim());
			}catch(NumberFormatException e){
			}
		}
		
		if(totalFreeSpace < 1){
			consoleAppend("获取目标主机["+asset[3]+"@"+asset[1]+"]磁盘剩余空间失败;");
			return false;
		}
		
		if(totalFreeSpace < ((this.localFileSize / 1000) + 100000)){
			consoleAppend("目标主机["+asset[3]+"@"+asset[1]+"]磁盘剩余空间不足;");
			return false;
		}
		
		command = "ls -al "+ targetPath +" | grep -e '\\d* .$'\n";
		echo = sc.shell(command);
		echo = getLine(echo, 1);
		
		if(echo == null || echo.equals("") || echo.equals(""+(char)13)){
			consoleAppend("目标主机["+asset[3]+"@"+asset[1]+"]目录["+targetPath+"]不是文件夹;");
			return false;
		}
		
		if(echo.indexOf("cannot access") > -1){
			consoleAppend(echo);
			return false;
		}
		
		echo = echo.replaceAll("  ", " ");
		String[] rightArr = echo.split(" ");
		String right = rightArr[0];
		String user = rightArr[2];
		String group = rightArr[3];
		
		if(asset[3].equals(user)){
			sc.close(2);
			if(right.charAt(2) == 'w'){
				return true;
			}else{
				consoleAppend("目标目录["+targetPath+"]属于当前用户["+asset[3]+"]但是没有写权限;");
				return false;
			}
		}
		
		command = "groups " + asset[3] + "\n";
		echo = sc.shell(command);
		
		String[] groupsArr = echo.split(" ");
		String getGroup = groupsArr[2];
		if(group.equals(getGroup)){
			if(right.charAt(5) == 'w'){
				return true;
			}else{
				consoleAppend("目标目录["+targetPath+"]不属于属于当前用户["+asset[3]+"]并且同组用户没有写权限;");
				return false;
			}
		}
		
		if(right.charAt(8) == 'w'){
			return true;
		}else{
			consoleAppend("目标目录["+targetPath+"]不属所属用户与于当前用户["+asset[3]+"]不在同一组并且其他用户没有写权限;");
			return false;
		}

	}
	
	private String getLine(String echo,int lineIndex){
//		char[] echoChar = echo.toCharArray();
//		for(char c : echoChar){
//			System.out.println(c);
//			System.out.println((int)c);
//		}
		String[] lineArr = echo.split(""+(char)13);
		if(lineIndex >= lineArr.length)return null;
		return lineArr[lineIndex].trim();
	}
}
