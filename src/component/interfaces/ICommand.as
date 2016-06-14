package com.throne.interfaces
{
	/**
	 * 命令接口 
	 * @author heven
	 * 
	 */	
	public interface ICommand extends IDisposable
	{
		/**
		 *
		 * 执行命令 
		 * 
		 */		
		function execute():void;
	}
}