package com.mvar;

public class MVarTest 
{

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MVar<Integer> foo = new MVar<Integer> ();
		final Statistics stat = new Statistics();
		
		MVarTestworker mvtw1 = new MVarTestworker(foo, new Integer(1), stat);
		MVarTestworker mvtw2 = new MVarTestworker(foo, 2, stat);
		MVarTestworker mvtw3 = new MVarTestworker(foo, 3, stat);
		MVarTestworker mvtw4 = new MVarTestworker(foo, 4, stat);
		MVarTestworker mvtw5 = new MVarTestworker(foo, 5, stat);
		MVarTestworker mvtw6 = new MVarTestworker(foo, 6, stat);

		MVarTestworkerTry mvtwt1 = new MVarTestworkerTry(foo, 10, stat);
		MVarTestworkerTry mvtwt2 = new MVarTestworkerTry(foo, 20, stat);
		MVarTestworkerTry mvtwt3 = new MVarTestworkerTry(foo, 30, stat);
		MVarTestworkerTry mvtwt4 = new MVarTestworkerTry(foo, 40, stat);
		MVarTestworkerTry mvtwt5 = new MVarTestworkerTry(foo, 50, stat);
		MVarTestworkerTry mvtwt6 = new MVarTestworkerTry(foo, 60, stat);
		
		new Thread( mvtw1 ).start();
		new Thread( mvtw2 ).start();
		new Thread( mvtw3 ).start();
		new Thread( mvtw4 ).start();
		new Thread( mvtw5 ).start();
		new Thread( mvtw6 ).start();
		new Thread( mvtwt1 ).start();
		new Thread( mvtwt2 ).start();
		new Thread( mvtwt3 ).start();
		new Thread( mvtwt4 ).start();
		new Thread( mvtwt5 ).start();
		new Thread( mvtwt6 ).start();
		
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				while(true)
				{
					try {
						Thread.sleep(1500);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					stat.printStatistics();
				}
			}
		}).start();
	}

}
