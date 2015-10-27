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

//	public static byte[] messageCreator(int dst , int src , int cmd , int data) {
//
//		ArrayList<Byte> msg = new ArrayList<Byte>();
//
//		byte[] dst_a = Utils.intToByteArray2(dst);
//		byte[] src_a = Utils.intToByteArray2(src);
//		byte[] cmd_a = Utils.intToByteArray2(cmd);
//		byte[] data_a = Utils.intToByteArray2(data);
//		
//		msg.add(dst_a[0]);
//		msg.add(dst_a[1]);
//		msg.add(src_a[0]);
//		msg.add(src_a[1]);
//		msg.add(cmd_a[0]);
//		msg.add(cmd_a[1]);
//		msg.add(data_a[0]);
//		msg.add(data_a[1]);
//		
//		byte[] length_a = Utils.intToByteArray2(msg.size()+2);
//		
//		msg.add(0,length_a[0]);
//		msg.add(1,length_a[1]);
//		
//		//---Switch bytes 2by2
//		msg = Utils.byteSwitcher(msg);
//
//		//---Search for 1Bh and add FFh
//		msg = Utils.addEscape(msg);
//
//		//---Add Sync Marker
//		msg.add(0,(byte) 0x1B);
//		
//		//---Final transformations
//		Byte[] finalmsg = new Byte[msg.size()];
//		msg.toArray(finalmsg);
//
//		return Utils.toPrimitive(finalmsg);
//	}
//	
//	public static String messageReader(byte[] msg){
//		ArrayList <Byte> decodedmessage=new ArrayList<Byte>();
//		
//		//---Search for 1B (message start) and FF.
//		for(int i=0; i<msg.length;i++){
//			if(i!=msg.length-1){
//				if((msg[i]==0x1B && msg[i+1]!=0xFF) || (msg[i]==0xFF && msg[i-1]==0x1B)){
//					continue;
//				}
//				else{
//					decodedmessage.add(msg[i]);
//				}
//			}
//			else{
//				decodedmessage.add(msg[i]);
//			}
//		}
//
//		//---Switch bytes 2by2
//		decodedmessage = Utils.byteSwitcher(decodedmessage);
//		
//		//---Determine command type
//		int cmd = Utils.byte2toInt(decodedmessage.get(6),decodedmessage.get(7));
//		
//		//---Return formated string
//		return printmessage(cmd,decodedmessage);
//	}
//
//	public static String printmessage(int cmd, ArrayList<Byte> finalmsg){
//		int comp = Utils.byte2toInt(finalmsg.get(0),finalmsg.get(1));
//		int dst_id = Utils.byte2toInt(finalmsg.get(2),finalmsg.get(3));
//		int src_id = Utils.byte2toInt(finalmsg.get(4),finalmsg.get(5));
//		
//		String general_string = "Command: " + cmd + " Destination ID: " + dst_id + " Source ID: "
//									+ src_id + " Length: " + comp + "\n";
//		
//		if(cmd==2){ //---Connect Response
//			int window_size = Utils.byte2toInt(finalmsg.get(8),finalmsg.get(9));
//			int compat_high = finalmsg.get(10);
//			int compat_low = finalmsg.get(11);
//			int return_value = finalmsg.get(12);
//			int error_value = finalmsg.get(13);
//
//			String connect_rsp = "Window Size: " + window_size + "\nCompat High: " + compat_high + "\nCompat Low: " + compat_low + "\nReturn Value: " + 
//								return_value + "\nError Value: "+ error_value;
//			
//			return general_string+connect_rsp;
//		}
//		else if(cmd==8){ //---Disconnect Response
//			int resp = Utils.byte2toInt(finalmsg.get(8),finalmsg.get(9));
//			String disconnect_rsp = "Disconnect Response: " + resp;
//			
//			return general_string+disconnect_rsp;
//		}
//		else if(cmd==12){ //---ParList Response
//			int actual = finalmsg.get(8);
//			int total = finalmsg.get(9);
//			
//			String format = "|%1$-10s|%2$-10s|%3$-10s|%4$-8s|%5$-8s|%6$-8s|%7$-8s|%8$-10s|\n";
//			String text = String.format(format, "Src ID","Ch ID","Msg Type","Ch N","Src N","Unused","Layer","Ch Name");
//			
//			int [] num = new int[16];
//			int b = 10;
//			while(b<finalmsg.size()){
//				int source_id = Utils.byte2toInt(finalmsg.get(b),finalmsg.get(b+1));
//				int channel_id = Utils.byte2toInt(finalmsg.get(b+2),finalmsg.get(b+3));
//				int msg_type = Utils.byte2toInt(finalmsg.get(b+4),finalmsg.get(b+5));
//				int channel_num = Utils.byte2toInt((byte) 0,finalmsg.get(b+6));
//				int source_num = Utils.byte2toInt((byte) 0,finalmsg.get(b+7));
//				int unused = Utils.byte2toInt((byte) 0,finalmsg.get(b+8));
//				int layer = Utils.byte2toInt((byte) 0,finalmsg.get(b+9));
//				for(int j = 0; j<16 ; j++){
//					num[j] = Utils.byte2toInt((byte) 0,finalmsg.get(b+10+j));
//				}
//				
//				text = text + String.format(format, source_id,channel_id,msg_type,channel_num,source_num,unused,layer,AsciiConversions.c16_to_c8(num));
//				b+=26;
//			}
//			
//			String parlist_rsp = "Actual: " + actual + " Total: " + total + "\n" + text;
//		
//			return general_string+parlist_rsp;
//		}
//		else if(cmd==16){ //---Single Tune Response
//			int resp = Utils.byte2toInt(finalmsg.get(8),finalmsg.get(9));
//			String singletune_rsp = "Single Tune ID: " + resp;
//			
//			return general_string+singletune_rsp;
//		}
//		else{
//			return "Error: Command not known.";
//		}
//	}

//	public static ArrayList<Byte> byteSwitcher(ArrayList<Byte> msg){
//		int i=0;
//		while(i<msg.size()){
//			byte temp = (byte) msg.get(i);
//			byte temp2 = (byte) msg.get(i+1);
//			msg.set(i, temp2);
//			msg.set(i+1, temp);
//			i = i+2;
//		}
//		return msg;
//	}
//	
//	public static ArrayList<Byte> addEscape(ArrayList<Byte> msg){
//		for(int j=0 ; j<msg.size() ; j++){
//			if(msg.get(j)==(byte)0x1B){
//				msg.add(j+1, (byte) 0xFF);
//			}
//		}
//		return msg;
//	}
//	
//	public static byte[] intToByteArray2(int value){
//		byte[] array = new byte[2];
//		array[0] = (byte) (value/256);
//		array[1] = (byte) (value%256);
//		return array;
//	}
//
//	public static int byte2toInt(byte one,byte two){
//		byte[] aux = {one,two};
//		ByteBuffer buffer = ByteBuffer.wrap(aux);
//		buffer.order(ByteOrder.BIG_ENDIAN);  
//		return buffer.getShort();
//	}
//
//	public static byte[] toPrimitive(Byte[] array) {
//		byte[] primitive = new byte[array.length];
//		for (int i = 0; i < array.length; i++) {
//			primitive[i] = array[i].byteValue();
//		}
//		return primitive;
//	}
}