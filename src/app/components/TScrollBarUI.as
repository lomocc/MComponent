package app.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class TScrollBarUI extends TSliderUI
	{
		public var upButton:Sprite;
		public var downButton:Sprite;
		public function TScrollBarUI(ui:DisplayObjectContainer=null)
		{
			super(ui);
			upButton = _mc.getChildByName("mc_upButton") as Sprite || new Sprite();
			downButton= _mc.getChildByName("mc_downButton") as Sprite || new Sprite();
			
		}
	}
}