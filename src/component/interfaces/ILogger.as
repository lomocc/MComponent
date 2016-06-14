package com.throne.interfaces
{
	public interface ILogger
	{
		function out(time:Date,level:int,_owner:Object,rest:Array):void;
		function formatOut(level:int,msg:String):void;
	}
}