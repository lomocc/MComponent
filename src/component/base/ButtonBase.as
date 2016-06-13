package component.base
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ButtonBase extends Sprite
	{
		include 'callLater.as';
		
		private var invalidFlag:Boolean = false;
		protected function invalidate(callLater:Boolean=true):void {
			invalidFlag = true;
			if (callLater) { 
				this.callLater(doRender); 
			}else{
				doRender();
			}
		}
		private function doRender():void {
			this.render();
			invalidFlag = false;
		}
		
		private var currentSkin:DisplayObject;
		
		protected var _label:String = "按钮";
		
		protected var _skinColor:uint = 0xffffff;
		
		protected var _skinWidth:Number = 30;
		protected var _skinHeight:Number = 30;
		
		public function ButtonBase()
		{
			super();
			
			this.buttonMode = true;
			invalidate();
		}
		public function get label():String{
			return this._label;
		}
		public function set label(value:String):void{
			this._label = value;
			this.invalidate();
		}
		
		public function get skinWidth():Number{
			return this._skinWidth;
		}
		public function set skinWidth(value:Number):void{
			this._skinWidth = value;
			this.invalidate();
		}
		public function get skinHeight():Number{
			return this._skinHeight;
		}
		public function set skinHeight(value:Number):void{
			this._skinHeight = value;
			this.invalidate();
		}
		public function get skinColor():uint{
			return this._skinColor;
		}
		public function set skinColor(value:uint):void{
			this._skinColor = value;
			this.invalidate();
		}
		protected function render():void {
			this.currentSkin && this.removeChild(this.currentSkin);
			this.currentSkin = this.getCurrentSkin();
			this.currentSkin && this.addChild(this.currentSkin);
			
			this.renderBackGround();
		}
		
		private var _labelField:TextField;
		private function renderBackGround():void
		{
			var g:Graphics = this.graphics;
			g.beginFill(0xffffff, 0);
			g.drawRect(0, 0, this.skinWidth, this.skinHeight);
			g.endFill();
			
			if(!this._labelField){
				this._labelField = new TextField();
				this._labelField.mouseEnabled = false;
				this._labelField.autoSize = "left";
			}
			this._labelField.width = this.skinWidth;
			this._labelField.text = this.label;
			this._labelField.x = (this.skinWidth - this._labelField.textWidth - 2) /2;
			this._labelField.y = (this.skinHeight - this._labelField.height)/2;
			this.addChild(this._labelField);
		}
		
		public function getCurrentSkin():DisplayObject{
			return this.normalSkin();
		}
		
		public function normalSkin():DisplayObject{
			return null;
		}
		
		
		private var clientProperty:Dictionary;
		private var defaultKey:Object = {};
		public function getClientProperty(key:*=null):*{
			if(clientProperty == null){
				return null;
			}
			if(key == null)
				key = defaultKey;
			return clientProperty[key];
		}
		
		public function putClientProperty(value:*=null, key:*=null):void{
			//Lazy initialization
			if(clientProperty == null){
				clientProperty = new Dictionary();
			}
			if(key == null)
				key = defaultKey;
			clientProperty[key]  = value;
		}
	}
}