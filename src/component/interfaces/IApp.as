package com.throne.interfaces
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;

	public interface IApp extends IEventDispatcher
	{
		function initApp(container:DisplayObjectContainer):void;
	}
}