package component
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	
	import component.base.ButtonBase;
	
	public class CircleButton extends ButtonBase
	{
		public function CircleButton()
		{
			super();
		}
		
		override public function normalSkin():DisplayObject{
			var skin:Shape = new Shape();
			skin.graphics.beginFill(this.skinColor);
			skin.graphics.drawCircle(25, 25, 25);
			skin.graphics.endFill();
			return skin;
		}
	}
}