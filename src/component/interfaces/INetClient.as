/********************************************************************************
  * File Name：INetClient.as
  * Owner：Heven
  * Create Time：1.0
  * Version：1.0
  * Current Version：
  * Last Update：
  * Summary：网络通信接口
  * History：
  * <author>  <time>           <version >   <desc>
 *********************************************************************************/


package com.throne.interfaces
{
	import flash.events.IEventDispatcher;
	public interface INetClient extends IEventDispatcher
	{
		//获取服务器连接状态
		function get isConnected():Boolean 
		//设置服务器连接状态
		function set isConnected(_b:Boolean ):void
		
		/**
		 * 增加消息处理类
		 * @param	key actionType
		 * @param	handler 消息处理类
		 */
		//function addMessageHandler(key:int, handler:IMessageHandler) : void
		
		/**
		 * 连接到服务器
		 * @param	_ipAdr IP地址
		 * @param	_port  端口 
		 */
		function connect(_ipAdr:String, _port:int = 8080) : void
		
		/**
		 * 断开连接
		 */
		function disconnect() : void
		
	}
	
}