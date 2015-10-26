package main;

public class BufferTwo {

	private static byte[] buff;
	private static int sizeBuffer;
	private static int beginIndex;
	private static int endIndex;
	private static int writeIndex;

	public BufferTwo(int size) {
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
	 * Finds the first 1B in the buffer
	 */
	public void findbegin(){
		for(int i=0;i<buff.length-1;i++){
			if(buff[i] == (byte)0x1B && buff[i+1] != (byte)0xFF){
				beginIndex = i;
				break;
			}
		}	
	}


	/**
	 * Check if message is complete: Has got at least the number of bytes defined in comp
	 * @return boolean complete
	 */
	public boolean checkMessage(){

		boolean complete = true;

		int comp = CMSInterface.byte2toInt(buff[(beginIndex+2)%sizeBuffer], buff[(beginIndex+1)%sizeBuffer]);

		if(((writeIndex+sizeBuffer-beginIndex)%sizeBuffer) < comp+1){
			complete = false;
			System.out.println("Nao chega o comprimento");
		}
		else{
			endIndex = beginIndex + comp; //endIndex e "virtual"
			
			int ff_contagem=0;
			for(int ii=beginIndex ; ii<endIndex; ii++){
				if(buff[ii% sizeBuffer] == (byte)0x1B && buff[(ii+1)% sizeBuffer]==(byte)0xFF){ //If the message contains 1BFF, it might not be complete
					System.out.println("Existe FF");
					complete = false;
					//break;
					ff_contagem+=1;
				}			
			}

			if((ff_contagem+comp+1)>(endIndex-beginIndex) && !complete){
				endIndex=endIndex+ff_contagem;
				complete=true;
			}
			
//			if((writeIndex-endIndex) > 0 && !complete){ //Check if the buffer has more bytes to read.
//				System.out.println("Tem mais bytes.");
//				for(int j=endIndex+1 ; j<writeIndex ;j++){ 
//					if(buff[j % sizeBuffer]==(byte)0x1B && buff[(j+1) % sizeBuffer]!=(byte)0xFF){ //If a start 0x1B is found, then the message ends before that.
//						System.out.println("Encontrei outro 27.");
//						endIndex=j-1;
//						complete = true;
//						break;
//					}
//				}
//			}
		}
		System.out.println("B: " + beginIndex + " E: " + endIndex + " W: " + writeIndex);
		return complete;
	}

	public static byte[] getBuff() {
		return buff;
	}

	public static void setBuff(byte[] buff) {
		BufferTwo.buff = buff;
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
