package src.com.chan;

import src.com.mvar.MVar;

public class ChannelElement<T>
{
	T value;
	MVar<ChannelElement<T>> next;
	
	public ChannelElement(T value) 
	{
		this.value = value;
		this.next = null;
	}
	
	public ChannelElement()
	{
		this.value = null;
		this.next  = null;
	}

	public ChannelElement(T value, MVar<ChannelElement<T>> next) {
		this.value = value;
		this.next = next;
	}
}
