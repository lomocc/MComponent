package app.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ScrollBarUpDownButton extends TButton
	{
		
		private var over:DisplayObject;
		private var disabled:DisplayObject;
		
		private const DUR:Number=0.3;
		
		private const EASE:Function=Expo.easeOut;
		
		
		public function ScrollBarUpDownButton(ui:DisplayObject=null, defaultHandler:Function=null, params:Array=null)
		{
			super(ui, defaultHandler, params);
		}
		
		
		override protected function initView():void
		{
			this.over=(ui is DisplayObjectContainer) ? ((ui as DisplayObjectContainer).getChildByName("mc_over") || new Sprite()):new Sprite;
			this.disabled= (ui is DisplayObjectContainer) ?((ui as DisplayObjectContainer).getChildByName("mc_disabled") || new Sprite()):new Sprite;
			
			this.disabled.alpha=0;
			this.over.alpha=0;
			
		}
		
		override protected function updateState(event:MouseEvent=null):void
		{
			super.updateState(event);
			
			if(!enable){
				showDisabled();
				return;
			}
			hideDisabled();
			if(_over){
				onOver();
			}else{
				onOut();
			}
			
		}
		
		private function hideDisabled():void
		{
			TweenLite.to(disabled,DUR,{alpha:0,ease:EASE});
			
		}
		
		private function showDisabled():void
		{
			TweenLite.to(disabled,DUR,{alpha:1,ease:EASE});
			
		}		
		
		
		
		private function onOver():void
		{
			TweenLite.to(over,DUR,{alpha:1,ease:EASE});
		}
		
		
		private function onOut():void
		{
			TweenLite.to(over,DUR,{alpha:0,ease:EASE});
		}
		
	}
}