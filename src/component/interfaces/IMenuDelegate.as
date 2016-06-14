package com.throne.interfaces
{
	

	public interface IMenuDelegate
	{
		/**
		 * 当点击菜单项 
		 * @param target 被点击菜单项所属的菜单
		 * @param id 被点击菜单项id
		 * 
		 */		
		function onMenuItemClick(target:ITMenu,id:int):void;
	}
}