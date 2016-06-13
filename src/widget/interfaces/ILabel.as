package widget.interfaces
{
	public interface ILabel extends IWidget
	{
		function get text():String;
		function set text(value:String):void;
		function get font():String;
		function set font(value:String):void;
	}
}