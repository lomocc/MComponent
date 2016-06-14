package com.throne.interfaces
{
	public interface ITMenu
	{
		/**
		 * 显示菜单 
		 * 
		 */		
		function show():void;
		
		/**
		 * 隐藏菜单  
		 * 
		 */		
		function hide():void;
		
		
		/**
		 * 设置便宜量 
		 * @param value
		 * 
		 */		
		function set offsetX(value:int):void;
		function set offsetY(value:int):void;
		
		function get offsetX():int;
		function get offsetY():int;
	}
}