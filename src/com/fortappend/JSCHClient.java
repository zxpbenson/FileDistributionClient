package com.fortappend;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Vector;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

public class JSCHClient {
    //private boolean debug = false;
    private static final Logger logger = LogManager.getLogger(JSCHClient.class);
    
    public static final String channel_type_sftp = "sftp";
    public static final String channel_type_shell = "shell";
    
    public static final String charset_name_iso8859_1 = "iso8859-1";
    public static final String charset_name_utf_8 = "utf8";
    public static final String charset_name_unicode = "unicode";
    
    private JSch jsch = new JSch();
    private Session session = null;
    private Channel channel = null;
    private OutputStream outstream = null;
    private InputStream instream = null;

    public void connect(String ip, String user, String pwd)throws Exception{
        connect(ip, user, pwd, 22);
    }
    
    public void connect(String ip, String user, String pwd, int port)throws Exception {
        if (port <= 0) {
            session = jsch.getSession(user, ip);
        } else {
            session = jsch.getSession(user, ip, port);
        }

        if (session == null) {
            throw new Exception("session is null");
        }

        session.setPassword(pwd);
        session.setConfig("StrictHostKeyChecking", "no");//ask | yes | no
        session.connect(30000);
    }
    
    public void close(){
        this.close(3);
    }
    
    public void close(int level){
        if(level > 0)try {if(instream != null)instream.close();} catch (Exception e) {e.printStackTrace();}
        if(level > 0)instream = null;
        
        if(level > 0)try {if(outstream != null)outstream.close();} catch (Exception e) {e.printStackTrace();}
        if(level > 0)outstream = null;
        
        if(level > 1)try {if(channel != null && !channel.isClosed())channel.disconnect();} catch (Exception e) {e.printStackTrace();}
        if(level > 1)channel = null;
        
        if(level > 2)try {if(session != null && session.isConnected())session.disconnect();} catch (Exception e) {e.printStackTrace();}
        if(level > 2)session = null;
    }

    public String shell(String command) throws Exception{
        return shell(command, "UTF-8", 2000, "# ");
    }
    
    public String shell(String command, String echo_charset_name, long timeout, String prompt) throws Exception{
         return shell(command, echo_charset_name, timeout, new  String[] {prompt}, null, null);
    }
    
    public String shell(String command, String echo_charset_name, long timeout, String[] prompt, PromptMatcher pMatcher, EchoMatcher[] eMatcherArr) throws Exception{
        if(channel == null){
            channel = session.openChannel(JSCHClient.channel_type_shell);
            channel.connect(1000);
        }

        if(instream == null)instream = channel.getInputStream();
        if(outstream == null)outstream = channel.getOutputStream();
        
        outstream.write(command.getBytes());
        outstream.flush();
        
        StringBuffer sb = new StringBuffer();
        long start = System.currentTimeMillis();
        
        while(true){
            Thread.sleep(200);
            if(channel.isClosed() || !session.isConnected()){
                logger.debug("channel closed, break.");
                break;
            }
            
            if(eMatcherArr != null){
                while(instream.available() > 0){
                    byte[] data = new byte[instream.available()];
                    int nLen = instream.read(data);
                     
                    if (nLen < 0) {
                        throw new Exception("network error.");
                    }
                    String echo = new String(data, 0, nLen, echo_charset_name);
                    logger.debug("-----------echo splitys : \n " + echo);
                    sb.append(echo);
                    
                    for(EchoMatcher eMatcher : eMatcherArr){
                        eMatcher.match(sb.toString());
                    }
                }
            }
            
            if (instream.available() > 0) {
                byte[] data = new byte[instream.available()];
                int nLen = instream.read(data);
                 
                if (nLen < 0) {
                    throw new Exception("network error.");
                }
                String echo = new String(data, 0, nLen, echo_charset_name);
                logger.debug("-----------echo splitys : \n " + echo);
                sb.append(echo);
            }
            
            boolean getPrompt = false;
            for(String onePrompt : prompt){
                if(pMatcher == null){
                    if(sb.toString().endsWith(onePrompt)){
                        logger.debug("echo finish, break.");
                        getPrompt = true;
                        break;
                    }
                }else{
                    if(pMatcher.match(sb.toString(), onePrompt)){
                        logger.debug("echo finish, break.");
                        getPrompt = true;
                        break;
                    }
                }
            }
            if(getPrompt)break;
            if(timeout == 0){
                logger.debug("timeout less, continue.");
                continue;
            }
            if(System.currentTimeMillis() - start > timeout){
                logger.debug("timeout, break.");
                break;
            }
        }
        
        String echo = sb.toString();
        
        //if(echo.indexOf("\n")>0)return echo.substring(echo.indexOf("\n")+1);
        
        return echo;
    }
    
    public void upload(String sourceFileWithPath, String targetPath, String targetFile) throws Exception{
        uploadFile(sourceFileWithPath, targetPath, targetFile, false, false);
    }
    
    public void uploadFile(String sourceFileWithPath, String targetPath, String targetFile, boolean mkDirRecursion, boolean coverOnFileExists) throws Exception{
        if(channel == null){
            channel = session.openChannel(JSCHClient.channel_type_sftp);
            channel.connect(1000);
        }

        ChannelSftp sftp = (ChannelSftp) channel;
        
        if(mkDirRecursion){
            mkdir(sftp, targetPath);
        }
        sftp.cd(targetPath);//"domains"
        if(exists(sftp, targetFile)){
            if(coverOnFileExists){
                //do nothing
            }else{
                return;
            };
        }
        
        //String tempPath = "/root/"+System.currentTimeMillis();
        //sftp.mkdir(tempPath);
        
        writeFile(sftp, sourceFileWithPath, targetFile);
        
        close(2);
    }
    
    public void writeFile(ChannelSftp sftp, String sourceFileWithPath, String targetFile) throws Exception{
        outstream = sftp.put(targetFile);//"1.txt"
        File file = new File(sourceFileWithPath);//"c:/print.txt"
        instream = new FileInputStream(file);
        
        byte b[] = new byte[1024];
        int n;
        while ((n = instream.read(b)) != -1) {
            outstream.write(b, 0, n);
        }
        
        outstream.flush();
    }
    
    public boolean exists(ChannelSftp sftp, String fileName) throws Exception{
        Vector v = sftp.ls("*");//"*.txt"
        int length = 0;
        for (int i = 0; i < v.size(); i++) {
            //logger.info(v.get(i));
            String[] attArr = v.get(i).toString().split(" ");
            if(attArr != null){
                length = attArr.length;
                logger.debug("fileName : "+attArr[length - 1]);
                if(attArr[length - 1].equals(fileName)){
                    //throw new Exception("file already exists");
                    return true;
                }
            }
        }
        return false;
    }
    
    public void mkdir(ChannelSftp sftp, String targetPath) throws Exception{
        String[] pathDirNames = targetPath.split("/");
        String fullPath = "/";
        for(String pathDirName : pathDirNames){
            sftp.cd(fullPath);
            if(pathDirName == null || "".equals(pathDirName)){
                //do nothing
            }else{
                fullPath += ("/"+pathDirName);
                if(exists(sftp, pathDirName)){
                    continue;
                }else{
                    sftp.mkdir(fullPath);
                }
            }
        }
    }
    
    public static void main(String[] args) {
        
        JSCHClient sc = new JSCHClient();
        try {
            //sc.connect("192.168.10.129", "root", "root");
            sc.connect("fort.simp.com", "root", "root");
            //logger.info(sc.shell("rm -r /tmp/fort_append/abc\n"));//if(true)return;
            //sc.uploadFile("E:/install_src/ubuntu-12.10-server-amd64.iso", "/", "ubuntu12.iso", true, false);
            //sc.uploadFile("E:/install_src/jdk-6u45-windows-x64.exe_", "/", "jdk6.exe", true, false);
            //sc.uploadFile("D:/ubuntu-12.10-server-amd64.iso", "/tmp", "ubuntu12.iso", true, false);
//            
//            logger.info("-----1------");
//            logger.info(sc.shell("sh\n"));
//            logger.info("-----2------");
//            //logger.info(sc.shell("ls -al\n"));
//            logger.info(sc.shell("cd /\n"));
//            logger.info("-----3------");
//            logger.info(sc.shell("FortDecryption Asset_002A5D869 root\n"));
//            logger.info("-----4------");
            
            //String echo = sc.shell("scp /tmp/ubuntu12.iso root@192.168.10.103:/\n", "UTF-8", 0, "password: ");
//             //String echo = sc.shell("scp jdk6.exe root@192.168.10.102:/\n", "UTF-8", 0, "password: ");
//            //String echo = sc.shell("scp decode.bat root@192.168.10.102:/\n", "UTF-8", 0, "password: ");
            
            String charSet = "UTF-8";
            String[] appendPrompt = new String[]{"# ", "assword: ","lost connection","Connection refused"};
            PromptMatcher pMatcher = new PromptMatcher(){
                public boolean match(String echo, String prompt){
                    if( echo.endsWith(prompt))return true;
                    echo = echo.trim();
                    prompt = prompt.trim();
                    logger.info("echo===="+echo);
                    logger.info("prompt===="+prompt);
                    return echo.endsWith(prompt);
                }
            };
            EchoMatcher[] eMatcherArr = new EchoMatcher[]{new EchoMatcher(){
                public boolean match(String echo){
                    String echoTrim = echo.trim();
                    if(echoTrim.endsWith(" ETA")){
                        logger.info(echo);
                        return true;
                    }
                    return false;
                }
            }};
            
            String echo = sc.shell("scp /root/tomcat.tar root@192.168.10.130:/\n", charSet, 0, appendPrompt, pMatcher, eMatcherArr);
            
            logger.info(echo);
            
            Thread.sleep(300);
            
            if(echo.indexOf("Are you sure you want to continue connecting")>0){
                echo = sc.shell("yes\n");
                logger.info(echo);
            }
            
            Thread.sleep(300);
            
            if(echo.endsWith("assword: ")){
                echo = sc.shell("root\n", charSet, 0, appendPrompt, pMatcher, eMatcherArr);
                logger.info(echo);
            }
            
            
        } catch (Exception e) {
            e.printStackTrace();
        }finally{
            sc.close();
            logger.info("sc.close();");
        }
    }
}
