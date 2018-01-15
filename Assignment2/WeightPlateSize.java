package Assignment2;

import java.util.Random;

public enum WeightPlateSize {
	
	SMALL_3KG, MEDIUM_5KG, LARGE_10KG;
	
	public static WeightPlateSize generateRandom(){		
		WeightPlateSize[] enums= WeightPlateSize.values();
		Random random = new Random();  
		WeightPlateSize wp = enums[random.nextInt(enums.length)]; 
		
		return wp;
	}
	
}
