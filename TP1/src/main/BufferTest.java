package main;

import java.util.ArrayList;

public class BufferTest {
	
	private static ArrayList<Byte> buff;
	private static int beginIndex;
	private static int endIndex;
	
	public BufferTest(){
		buff = new ArrayList<Byte>();
	}
	
	/**
	 * Add bytes to Buffer , Define read begin 
	 * @param array
	 */	
	public void findbegin(){
		for(int i=0;i<buff.size()-1;i++){
			if(buff.get(i) == (byte)0x1B && buff.get(i+1) != (byte)0xFF){
				beginIndex = i;
				break;
			}
		}	
	}
	
	public void addBytes(byte[] array){
		for(int i=0;i<array.length;i++){
			buff.add(array[i]);
		}
	}
	
	public ArrayList<Byte> getBuff() {
		return buff;
	}

	public static void setBuff(ArrayList<Byte> buff) {
		BufferTest.buff = buff;
	}

	/**
	 * Check if message is complete: Has got at least the number of bytes defined in comp
	 * @return boolean complete
	 */
	public boolean checkMessage(){
		boolean complete = true;
		for(int j = 0 ; j<10 ; j++){
			System.out.print(buff.get(j));
		}
		System.out.println("\nBuffer size: " + buff.size());
		System.out.println("Comp byte1: " + buff.get(beginIndex+1) + " Comp byte2: " + buff.get(beginIndex+2));
		int comp = CMSInterface.byte2toInt(buff.get(beginIndex+2), buff.get(beginIndex+1));
		System.out.println("Message true length: " + comp);
		
		if(buff.size()<comp+1){
			complete = false;
		}
		else{
			endIndex = beginIndex + comp;
			
			for(int ii=beginIndex ; ii<endIndex; ii++){
				if(buff.get(ii) == (byte)0x1B && buff.get(ii+1)==(byte)0xFF){ //If the message contains 1BFF, it might not be complete
					System.out.println("Mensagem nao completa.");
					complete = false;
					break;
				}			
			}
			
			if(endIndex+1<buff.size() && !complete){ //Check if the buffer has more bytes to read.
				for(int j=endIndex+1 ; j<buff.size()-1 ;j++){ 
					if(buff.get(j)==(byte)0x1B && buff.get(j+1)!=(byte)0xFF){ //If a start 0x1B is found, then the message ends before that.
						System.out.println("End Index ajustado.");
						endIndex = j - 1;
						complete = true;
						break;
					}
				}
			}
			System.out.println("End index: " + endIndex);
		}

		return complete;
	}
	
	/**
	 * Export message in byte array and delete it from buffer.
	 * @return byte[] message
	 */
	public byte[] exportMessage(){
		byte[] message = new byte[endIndex + 1 - beginIndex];
		
		System.out.println("First buff byte: " + buff.get(0));
		System.out.println("First byte: " + buff.get(beginIndex));
		System.out.println("Last byte: " + buff.get(endIndex));
		
//		for(int ii=beginIndex ; ii<=endIndex ; ii++){
//			message[ii] = buff.get(ii);
//		}
//		for(int ii=beginIndex ; ii<=endIndex ; ii++){
//			buff.remove(0);
//		}
		
		
		for(int ii=endIndex; ii>=beginIndex;ii--){
			message[ii] = buff.get(ii);
			buff.remove(ii);
		}
		
		System.out.println("Buffer size after remove: " + buff.size());
		return message;
	}
	
}
