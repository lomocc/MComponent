package component.buttons
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import component.base.TComponent;
	import component.utils.DisplayUtil;
	
	public class TButton extends TComponent
	{
		protected var _over:Boolean = false;
		protected var _down:Boolean = false;
		protected var _enable:Boolean = false;
		protected var ui:DisplayObject;
		

		protected var _defaultHandler:Function;
		protected var params:Array;
		private var underlay:Boolean =true;
		
		public function TButton(ui:DisplayObject = null,__defaultHandler:Function=null,params:Array=null,underlay:Boolean = true)
		{
			this.ui=ui;
			this.underlay=underlay;
			initView();
			
			if(ui)
			{
				this.x=ui.x;
				this.y=ui.y;
				ui.x = 0;
				ui.y = 0;
				if(ui.parent)
				{
					var index:int = ui.parent.getChildIndex(ui);
					ui.parent.addChildAt(this,index);
				}
				addChild(ui);
				
				if (ui is InteractiveObject)
					(ui as InteractiveObject).mouseEnabled=false;
				
				if (ui is DisplayObjectContainer)
					(ui as DisplayObjectContainer).mouseChildren=false;
				drawUnderLay();
			}
			
			
			super(null);
			
			mouseChildren=false;
			
			enable=true;
			
			setDefaultHandler(__defaultHandler,params);
			
			addEventListener(MouseEvent.CLICK,defaultHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			mute = false;
		}
		
		public function drawUnderLay():void
		{
		
			var rect:Rectangle=this.getRect(this);
			
			if(underlay && !rect.isEmpty())
			{
				this.graphics.beginFill(0x00,0);
				this.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
				this.graphics.endFill();
			}
			
		}
		
		protected function defaultHandler(event:MouseEvent):void
		{
			if(_defaultHandler!=null){
				_defaultHandler.apply(this,params);
			}
		}
		
		public function setDefaultHandler(defaultHandler:Function=null,params:Array=null):void{
			
			this._defaultHandler=defaultHandler;
			if(params) this.params=params.concat();
		}
		
		protected function initView():void
		{
			// TODO Auto Generated method stub
			
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
	
		/**
		 * Internal mouseOver handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			_over = true;
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			updateState(event);
		}
		
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			updateState(event);
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoDown(event:MouseEvent):void
		{
			_down = true;
			addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
			DisplayUtil.getStage().addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
			updateState(event);
		}
		
		/**
		 * Internal mouseUp handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoUp(event:MouseEvent):void
		{
			_down=false;
			removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
			DisplayUtil.getStage().removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
			updateState(event);
		}
		
		
		protected function updateState(event:MouseEvent=null):void
		{
			// TODO Auto Generated method stub
		}
		
		
		public function get enable():Boolean
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void
		{
			if(_enable==value) return;
			_enable = value;
			mouseEnabled=value;
			buttonMode=value;
			updateState();
		}
		
		override public function dispose():void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
			super.dispose();
			
			ui = null;
			_defaultHandler = null;
			params = null;
			
		}
		
		
		public function set mute(value:Boolean):void
		{
			if(!value)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, onPlayPress);
				addEventListener(MouseEvent.MOUSE_OVER, onPlayOver);
				addEventListener(MouseEvent.MOUSE_OUT,onPlayOut);
			}else
			{
				removeEventListener(MouseEvent.MOUSE_DOWN, onPlayPress);
				removeEventListener(MouseEvent.MOUSE_OVER, onPlayOver);
				removeEventListener(MouseEvent.MOUSE_OUT,onPlayOut);
			}
		}
		
		private function onPlayOut(event:MouseEvent):void
		{
			playOutSound();
		}
		
		private function onPlayOver(event:MouseEvent):void
		{
			playOverSound();
		}
		
		private function onPlayPress(event:MouseEvent):void
		{
			playPressSound();
		}
		
		
		protected function playOverSound():void
		{
			
		}
		
		
		protected function playOutSound():void
		{
			
		}
		
		protected function playPressSound():void
		{
			
		}		
		
		public function simulateClick():void
		{
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
	}
}