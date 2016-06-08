package widget
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class Component extends MovieClip
	{
		protected var container:Sprite;
		protected var loader:Loader = new Loader();
		protected var startWidth:Number;
		protected var startHeight:Number;
		
		public function Component()
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
			this.container = new Sprite();
			this.container.addChild(this.loader);
			this.addChild(this.container);
			
			this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.onLoaderInit);
		}
		
		protected function onLoaderInit(event:Event):void{
			this.container.x = (this.startWidth - this.loader.width)/2;
			this.container.y = (this.startHeight - this.loader.height)/2;
		}
		[Inspectable(type="Number", defaultValue="0", name="x（横坐标）")]
		public function get contentX():Number { 
			return this.loader.x;
		}
		public function set contentX(value:Number):void {
			this.loader.x = value;
		}
		[Inspectable(type="Number", defaultValue="0", name="y（纵坐标）")]
		public function get contentY():Number {
			return this.loader.y;
		}
		public function set contentY(value:Number):void {
			this.loader.y = value;
		}
		[Inspectable(type="Number", defaultValue="1", name="scale（缩放）")]
		public function get scale():Number {
			return this.loader.scaleX;
		}
		
		public function set scale(value:Number):void {
			this.loader.scaleX = value;
			this.loader.scaleY = value;
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