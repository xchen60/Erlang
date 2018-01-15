package Assignment2;

import java.util.Random;

public enum ApparatusType {
	
	LEGPRESSMACHINE, BARBELL, HACKSQUATMACHINE, 
	LEGEXTENSIONMACHINE, LEGCURLMACHINE, LATPULLDOWNMACHINE, 
	PECDECKMACHINE, CABLECROSSOVERMACHINE;
		
	public static ApparatusType generateRandom(){		
		ApparatusType[] enums= ApparatusType.values();
		Random random = new Random();  
		ApparatusType at = enums[random.nextInt(enums.length)]; 
		
		return at;
	}
	
}
