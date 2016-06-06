package mcomponents
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class MLabel extends MovieClip
	{
		private var tf:TextField;
		public function MLabel()
		{
			
			this.tf = new TextField();
			this.tf.autoSize = "left";
			this.addChild(this.tf);
		}
		public var xxxx:Number=0;
		protected var $content:String;
		[Inspectable(type="String",defaultValue="ABHKHJHKJHJ")]
		public function get content():String {
			return $content;
		}
		public function set content(value:String):void {
			$content=value;
			
			this.tf.text = $content;
		}
		override public function get x():Number {
			return super.x;
		}
		override public function set x(value:Number):void {
			this.xxxx = value;
			super.x = value;
		}
	}
}