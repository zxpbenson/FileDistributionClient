::java -cp FileDistributionClient.jar;jsch-0.1.51.jar; com.fortappend.SwingClient true
::java -Djava.ext.dirs=. com.fortappend.SwingClient true
java -cp FileDistributionClient.jar;jsch-0.1.51.jar; com.fortappend.SwingClient true userAccount serverHost 22 ~/ authorize_list
pause