package app.components
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	public class TRangeUI extends TBaseUI
	{
		
		public var _tf_min:TextField;
		public var _tf_max:TextField;
		
		public function TRangeUI(ui:DisplayObjectContainer=null)
		{
			super(ui);
			_tf_min = _mc.getChildByName("_tf_min") as TextField || new TextField();
			_tf_max = _mc.getChildByName("_tf_max") as TextField || new TextField();
		}
	}
}