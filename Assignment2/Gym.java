package Assignment2;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;

public class Gym implements Runnable{
	
	private static final int GYM_SIZE = 30;
	private static final int GYM_REGISTERED_CLIENTS = 10000;
	
	private static final int SMALL_3KG_size = 110;
	private static final int MEDIUM_5KG_size = 90;
	private static final int LARGE_10KG_size = 75;
	
	private Map<WeightPlateSize, Semaphore> plateSemaphore = new Hashtable<>();
	private Map<ApparatusType, Semaphore> apparatusSemaphore = new Hashtable<>();
	
//	private Map<WeightPlateSize,Integer> noOfWeightPlates = null;
	private Set<Integer> clients = null; 
	private ExecutorService executor = null;
	
	private Semaphore mutex = new Semaphore(1);
	
	public Gym() {

		executor = Executors.newFixedThreadPool(GYM_SIZE);
		
		plateSemaphore.put(WeightPlateSize.SMALL_3KG, new Semaphore(SMALL_3KG_size));
		plateSemaphore.put(WeightPlateSize.MEDIUM_5KG, new Semaphore(MEDIUM_5KG_size));
		plateSemaphore.put(WeightPlateSize.LARGE_10KG, new Semaphore(LARGE_10KG_size));
		
		ApparatusType[] atEnums= ApparatusType.values();
		for (ApparatusType at : atEnums) {
			apparatusSemaphore.put(at, new Semaphore(5));
		}
			
		clients = new HashSet<>();
		for (int i = 0; i < GYM_REGISTERED_CLIENTS; i++) {
			clients.add(i);
		}
		
	}
	
	@Override
	public void run() {
		ArrayList<Client> clientList = new ArrayList<>();
		for (int id : clients) {
			clientList.add(Client.generateRandom(id));
		}
		
//		Collections.shuffle(clientList);
		
		for (Client currClient : clientList) {
			executor.execute(new Runnable() {

				@Override
				public void run() {
					System.out.println("The client " + currClient.getId() + " starts exercising");
					
					for (Exercise e : currClient.routine) {
                        try {
                            apparatusSemaphore.get(e.at).acquire();
                            mutex.acquire();
                            for (WeightPlateSize wp : e.weight.keySet()) {
                                int plateNums = e.weight.get(wp);
                                for (int i = 0; i < plateNums; i++) {
                                    plateSemaphore.get(wp).acquire();
                                }
                            } 
                            mutex.release();
                           
                            //Spending time doing exercise...
                            System.out.println("The client " + currClient.getId() + " is doing " + e.at.toString());
                            while (e.duration > 0) {
                            	e.duration--;
                            }
                            
                            for (WeightPlateSize wp : e.weight.keySet()) {
                                int plateNums = e.weight.get(wp);
                                for (int i = 0; i < plateNums; i++) {
                                    plateSemaphore.get(wp).release();
                                }
                            }
                            
                            apparatusSemaphore.get(e.at).release();
                            
                        } catch (InterruptedException e1) {
                            e1.printStackTrace();
                        }
                    }
					System.out.println("The client " + currClient.getId() + " ends exercising");
				}
			});
			
		}
		executor.shutdown();
	} 
}















