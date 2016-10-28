package main;
/**
 * Simple program to open communications ports and connect to Agilent Monitor
 * Circular Buffer
 * @version 1 - 29 Oct 2015
 * @author Alexandre Sayal (uc2011149504@student.uc.pt)
 * @author André Pedrosa (uc2011159905@student.uc.pt)
 */
public class BufferCircular {

	private static byte[] buff;
	private static int sizeBuffer;
	private static int beginIndex;
	private static int endIndex;
	private static int writeIndex;

	public BufferCircular(int size) {
		sizeBuffer = size;
		buff = new byte[size];
		beginIndex = 0;
		endIndex = 0;
		writeIndex = 0;
	}

	/**
	 * Add bytes to Buffer , Define read begin 
	 * @param array
	 */	
	public void addBytes(byte[] array){
		for(int i=0;i<array.length;i++){
			buff[(writeIndex)%sizeBuffer] = array[i];
			writeIndex+=1;
		}	
	}

	/**
	 * Check if message is complete: Has got at least the number of bytes defined in comp
	 * @return boolean complete
	 */
	public boolean checkMessage(){

		boolean complete = true;

		int comp = Utils.byte2toInt(buff[(beginIndex+2)%sizeBuffer], buff[(beginIndex+1)%sizeBuffer]);
		
		if((writeIndex-beginIndex) < comp+1){
			complete = false;
		}
		else{
			endIndex = beginIndex + comp; 
			
			int ff_contagem=0;
			for(int ii=beginIndex ; ii<endIndex; ii++){
				if(buff[ii% sizeBuffer] == (byte)0x1B && buff[(ii+1)% sizeBuffer]==(byte)0xFF){ //If the message contains 1BFF, it might not be complete
					complete = false;
					ff_contagem+=1;
				}			
			}
			
			if((ff_contagem+comp+1)>(endIndex-beginIndex) && !complete){
				endIndex=endIndex+ff_contagem;
				complete=true;
			}
		}
		return complete;
	}

	public static byte[] getBuff() {
		return buff;
	}

	public static void setBuff(byte[] buff) {
		BufferCircular.buff = buff;
	}

	/**
	 * Export message in byte array and delete it from buffer.
	 * @return byte[] message
	 */
	public byte[] exportMessage(){
		byte[] message = new byte[endIndex + 1 - beginIndex];
				
		for(int ii=beginIndex; ii<=endIndex;ii++){
			message[ii-beginIndex] = buff[ii%sizeBuffer];
		}
		
		beginIndex = (endIndex+1) % sizeBuffer;
		endIndex = endIndex % sizeBuffer;
		writeIndex = writeIndex % sizeBuffer;
		
		return message;
	}
}