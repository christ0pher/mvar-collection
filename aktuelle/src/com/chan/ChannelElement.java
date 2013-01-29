package com.chan;

import com.mvar.MVar;

public class ChannelElement<T>
{
	T value;
	MVar<ChannelElement<T>> next = null;
}
