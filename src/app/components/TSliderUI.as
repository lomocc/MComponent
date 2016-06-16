package app.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import app.utils.DisplayUtil;

	public class TSliderUI extends TBaseUI
	{
		
		public var back:Sprite;
		public var handle:Sprite;
		public function TSliderUI(ui:DisplayObjectContainer=null)
		{
			super(ui);
            var backRes:DisplayObject = _mc.getChildByName("mc_back");
            back = backRes ? DisplayUtil.wrap(backRes) : new Sprite;
            
            var handleRes:DisplayObject = _mc.getChildByName("mc_handle");
            handle = handleRes ? DisplayUtil.wrap(handleRes) : new Sprite;
		}
	}
}