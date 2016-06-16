package app.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TToggleButton extends TButton
	{
		
		protected var _selected:Boolean;
		protected var _toggle:Boolean =true;
		
		
		public function TToggleButton(ui:DisplayObject = null,defaultHandler:Function=null,params:Array=null,underlay:Boolean = true)
		{
			super(ui,defaultHandler,params,underlay);
		}

		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
	
		
		/**
		 * Internal mouseUp handler.
		 * @param event The MouseEvent passed by the system.
		 */
		override protected function onMouseGoUp(event:MouseEvent):void
		{
			
			if(_toggle  && _over)
			{
				setSelected(!_selected);
			}
			super.onMouseGoUp(event);
		}	
		
		private function setSelected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		
		public function set selected(value:Boolean):void
		{
			setSelected(value);
			updateState();
		}
		
		[Bindable]
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set toggle(value:Boolean):void
		{
			_toggle = value;
		}
		
		public function get toggle():Boolean
		{
			return _toggle;
		}
		
		
	}
}