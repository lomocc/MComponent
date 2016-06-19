package app.events
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import app.components.list.AbstractCell;
	
	
	public class ListItemEvent extends MouseEvent{
		
		public static const ITEM_CLICK:String = "itemClick";
		
		public static const ITEM_DOUBLE_CLICK:String = "itemDoubleClick";
		
		
		public static const ITEM_MOUSE_DOWN:String = "itemMouseDown";
		
		
		public static const ITEM_ROLL_OVER:String = "itemRollOver";
		
		public static const ITEM_ROLL_OUT:String = "itemRollOut";
		
		
		public static const ITEM_RELEASE_OUT_SIDE:String = "itemReleaseOutSide";	
		
		private var value:*;
		private var cell:AbstractCell;
		
		/**
		 * @param type
		 * @param value
		 * @param cell
		 * @param e the original mouse event
		 */
		public function ListItemEvent(type:String, value:*, cell:AbstractCell, e:MouseEvent){
			super(type, false, false, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown);
			this.value = value;
			this.cell = cell;
		}
		
		public function getValue():*{
			return value;
		}
		
		public function getCell():AbstractCell{
			return cell;
		}
		
		override public function clone():Event{
			return new ListItemEvent(type, value, cell, this);
		}
	}
}