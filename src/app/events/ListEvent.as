package app.events
{
	
	import flash.events.Event;
	
	import app.components.list.AbstractCell;
	
	
	public class ListEvent extends Event{
		
		
		public static const ITEM_SELECTED:String = "ITEM_SELECTED";
		
		
		private var value:*;
		private var cell:AbstractCell;
		
		
		public function ListEvent(type:String, value:*, cell:AbstractCell){
			super(type);
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
			return new ListEvent(type, value, cell);
		}
	}
}