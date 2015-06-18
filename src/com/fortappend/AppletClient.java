package com.fortappend;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.applet.*;
import java.security.AccessController;
import java.security.PrivilegedAction;

import javax.swing.*;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class AppletClient extends Applet {

    private static final Logger logger = LogManager.getLogger(AppletClient.class);
    
    private static final long serialVersionUID = 6448045111501741489L;
    private JFrame jFrame = new JFrame();
    private JTextArea jTextArea = new JTextArea();
    private JScrollPane jScrollPane = new JScrollPane(this.jTextArea);
    private JButton jButton = new JButton("选择文件");
    private JPanel jPanelNorth = new JPanel();
    private JPanel jPanel = new JPanel();
    private JFileChooser jFileChooser = new JFileChooser();
    private JTextField jTextFieldNorth = new JTextField();
    private JLabel jLabelNorth = new JLabel();
    private JTextField jTextField = new JTextField();
    private JLabel jLabel = new JLabel();
    
    public AppletClient(){
        AccessController.doPrivileged(new PrivilegedAction<String>() {    
            public String run() {  
                return null;  
            }  
        });  
        
        
        logger.info("SimpleApplet constructor start");
        this.validate();
    }
    
    public void init() {
        super.init();
        
        logger.info("SimpleApplet init start");
        //this.setLocation(300, 300);
        this.setVisible(false);
        //this.setName("BatchUploadApplet");
        this.setSize(1, 1);
        //this.setLayout(new BorderLayout());
        
        this.jFrame.setLayout(new BorderLayout(2, 3));
        this.jFrame.setSize(450, 450);
        this.jFrame.setLocationByPlatform(true);
        this.jFrame.setResizable(false);
        this.jFrame.setLocation(500, 270);
        //this.jFrame.setIconImage(new ImageIcon("img/d.jpg").getImage());
        this.jFrame.setTitle("Batch Upload Applet");
        this.jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        
        this.jTextArea.setVisible(true);
        this.jTextArea.setRows(10); // 设置文本框大小
        this.jTextArea.setColumns(30); // 设置文本框大小
        this.jTextArea.setLineWrap(true); // 设置文本自动换行
        this.jTextArea.setEditable(false);
        this.jTextArea.setText("后台日志:\n");
        this.jTextArea.setSelectedTextColor(Color.RED);
        this.jTextArea.setBackground(Color.GRAY);
        this.jTextArea.setFont(new Font(Font.DIALOG, Font.TYPE1_FONT, 11));
        
        this.jScrollPane.setVisible(true);
        this.jScrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        this.jScrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        //this.add(this.jScrollPane, BorderLayout.CENTER);
        this.jFrame.add(this.jScrollPane, BorderLayout.CENTER);
        
        this.jFileChooser.setDialogTitle("打开并上传文件");
        this.jFileChooser.setMultiSelectionEnabled(false);
        this.jFileChooser.setApproveButtonText("选择并上传");
        
        this.jButton.setVisible(true);
        this.jLabel.setText("目标路径:");
        this.jLabelNorth.setText("目标主机:");

        this.jPanel.setVisible(true);
        this.jPanel.setLayout(new BoxLayout(this.jPanel, BoxLayout.X_AXIS));
        this.jPanel.add(this.jLabel);
        this.jPanel.add(this.jTextField);
        this.jPanel.add(this.jButton);
        this.jFrame.add(this.jPanel, BorderLayout.SOUTH);
        
        this.jPanelNorth.setVisible(true);
        this.jPanelNorth.setLayout(new BoxLayout(this.jPanelNorth, BoxLayout.X_AXIS));
        this.jPanelNorth.add(this.jLabelNorth);
        this.jPanelNorth.add(this.jTextFieldNorth);
        this.jFrame.add(this.jPanelNorth, BorderLayout.NORTH);
        
        this.jFrame.setVisible(true);
        this.jFrame.repaint();
        
        this.jTextField.setText("~/");
        this.jTextFieldNorth.setText("asset_123,asset_456");
        
        this.resize(1, 1);
        if(this.getParent()!=null){
            this.getParent().setVisible(false);
            if(this.getParent().getParent() != null){
                this.getParent().getParent().setVisible(false);
            }
        }
        this.repaint();
        
        this.jButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                String targetPath = jTextField.getText();
                targetPath = targetPath == null ? "" : targetPath.trim();
                if("".equals(targetPath)){
                    jTextArea.append("need target path first;\n");
                    return;
                }
                
                String targetResource = jTextFieldNorth.getText();
                targetResource = targetResource == null ? "" : targetResource.trim();
                if("".equals(targetResource)){
                    jTextArea.append("need target Linux os first;\n");
                    return;
                }
                
                int result = jFileChooser.showOpenDialog(jFrame);
                if (result == JFileChooser.APPROVE_OPTION) {// 确认打开
                    jTextArea.append("Select file : " + jFileChooser.getSelectedFile().getAbsolutePath()+"\n");
                    
                } else if (result == JFileChooser.CANCEL_OPTION) {
                    jTextArea.append("Cancel button is pushed.\n");
                } else if (result == JFileChooser.ERROR_OPTION) {
                    jTextArea.append("Error when select file.\n");
                }
            }
        });
        
        
    }

}