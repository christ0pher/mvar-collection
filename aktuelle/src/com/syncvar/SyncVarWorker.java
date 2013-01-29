package com.syncvar;

public class SyncVarWorker implements Runnable
{
	private SyncVar syncer;
	private Integer id;
	
	public SyncVarWorker(SyncVar syncer, Integer id)
	{
		super();
		this.syncer = syncer;
		this.id = id;
	}

	@Override
	public void run()
	{
		try
		{
			while(true)
			{
			syncer.take();
			System.out.println("Waited to proceed ID:"+this.id);
			syncer.put();
			System.out.println("Proceeded! ID: "+this.id);
			}
			
		}
		catch (InterruptedException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
