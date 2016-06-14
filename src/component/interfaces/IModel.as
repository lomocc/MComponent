package com.throne.interfaces
{
	import com.throne.patterns.observer.INotifier;
	
	public interface IModel extends INotifier
	{
		function initData(value:Object):void;
		function initStatus(data:Object):void;
		function get className():String;
	}
}