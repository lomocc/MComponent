/**
 * List.as
 * Keith Peters
 * version 0.9.9
 * 
 * A scrolling list of selectable items. 
 * 
 * Copyright (c) 2011 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package app.components.list
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import app.components.TComponent;
	import app.components.TListUI;
	import app.components.TScrollBar;
	import app.components.TSlider;
	import app.events.ListEvent;
	import app.events.ListItemEvent;
	import app.events.ReleaseEvent;
	import app.utils.ArrayList;
	import app.utils.DisplayUtil;
	import app.utils.HashMap;
	import app.utils.MathUtil;
	
	[Event(name="ITEM_SELECTED", type="app.events.ListEvent")]
	
	
	/**
	 * Dispatched when the list item be click.
	 * @eventType com.throne.events.ListItemEvent.ITEM_CLICK
	 */
	[Event(name="itemClick", type="app.events.ListItemEvent")]
	
	/**
	 * Dispatched when the list item be double click.
	 * @eventType com.throne.events.ListItemEvent.ITEM_DOUBLE_CLICK
	 */
	[Event(name="itemDoubleClick", type="app.events.ListItemEvent")]
	
	/**
	 * Dispatched when the list item be mouse down.
	 * @eventType com.throne.events.ListItemEvent.ITEM_MOUSE_DOWN
	 */
	[Event(name="itemMouseDown", type="app.events.ListItemEvent")]
	
	/**
	 * Dispatched when the list item be roll over.
	 * @eventType com.throne.events.ListItemEvent.ITEM_ROLL_OVER
	 */
	[Event(name="itemRollOver", type="app.events.ListItemEvent")]
	
	/**
	 * Dispatched when the list item be roll out.
	 * @eventType com.throne.events.ListItemEvent.ITEM_ROLL_OUT
	 */
	[Event(name="itemRollOut", type="app.events.ListItemEvent")]
	
	/**
	 * Dispatched when the list item be released out side.
	 * @eventType com.throne.events.ListItemEvent.ITEM_RELEASE_OUT_SIDE
	 */
	[Event(name="itemReleaseOutSide", type="app.events.ListItemEvent")]
	
	
	
	public class TList extends TComponent
	{
		protected var _items:Array;
		protected var _itemHolder:Sprite;
		protected var _cellFactory:GeneralListCellFactory;
		protected var _scrollbar:TScrollBar;
		protected var _selectedIndex:int = -1;
		protected var _alternateRows:Boolean = false;
		protected var ui:TListUI;
		
		protected var cells:ArrayList;
		protected var comToCellMap:HashMap;
		protected var cellHeight:int=22;
		protected var cellWidth:int=22;
		
		protected var marginH:int = 0;
		protected var marginW:int = 0;
		//protected var showingCell:HashMap=new HashMap;
		
		protected var lastStartIndex:int = -1;
		protected var lastEndIndex:int = -1;
		
		private var _lineSize:int = 1;
		
		protected var _orientation:String;
		
		public function get scrollDur():Number
		{
			return _dur;
		}
		
		public function set scrollDur(value:Number):void
		{
			_dur = value;
		}
		
		public static function get HORIZONTAL():String{ return TSlider.HORIZONTAL };
		public static function get VERTICAL():String { return TSlider.VERTICAL };
		
		
		private var container:Sprite;
		
		
		
		
		/**
		 * Constructor
		 */
		public function TList(ui:TListUI,items:Array=null,orientation:String=TSlider.VERTICAL)
		{
			//			if(_cellFactory){
			//				this._cellFactory=cellFactory;
			//			}else{
			_cellFactory= new GeneralListCellFactory(AbstractCell);
			//			}
			
			if(items != null)
			{
				_items = items;
			}
			else
			{
				_items = new Array();
			}
			_orientation = orientation;
			cells = new ArrayList();
			comToCellMap = new HashMap();
			
			this.ui=ui;
			super(ui);
		}
		
		
		/**
		 * @return the cellFactory of this List
		 */
		public function getCellFactory():GeneralListCellFactory{
			return _cellFactory;
		}
		
		/**
		 * This will cause all cells recreating by new factory.
		 * @param newFactory the new cell factory for this List
		 */
		public function setCellFactory(newFactory:GeneralListCellFactory):void{
			_cellFactory = newFactory;
			removeAllCells();
			updateListView();
		}
		
		
		/**
		 * 更换工厂需要清空所有缓存数据 会闪烁 除非Cell改变 否则尽量不更新工厂
		 * @param itemCellClass
		 * @param shareCells 显示大量数据时 适合共享cell 	单个cell内容更新耗时过长或者单屏幕显示cell过多 不适合共享cell
		 * @param cacheCells 是否缓存cell 为true 当数据比实际的cell少的时候 不删除多余的cell
		 * 
		 */		
		public function setCellType(itemCellClass:Class,shareCells:Boolean=false,cacheCells:Boolean = true):void{
			
			if(itemCellClass==null) return;
			if(itemCellClass==getCellFactory().getCellClass() && shareCells==isShareCells() && cacheCells == isCacheCells()) return;
			if(itemCellClass!=getCellFactory().getCellClass()){
				setCellFactory(new GeneralListCellFactory(itemCellClass,shareCells));
			}else{
				getCellFactory().setIsShareCells(shareCells);
				getCellFactory().setIsCacheCells(cacheCells);
				updateListView();
			}
			
		}
		
		
		
		
		public function updateListView() : void {
			//TweenLite.killTweensOf(_itemHolder);
			redraw();
		}
		
		
		
		/**
		 * Initilizes the component.
		 */
		protected override function init() : void
		{
			
			setSize(ui.masker.width, ui.masker.height);
			createCells();
			super.init();
		}
		
		
		
		
		public function set mouseWheel(b:Boolean):void
		{
			
			if(b){
				addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}else{
				removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
			_scrollbar.mouseWheel=b;
		}
		
		
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function addChildren() : void
		{
			super.addChildren();
			
			
			
			container=DisplayUtil.createSprite(ui.masker.width, ui.masker.height,0x00,0);
			addChild(container);
			
			
			
			container.x=ui.masker.x;
			container.y=ui.masker.y;
			
			ui.masker.x=0;
			ui.masker.y=0;
			
			
			_itemHolder = new Sprite();
			_itemHolder.mask = ui.masker;
			
			
			container.addChild(_itemHolder);
			container.addChild(ui.masker);
			
			/*with(container.graphics){
			beginFill(0x0,0);
			drawRect(0,0,ui.masker.width, ui.masker.height);
			endFill();
			}*/
			
			
			createScrollBar();
			
			mouseWheel=true;
		}
		
		protected function createScrollBar():void
		{
			_scrollbar = new TScrollBar(ui.scrollbarUI,_orientation,onScroll);
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		public override function redraw() : void
		{
			super.redraw();
			
			//_selectedIndex = Math.min(_selectedIndex, _items.length - 1);
			
			
			//TweenLite.killTweensOf(_itemHolder);
			
			//clearShowingCells();
			
			createCells();
			
			lastStartIndex=-1;
			lastEndIndex=-1;
			
			_scrollbar.setThumbPercent(getThumbPercent()); 
			
			_scrollbar.maximum = Math.max(0, getScrollAbleMaximum());
			
			_scrollbar.pageSize = getPageSize();
			
			_scrollbar.lineSize = getLineSize();
			
			_scrollbar.redraw();
			
			
			onScroll();
			
			layout();
			
		}
		
		
		
		/**
		 * 上下按钮和滚轮 每次滚动行数 
		 * @return 
		 * 
		 */		
		protected function getLineSize():int
		{
			return _lineSize;
		}	
		
		public function set lineSize(value:int):void
		{
			_lineSize = value;
		}
		/*public function get lineSize():int
		{
		return _lineSize;
		}*/
		
		
		protected function isVertical():Boolean{
			return _orientation == VERTICAL;
		}
		
		protected function getThumbPercent():Number
		{
			return getUsingSize() / getContentUsingSize();
		}
		
		protected function getPageSize():Number
		{
			return Math.floor(getUsingSize() / getCellUsingSize());
		}
		
		protected function getScrollAbleMaximum():int{
			return rowNum - getPageSize();
		}
		
		protected function getContentUsingSize():Number{
			//return isVertical()?rowNum * getCellUsingSize():rowNum * getCellUsingSize();
			return rowNum * getCellUsingSize();
		}
		
		protected function getCellUsingSize():int{
			return isVertical()?getCellHeight():getCellWidth();
		}
		
		
		protected function get rawWidth():int{
			return _width+marginW;
		}
		
		protected function get rawHeight():int{
			return _height+marginH;
		}
		
		
		protected function getUsingSize():int{
			return isVertical()?rawHeight:rawWidth;
		}
		
		
		protected function get rowNum():int{
			return _items.length; 
		}
		
		
		protected function setPos(cellCom:TComponent,pos:int):void{
			isVertical()?cellCom.y=pos:cellCom.x=pos;
		}
		
		protected function getHolderPos():int{
			return isVertical()?-_itemHolder.y:-_itemHolder.x;
		}
		
		
		/**
		 * Adds an item to the list.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 */
		public function addCell(item:Object):void
		{
			_items.push(item);
			validateCells();
		}
		
		/**
		 * Adds an item to the list at the specified index.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 * @param index The index at which to add the item.
		 */
		public function addCellAt(item:Object, index:int):void
		{
			//index = Math.max(0, index);
			//index = Math.min(_items.length, index);
			index = MathUtil.clamp(index,0,_items.length);
			_items.splice(index, 0, item);
			validateCells();
		}
		
		/**
		 * Removes the referenced item from the list.
		 * @param item The item to remove. If a string, must match the item containing that string. If an object, must be a reference to the exact same object.
		 */
		public function removeCell(item:Object):void
		{
			var index:int = _items.indexOf(item);
			removeCellAt(index);
		}
		
		/**
		 * Removes the item from the list at the specified index
		 * @param index The index of the item to remove.
		 */
		public function removeCellAt(index:int):void
		{
			if(index < 0 || index >= _items.length) return;
			if(isSelectedIndex(index)){
				_selectedIndex=-1;
			}
			_items.splice(index, 1);
			validateCells();
		}
		
		
		
		/**
		 * Sets / gets the list of items to be shown.
		 */
		public function set items(value:Array):void
		{
			if(value != null)
			{
				_items = value;
			}
			else
			{
				_items = new Array();
			}
			//_items = value;
			_selectedIndex = -1;
			updateListView();
		}
		public function get items():Array
		{
			return _items;
		}
		
		
		public function set scrollPos(value:Number):void
		{
			scrollbar.pos= value;
			onScroll();
		}
		
		
		protected var tarPos:Number=Number.MAX_VALUE;
		private var _dur:Number = 0.3;
		
		
		/**
		 * Called when the user scrolls the scroll bar.
		 */
		protected function onScroll(event:Event = null):void
		{
			//_itemHolder.y=-scrollbar.value*getCellUsingSize();
			if(tarPos==scrollbar.value) return;
			tarPos=scrollbar.value;
			var dur:Number=event==null?0:_dur;
			if(isVertical()){
				TweenLite.to(_itemHolder,_dur,{y:-scrollbar.value*getCellUsingSize(),onUpdate:layout});
			}else{
				TweenLite.to(_itemHolder,_dur,{x:-scrollbar.value*getCellUsingSize(),onUpdate:layout});
			}
			//layout();
		}
		
		/**
		 * Called when the mouse wheel is scrolled over the component.
		 */
		protected function onMouseWheel(event:MouseEvent):void
		{
			event.preventDefault();
			event.stopImmediatePropagation();
			if(event.delta>0){
				_scrollbar.value -=_scrollbar.lineSize;
			}
			else if(event.delta<0)
			{
				_scrollbar.value -=	-_scrollbar.lineSize;
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function unSelectCell():void
		{
			selectedIndex = -1;
		}
		
		/**
		 * Sets / gets the index of the selected list item.
		 */
		public function set selectedIndex(value:int):void
		{
			if(_selectedIndex == value) return;
			var _pselectedIndex:int= _selectedIndex;
			
			if(value >= 0 && value < _items.length)
			{
				_selectedIndex = value;
				//_scrollbar.value = _selectedIndex;
			}
			else
			{
				_selectedIndex = -1;
			}
			//validateCells();
			
			var cell:AbstractCell;
			if(isShareCells())
			{
				var size:int = cells.getSize();
				for(var i:int=0; i<size; i++){
					cell = cells.get(i);
					if(cell.getIndex() == _pselectedIndex)
					{
						cell.setListCellStatus(this, false, _pselectedIndex);
					}
					if(cell.getIndex() == _selectedIndex)
					{
						cell.setListCellStatus(this, true, _selectedIndex);
						dispatchEvent(new ListEvent(ListEvent.ITEM_SELECTED,cell.getCellValue(),cell));
					}
				}
			}else
			{
				
				cell = AbstractCell(cells.get(_pselectedIndex));
				if(cell){
					cell.setListCellStatus(this, false, _pselectedIndex);
				}
				cell = AbstractCell(cells.get(_selectedIndex));
				if(cell){
					cell.setListCellStatus(this, true, _selectedIndex);
					dispatchEvent(new ListEvent(ListEvent.ITEM_SELECTED,cell.getCellValue(),cell));
				}
			}
		}
		
		public function scrollToSelection():void{
			_scrollbar.value = _selectedIndex;
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		/**
		 * Sets / gets the item in the list, if it exists.
		 */
		public function set selectedCell(item:AbstractCell):void
		{
			if(item == null)
			{
				unSelectCell();
				return;
			}
			var index:int = item.getIndex();
			/*if(index != -1)
			{*/
			selectedIndex = index;
			//}
		}
		public function get selectedCellValue():Object
		{
			if(_selectedIndex >= 0 && _selectedIndex < _items.length)
			{
				return _items[_selectedIndex];
			}
			return null;
		}
		/**
		 * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
		 */
		public function set autoHideScrollBar(value:Boolean):void
		{
			_scrollbar.autoHide = value;
		}
		public function get autoHideScrollBar():Boolean
		{
			return _scrollbar.autoHide;
		}
		
		public function get scrollbar():TScrollBar
		{
			return _scrollbar;
		}
		
		
		override public function dispose():void{
			
			removeAllCells();
			comToCellMap.clear();
			
			super.dispose();
			
			comToCellMap = null;
			_items = null;
			container=null;
			_itemHolder = null;
			_cellFactory =null;
			_scrollbar = null;
			cells = null;
			ui = null;
		}
		
		
		//----------------------privates-------------------------
		
		protected function addCellToContainer(cell:AbstractCell):void{
			_itemHolder.addChild(cell.getCellComponent());
			comToCellMap.put(cell.getCellComponent(), cell);
			addHandlersToCell(cell.getCellComponent());
		}
		
		protected function removeCellFromeContainer(cell:AbstractCell):void{
			cell.getCellComponent().removeFromContainer();
			comToCellMap.remove(cell.getCellComponent());
			removeHandlersFromCell(cell.getCellComponent());
		}
		
		protected function getNeedNum():int{
			var needNum:int = getPageSize() +2;
			needNum = Math.min(needNum, items.length);
			return needNum;
		}
		
		/**
		 * 创建出足够用的cell 
		 * 一屏多2个
		 * 
		 */		
		protected function createCellsWhenShareCells():void{
			
			var needNum:int = getNeedNum();
			
			//如果刚好够用不需要做操作
			if(cells.getSize() == needNum){
				return;
			}
			
			var i:int;
			var cell:AbstractCell;
			//不够需要创建新的
			if(cells.getSize() < needNum){
				var addNum:int = needNum - cells.getSize();
				
				for(i=0; i<addNum; i++){
					
					cell = createNewCell();
					cell.hide();
					
					addCellToContainer(cell);
					cells.append(cell);
					
				}
				//多了的删除掉	
			}else if(cells.getSize() > needNum){ 
				var removeIndex:int = needNum;
				var removed:Array = cells.removeRange(removeIndex, cells.getSize()-1);
				for(i=0; i<removed.length; i++){
					cell = AbstractCell(removed[i]);
					removeCellFromeContainer(cell);
					cell.dispose();
					
				}
			}
		}
		
		
		/*private function itemIsShowing(key:*):Boolean
		{
		return showingCell.containsKey(key);
		}*/
		
		/**
		 * 为每条纪录创建cell  不共享的时候 创建时数值
		 * 
		 */		
		protected function createCellsWhenNotShareCells():void{
			
			//Logger.log(this,"createCellsWhenNotShareCells");
			
			var cSize:int = cells.getSize();
			var mSize:int=items.length;
			
			
			var n:int = Math.min(mSize, cSize);
			var i:int;
			var cell:AbstractCell;
			//初始化已经有的cell
			for(i=0; i<n; i++){
				cell = AbstractCell(cells.get(i));
				cell.hide();
				cell.setCellValue(items[i]);
				addCellToContainer(cell);
			}
			//现有的item没有需要的多的时候创建新的cell
			if(mSize > cSize){
				for(i = cSize; i<mSize; i++){
					cell = createNewCell();
					cell.setCellValue(items[i]);
					cell.hide();
					addCellToContainer(cell);
					cells.append(cell);
				}
				
				//不删掉多余的 dipose调用 removeAllCells()释放内存
				//删掉多余的	cell
			}else if(mSize < cSize){ 
				if(isCacheCells())
				{
					for(i = mSize; i<cSize; i++){
						cell = AbstractCell(cells.get(i));
						cell.setCellValue(items[i]);
						cell.hide();
						removeCellFromeContainer(cell);
					}
				}else
				{
					var removed:Array = cells.removeRange(mSize, cSize-1);
					for(i=0; i<removed.length; i++){
						cell = AbstractCell(removed[i]);
						removeCellFromeContainer(cell);
						cell.dispose();
					}
				}
				
			}
		}
		
		
		protected function layout():void
		{
			isShareCells()
			?layoutWhenShareCells()
				:layoutWhenNotShareCells();
		}
		
		/**
		 *共享时 布局时付值 
		 * 
		 */		
		protected function layoutWhenShareCells():void{
			
			var isize:int = getCellUsingSize();
			var startIndex:int = Math.floor(getHolderPos()/isize);
			var listSize:int = rowNum;
			var endIndex:int = startIndex + Math.ceil(getUsingSize()/isize);
			if(endIndex >= listSize){
				endIndex = listSize - 1;
			}
			if(lastStartIndex==startIndex && lastEndIndex==endIndex) return;
			
			lastStartIndex = startIndex;
			lastEndIndex = endIndex;
			
			
			var cell:AbstractCell;
			var cellCom:TComponent;
			
			
			
			
			var ldIndex:int;
			
			var cellsSize:int = cells.getSize();
			for(var i:int = 0; i<cellsSize; i++){
				cell = cells.elementAt(i);
				ldIndex = startIndex + i;
				cellCom = cell.getCellComponent();
				if(ldIndex < listSize){
					cell.setCellValue(items[ldIndex]);
					cell.show();
					setPos(cellCom,ldIndex*isize);
					//直接重绘 避免等到下一帧重绘时闪烁
					//cellCom.redraw();
					cell.setListCellStatus(this, isSelectedIndex(ldIndex), ldIndex);
					
				}else{
					cell.hide();
				}
			}
			
			
			
		}
		
		protected function layoutWhenNotShareCells():void
		{
			
			var isize:int = getCellUsingSize();
			var startIndex:int = Math.floor(getHolderPos()/isize);
			var listSize:int = rowNum;
			var endIndex:int = startIndex + Math.ceil(getUsingSize()/isize);
			if(endIndex >= listSize){
				endIndex = listSize - 1;
			}
			if(lastStartIndex==startIndex && lastEndIndex==endIndex) return;
			
			lastStartIndex = startIndex;
			lastEndIndex = endIndex;
			
			
			var cell:AbstractCell;
			var cellCom:TComponent;
			
			
			
			for(var i:int=startIndex; i<=endIndex; i++){
				cell= AbstractCell(cells.get(i));
				cellCom=cell.getCellComponent();
				cell.show();
				setPos(cellCom,i*getCellUsingSize());
				cell.setListCellStatus(this, isSelectedIndex(i), i);
			}
		}		
		
		
		public function getCellAt(index:int):AbstractCell
		{
			return cells.get(index);
		}
		
		protected function isSelectedIndex(value:int):Boolean
		{
			return selectedIndex==value;
		}
		
		
		
		public function setCellWidth(value:int,marginW:int = 0) : void {
			this.marginW = marginW;
			cellWidth = value;
			updateListView();
		}
		
		public function getCellWidth():int
		{
			return cellWidth;
		}
		
		
		public function setCellHeight(value:int, marginH:int = 0) : void {
			this.marginH = marginH;
			cellHeight = value;
			updateListView();
		}
		
		public function getCellHeight() : int {
			return cellHeight;
		}
		
		protected function createNewCell():AbstractCell{
			return getCellFactory().createNewCell();
		}
		
		protected function isShareCells():Boolean{
			return getCellFactory().isShareCells();
		}
		
		protected function isCacheCells():Boolean{
			return getCellFactory().isCacheCells();
		}
		
		protected function createCells():void{
			isShareCells()
			?createCellsWhenShareCells()
				:createCellsWhenNotShareCells();
		}
		
		protected function removeAllCells() : void {
			var cell:AbstractCell;
			for(var i:int=0; i<cells.getSize(); i++){
				cell = cells.get(i);
				removeCellFromeContainer(cell);
				cell.dispose();
			}
			cells.clear();
		}
		
		protected function validateCells():void{
			invalidate();
		}
		
		//--------------------------------------------------------
		
		
		//-------------------------------Event Listener For All Items----------------
		
		protected function addHandlersToCell(cellCom:TComponent):void{
			cellCom.addEventListener(MouseEvent.CLICK, __onItemClick);
			cellCom.addEventListener(MouseEvent.DOUBLE_CLICK, __onItemDoubleClick);
			cellCom.addEventListener(MouseEvent.MOUSE_DOWN, __onItemMouseDown);
			cellCom.addEventListener(MouseEvent.ROLL_OVER, __onItemRollOver);
			cellCom.addEventListener(MouseEvent.ROLL_OUT, __onItemRollOut);
			cellCom.addEventListener(ReleaseEvent.RELEASE_OUTSIDE, __onItemReleaseOutSide);
		}
		
		protected function removeHandlersFromCell(cellCom:TComponent):void{
			cellCom.removeEventListener(MouseEvent.CLICK, __onItemClick);
			cellCom.removeEventListener(MouseEvent.DOUBLE_CLICK, __onItemDoubleClick);
			cellCom.removeEventListener(MouseEvent.MOUSE_DOWN, __onItemMouseDown);
			cellCom.removeEventListener(MouseEvent.ROLL_OVER, __onItemRollOver);
			cellCom.removeEventListener(MouseEvent.ROLL_OUT, __onItemRollOut);
			cellCom.removeEventListener(ReleaseEvent.RELEASE_OUTSIDE, __onItemReleaseOutSide);
		}
		
		protected function createItemEventObj(cellCom:*, type:String, e:MouseEvent):ListItemEvent{
			var cell:AbstractCell = getCellByCellComponent(TComponent(cellCom));
			var event:ListItemEvent = new ListItemEvent(type, cell.getCellValue(), cell, e);
			return event;
		}
		
		
		protected function getCellByCellComponent(item:TComponent):AbstractCell{
			return comToCellMap.get(item);
		}
		
		/**
		 * Event Listener For All Items
		 */
		protected function __onItemMouseDown(e:MouseEvent):void{
			dispatchEvent(createItemEventObj(e.currentTarget, ListItemEvent.ITEM_MOUSE_DOWN, e));
		}
		
		/**
		 * Event Listener For All Items
		 */	
		protected function __onItemClick(e:MouseEvent):void{
			dispatchEvent(createItemEventObj(e.currentTarget, ListItemEvent.ITEM_CLICK, e));
		}
		
		/**
		 * Event Listener For All Items
		 */	
		protected function __onItemReleaseOutSide(e:ReleaseEvent):void{
			dispatchEvent(createItemEventObj(e.currentTarget, ListItemEvent.ITEM_RELEASE_OUT_SIDE, e));
		}
		
		/**
		 * Event Listener For All Items
		 */	
		protected function __onItemRollOver(e:MouseEvent):void{
			dispatchEvent(createItemEventObj(e.currentTarget, ListItemEvent.ITEM_ROLL_OVER, e));
		}
		
		/**
		 * Event Listener For All Items
		 */	
		protected function __onItemRollOut(e:MouseEvent):void{
			dispatchEvent(createItemEventObj(e.currentTarget, ListItemEvent.ITEM_ROLL_OUT, e));
		}
		
		/**
		 * Event Listener For All Items
		 */	
		protected function __onItemDoubleClick(e:MouseEvent):void{
			dispatchEvent(createItemEventObj(e.currentTarget, ListItemEvent.ITEM_DOUBLE_CLICK, e));
		}
		
	}
}