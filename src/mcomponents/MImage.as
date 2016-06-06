package mcomponents
{
	import flash.display.Sprite;

	dynamic public class MImage extends MComponent
	{
		public function MImage()
		{
			super();
			
			this.addChild(this.spt);
			
		}
		
		public var spt:Sprite = new Sprite();
		protected var bgColor:uint;
		public var xxxx:Number=0;
		[Inspectable(type="Color",defaultValue="#0000ff")]
		public function get backGroundColor():uint {
			return bgColor;
		}
		
		public function set backGroundColor(value:uint):void {
			bgColor=value;
			
			this.spt.graphics.clear();
			this.spt.graphics.beginFill(bgColor);
			this.spt.graphics.drawRect(0,0,100,100);
			this.spt.graphics.endFill();
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