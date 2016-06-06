package mcomponents
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	public class MDocument extends MovieClip
	{
		public function MDocument()
		{
			super();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private var mComponentMap:Dictionary = new Dictionary();
		private function onEnterFrame(e):void{
			loop(this);
		}
		
		public function loop(node):void{
			if(node is DisplayObjectContainer){
				for(var i:int = node.numChildren-1;i>=0;i--)
				{
					loop(node.getChildAt(i));
				}
				
			}
			var clazzName:String = getQualifiedClassName(node);
			if(/mcomponents/.test(clazzName)){
				if(!mComponentMap[node]){
					mComponentMap[node] = true;
					trace(this.currentFrame, node);
				}
			}
		}
	}
}