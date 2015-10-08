package main;

import java.util.ArrayList;

/**
 * Simple program to open communications ports and connect to Agilent Monitor
 * Agilent Communication Interface
 * @version 1.0 - 2015
 * @author Alexandre Sayal
 * @author André Pedrosa
 */


public class CMSInterface {

	final static int dst = 32865;
	final static int src = 10;
		
	public static void connect(ComInterface port) throws InterruptedException {

		final int cmd = 01;

		int data = 00; //---No Life Tick

		byte[] message = messageCreator(dst,src,cmd,data);

		System.out.println("--Message--------");
		for(byte b : message){
			System.out.print(b);
		}
		System.out.println("\n--End--------");
		
		port.writeBytes(message);
//		Thread.sleep(1000);
//		byte[] response = port.readBytes();
//		
//		String rsp_string=messageReader(response);
//
//		System.out.println("---Message received---");
//		System.out.println(rsp_string);
//		System.out.println("----------------------");
		
	}

	public static void disconnect(ComInterface port) throws InterruptedException {

		final int cmd = 07;

		int data = 00; //---Necessary?

		byte[] message = messageCreator(dst,src,cmd,data);
		
		port.writeBytes(message);
//		Thread.sleep(1000);
//		byte[] response = port.readBytes();
//		
//		String rsp_string = messageReader(response);
//
//		System.out.println("---Message received---");
//		System.out.println(rsp_string);
//		System.out.println("----------------------");

	}

	public static void getParList(ComInterface port) throws InterruptedException {
		
		final int cmd = 11;

		int data = 00; //---Necessary?

		byte[] message = messageCreator(dst,src,cmd,data);
		
		port.writeBytes(message);
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
		msg = byteSwitcher(msg);
		
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
	
	public static String messageReader(byte[] msg){
		ArrayList <Byte> decodedmessage=new ArrayList<Byte>();
		
		//---Search for 1B (message start) and FF.
		for(int i=0; i<msg.length;i++){
			if((msg[i]==0x1B && msg[i+1]!=0xFF) || (msg[i]==0xFF && msg[i-1]==0x1B)){
				continue;
			}
			else{
				decodedmessage.add(msg[i]);
			}
		}

		//---Switch bytes 2by2
		decodedmessage = byteSwitcher(decodedmessage);
		
		//---Determine command type
		int cmd = byte2toInt(decodedmessage.get(6),decodedmessage.get(7));
		
		System.out.println("\nCMD: " + cmd);

		//---Return formated string
		return printmessage(cmd,decodedmessage);
	}

	public static String printmessage(int cmd, ArrayList<Byte> finalmsg){
		int comp = byte2toInt(finalmsg.get(0),finalmsg.get(1));
		int dst_id = byte2toInt(finalmsg.get(2),finalmsg.get(3));
		int src_id = byte2toInt(finalmsg.get(4),finalmsg.get(5));
		
		String general_string = "Command: " + cmd + " Destination ID: " + dst_id + " Source ID: "
									+ src_id + " Length: " + comp + "\n";
		
		if(cmd==2){ //---Connect Response
			int window_size = byte2toInt(finalmsg.get(8),finalmsg.get(9));
			int compat_high = finalmsg.get(10);
			int compat_low = finalmsg.get(11);
			int return_value = finalmsg.get(12);
			int error_value = finalmsg.get(13);

			String connect_rsp = "Window Size: " + window_size + "\nCompat High: " + compat_high + "\nCompat Low: " + compat_low + "\nReturn Value: " + 
								return_value + "\nError Value: "+ error_value;
			
			return general_string+connect_rsp;
		}
		else if(cmd==8){ //---Disconnect Response
			int resp = byte2toInt(finalmsg.get(8),finalmsg.get(9));
			String disconnect_rsp = "Disconnect Response: " + resp;
			
			return general_string+disconnect_rsp;
		}
		else if(cmd==12){ //---ParList Response
			int actual = finalmsg.get(8);
			int total = finalmsg.get(9);
			int msg_id = finalmsg.get(10); //---TODO Pode nao ter so 1 byte
			String temp = "";
			for(int b=11 ; b<finalmsg.size();b++){
				temp = temp + finalmsg.get(b);
			}
			String parlist_rsp = "Actual: " + actual + "Total: " + total + "Msg_ID: " + msg_id + "\nMessage: " + temp;
		
			return parlist_rsp;
		}
		else{
			return null;
		}
	}

	public static ArrayList<Byte> byteSwitcher(ArrayList<Byte> msg){
		int i=0;
		while(i<msg.size()){
			byte temp = msg.get(i);
			byte temp2 = msg.get(i+1);
			msg.set(i, temp2);
			msg.set(i+1, temp);
			i = i+2;
		}
		return msg;
	}
	
	public static byte[] intToByteArray2(int value){
		byte[] array = new byte[2];
		array[0] = (byte) (value/256);
		array[1] = (byte) (value%256);
		return array;
	}

	public static int byte2toInt(byte one,byte two){
		int number = one*256 + two;
		return number;
	}

	public static byte[] toPrimitive(Byte[] array) {
		byte[] primitive = new byte[array.length];
		for (int i = 0; i < array.length; i++) {
			primitive[i] = array[i].byteValue();
		}
		return primitive;
	}
}