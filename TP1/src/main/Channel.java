package main;

/**
 * Simple program to open communications ports and connect to Agilent Monitor
 * Object Channel
 * @version 1 - 29 Oct 2015
 * @author Alexandre Sayal (uc2011149504@student.uc.pt)
 * @author André Pedrosa (uc2011159905@student.uc.pt)
 */
public class Channel {

	private int source_id;
	private int channel_id;
	private int msg_type;
	private int channel_num;
	private int source_num;
	private int unused;
	private int layer;
	private String channel_name;
	
	public Channel(int source_id,int channel_id,int msg_type,int channel_num,int source_num,int unused, int layer,String channel_name) {
		this.source_id = source_id;
		this.channel_id = channel_id;
		this.msg_type = msg_type;
		this.channel_num = channel_num;
		this.source_num = source_num;
		this.unused = unused;
		this.layer = layer;
		this.channel_name = channel_name;
	}
	
	/**
	 * Generate the MsgId segment.
	 * @return byte[] msg_id
	 */
	public byte[] returnMsgID(){
		byte[] msgid = new byte[10];
		byte[] temp1 = Utils.intToByteArray2(this.source_id);
		byte[] temp2 = Utils.intToByteArray2(this.channel_id);
		byte[] temp3 = Utils.intToByteArray2(this.msg_type);
		msgid[0] = temp1[0];
		msgid[1] = temp1[1];
		msgid[2] = temp2[0];
		msgid[3]= temp2[1];
		msgid[4] = temp3[0];
		msgid[5] = temp3[1];
		msgid[6] = (byte) this.channel_num;
		msgid[7] = (byte) this.source_num;
		msgid[8] = (byte) this.unused;
		msgid[9] = (byte) this.layer;
		
		return msgid;
	}
	
	/**
	 * Generate the formated string with channel information.
	 * @return String
	 */
	public String formatedString(){
		String format = "|%1$-10s|%2$-10s|%3$-10s|%4$-8s|%5$-8s|%6$-8s|%7$-8s|%8$-10s|\n";
		
		return String.format(format, source_id,channel_id,msg_type,channel_num,source_num,unused,layer,channel_name);
	}

	public int getSource_id() {
		return source_id;
	}

	public void setSource_id(int source_id) {
		this.source_id = source_id;
	}

	public int getChannel_id() {
		return channel_id;
	}

	public void setChannel_id(int channel_id) {
		this.channel_id = channel_id;
	}

	public int getMsg_type() {
		return msg_type;
	}

	public void setMsg_type(int msg_type) {
		this.msg_type = msg_type;
	}

	public int getChannel_num() {
		return channel_num;
	}

	public void setChannel_num(int channel_num) {
		this.channel_num = channel_num;
	}

	public int getSource_num() {
		return source_num;
	}

	public void setSource_num(int source_num) {
		this.source_num = source_num;
	}

	public int getUnused() {
		return unused;
	}

	public void setUnused(int unused) {
		this.unused = unused;
	}

	public int getLayer() {
		return layer;
	}

	public void setLayer(int layer) {
		this.layer = layer;
	}

	public String getChannel_name() {
		return channel_name;
	}

	public void setChannel_name(String channel_name) {
		this.channel_name = channel_name;
	}
}
