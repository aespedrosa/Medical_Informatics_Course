package main;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class balele {

	public static void main(String[] args) throws InterruptedException {
//		byte coiso= (byte) 0x1B;
//		byte a=coiso;
//		System.out.println(a);
//		System.out.println(a==(byte)0xFF);
		
//		String format = "|%1$-8s|%2$-8s|%3$-10s|%4$-8s|%5$-8s|%6$-8s|%7$-8s|%8$-10s|\n";
//		String text = String.format(format, "Src ID","Ch ID","Msg Type","Ch N","Src N","Unused","Layer","Ch Name");
//		
//		text = text + String.format(format, 12999,11111,345,23,123,12,123,3456);
//		
//		System.out.println(text);
//
//		int size = 50;
////		System.out.println( ((10+size)-40)%size );
//		
//		System.out.println( 60 % size + size);
		
		BufferTwo buffer = new BufferTwo(30);
		int k = 0;
		while(k<11){
			int[] data = {27};
			byte[] msg = CMSInterface.messageCreator(23412, 11 , 8 , data);
			
			buffer.addBytes(msg);
			for(int b=0; b<buffer.getBuff().length ;b++){
				System.out.print(buffer.getBuff()[b]+ ",");
			}
			
			System.out.println();
			
			if(buffer.checkMessage()){
				System.out.println("Fixe");
				byte[] finalmsg = buffer.exportMessage();
				for(int b=0; b<finalmsg.length ;b++){
					System.out.print(finalmsg[b]+ ",");
				}
				System.out.println();
				System.out.println(CMSInterface.messageReader(finalmsg)  + "\n");
				System.out.println("iter:------------------------>"+k);
			}
			Thread.sleep(100);
			k+=1;			
		}
		
		
	} 
}
