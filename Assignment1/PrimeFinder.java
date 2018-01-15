package hw1;

import java.util.ArrayList;
import java.util.List;

public class PrimeFinder implements Runnable {

	private Integer start;
	private Integer end;
	private List<Integer> primes;

	// Constructs a PrimeFinder
	public PrimeFinder(Integer start, Integer end) {
		this.start = start;
		this.end = end;
		this.primes = new ArrayList<Integer>();
	}

	// Returns the value of the attribute primes
	public List<Integer> getPrimesList() {
		return primes;
	}

	// Determines whether its argument is prime or not
	public Boolean isPrime(int n) {
		if (n < 2) {
			return false;
		}
		
		for (int i = 2; i*i <= n; i++) {
			if (n % i == 0) {
				return false;
			}
		}
		return true;
	}

	public void run() {
		for (int i = start; i < end; i++) {
			if (isPrime(i))
				primes.add(i);
		}
	}

}





