package main;

import java.util.ArrayList;
import java.util.concurrent.TimeUnit;

/**
 * Simple program to open communications ports and connect to Agilent Monitor
 * Agilent Communication Interface - TO BE IMPLEMENTED
 * @version 1.2 - 30 Set 2003
 * @author Francisco Cardoso (fmcc@student.dei.uc.pt)
 * @author Ricardo Sal (ricsal@student.dei.uc.pt)
 */


public class CMSInterface {

	final static int dst = 32865;
	final static int src = 10;
	
//	public static void main(String[] args) throws InterruptedException {
//		connect();
//	}
	
	public static void connect(ComInterface port) throws InterruptedException {

		// 
		final int cmd = 01;

		int data = 00; //---No Life Tick

		byte[] message = messageCreator(dst,src,cmd,data);

		System.out.println("--Message--------");
		for(byte b : message){
			System.out.print(b);
		}
		System.out.println("\n--End--------");
		
		port.writeBytes(message);
		Thread.sleep(1000);
		byte[] response = port.readBytes();
		
		System.out.println("---Message received: ");
		System.out.println("Size: " + response.length);
		System.out.println("------------------");
		
	}

	public static void disconnect(ComInterface port) throws InterruptedException {

		final int cmd = 07;

		int data = 00; //---Necessary?

		byte[] message = messageCreator(dst,src,cmd,data);
		
		port.writeBytes(message);
		Thread.sleep(1000);
		byte[] response = port.readBytes();
		
		System.out.println("---Message received: ");
		System.out.println("Size: " + response.length);
		System.out.println("------------------");

	}

	public static void getParList() {

	}

	public static void singleTuneRequest(int id) {

	}

	public static byte[] messageCreator(int dst , int src , int cmd , int data) {

		ArrayList<Byte> msg = new ArrayList<Byte>();

		byte[] dst_a = intToByteArray2(dst);
		byte[] src_a = intToByteArray2(src);
		byte[] cmd_a = intToByteArray2(cmd);
		byte[] data_a = intToByteArray2(data);

		msg.add(dst_a[0]);
		msg.add(dst_a[1]);
		msg.add(src_a[0]);
		msg.add(src_a[1]);
		msg.add(cmd_a[0]);
		msg.add(cmd_a[1]);
		msg.add(data_a[0]);
		msg.add(data_a[1]);

		byte[] length_a = intToByteArray2(msg.size()+2);
		
		msg.add(0,length_a[0]);
		msg.add(1,length_a[1]);
		
		//---Switch bytes 2by2
		int i=0;
		while(i<msg.size()){
			byte temp;
			byte temp2;
			temp = msg.get(i);
			temp2 = msg.get(i+1);
			msg.set(i, temp2);
			msg.set(i+1, temp);
			i = i+2;
		}
		
		//---Search for 1Bh and add FFh
		if(msg.contains((byte) 0x1B)){
			msg.add(msg.indexOf((byte) 0x1B)+1, (byte) 0xFF);
		}
				
		//---Add Marker
		msg.add(0,(byte) 0x1B);
		
		//---Final transformations
		Byte[] finalmsg = new Byte[msg.size()];
		msg.toArray(finalmsg);

		return toPrimitive(finalmsg);

	}
	
	//TODO 
	public static String messageReader(byte[] msg){
		String printmensage = null;
		return printmensage;
	}

	public static byte[] intToByteArray2(int value){
		byte[] array = new byte[2];
		array[0] = (byte) (value/256);
		array[1] = (byte) (value%256);
		return array;
	}

	public static byte[] toPrimitive(Byte[] array) {
		byte[] primitive = new byte[array.length];
		for (int i = 0; i < array.length; i++) {
			primitive[i] = array[i].byteValue();
		}
		return primitive;
	}
}