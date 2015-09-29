package main;

import java.util.ArrayList;

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

	public static void connect(ComInterface port) {

		final int cmd = 01;
		
		int data = 00;
		
		byte[] message = messageCreator(dst,src,cmd,data);
//		for(byte b : message){
//			System.out.print(b + " ");
//		}
		
		port.writeBytes(message);
	}

	public static void disconnect() {

	}

	public static void getParList() {

	}

	public static void singleTuneRequest(int id)
	{

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
		
		msg.add(0,(byte) 27);
		msg.add(1,length_a[0]);
		msg.add(2,length_a[1]);

		Byte[] finalmsg = new Byte[msg.size()];

		msg.toArray(finalmsg);

		return toPrimitive(finalmsg);

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