package hw1;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class AssignmentOne {
	
	public static List<Integer> result = null;
	public static List<Thread> threadList = null;
	public static List<PrimeFinder> primeFinderList = null;
	
	public static void main(String[] args) throws InterruptedException {
		 result = new ArrayList<>();
		 threadList = new ArrayList<>();
		 primeFinderList = new ArrayList<>();
		 
		 List<Integer[]> intervals = new ArrayList<>();
		 
		 for (int i = 0; i < args.length-1; i++) {
			 Integer[] arr = new Integer[2];
			 arr[0] = Integer.valueOf(args[i]);
			 arr[1] = Integer.valueOf(args[i+1]);
			 intervals.add(arr);
		 }
		 
		 AssignmentOne ao = new AssignmentOne();
		 ao.lprimes(intervals);
		 System.out.println(result);
	}
	
	public List<Integer> lprimes(List<Integer[]> intervals) throws InterruptedException {
		if (intervals == null) {
			return null;
		}
		
		for (Integer[] interval : intervals) {
			PrimeFinder pf = new PrimeFinder(interval[0], interval[1]);
			primeFinderList.add(pf);
			Thread t = new Thread(pf);
			t.start();
			threadList.add(t);
		}
		
		for (int i = 0; i < threadList.size(); i++) {
			threadList.get(i).join();			
			result.addAll(primeFinderList.get(i).getPrimesList());
		}
			
		return result;
	}
}







