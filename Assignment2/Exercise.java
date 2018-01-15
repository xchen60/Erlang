package Assignment2;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

public class Exercise {
	
	public ApparatusType at = null;
	public Map<WeightPlateSize,Integer> weight = null;
	public int duration;
	
	public Exercise(ApparatusType at, Map<WeightPlateSize, Integer> weight, int duration) {
		this.at = at;
		this.weight = weight;
		this.duration = duration;
	}
	
	public static Exercise generateRandom() {
		
//		Map<WeightPlateSize, Integer> new_wpMap = wpMap;
		int new_duration = (int)((Math.random()+1) * 5000000);
		ApparatusType new_at = ApparatusType.generateRandom();
		
		Map<WeightPlateSize, Integer> new_weight = new Hashtable<>();
		new_weight.put(WeightPlateSize.SMALL_3KG, (int)(Math.random() * 9) + 1);
		new_weight.put(WeightPlateSize.MEDIUM_5KG, (int)(Math.random() * 9) + 1);
		new_weight.put(WeightPlateSize.LARGE_10KG, (int)(Math.random() * 9) + 1);
		
		return new Exercise(new_at, new_weight, new_duration);
	}
	
}












