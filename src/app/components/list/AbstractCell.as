package app.components.list
{
	import app.components.TComponent;
	
	public class AbstractCell extends TComponent
	{
		
		protected var data:Object;
		protected var _index:int=-1;
		protected var _isSelected:Boolean;
		protected var _list:TList;
		/**
		 * Constructor
		 * @param data The string to display as a label or object with a label property.
		 */
		public function AbstractCell()
		{
			super();
		}
	
		/**
		 * Initilizes the component.
		 */
		protected override function init() : void
		{
			addChildren();
		}
		
		public function setListCellStatus(list:TList, isSelected:Boolean, index:int):void{
			_list = list;
			_isSelected = isSelected;
			_index = index;
		}
		
		/**
		 * Sets the value of this cell.
		 * @param value which should represent on the component of this cell.
		 */
		public function setCellValue(value:*):void{
			data = value;
		}
		
		/**
		 * Returns the value of the cell.
		 * @return the value of the cell.
		 */
		public function getCellValue():*{
			return data;
		}
		
		
		public function getCellComponent():TComponent{
			return this;
		}
		
		public function getIndex():int{
			return _index;
		}
		
		override public function dispose():void{
			super.dispose();
			data = null;
			_list = null;	
		}
		
		public function show():void
		{
			visible = true;
		}
		
		public function hide():void
		{
			visible = false;
		}
		
	}
}