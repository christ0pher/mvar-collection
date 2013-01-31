package src.com.syncvar;

public class SyncVarMain
{
	public static void main(String[] args)
	{
		SyncVar syncer = new SyncVar();
		
		SyncVarWorker w1 = new SyncVarWorker(syncer, 1);
		SyncVarWorker w2 = new SyncVarWorker(syncer, 2);
		SyncVarWorker w3 = new SyncVarWorker(syncer, 3);
		SyncVarWorker w4 = new SyncVarWorker(syncer, 4);
		SyncVarWorker w5 = new SyncVarWorker(syncer, 5);
		
		SyncVarWorkerViceVersa wv1 = new SyncVarWorkerViceVersa(syncer, 10);
		SyncVarWorkerViceVersa wv2 = new SyncVarWorkerViceVersa(syncer, 20);
		SyncVarWorkerViceVersa wv3 = new SyncVarWorkerViceVersa(syncer, 30);
		SyncVarWorkerViceVersa wv4 = new SyncVarWorkerViceVersa(syncer, 40);
		SyncVarWorkerViceVersa wv5 = new SyncVarWorkerViceVersa(syncer, 50);
		
		new Thread(w1).start();
		new Thread(w2).start();
		new Thread(w3).start();
		new Thread(w4).start();
		new Thread(w5).start();
		new Thread(wv1).start();
		new Thread(wv2).start();
		new Thread(wv3).start();
		new Thread(wv4).start();
		new Thread(wv5).start();

	}

}
