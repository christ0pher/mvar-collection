package src.com.syncvar;

public class SyncVar
{
	private Object checkUse = new Object();
	private Object changeUse = new Object();
	private boolean empty = true;
	
	public void take() throws InterruptedException
	{
		synchronized (checkUse)
		{
			while (empty)
				checkUse.wait();
			synchronized (changeUse)
			{
				empty = true;
				changeUse.notify();
			}
		}
	}
	
	public void put () throws InterruptedException
	{
		synchronized (changeUse)
		{
			while (!empty)
				changeUse.wait();
			synchronized (checkUse)
			{
				empty = false;
				checkUse.notify();
			}
		}
	}
}
