package src.com.mvar;
import java.util.HashMap;
import java.util.Map;


public class Statistics 
{
	private Map<String, Integer> forkStatistics = new HashMap<String, Integer>();
	
	public synchronized void registerRunnable(String id)
	{
		forkStatistics.put(id, 0);
	}
	
	public synchronized void increase(String forkName)
	{
		Integer count = forkStatistics.get(forkName);
		count++;
		forkStatistics.put(forkName, count);
	}
	
	public synchronized void printStatistics()
	{
		for (String key : forkStatistics.keySet())
		{
			System.out.println("Name: "+key+" count: "+forkStatistics.get(key)+" Procentage: "+calculateProcent(key)*100.0);
		}
		System.out.println("___________________");
	}
	
	private float calculateProcent(String id)
	{
		Integer sum = 0;
		for (String k : forkStatistics.keySet())
			sum += forkStatistics.get(k);
		return forkStatistics.get(id).floatValue() / sum.floatValue();
	}
}
