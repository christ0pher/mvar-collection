package src.com.mvar;


public class MVar<T> {
	boolean empty;
	T content = null;
	
	Object checkUse 	= new Object(),
		   changeUse 	= new Object();
	
	public MVar(T newElem) {
		empty = false;
		content = newElem;
	}
	
	public MVar()
	{
		empty = true;
		content = null;
	}

	public T read() throws InterruptedException {
		synchronized (checkUse) {
			while(empty)
				checkUse.wait();
			synchronized (changeUse) {
				checkUse.notify();
				return content;
			}
		}
	}
	
	public T swap (T o) throws InterruptedException {
		synchronized (changeUse) {
			while(empty)
				changeUse.wait();
			synchronized (checkUse) {
				T tmp = content;
				content = o;
				checkUse.notify();
				return tmp;
			}
		}
	}
	
	public void clear() throws InterruptedException {
		T o = take();
	}
	
	public void overWrite(T o) {
		synchronized (changeUse) {
			synchronized (checkUse) {
				empty = false;
				content = o;
				checkUse.notify();
			}
		}
	}
	
	public T takeTimeout(Long timeout) throws InterruptedException {
		Long checkIn 	= System.currentTimeMillis();
		Long restTime 	= timeout;
		synchronized(checkUse) {
			while(empty) {
				checkUse.wait(restTime);
				restTime = timeout - (System.currentTimeMillis() - checkIn);
				if (restTime <= 0)
					return null;
			}
			synchronized (changeUse) {
				empty = true;
				checkUse.notify();
				return content;
			}
		}
	}
		
	public T tryTake() throws InterruptedException {
		synchronized (checkUse) {
			if (empty)
				return null;
			synchronized (changeUse) {
				empty = true;
				changeUse.notify();
				return content;
			}
		}
	}
	
	public T take() throws InterruptedException {
		synchronized (checkUse) {
			while(empty)
				checkUse.wait();
			synchronized (changeUse) {
				empty = true;
				changeUse.notify();
				return content;
			}
		}
	}
	
	public boolean tryPut(T o) throws  InterruptedException{
		synchronized(changeUse) {
			if (!empty) {
				return false;
			}
			synchronized (checkUse){
				empty = false;
				content = o;						
				checkUse.notify();
				return true;
			}
		}
	}
	
	public void put(T o) throws InterruptedException {
		synchronized (changeUse) {
			while(!empty)
				changeUse.wait();
			synchronized (checkUse) {
				empty = false;
				content = o;
				checkUse.notify();
			}
		}
	}
	
	public synchronized T take2() throws InterruptedException
	{
		while (empty)
			this.wait();
		empty = true;
		this.notifyAll();
		return content;
	}
	
	
	
	
	public synchronized void put2(T o) throws InterruptedException
	{
		
		while (!empty)
			this.wait();
		empty = false;
		content = o;
		this.notifyAll();
	
	}
	
}
