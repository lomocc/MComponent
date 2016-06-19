package widget.interfaces
{
	public interface IWidget
	{
		function get contentX():Number;
		function set contentX(value:Number):void;
		function get contentY():Number;
		function set contentY(value:Number):void;
		function get contentScale():Number;
		function set contentScale(value:Number):void;
		function toConfig():Object;
		function fromConfig(config:Object):void;
	}
}