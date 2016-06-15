package widget
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import widget.interfaces.IImage;
	import widget.interfaces.ILabel;
	import widget.interfaces.IWidget;
	
	public class Document extends MovieClip
	{
		private var designMode:Boolean = stage != null;
		
		private var widgets:Array;
		private var mComponentMap:Dictionary;
		
		public function Document()
		{
			super();
			if(designMode){
				trace("播放完成后发布");
				widgets = [];
				mComponentMap = new Dictionary();
				
				this.addEventListener(Event.FRAME_CONSTRUCTED, frameConstructed);
			}
		}
		
		private function frameConstructed(e):void{
			trace(this.currentFrame);
			loop(this);
			if(this.currentFrame == this.totalFrames){
				trace(JSON.stringify(this.widgets));
				for (var i:* in mComponentMap) 
				{
					trace(i.toString());
				}
				
				
				this.removeEventListener(Event.FRAME_CONSTRUCTED, frameConstructed);
			}
		}
		
		private function loop(node:DisplayObject):void{
			if(node is IWidget){
				if(!mComponentMap[node]){
					mComponentMap[node] = true;
					
					var props:Object = {frame:this.currentFrame, type:getQualifiedClassName(node)};
					props.contentX = (node as IWidget).contentX;
					props.contentY = (node as IWidget).contentY;
					props.scale = (node as IWidget).scale;
					
					if(node is IImage){
						props.url = (node as IImage).url;
					}else if(node is ILabel){
						props.text = (node as ILabel).text;
						props.font = (node as ILabel).font;
					}
					this.widgets.push(props);
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