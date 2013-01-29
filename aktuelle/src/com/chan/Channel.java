package com.chan;

import com.mvar.MVar;

public class Channel<T>
{
	MVar<ChannelElement<T>> reader;
	MVar<ChannelElement<T>> writer;
	
	public Channel() throws InterruptedException
	{
		ChannelElement<T> newEmptyTarget = new ChannelElement<T>();
		reader = new MVar<ChannelElement<T>>();
		reader.put(newEmptyTarget);
		
		writer = new MVar<ChannelElement<T>>();
		writer.put(newEmptyTarget);
	}
	
	public void put(T elem) throws InterruptedException
	{
		
		ChannelElement<T> hole = writer.take();
		hole.value = elem;
	}
}
