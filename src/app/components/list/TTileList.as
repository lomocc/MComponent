package app.components.list
{
	import app.components.TComponent;
	import app.components.TListUI;
	import app.components.TSlider;
	import app.components.list.AbstractCell;
	import app.components.list.TList;
	
	public class TTileList extends TList
	{
		
		
		protected var columnNum:int=1;
		
		/**
		 * shareCell设置无效 
		 * @param ui
		 * @param cellFactory
		 * @param items
		 * @param orientation 方向
		 * 
		 */	
		
		public function TTileList(ui:TListUI, items:Array=null,orientation:String=TSlider.VERTICAL)
		{
			super(ui, items,orientation);
		}
		
		
		public function setCellSize(w:int,h:int,marginW:int=0,marginH:int=0):void
		{
			this.marginW = marginW;
			this.marginH = marginH;
			cellWidth = w;
			cellHeight = h;
			updateColumnNum();
			updateListView();
		}
		
		/**
		 * 设置宽度时 计算行个数 
		 * @param value
		 * 
		 */		
		override public function setCellWidth(value:int,marginW:int = 0) : void
		{
			if(isVertical()) updateColumnNum();
			super.setCellWidth(value,marginW);
		}
		
		override public function setCellHeight(value:int, marginH:int = 0) : void 
		{
			if(!isVertical()) updateColumnNum();
			super.setCellHeight(value,marginW);
		}
		
		private function updateColumnNum():void
		{
			columnNum = Math.floor((isVertical()?rawWidth:rawHeight)/(isVertical()?getCellWidth():getCellHeight()));
		}
		
		override protected function layoutWhenShareCells():void
		{
			var isize:int = getCellUsingSize();
			var startIndex:int = Math.floor(getHolderPos()/isize);
			
			var endIndex:int = startIndex + Math.ceil(getUsingSize()/isize);
			
			if(endIndex > rowNum)
			{
				endIndex = rowNum;
			}
			
			
			if(lastStartIndex==startIndex && lastEndIndex==endIndex) return;
			
			lastStartIndex = startIndex;
			lastEndIndex = endIndex;
			
			var cell:AbstractCell;
			var cellCom:TComponent;
			
			
			var i:int;
			var j:int;
			var si:int=startIndex*columnNum;
			var ldIndex:int = 0;
			var h:int;
			
			for(i=startIndex; i<=endIndex; i++)
			{
				for(j=0;j<columnNum;j++)
				{
					cell= AbstractCell(cells.get(ldIndex));
					if(!cell || !items[si]) break;
					cell.setCellValue(items[si]);
					cellCom=cell.getCellComponent();
					cell.show();
					cellCom.x=(isVertical()?j:i)*getCellWidth();
					cellCom.y=(isVertical()?i:j)*getCellHeight();
					cell.setListCellStatus(this, isSelectedIndex(si), si);
					si++;
					ldIndex ++;
				}
			}
			
			var total:int = cells.getSize();
			
			for (h = ldIndex; h < total; h++) 
			{
				cell= AbstractCell(cells.get(h));
				cell.hide();
			}
		}
		
		override protected function layoutWhenNotShareCells():void
		{
			var isize:int = getCellUsingSize();
			var startIndex:int = Math.floor(getHolderPos()/isize);
			
			var endIndex:int = startIndex + Math.ceil(getUsingSize()/isize);
			
			if(endIndex > rowNum)
			{
				endIndex = rowNum;
			}
			
			
			if(lastStartIndex==startIndex && lastEndIndex==endIndex) return;
			
			lastStartIndex = startIndex;
			lastEndIndex = endIndex;
			
			var cell:AbstractCell;
			var cellCom:TComponent;
			
			
			var i:int;
			var j:int;
			var si:int=startIndex*columnNum;
			
			var h:int;
			for (h = 0; h < si; h++) 
			{
				cell= AbstractCell(cells.get(h));
				cell.hide();
			}
			
			
			for(i=startIndex; i<=endIndex; i++){
				for(j=0;j<columnNum;j++){
					cell= AbstractCell(cells.get(si));
					if(!cell || !items[si]) break;
					cellCom=cell.getCellComponent();
					cell.show();
					cellCom.x=(isVertical()?j:i)*getCellWidth();
					cellCom.y=(isVertical()?i:j)*getCellHeight();
					cell.setListCellStatus(this, isSelectedIndex(si), si);
					si++;
				}
			}
			
			var total:int = cells.getSize();
			
			for (h = si; h < total; h++) 
			{
				cell= AbstractCell(cells.get(h));
				cell.hide();
			}
		}
		
		override protected function getNeedNum():int
		{
			var needNum:int = (Math.ceil(getUsingSize()/getCellUsingSize())+2)*columnNum;
			needNum = Math.min(needNum, items.length);
			return needNum;
		}
		
		
		override protected function get rowNum():int
		{
			return Math.ceil(_items.length/columnNum); 
		}
	
	
	}
	
}