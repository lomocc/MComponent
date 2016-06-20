package app.views
{
	import flash.utils.getDefinitionByName;
	
	import app.components.CommonButton;
	import app.components.list.AbstractCell;
	import app.components.list.TList;
	import app.utils.Binder;
	
	import assets.WidgetItemUI;
	
	
	public class WidgetItem extends AbstractCell
	{
		
		//private var icon:IResObject;
		private var mc_holder:WidgetItemUI;
		
		private var toggleSelect:CommonButton;
		
		protected var binder:Binder = new Binder;
	
		public function WidgetItem()
		{
			super();
			
			
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren() : void
		{
			super.addChildren();
//			setToolTip(getTip);
			mc_holder = new WidgetItemUI();
			addChild(mc_holder);
			
			toggleSelect = new CommonButton(mc_holder);
			
		}
		
		
		override public function setCellValue(value:*):void
		{
			if(value == data) return;
			super.setCellValue(value);
			
			var widgetClazz:* = getDefinitionByName(data.type);
			var widgetInstance:* = new widgetClazz();
			
			this.addChild(widgetInstance);
//			removeIcon();
//			if(delay) delay.kill();
//			delay = null;
			binder.unBinding();
//			if(value ==null) return;
//			binding();
		}
		override public function setListCellStatus(list:TList, isSelected:Boolean, index:int):void
		{
			super.setListCellStatus(list,isSelected,index);
			
			this.mc_holder.mc_bg.visible = !isSelected;
		}
		
//		public function get vo():BuffVo
//		{
//			return data as BuffVo;
//		}
		override public function dispose():void
		{
			binder.unBinding();
			super.dispose();
			mc_holder = null;
		}
		
	}
}