package component.base
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ToggleButton extends ButtonBase
	{
		protected var _toggled:Boolean = false;
		protected var _toggledSkinColor:uint = 0xffffff;
		public function ToggleButton()
		{
			super();
			
			this.addEventListener(MouseEvent.CLICK, this.onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			this.toggled = !this.toggled;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		public function get toggledSkinColor():uint{
			return this._toggledSkinColor;
		}
		public function set toggledSkinColor(value:uint):void{
			this._toggledSkinColor = value;
			this.invalidate();
		}
		
		public function get toggled():Boolean{
			return this._toggled;
		}
		public function set toggled(value:Boolean):void{
			this._toggled = value;
			
			this.invalidate();
		}
		
		override public function getCurrentSkin():DisplayObject{
			if(this.toggled)
				return this.toggledSkin();
			return super.getCurrentSkin();
		}
		override public function normalSkin():DisplayObject{
			var skin:Shape = new Shape();
			skin.graphics.beginFill(this.skinColor);
			skin.graphics.drawRoundRect(0, 0, this.skinWidth, this.skinHeight, 5);
			skin.graphics.endFill();
			return skin;
		}
		
		public function toggledSkin():DisplayObject{
			var skin:Shape = new Shape();
			skin.graphics.beginFill(this.toggledSkinColor);
			skin.graphics.drawRoundRect(0, 0, this.skinWidth, this.skinHeight, 5);
			skin.graphics.endFill();
			return skin;
		}
	}
}