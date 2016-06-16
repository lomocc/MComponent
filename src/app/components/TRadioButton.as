package app.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TRadioButton extends TButton
	{
		protected var _selected:Boolean = false;
		
		protected var _group : TRadioButtonGroup;
		protected var _groupName:String =  "";
		
		
		public function TRadioButton(_groupName:String,ui:DisplayObject = null,checked:Boolean = false,defaultHandler:Function=null,params:Array=null,underlay:Boolean = true)
		{
			groupName = _groupName;
			super(ui,defaultHandler,params,underlay);
			selected = checked;			
			addEventListener(MouseEvent.CLICK, onClick, false, 1);
			
		}
		
		
		/**
		 * Internal click handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onClick(event:MouseEvent):void
		{
			selected = true;
		}
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets the selected state of this CheckBox.
		 */
		public function set selected(s:Boolean):void
		{
			if(_selected==s) return;
			_selected = s;
			
			if(_selected)
			{
				if(_group.selection && _group.selection!=this)
				{
					_group.selection.selected=false;
				}
				_group.selection=this;
			}
			else
			{
				if(_group.selection && _group.selection ==this) _group.selection = null;
			}
			
			dispatchEvent(new Event(Event.CHANGE));
			updateState();
			
		}
		
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		/**
		 * Sets / gets the group name, which allows groups of RadioButtons to function seperately.
		 */
		public function get groupName():String
		{
			return _groupName;
		}
		
		public function set groupName(value:String):void
		{
			if(_group)
			{
				_group.removeObject(this);
			}
			_groupName = value;
			
			_group = TRadioButtonGroup.getGroup(value);
			
			
			_group.addObject(this);
			selected=_selected;
			
		}
		
		override public function dispose() : void {
			super.dispose();
			_group.removeObject(this);
			TRadioButtonGroup.cleanGroup(_groupName);
			_group=null;
		}
		
		override protected function updateState(event:MouseEvent=null):void
		{
			mouseEnabled=!_selected;
			buttonMode=!_selected;
		}
		
	}
}