package
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	[SWF(backgroundColor="#000000", width="800", height="600", frameRate="24")]
	public class Preloader extends Sprite
	{
		//		LoaderMax.activate([SWFLoader]);
		
		public function Preloader()
		{
			super();
			
			stage.scaleMode = "noScale";
			stage.align = "tl";
			
			new DataLoader("config.json", {onComplete:completeHandler, autoDispose:true}).load();
			
		}
		private function completeHandler(event:LoaderEvent):void {
			var config:Object = JSON.parse(event.target.content);
			
			var queue:LoaderMax = new LoaderMax();
			queue.maxConnections = 1;
			queue.append(new SWFLoader(config.ThemeUI, {context:new LoaderContext(false, ApplicationDomain.currentDomain), autoDispose:true}));
			queue.append(new SWFLoader(config.Main, {context:new LoaderContext(false, ApplicationDomain.currentDomain), onComplete:mainCompleteHandler}));
			queue.load();
		}
		private function mainCompleteHandler(event:LoaderEvent):void {
			
			this.addChild(event.target.rawContent as DisplayObject);
			
			trace("1234567")
		}
	}
}