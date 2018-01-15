package Assignment2;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Client {
	
	public int id;
	public List<Exercise> routine = null;
	
	public Client(int id) {
		this.id = id;
		routine = new ArrayList<>();
	}
	
	public void addExercise(Exercise e) {
		this.routine.add(e);
	}
	
	public int getId() {
		return this.id;
	}
	
	public static Client generateRandom(int id) {
		
		Client currClient = new Client(id);
		
		int count = (int)(Math.random() * 5) + 15;
		
		for (int i = 0; i < count; i++) {
			Exercise currExercise = Exercise.generateRandom();
			currClient.addExercise(currExercise);
		}
		
		return currClient;
	}
	
	
}
