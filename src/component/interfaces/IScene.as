package com.throne.interfaces
{
	/**
	 * 定义一个游戏场景 
	 * @author heven
	 * 
	 */	
	public interface IScene 
	{
		
		/**
		 * 场景id 
		 * @return 
		 * 
		 */		
		function get id():String;
		
		/**
		 * 当进入该场景 
		 * 
		 */		
        function onEnter():void;
		
		/**
		 * 当退出该场景
		 * @param callback 确定进入新场景的时机
		 * 
		 */		
        function onExit(callback:Function):void;

	}
	
}