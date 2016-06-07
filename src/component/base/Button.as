package component.base
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	
	public class Button extends ButtonBase
	{
		public function Button()
		{
			super();
		}
		
		override public function normalSkin():DisplayObject{
			var skin:Shape = new Shape();
			skin.graphics.beginFill(this.skinColor);
			skin.graphics.drawRoundRect(0, 0, this.skinWidth, this.skinHeight, 5);
			skin.graphics.endFill();
			return skin;
		}
	}
}