package main;

import javax.swing.JTextArea;

/**
 * Simple program to open communications ports and connect to Agilent Monitor
 * Reader Thread
 * @version 1 - 29 Oct 2015
 * @author Alexandre Sayal (uc2011149504@student.uc.pt)
 * @author André Pedrosa (uc2011159905@student.uc.pt)
 */
public class ThreadRead {
	
	private Thread thread_read;
	private int buffersize;
	private int sleeptime;

	public ThreadRead(JTextArea textArea , ComInterface cominterface) {
		buffersize = 1500;
		sleeptime = 100; 
		
		this.thread_read = new Thread(new Runnable() {
			public void run(){
				BufferCircular buffer = new BufferCircular(buffersize);

				textArea.append("Listener Thread Started. Step " + sleeptime + "ms.\n");
				
				while(true){
					try {
						
						byte[] msg = cominterface.readBytes();

						if(msg.length!=0){

							buffer.addBytes(msg);
							
							if(buffer.checkMessage()){
//								textArea.append("-----New Message Received-----\n");
//								textArea.append(Utils.messageReader(buffer.exportMessage())  + "\n");
//								textArea.append("------------------------------\n");
								System.out.println("-----New Message Received-----\n");
								System.out.println(Utils.messageReader(buffer.exportMessage())  + "\n");
								System.out.println("------------------------------\n");
							}
						}
						
						Thread.sleep(sleeptime); 
												
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			}
		});  
	}
	
	public void startThreadRead(){
		this.thread_read.start();
	}
	
	@SuppressWarnings("deprecation")
	public void stopThreadRead(){
		this.thread_read.stop();
	}
}