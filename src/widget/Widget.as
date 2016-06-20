package widget
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import widget.interfaces.IWidget;
	
	public class Widget extends MovieClip implements IWidget
	{
		//		protected var startWidth:Number;
		//		protected var startHeight:Number;
		
		private var _contentDisplay:Sprite;
		
		public function Widget()
		{
			super();
			
			//			startWidth = this.width/this.scaleX;
			//			startHeight = this.height/this.scaleY;
			
			if (numChildren > 0) {
				super.removeChildAt(0);
			}
			
			this.createChildren();
			this.invalidate();
		}
		public function contentDisplay():DisplayObject
		{
			return this._contentDisplay;
		}
		protected function createChildren():void
		{
			this._contentDisplay = new Sprite();
			super.addChild(this._contentDisplay);
		}
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return this._contentDisplay.addChild(child);
		}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return this._contentDisplay.addChildAt(child, index);
		}
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return this._contentDisplay.removeChild(child);
		}
		override public function removeChildAt(index:int):DisplayObject
		{
			return this._contentDisplay.removeChildAt(index);
		}
		private var _contentX:Number = 0;
		[Inspectable(type="Number", defaultValue="0", name="x（横坐标）")]
		public function get contentX():Number { 
			return this._contentX;
		}
		public function set contentX(value:Number):void {
			this._contentX = value;
			this.invalidate();
		}
		private var _contentY:Number = 0;
		[Inspectable(type="Number", defaultValue="0", name="y（纵坐标）")]
		public function get contentY():Number {
			return this._contentY;
		}
		public function set contentY(value:Number):void {
			this._contentY = value;
			this.invalidate();
		}
		private var _contentScale:Number = 1;
		[Inspectable(type="Number", defaultValue="1", name="scale（内容缩放）")]
		public function get contentScale():Number {
			return this._contentScale;
		}
		
		public function set contentScale(value:Number):void {
			this._contentScale = value;
			this.invalidate();
		}
		public function toConfig():Object{
			return {
				contentX:this.contentX, 
					contentY:this.contentY, 
					contentScale:this.contentScale
			};
		}
		public function fromConfig(config:Object):void
		{
			contentX = config.contentX;
			contentY = config.contentY;
			contentScale = config.contentScale;
		}
		/////////////////////////////////////////////////////////////////////////////////////
		// helper
		/////////////////////////////////////////////////////////////////////////////////////
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
		protected function render():void {
			this._contentDisplay.x = this.contentX;
			this._contentDisplay.y = this.contentY;
			this._contentDisplay.scaleX = this.contentScale;
			this._contentDisplay.scaleY = this.contentScale
		}
		
		private static var inCallLaterPhase:Boolean=false;
		private var callLaterMethods:Dictionary = new Dictionary();
		protected function callLater(fn:Function):void {
			if (inCallLaterPhase) { return; }
			
			callLaterMethods[fn] = true;
			if (stage != null) {
				try {
					stage.addEventListener(Event.RENDER,callLaterDispatcher,false,0,true);
					stage.invalidate();
				} catch (se:SecurityError) {
					addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
				}
			} else {
				addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
			}
		}
		
		private function callLaterDispatcher(event:Event):void {
			if (event.type == Event.ADDED_TO_STAGE) {
				try {
					removeEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher);
					// now we can listen for render event:
					stage.addEventListener(Event.RENDER,callLaterDispatcher,false,0,true);
					stage.invalidate();
					return;
				} catch (se1:SecurityError) {
					addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
				}
			} else {
				event.target.removeEventListener(Event.RENDER,callLaterDispatcher);
				event.target.removeEventListener(Event.ENTER_FRAME,callLaterDispatcher);
				try {
					if (stage == null) {
						// received render, but the stage is not available, so we will listen for addedToStage again:
						addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
						return;
					}
				} catch (se2:SecurityError) {
				}
			}
			
			inCallLaterPhase = true;
			
			var methods:Dictionary = callLaterMethods;
			for (var method:Object in methods) {
				method();
				delete(methods[method]);
			}
			inCallLaterPhase = false;
		}
	}
}