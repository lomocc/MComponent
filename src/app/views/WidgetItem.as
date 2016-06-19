package app.views
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	
	import app.components.CommonButton;
	import app.components.list.AbstractCell;
	import app.utils.Binder;
	
	import assets.WidgetItemUI;
	
	
	public class WidgetItem extends AbstractCell
	{
		
		//private var icon:IResObject;
		private var mc_holder:WidgetItemUI;
		protected var binder:Binder = new Binder;
		private var delay:TweenLite;
		
		private var mc_onUp:MovieClip;
		private var mc_onOver:MovieClip;
		private var mc_onLock:MovieClip;
		
		/**
		 * 到期时间
		 */		
		protected var expireDate:Date;
		/**
		 * 是否提醒状态
		 */		
		protected var mState:Boolean = false;
		
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
			mc_onUp = mc_holder.mc_onUp;
			mc_onOver = mc_holder.mc_onOver;
			mc_onLock = mc_holder.mc_onLock;
			addChild(mc_holder);
			
			new CommonButton(mc_holder);
			
		}
		
		
		override public function setCellValue(value:*):void
		{
			if(value == data) return;
			super.setCellValue(value);
//			removeIcon();
//			if(delay) delay.kill();
//			delay = null;
			binder.unBinding();
//			if(value ==null) return;
//			binding();
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
			mc_onOver = null;
			mc_onUp = null;
			binder = null;
		}
		
	}
}