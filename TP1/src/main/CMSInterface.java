package main;
/**
 * Simple program to open communications ports and connect to Agilent Monitor
 * CMS Interface
 * @version 1 - 29 Oct 2015
 * @author Alexandre Sayal (uc2011149504@student.uc.pt)
 * @author André Pedrosa (uc2011159905@student.uc.pt)
 */
public class CMSInterface {

	final static int dst = 32865;
	final static int src = 10;
		
	public static void connect(ComInterface port) throws InterruptedException {

		final int cmd = 01;

		int data = 0; //---No Life Tick

		byte[] message = Utils.messageCreator(dst,src,cmd,data);
		
		port.writeBytes(message);
				
	}

	public static void disconnect(ComInterface port) throws InterruptedException {

		final int cmd = 07;

		int data = 0;

		byte[] message = Utils.messageCreator(dst,src,cmd,data);
		
		port.writeBytes(message);

	}

	public static void getParList(ComInterface port) throws InterruptedException {
		
		final int cmd = 11;

		int data = 0;

		byte[] message = Utils.messageCreator(dst,src,cmd,data);
		
		port.writeBytes(message);
	}

	public static void singleTuneRequest(ComInterface port,int id) {
		
		final int cmd = 15;
		
		int data = id ;
				
		byte[] message = Utils.messageCreator(dst,src,cmd,data);
		
		port.writeBytes(message);
	}
}