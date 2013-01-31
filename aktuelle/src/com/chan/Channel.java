package src.com.chan;

import src.com.mvar.MVar;

public class Channel<T>
{
	MVar<MVar<ChannelElement<T>>> reader;
	MVar<MVar<ChannelElement<T>>> writer;
	
	public Channel() throws InterruptedException
	{
		MVar<ChannelElement<T>> hole = new MVar<ChannelElement<T>>();
		
		reader = new MVar<MVar<ChannelElement<T>>>();
		reader.put(hole);
		
		writer = new MVar<MVar<ChannelElement<T>>>();
		writer.put(hole);
	}
	
	public void write(T elem) throws InterruptedException
	{
		MVar<ChannelElement<T>> writeHole = writer.take();
		MVar<ChannelElement<T>> newEmpty = new MVar<ChannelElement<T>>();
		ChannelElement<T> newElem = new ChannelElement<T>(elem, newEmpty);
		
		writeHole.put(newElem);
		writer.put(newEmpty);
	}
	
	public T read() throws InterruptedException 
	{
		MVar<ChannelElement<T>> readHole = reader.take();
		ChannelElement<T> elem = readHole.take();		
		reader.put(elem.next);		
		return elem.value;
		
	}
	
	public boolean isChannelFilled() throws InterruptedException
	{
		MVar<ChannelElement<T>> readerHole = reader.read();
		MVar<ChannelElement<T>> writerHole = writer.read();
		
		return readerHole != writerHole;
	}
}
