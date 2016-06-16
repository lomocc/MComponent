package app.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class TProgressBarUI extends TBaseUI
	{
		public var _bar:Sprite;
		public var _tf:TextField;
		public function TProgressBarUI(ui:DisplayObjectContainer=null)
		{
			super(ui);
			_tf = _mc.getChildByName("_tf") as TextField || new TextField();
			_bar= _mc.getChildByName("_bar") as Sprite || new Sprite();
		}
	}
}