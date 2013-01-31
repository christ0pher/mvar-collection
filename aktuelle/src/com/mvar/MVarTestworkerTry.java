package src.com.mvar;

public class MVarTestworkerTry implements Runnable {

	MVar<Integer> contentHolder;
	Integer id;
	private Statistics stat;
	
	public MVarTestworkerTry(MVar<Integer> mvar, Integer id, Statistics stat) {
		contentHolder = mvar;
		this.id = id;
		this.stat = stat;
		this.stat.registerRunnable(id.toString());
	}
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		Integer other_id;
		while (true) {
			try {
				if ((other_id = contentHolder.tryTake())!= null) {
//					System.out.println(id+" takes Other ID: "+other_id);
					stat.increase(id.toString());
				}
				if (contentHolder.tryPut(id))
				{
//					System.out.println(id+" puts his id");
					stat.increase(id.toString());
				}
					
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

}
