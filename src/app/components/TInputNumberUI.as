package app.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class TInputNumberUI extends TBaseUI
	{
		public var btn_sub:Sprite;
		public var btn_add:Sprite;
		public var tf_input:TextField;
		
		public function TInputNumberUI(ui:DisplayObjectContainer=null)
		{
			super(ui);
			btn_sub = _mc.getChildByName("btn_sub") as Sprite || new Sprite();
			btn_add = _mc.getChildByName("btn_add") as Sprite || new Sprite();
			tf_input= _mc.getChildByName("tf_input") as TextField || new TextField();
		}
	}
}