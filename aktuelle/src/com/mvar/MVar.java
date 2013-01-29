package com.mvar;

public class MVar<T> {
	boolean empty;
	T content = null;
	
	Object checkUse 	= new Object(),
		   changeUse 	= new Object();
	
	public T read() throws InterruptedException {
		synchronized (checkUse) {
			while(empty)
				checkUse.wait();
			synchronized (changeUse) {
				checkUse.notifyAll();
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
				checkUse.notifyAll();
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
				checkUse.notifyAll();
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
				checkUse.notifyAll();
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
				changeUse.notifyAll();
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
				changeUse.notifyAll();
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
				checkUse.notifyAll();
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
				checkUse.notifyAll();
			}
		}
	}

	
}
