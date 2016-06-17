package widget
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import widget.interfaces.IWidget;
	
	public class Widget extends MovieClip implements IWidget
	{
		protected var startWidth:Number;
		protected var startHeight:Number;
		
		public function Widget()
		{
			super();
			
			startWidth = this.width/this.scaleX;
			startHeight = this.height/this.scaleY;
			
			if (numChildren > 0) {
				removeChildAt(0);
			}
			
			this.createChildren();
			this.invalidate();
		}
		protected function createChildren():void
		{
			
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
		private var _scale:Number = 1;
		[Inspectable(type="Number", defaultValue="1", name="scale（缩放）")]
		public function get scale():Number {
			return this._scale;
		}
		
		public function set scale(value:Number):void {
			this._scale = value;
			this.invalidate();
		}
		
		//		public function get contentWidth():Number { 
		//			return this.loader.width;
		//		}
		//		public function get contentHeight():Number {
		//			return this.loader.height; 
		//		}
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