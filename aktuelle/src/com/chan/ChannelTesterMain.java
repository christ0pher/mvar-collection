package src.com.chan;

public class ChannelTesterMain {
	public static void main(String[] args) throws InterruptedException {
		final Channel<Long> chan = new Channel<Long>();

		new Thread(new Runnable() {

			@Override
			public void run() {
				Long i = 0L;
				while (true) {
					try {
						chan.write(i++);

						System.out.println("putted");
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}).start();

		new Thread(new Runnable() {

			@Override
			public void run() {
				Long i = 0L;
				while (true) {
					try {
						chan.write(i++);

						System.out.println("putted");
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}).start();

		new Thread(new Runnable() {

			@Override
			public void run() {
				Long i = 0L;
				while (true) {
					try {
						chan.write(i++);
						System.out.println("putted");
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}).start();
		
		new Thread(new Runnable() {

			@Override
			public void run() {
				Long i = 0L;
				while (true) {
					try {
						System.out.println("Taken: "+chan.read());
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}).start();
		
		new Thread(new Runnable() {

			@Override
			public void run() {
				Long i = 0L;
				while (true) {
					try {
						System.out.println("Taken: "+chan.read());
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}).start();
		new Thread(new Runnable() {

			@Override
			public void run() {
				Long i = 0L;
				while (true) {
					try {
						System.out.println("Taken: "+chan.read());
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}).start();
		new Thread(new Runnable() {

			@Override
			public void run() {
				Long i = 0L;
				while (true) {
					try {
						System.out.println("Taken: "+chan.read());
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}).start();
	}
}
