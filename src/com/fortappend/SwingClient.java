package com.fortappend;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Image;
//import java.awt.Menu;
//import java.awt.MenuBar;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.net.URL;
//import java.math.BigInteger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
//import javax.swing.JLabel;
//import javax.swing.JMenu;
//import javax.swing.JMenuBar;
//import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
//import javax.swing.JTextField;
//import javax.swing.JPasswordField;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;

//import javax.swing.filechooser.FileView;

public class SwingClient {
    private boolean realEnv = false;

    private String userAccount = "";// 当前操作用户堡垒机账号
    private String userPassword = "";// 当前操作用户堡垒机密码
    private String fortHost = "";// 堡垒机IP
    private String fortPort = "";// 堡垒机SSH端口
    private String targetPath = "";// 文件纷发统一目标路径
    private String targetHosts = "";// 文件纷发目标主机
    private String sourceFile = "";// 纷发源文件

    private URL url_1 = this.getClass().getResource("img/title.png");
    private Image img_1 = Toolkit.getDefaultToolkit().getImage(url_1);
    // private URL url_2 = this.getClass().getResource("img/file.png");
    // private ImageIcon img_2 = new ImageIcon(url_2);
    private URL url_3 = this.getClass().getResource("img/upload.png");
    private ImageIcon img_3 = new ImageIcon(url_3);
    private URL url_4 = this.getClass().getResource("img/delete.png");
    private ImageIcon img_4 = new ImageIcon(url_4);

    private JFrame jFrame = new JFrame();

    private JTextArea jTextArea = new JTextArea();
    private JScrollPane jScrollPane = new JScrollPane(jTextArea);

    private JPanel jPanelSouth = new JPanel();

    // private JPanel jPanel_1 = new JPanel();
    // private JLabel jLabel_1 = new JLabel();
    // private JTextField jTextField_1 = new JTextField();
    //
    // private JPanel jPanel_2 = new JPanel();
    // private JLabel jLabel_2 = new JLabel();
    // private JPasswordField jTextField_2 = new JPasswordField();
    //
    // private JPanel jPanel_3 = new JPanel();
    // private JLabel jLabel_3 = new JLabel();
    // private JTextField jTextField_3 = new JTextField();
    //
    // private JPanel jPanel_4 = new JPanel();
    // private JLabel jLabel_4 = new JLabel();
    // private JTextField jTextField_4 = new JTextField();
    //
    private JPanel jPanel_5 = new JPanel();
    private JLabel jLabel_5 = new JLabel();
    private JTextField jTextField_5 = new JTextField();
    //
    // private JPanel jPanel_6 = new JPanel();
    // private JLabel jLabel_6 = new JLabel();
    // private JTextField jTextField_6 = new JTextField();
    //
    // private JPanel jPanel_7 = new JPanel();
    // private JLabel jLabel_7 = new JLabel();
    // private JTextField jTextField_7 = new JTextField();

    private JFileChooser jFileChooser = new JFileChooser();
    // private JButton jButtonSelFile = new JButton("选择文件", img_2);
    private JButton jButtonUpload = new JButton("批量上传", img_3);
    private JButton jButtonClearConsole = new JButton("清除日志", img_4);

    private JPanel jPanel_8 = new JPanel();

    /*
     * 1 认证账号 2 认证密码 3 堡垒Ip 4 堡垒端口 5 上传路径 6 目标主机和账号字符串 7 上传文件 8 选择文件按钮 9 上传按钮
     */

    public void init(String[] args) {
        this.initComponent();
        this.initAction();
        if (args != null) {
            this.initArguments(args);
        }
    }

    private void initArguments(String[] args) {
        // if(args.length >= 2)this.jTextField_3.setText(args[1]);//fortHost
        // if(args.length >= 3)this.jTextField_1.setText(args[2]);//account
        // if(args.length >=
        // 4)this.jTextField_6.setText(args[3]);//targetHostList
        // if(args.length >= 4)this.jTextField_2.setText("");//password
        // if(args.length >= 4)this.jTextField_7.setText("");//targetFile
        
        for(int index = 0; index < args.length; index++){
            consoleAppend("args["+index+"]=" + args[index]);
        }
        
        if (args.length >= 2)
            this.userAccount = args[1] == null ? "" : args[1].trim();
//        if (args.length > 3)
//            this.userPassword = args[2] == null ? "" : args[2].trim();
        if (args.length >= 3)
            this.fortHost = args[2] == null ? "" : args[2].trim();
        if (args.length >= 4)
            this.fortPort = args[3] == null ? "" : args[3].trim();
        if (args.length >= 5)
            this.targetPath = args[4] == null ? "" : args[4].trim();
        if (args.length >= 6)
            this.targetHosts = args[5] == null ? "" : args[5].trim();

    }

    private void initComponent() {
        // JMenuBar jmb = new JMenuBar();
        // JMenu jm1 = new JMenu("选择文件");
        // JMenu jm2 = new JMenu("批量上传");
        // JMenu jm3 = new JMenu("清除日志");
        // jmb.add(this.jButtonSelFile);
        // jm1.setIcon(img_2);
        // jm2.setIcon(img_3);
        // jm3.setIcon(img_4);
        // jmb.add(jm1);
        // jmb.add(jm2);
        // jmb.add(jm3);
        //
        // JMenuItem jmi1 = new JMenuItem("登录");
        // JMenuItem jmi2 = new JMenuItem("注销");
        // jm1.add(jmi1);
        // jm1.add(jmi2);
        //
        // //this.jFrame.setJMenuBar(jmb);
        
        this.jFrame.setIconImage(img_1);
        this.jFrame.setLayout(new BorderLayout(2, 3));
        this.jFrame.setSize(560, 560);
        this.jFrame.setLocationByPlatform(true);
        this.jFrame.setResizable(false);
        this.jFrame.setLocation(500, 270);
        this.jFrame.setTitle("File Distribution Client");
        this.jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // this.jTextArea.setVisible(true);
        this.jTextArea.setRows(10); // 设置文本框大小
        this.jTextArea.setColumns(30); // 设置文本框大小
        this.jTextArea.setLineWrap(true); // 设置文本自动换行
        this.jTextArea.setEditable(false);
        this.jTextArea.setText("Welcome:\n");
        this.jTextArea.setSelectedTextColor(Color.BLACK);
        this.jTextArea.setBackground(Color.LIGHT_GRAY);
        this.jTextArea.setFont(new Font(Font.DIALOG, Font.TYPE1_FONT, 11));

        // this.jScrollPane.setVisible(true);
        this.jScrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        this.jScrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        this.jFrame.add(this.jScrollPane, BorderLayout.SOUTH);

        this.jFileChooser.setDialogTitle("选择上传文件");
        this.jFileChooser.setMultiSelectionEnabled(false);
        this.jFileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
        this.jFileChooser.setApproveButtonText("确定");
        this.jFileChooser.setControlButtonsAreShown(false);

        this.jPanelSouth.setLayout(new BoxLayout(jPanelSouth, BoxLayout.Y_AXIS));
        // addComponentToPanel(jPanelSouth, jPanel_1, jLabel_1, jTextField_1,
        // "认证账号 : ", "zhangke");
        // addComponentToPanel(jPanelSouth, jPanel_2, jLabel_2, jTextField_2,
        // "认证密码 : ", "123");
        // addComponentToPanel(jPanelSouth, jPanel_3, jLabel_3, jTextField_3,
        // "堡垒地址 : ", "192.168.10.129");
        // addComponentToPanel(jPanelSouth, jPanel_4, jLabel_4, jTextField_4,
        // "堡垒端口 : ", "22");
        
        //this.jPanel_5.setPreferredSize(new Dimension(1, 1));
        this.jPanel_5.setBorder(BorderFactory.createEtchedBorder());
        
        jLabel_5.setText("目标路径：");
        jLabel_5.setBounds(10, 1, 100, 30);
        jTextField_5.setText("~/");
        jTextField_5.setBounds(82,1,460,30);
        jPanel_5.setLayout(null);
        jPanel_5.add(jLabel_5);
        jPanel_5.add(jTextField_5);
        jPanelSouth.add(jPanel_5);
        
        //addComponentToPanel(jPanelSouth, jPanel_5, jLabel_5, jTextField_5, "   目标路径：    ", "~/");
        // addComponentToPanel(jPanelSouth, jPanel_6, jLabel_6, jTextField_6,
        // "目标主机 : ",
        // "root@Asset_1316159995894567,root@Asset_1316159996475177");
        // addComponentToPanel(jPanelSouth, jPanel_6, jLabel_6, jTextField_6,
        // "目标主机 : ", "$13165170732686$1323440707686727$");
        // addComponentToPanel(jPanelSouth, jPanel_7, jLabel_7, jTextField_7,
        // "上传文件 : ", "C:/Users/Benson/Documents/desktop.ini");

        this.jPanel_8.setLayout(new BoxLayout(this.jPanel_8, BoxLayout.X_AXIS));
        // this.jPanel_8.add(this.jButtonSelFile);
        this.jPanel_8.add(this.jButtonUpload);
        this.jPanel_8.add(this.jButtonClearConsole);
        this.jPanelSouth.add(this.jPanel_8);

        // this.jFrame.add(this.jPanel_8, BorderLayout.CENTER);

        this.jFrame.add(this.jPanelSouth, BorderLayout.CENTER);

        this.jFrame.add(this.jFileChooser, BorderLayout.NORTH);

        this.jFrame.setVisible(true);
        this.jFrame.repaint();

    }

//     private void addComponentToPanel(JPanel panel, JPanel subPanel, JLabel
//         label, JTextField textField, String labelText, String textFieldText){
//         label.setText(labelText);
//         textField.setText(textFieldText);
//         subPanel.setLayout(new BoxLayout(subPanel, BoxLayout.X_AXIS));
//         subPanel.add(label);
//         subPanel.add(textField);
//         panel.add(subPanel);
//     }

    private void logParameter() {
        consoleAppend("当前操作用户堡垒机账号[" + userAccount + "]");
        //consoleAppend("当前操作用户堡垒机密码[" + userPassword + "]");
        consoleAppend("当前操作用户堡垒机密码[******]");
        consoleAppend("堡垒机IP[" + fortHost + "]");
        consoleAppend("堡垒机SSH端口[" + fortPort + "]");
        consoleAppend("文件纷发统一目标路径[" + targetPath + "]");
        consoleAppend("文件纷发目标主机[" + targetHosts + "]");
        consoleAppend("纷发源文件[" + sourceFile + "]");
    }

    private void initAction() {
        // this.jButtonSelFile.addActionListener(new ActionListener() {
        // public void actionPerformed(ActionEvent e) {
        // int result = jFileChooser.showOpenDialog(jFrame);
        // if (result == JFileChooser.APPROVE_OPTION) {// 确认打开
        // consoleAppend("Select file : " +
        // jFileChooser.getSelectedFile().getAbsolutePath());
        // jTextField_7.setText(jFileChooser.getSelectedFile().getAbsolutePath());
        // } else if (result == JFileChooser.CANCEL_OPTION) {
        // consoleAppend("Cancel button is pushed.");
        // } else if (result == JFileChooser.ERROR_OPTION) {
        // consoleAppend("Error when select file.");
        // }
        // }
        // });

        this.jButtonUpload.addActionListener(new ActionListener() {

            // String targetPath = jTextField_1.getText();
            // String targetResource = jTextField_2.getText();
            public void actionPerformed(ActionEvent e) {

                targetPath = jTextField_5.getText();
                
                File sourceF = jFileChooser.getSelectedFile();
                if (sourceF != null) {
                    sourceFile = sourceF.getAbsolutePath();
                }

                logParameter();
                
                if (!formValidate())
                    return;

                new Thread() {
                    public void run() {
                        lockForm(true);
                        try {
                            FileOptor fileOptor = new FileOptor(realEnv,jTextArea);
                            fileOptor.batchUpload(getFormData());
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        lockForm(false);
                    }
                }.start();

            }
        });

        jButtonClearConsole.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                jTextArea.setText("Welcome:\n");
            }
        });
    }

    public static void main(String[] args) {
        //args = new String[]{"false","zhangke","192.168.10.129","22","~/","$00521B692$1351713120505256$"};
        
        try {
            // UIManager.setLookAndFeel("com.sun.java.swing.plaf.motif.MotifLookAndFeel");//Mac风格
            UIManager.setLookAndFeel("com.sun.java.swing.plaf.nimbus.NimbusLookAndFeel");
            // UIManager.setLookAndFeel("com.sun.java.swing.plaf.windows.WindowsLookAndFeel");//Windows风格
            // UIManager.setLookAndFeel("javax.swing.plaf.metal.MetalLookAndFeel");//Java默认风格

            // UIManager.setLookAndFeel("javax.swing.plaf.basic.BasicLookAndFeel");//java.lang.InstantiationException
            // UIManager.setLookAndFeel("javax.swing.plaf.multi.MultiLookAndFeel");//Multiplexing
            // LAF
            // UIManager.setLookAndFeel("javax.swing.plaf.synth.SynthLookAndFeel");//xxx

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (UnsupportedLookAndFeelException e) {
            e.printStackTrace();
        }

        SwingClient client = new SwingClient();
        if (args != null && args.length > 0) {
            client.realEnv = Boolean.parseBoolean(args[0]);
        }
        client.init(args);
    }

    public void lockForm(boolean lock) {
        lock = !lock;
        // this.jTextField_1.setEditable(lock);
        // this.jTextField_2.setEditable(lock);
        // this.jTextField_3.setEditable(lock);
        // this.jTextField_4.setEditable(lock);
        this.jTextField_5.setEditable(lock);
        // this.jTextField_6.setEditable(lock);
        // this.jTextField_7.setEditable(lock);
        // this.jButtonSelFile.setEnabled(lock);
        this.jButtonUpload.setEnabled(lock);
    }

    public boolean formValidate() {
        // if(!simpleValidate(jTextField_1, "认证账号"))return false;
        // if(!simpleValidate(jTextField_2, "认证密码"))return false;
        // if(!simpleValidate(jTextField_3, "堡垒地址"))return false;
        // if(!simpleValidate(jTextField_4, "堡垒端口"))return false;
        // if(!simpleValidate(jTextField_5, "目标路径"))return false;
        // if(!simpleValidate(jTextField_6, "目标主机"))return false;
        // if(!simpleValidate(jTextField_7, "上传文件"))return false;

        if (!simpleValidate(this.userAccount, "认证账号"))
            return false;
        //if (!simpleValidate(this.userPassword, "认证密码"))
        //    return false;
        if (!simpleValidate(this.fortHost, "堡垒地址"))
            return false;
        if (!simpleValidate(this.fortPort, "堡垒端口"))
            return false;
        if (!simpleValidate(this.targetPath, "目标路径"))
            return false;
        if (!simpleValidate(this.targetHosts, "目标主机"))
            return false;
        if (!simpleValidate(this.sourceFile, "上传文件"))
            return false;

        // if(!validateIp(jTextField_3.getText())){
        // consoleAppend("[堡垒地址]格式不正确,应该为IP;");
        // return false;
        // }
        //
        // if(!validatePort(jTextField_4.getText())){
        // consoleAppend("[堡垒端口]格式不正确,应该为数字;");
        // return false;
        // }
        //
        // if(!validateTargetHostInfo2(jTextField_6.getText())){
        // consoleAppend("[目标主机]描述字符串格式不正确;");
        // return false;
        // }
        //
        // if(!validateLocalFilePath(jTextField_7.getText())){
        // consoleAppend("[上传文件]路径格式不正确或者文件不存在;");
        // return false;
        // }

        if (!validateIp(this.fortHost)) {
            consoleAppend("[堡垒地址]格式不正确,应该为IP;");
            return false;
        }

        if (!validatePort(this.fortPort)) {
            consoleAppend("[堡垒端口]格式不正确,应该为数字;");
            return false;
        }

        if (!validateTargetHostInfo2(this.targetHosts)) {
            consoleAppend("[目标主机]描述字符串格式不正确;");
            return false;
        }

        if (!validateLocalFilePath(this.sourceFile)) {
            consoleAppend("[上传文件]是个文件夹或者文件不存在;");
            return false;
        }

        return true;
    }

    // private boolean simpleValidate(JTextField jTextField, String prompt){
    // String text = null;
    // if(jTextField.getClass().getName().indexOf("JPasswordField") >= 0){
    // text = new String(((JPasswordField)jTextField).getPassword());
    // }else{
    // text = jTextField.getText();
    // }
    //
    // text = text == null ? "" : text.trim();
    // if("".equals(text)){
    // consoleAppend("["+prompt+"]不能为空;");
    // return false;
    // }
    // jTextField.setText(text);
    // return true;
    // }

    private boolean simpleValidate(String value, String prompt) {
        String text = value == null ? "" : value.trim();
        if ("".equals(text)) {
            consoleAppend("[" + prompt + "]不能为空;");
            return false;
        }
        return true;
    }

    private boolean validateIp(String fortIp) {
        if ("fort.simp.com".equals(fortIp))
            return true;

        if (fortIp.length() < 7 || fortIp.length() > 15) {
            return false;
        }
        String rexp = "([1-9]|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3}";
        Pattern pat = Pattern.compile(rexp);
        Matcher mat = pat.matcher(fortIp);
        boolean isIp = mat.find();
        return isIp;
    }

    private boolean validatePort(String fortPort) {
        String rexp = "\\d{1,5}\\b";
        Pattern pat = Pattern.compile(rexp);
        Matcher mat = pat.matcher(fortPort);
        boolean isPort = mat.find();
        return isPort;
    }

    private boolean validateLocalFilePath(String uploadFilePath) {
        try {
            File localFile = new File(uploadFilePath);
            return localFile.exists() && localFile.isFile();
        } catch (Exception e) {
            return false;
        }
    }

    // private boolean validateTargetHostInfo(String targetResource){
    // String[] hostArr = targetResource.split(",");
    // if(hostArr == null || hostArr.length < 1){
    // return false;
    // }
    // for(String hostStr : hostArr){
    // String[] hostCnAndAccountArr = hostStr.split("@");
    // if(hostCnAndAccountArr == null || hostCnAndAccountArr.length != 2){
    // return false;
    // }
    // }
    // return true;
    // }

    private boolean validateTargetHostInfo2(String targetResource) {
        if (!targetResource.startsWith("$"))
            return false;
        if (!targetResource.endsWith("$"))
            return false;
        if (targetResource.length() < 3)
            return false;
        targetResource = targetResource.substring(1);
        targetResource = targetResource.substring(0,targetResource.length() - 1);

        String[] authorizationArr = targetResource.split("\\$");
        if (authorizationArr == null || authorizationArr.length < 1) {
            return false;
        }
        // for(String authorization : authorizationArr){
        // try{
        // //new BigInteger(authorization);
        // }catch(NumberFormatException e){
        // return false;
        // }
        // }
        return true;
    }

    public String[] getFormData() {
        // String account = jTextField_1.getText();
        // //String password = jTextField_2.getText();
        // String password = new String(jTextField_2.getPassword());
        // String fortIp = jTextField_3.getText();
        // String fortPort = jTextField_4.getText();
        // String targetPath = jTextField_5.getText();
        // String targetResource = jTextField_6.getText();
        // String uploadFilePath = jTextField_7.getText();
        //
        // return new String[]{
        // account,
        // password,
        // fortIp,
        // fortPort,
        // targetPath,
        // targetResource,
        // uploadFilePath
        // };

        return new String[] { this.userAccount, this.userPassword,
                this.fortHost, this.fortPort, this.targetPath,
                this.targetHosts, this.sourceFile };

    }

    private void consoleAppend(String text) {
        this.jTextArea.append(text);
        this.jTextArea.append("\n");
        this.jTextArea.setCaretPosition(this.jTextArea.getDocument().getLength());
    }
}
