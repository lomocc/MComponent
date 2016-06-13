package component
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	
	import component.base.ToggleButton;
	
	public class PlayButton extends ToggleButton
	{
		public function PlayButton()
		{
			super();
		}
		
		override public function normalSkin():DisplayObject{
			var skin:Shape = new Shape();
			skin.graphics.beginFill(this.skinColor);
			skin.graphics.moveTo(0, 0);
			skin.graphics.lineTo(30, 15);
			skin.graphics.lineTo(0, 30);
			skin.graphics.lineTo(0, 0);
			skin.graphics.endFill();
			return skin;
		}
		
		override public function toggledSkin():DisplayObject{
			var skin:Shape = new Shape();
			skin.graphics.beginFill(this.toggledSkinColor);
			skin.graphics.drawRect(0, 0, 20, 30);
			skin.graphics.drawRect(10, 0, 20, 30);
			skin.graphics.endFill();
			return skin;
		}
	}
}