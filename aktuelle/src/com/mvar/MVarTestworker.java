package src.com.mvar;

public class MVarTestworker implements Runnable {
	MVar<Integer> contentHolder;
	Integer id;
	Statistics stat;
	
	public MVarTestworker(MVar<Integer> mvar, Integer id, Statistics stat) {
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
				other_id = contentHolder.take2();
				stat.increase(id.toString());
//				System.out.println(id+" takes Other ID: "+other_id);
				contentHolder.put2(id);
				stat.increase(id.toString());
//				System.out.println(id+" puts his id");	
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}
