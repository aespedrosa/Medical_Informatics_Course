package main;

public class balele {

	public static void main(String[] args) {
//		byte coiso= (byte) 0x1B;
//		byte a=coiso;
//		System.out.println(a);
//		System.out.println(a==(byte)0xFF);
		
		String format = "|%1$-8s|%2$-8s|%3$-10s|%4$-8s|%5$-8s|%6$-8s|%7$-8s|%8$-10s|\n";
		String text = String.format(format, "Src ID","Ch ID","Msg Type","Ch N","Src N","Unused","Layer","Ch Name");
		
		text = text + String.format(format, 12999,11111,345,23,123,12,123,3456);
		
		System.out.println(text);
		
	} 
}
