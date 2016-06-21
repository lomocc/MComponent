package widget
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import widget.interfaces.IWidget;
	
	public class Document extends MovieClip
	{
		private var designMode:Boolean = stage != null;
		
		private var config:Object;
		private var mComponentMap:Dictionary;
		
		public function Document()
		{
			super();
			if(designMode){
				trace("播放完成后发布");
				config = {
					width:stage.stageWidth, 
						height:stage.stageHeight,
						frames:[]
				};
				mComponentMap = new Dictionary();
				
				this.addEventListener(Event.FRAME_CONSTRUCTED, frameConstructed);
			}
		}
		
		private function frameConstructed(e):void{
			loop(this);
			if(this.currentFrame == this.totalFrames){
				trace(JSON.stringify(this.config));
				this.removeEventListener(Event.FRAME_CONSTRUCTED, frameConstructed);
			}
		}
		
		private function loop(node:DisplayObject):void{
			if(node is IWidget){
				if(!mComponentMap[node]){
					mComponentMap[node] = true;
					
					var config:Object = (node as IWidget).toConfig();//{frame:this.currentFrame, type:getQualifiedClassName(node)};
					config.frame = this.currentFrame;
					config.type = getQualifiedClassName(node);
					this.config.frames.push(config);
				}
			}else if(node is DisplayObjectContainer){
				for(var i:int = 0, l:int = (node as DisplayObjectContainer).numChildren-1;i<=l;i++)
				{
					loop((node as DisplayObjectContainer).getChildAt(i));
				}
			}
		}
	}
}