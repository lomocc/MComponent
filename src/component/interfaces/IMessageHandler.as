/********************************************************************************
  * File Name：IMessageHandler.as
  * Owner：Heven
  * Create Time：1.0
  * Version：1.0
  * Current Version：
  * Last Update：
  * Summary：网络通信消息解析接口
  * History：
  * <author>  <time>           <version >   <desc>
 *********************************************************************************/


package com.throne.interfaces
{
	import flash.utils.ByteArray;
	public interface IMessageHandler 
	{
		/**
		 * 解析服务器传过来的数据
		 * @param	_actionId 消息动作Id
		 * @param	_msg  具体数据 类型为 ByteArray
		 */
        function handleMessage(_actionId:int, _msg:ByteArray):void;
		
		/**
		 * 处理服务器传过来的数据
		 * @param	_msg  具体数据 类型为 ByteArray
		 */
		function preParse(_msg:ByteArray):*;
	}
	
}