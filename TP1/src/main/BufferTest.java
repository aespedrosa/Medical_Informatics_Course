package main;

import java.util.ArrayList;

public class BufferTest {
	
	private static ArrayList<Byte> buff;
	private static int beginIndex;
	private static int endIndex;
	
	public BufferTest(){
		buff = new ArrayList<Byte>();
	}
		
	public void addBytes(byte[] array){
		boolean first = false;
		
		for(int i=0;i<array.length;i++){
			if(array[i] == 0x1B && array[i+1] != 0xFF && !first && i!=array.length-1){ //TODO Fora daqui satanas
				beginIndex = i;
				System.out.println("Begin defined: " + beginIndex);
				first = true;
			}
			buff.add(array[i]);
		}
	}
	
	public boolean checkMessage(){
		boolean complete = true;
		System.out.println("Buffer size: " + buff.size());
		int comp = CMSInterface.byte2toInt(buff.get(beginIndex+2), buff.get(beginIndex+1));
		
		if(buff.size()<comp+1){
			complete = false;
		}
		else{
			endIndex = beginIndex + comp + 1;
			for(int ii=beginIndex ; ii<endIndex; ii++){
				if(buff.get(ii) == 0x1B && buff.get(ii+1)==0xFF){
					complete = false;
					break;
				}			
			}
		}

		return complete;
	}
	
	public byte[] exportMessage(){
		byte[] message = new byte[endIndex - beginIndex];
		
		for(int ii=endIndex-1; ii>=beginIndex;ii--){
			message[ii] = buff.get(ii);
			buff.remove(ii);
		}
		
		beginIndex = 0;
		return message;
	}
	
}
