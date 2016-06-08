package widget
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	public class Document extends MovieClip
	{
		private var widgets:Array = [];
		
		private var designMode:Boolean = stage != null;
		public function Document()
		{
			super();
			
//			designMode = stage != null;
			
			if(designMode){
				trace("发布");
				
				this.doLoop();
				this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}else{
				trace("播放");
			}
			
		}
		
		protected function nextFrame2():void
		{
//			trace(this.currentFrame);
			this.gotoAndPlay(this.currentFrame + 1);
//			this.nextFrame2();
		}
		private function enterFrameHandler(e):void{
			this.doLoop();
		}
		
		
		private var mComponentMap:Dictionary = new Dictionary();
		private function onEnterFrame2(e):void{
			doLoop();
		}
		
		public function doLoop():void{
//			trace(this.totalFrames, this.currentFrame);
			if(this.currentFrame == this.totalFrames){
				trace(JSON.stringify(this.widgets));
//				this.loaderInfo.bytes
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
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
			if(/^mcomponents/.test(clazzName)){
				if(!mComponentMap[node]){
					mComponentMap[node] = true;
					
					this.widgets.push({frame:this.currentFrame, type:clazzName.replace("::", ".")});
					
//					var jsonStr:String = JSON.stringify({frame:this.currentFrame, type:clazzName.replace("::", ".")});
//					trace(jsonStr);
				}
			}
		}
	}
}