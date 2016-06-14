package component.interfaces
{
	import flash.display.DisplayObject;
	/**
	 * tipq容器 
	 * @author heven
	 * 
	 */
	public interface ITipContainer
	{
		function addTip(tip:DisplayObject):void;
		function removeTip(tip:DisplayObject):void;
	}
}