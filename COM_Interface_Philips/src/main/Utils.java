package main;

import gnu.io.CommPortIdentifier;
import java.util.ArrayList;
import java.util.Enumeration;

/**
 * Simple program to open communications ports and connect to Agilent Monitor
 * Several useful values and methods
 * @version 1 - 29 Oct 2015
 * @author Francisco Cardoso (fmcc@student.dei.uc.pt)
 * @author Ricardo Sal (ricsal@student.dei.uc.pt)
 * @author Alexandre Sayal (uc2011149504@student.uc.pt)
 * @author André Pedrosa (uc2011159905@student.uc.pt)
 */
public class Utils {
	static final int TYP_SPI_WS = 3;
	static final int TYP_SPI_CW = 2;
	static final int TYP_SPI_NU = 7;
	static final int SPI_GAIN_OFFSET = 15;
	static final int SPI_CALIBR_PARAM = 11;
	static final int SPI_RT_UNIT = 35;
	static final int SPI_NRM_UNIT = 47;
	static final int SPI_UNIT = 28;
	static final int SPI_NUMERIC = 17;
	static final int SPI_ALARM_LIMITS = 3;
	static final int SPI_RANGE = 24;
	static final int SPI_NUMERIC_STRING = 18;
	static final int SPI_ABS_TIME_STAMP = 1;

	/**
	 * Lists all available communication ports (COM and LPT) on this machine
	 * @return Enumeration with all the ports
	 */
	public static Enumeration<?> getPorts() {
		Enumeration<?> portList = CommPortIdentifier.getPortIdentifiers();
		return portList;
	}
	
	/**
	 * Create message following the MECIF protocol.
	 * @param dst Destination ID
	 * @param src Source ID
	 * @param cmd Command Type
	 * @param data
	 * @return byte[] message
	 */
	public static byte[] messageCreator(int dst , int src , int cmd , int data) {

		ArrayList<Byte> msg = new ArrayList<Byte>();

		byte[] dst_a = Utils.intToByteArray2(dst);
		byte[] src_a = Utils.intToByteArray2(src);
		byte[] cmd_a = Utils.intToByteArray2(cmd);
		byte[] data_a = Utils.intToByteArray2(data);
		
		msg.add(dst_a[0]);
		msg.add(dst_a[1]);
		msg.add(src_a[0]);
		msg.add(src_a[1]);
		msg.add(cmd_a[0]);
		msg.add(cmd_a[1]);
		
		if(cmd==15){
			int selectedChannel = 0;
			
			msg.add(src_a[0]);
			msg.add(src_a[1]);
			
			if(data>0 && data<appInterface.getChannelList().size())
				selectedChannel = data;
			
			byte[] temp = appInterface.getChannelList().get(selectedChannel).returnMsgID();
			
			for(int i=0 ; i<temp.length ; i++){
				msg.add(temp[i]);
			}
			
			msg.add((byte) 0); //--- MpbHd
			msg.add((byte) 0); //--- MpbHd
			msg.add((byte) 0); //--- Rec_Id
			msg.add((byte) 0); //--- Rec_Id
		}
		else{
			msg.add(data_a[0]);
			msg.add(data_a[1]);
		}
		
		byte[] length_a = Utils.intToByteArray2(msg.size()+2);
		
		msg.add(0,length_a[0]);
		msg.add(1,length_a[1]);
		
		//---Switch bytes 2by2
		msg = Utils.byteSwitcher(msg);

		//---Search for 1Bh and add FFh
		msg = Utils.addEscape(msg);

		//---Add Sync Marker
		msg.add(0,(byte) 0x1B);
		
		//---Final transformations
		Byte[] finalmsg = new Byte[msg.size()];
		msg.toArray(finalmsg);

		return Utils.toPrimitive(finalmsg);
	}
	
	/**
	 * Read message following MECIF protocol.
	 * @param msg Received message.
	 * @return String
	 */
	public static String messageReader(byte[] msg){
		ArrayList <Byte> decodedmessage=new ArrayList<Byte>();
		
		//---Search for 1B (message start) and FF.
		for(int i=0; i<msg.length;i++){
			if(i!=msg.length-1){
				if((msg[i]==0x1B && msg[i+1]!=0xFF) || (msg[i]==0xFF && msg[i-1]==0x1B)){
					continue;
				}
				else{
					decodedmessage.add(msg[i]);
				}
			}
			else{
				decodedmessage.add(msg[i]);
			}
		}

		//---Switch bytes 2by2
		decodedmessage = Utils.byteSwitcher(decodedmessage);
		
		//---Determine command type
		int cmd = Utils.byte2toInt(decodedmessage.get(6),decodedmessage.get(7));
		
		//---Return formated string
		return printmessage(cmd,decodedmessage);
	}

	/**
	 * Message formatter.
	 * @param cmd Command Type
	 * @param finalmsg Message
	 * @return String
	 */
	public static String printmessage(int cmd, ArrayList<Byte> finalmsg){
		int comp = Utils.byte2toInt(finalmsg.get(0),finalmsg.get(1));
		int dst_id = Utils.byte2toInt(finalmsg.get(2),finalmsg.get(3));
		int src_id = Utils.byte2toInt(finalmsg.get(4),finalmsg.get(5));
		
		String general_string = " Destination ID: " + dst_id + " Source ID: "
									+ src_id + " Length: " + comp + "\n";
		
		if(cmd==2){ //---Connect Response
			general_string = "Command: " + cmd + general_string;
			int window_size = Utils.byte2toInt(finalmsg.get(8),finalmsg.get(9));
			int compat_high = finalmsg.get(10);
			int compat_low = finalmsg.get(11);
			int return_value = finalmsg.get(12);
			int error_value = finalmsg.get(13);

			String connect_rsp = "Window Size: " + window_size + "\nCompat High: " + compat_high + "\nCompat Low: " + compat_low + "\nReturn Value: " + 
								return_value + "\nError Value: "+ error_value;
			
			return general_string+connect_rsp;
		}
		else if(cmd==8){ //---Disconnect Response
			general_string = "Command: " + cmd + general_string;
			int resp = Utils.byte2toInt(finalmsg.get(8),finalmsg.get(9));
			String disconnect_rsp = "Disconnect Response: " + resp;
			
			return general_string+disconnect_rsp;
		}
		else if(cmd==12){ //---ParList Response
			general_string = "Command: " + cmd + general_string;
			int actual = finalmsg.get(8);
			int total = finalmsg.get(9);
			
			String format = "|%1$-10s|%2$-10s|%3$-10s|%4$-8s|%5$-8s|%6$-8s|%7$-8s|%8$-10s|\n";
			String text = String.format(format, "Src ID","Ch ID","Msg Type","Ch N","Src N","Unused","Layer","Ch Name");
			
			int [] num = new int[16];
			int b = 10;

			while(b<finalmsg.size()){				
				int source_id = Utils.byte2toInt(finalmsg.get(b),finalmsg.get(b+1));
				int channel_id = Utils.byte2toInt(finalmsg.get(b+2),finalmsg.get(b+3));
				int msg_type = Utils.byte2toInt(finalmsg.get(b+4),finalmsg.get(b+5));
				int channel_num = Utils.byte2toInt((byte) 0,finalmsg.get(b+6));
				int source_num = Utils.byte2toInt((byte) 0,finalmsg.get(b+7));
				int unused = Utils.byte2toInt((byte) 0,finalmsg.get(b+8));
				int layer = Utils.byte2toInt((byte) 0,finalmsg.get(b+9));
				
				for(int j = 0; j<16 ; j++){
					num[j] = Utils.byte2toInt((byte) 0,finalmsg.get(b+10+j));
				}
				Channel temp = new Channel(source_id,channel_id,msg_type,channel_num,source_num,unused,layer,AsciiConversions.c16_to_c8(num));
				
				appInterface.getChannelList().add(temp);
				
				text = text + temp.formatedString();
				b+=26;
			}
			
			String parlist_rsp = "Actual: " + actual + " Total: " + total + "\n" + text;
		
			return general_string+parlist_rsp;
		}
		else if(cmd==16){ //---Single Tune Response
			general_string = "Command: " + cmd + general_string;
			int tune_id = Utils.byte2toInt(finalmsg.get(8),finalmsg.get(9));
			String data_tune = "\nMsg_ID: ";
			for(int i=10 ; i<20 ; i++){
				data_tune = data_tune + finalmsg.get(i) + ",";
			}
			int mpbhd = Utils.byte2toInt(finalmsg.get(20),finalmsg.get(21));
			int rec_id = Utils.byte2toInt(finalmsg.get(22),finalmsg.get(23));

			String singletune_rsp = "Single Tune ID: \nTune ID:" + tune_id + data_tune + "\nMPB: "
						+ mpbhd + "\nRec_Id: " + rec_id;

			return general_string+singletune_rsp;
		}
		else{ //---Single Tune DATA
			int mpbhd = Utils.byte2toInt(finalmsg.get(8),finalmsg.get(9));
			int rec_size = finalmsg.get(10);
			if(rec_size<0)
				rec_size = rec_size + 256;
			int mpb_len = finalmsg.get(11);
			String mpb_data = "";
			for(int i=12; i<finalmsg.size() ; i++){
				mpb_data = mpb_data + finalmsg.get(i) + ",";
			}
			
			String singletune_data = "Single Tune DATA\nMpbHd: " + mpbhd + "\nRecSize: " + rec_size + "\nMpbLength: "
					+ mpb_len + "\nDATA: " + mpb_data;
			
			return general_string+singletune_data;
		}
	}
	
	/**
	 * Byte Switcher (2by2).
	 * @param msg
	 * @return ArrayList<Byte>
	 */
	public static ArrayList<Byte> byteSwitcher(ArrayList<Byte> msg){
		int i=0;
		while(i<msg.size()){
			byte temp = (byte) msg.get(i);
			byte temp2 = (byte) msg.get(i+1);
			msg.set(i, temp2);
			msg.set(i+1, temp);
			i = i+2;
		}
		return msg;
	}
	
	/**
	 * Add escape sequence to message.
	 * @param msg
	 * @return ArrayList<Byte>
	 */
	public static ArrayList<Byte> addEscape(ArrayList<Byte> msg){
		for(int j=0 ; j<msg.size() ; j++){
			if(msg.get(j)==(byte)0x1B){
				msg.add(j+1, (byte) 0xFF);
			}
		}
		return msg;
	}
	
	/**
	 * Convert Integer to a byte array of length 2.
	 * @param value Integer
	 * @return byte[]
	 */
	public static byte[] intToByteArray2(int value){
		byte[] array = new byte[2];
		array[0] = (byte) (value/256);
		array[1] = (byte) (value%256);
		return array;
	}

	/**
	 * Convert two bytes to Integer.
	 * @param one byte
	 * @param two byte
	 * @return Integer
	 */
	public static int byte2toInt(byte one,byte two){
		int a=one;
		int b=two;
		if(a<0)
			a=one+256;
		if(b<0)
			b=two+256;
		
		return a*256+b;
	}

	/**
	 * Convert Byte[] to byte[].
	 * @param array
	 * @return byte[]
	 */
	public static byte[] toPrimitive(Byte[] array) {
		byte[] primitive = new byte[array.length];
		for (int i = 0; i < array.length; i++) {
			primitive[i] = array[i].byteValue();
		}
		return primitive;
	}
}