package mcomponents
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class MComponent extends MovieClip
	{
		public static var inCallLaterPhase:Boolean=false;
		
		public function MComponent()
		{
			super();
			configUI();
		}
		protected var startWidth:Number;
		protected var startHeight:Number;
		
		protected function configUI():void {	
			var r:Number = this.rotation;
//			this.rotation = 0;
			var w:Number = super.width;
			var h:Number = super.height;
//			super.scaleX = super.scaleY = 1;
			setSize(w,h);
//			this.rotation = r;
			startWidth = w;
			startHeight = h;
			if (numChildren > 0) {
				removeChildAt(0);
			}
		}
		protected var _width:Number;
		
		protected var _height:Number;
		
		override public function get scaleX():Number {
			return width / startWidth;
		}
		
		override public function set scaleX(value:Number):void {
			setSize(startWidth*value, height);
		}
		
		override public function get scaleY():Number {
			return height / startHeight;
		}
		
		override public function set scaleY(value:Number):void {
			setSize(width, startHeight*value);
		}
		
		override public function get width():Number { return _width; }
		
		override public function set width(value:Number):void {
			if (_width == value) { return; }
			setSize(value, height);
		}
		
		override public function get height():Number { return _height; }
		
		override public function set height(value:Number):void {
			if (_height == value) { return; }
			setSize(width, value);
		}
		public function setSize(width:Number, height:Number):void {
			_width = width;
			_height = height;
			invalidate();
		}
		protected var invalidFlag:Boolean = false;
		public function invalidate(callLater:Boolean=true):void {
			invalidFlag = true;
			if (callLater) { 
				this.callLater(doValidate); 
			}else{
				doValidate();
				
			}
		}
		protected function validate():void {
			
		}
		
		protected function doValidate():void {
			this.validate();
			invalidFlag = false;
		}
		
		protected var callLaterMethods:Dictionary = new Dictionary();
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