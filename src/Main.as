package
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import component.MovieClipWrapper;
	import component.PlayButton;
	import component.base.Button;
	
	[SWF(width="1024", height="768")]
	public class Main extends Sprite
	{
		public var frameRate:uint = 24;
		private var componentList:Sprite;
		
		private var playBtn:PlayButton;
		private var timeStampField:TextField;
		
		private var movieContainer:Sprite;
		private var toolContainer:Sprite;
		
		private var movieLoader:Loader;
		private var movieClipWrapper:MovieClipWrapper;
		
		private var mComponentMap:Dictionary = new Dictionary();
		
		private var mapConfig:Array = [
			{"frame":1,"type":"widget.Image"},{"frame":1,"type":"widget.Image"},
			{"frame":1,"type":"widget.Document"},{"frame":956,"type":"widget.Image"},
			{"frame":956,"type":"widget.Label"},{"frame":1403,"type":"widget.Image"},{"frame":1403,"type":"widget.Label"}];
		
		public function Main()
		{
			stage.frameRate = frameRate;
			initContainer();
			initUI();
			initMovie();
		}
		private function initContainer():void
		{
			stage.scaleMode = "noScale";
			stage.align = "tl";
			
			var g:Graphics = this.graphics;
			g.beginFill(0x313131);
			g.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			g.endFill();
			
			this.movieContainer = new Sprite();
			this.addChild(this.movieContainer);
			
			this.toolContainer = new Sprite();
			this.addChild(this.toolContainer);
		}
		
		private function initUI():void
		{
			this.componentList = new Sprite();
			this.addToolChild(this.componentList);
			for (var i:int = 0; i < this.mapConfig.length; i++) 
			{
				var obj:Object = this.mapConfig[i];
				var btn:Button = new Button();
				btn.label = obj.type + i;
				btn.addEventListener(MouseEvent.CLICK, this.onComponentClick);
				btn.x = 80 * i;
				btn.putClientProperty(obj);
				this.componentList.addChild(btn);
			}
			
			this.playBtn = new PlayButton();
			this.playBtn.addEventListener(Event.CHANGE, this.onTogglBbtnChange);
			this.playBtn.x = 300;
			this.playBtn.y = 600;
			this.playBtn.label = "播放";
			this.addToolChild(this.playBtn);
			
			this.timeStampField = new TextField();
			this.timeStampField.autoSize = "left";
			this.timeStampField.textColor = 0xffffff;
			this.timeStampField.defaultTextFormat = new TextFormat(null, 30);
			this.timeStampField.x = 600;
			this.timeStampField.y = 600;
			this.addToolChild(this.timeStampField);
		}
		
		protected function onComponentClick(event:MouseEvent):void
		{
			var btn:Button = event.currentTarget as Button;
			var obj:Object = btn.getClientProperty();
			
			var movie:MovieClip = this.movieLoader.content as MovieClip;
			movie.gotoAndStop(obj.frame);
			this.playBtn.toggled = false;
		}
		
		private function addToolChild(child:DisplayObject):void
		{
			this.toolContainer.addChild(child);
		}
		private function addMovieChild(child:DisplayObject):void
		{
			if(this.movieContainer.numChildren > 0)
				this.movieContainer.removeChildren();
			this.movieContainer.addChild(child);
		}
		private function initMovie():void
		{
			var mivieURL:String = "Template-61.swf";
			this.movieLoader = new Loader();
			this.movieLoader.contentLoaderInfo.addEventListener(Event.INIT, this.onMovieLoadInit);
			this.movieLoader.load(new URLRequest(mivieURL));
			this.addMovieChild(this.movieLoader);
		}
		
		protected function onMovieLoadInit(event:Event):void
		{
			var movie:MovieClip = LoaderInfo(event.target).content as MovieClip;
			movie.stop();
			
			this.movieClipWrapper = new MovieClipWrapper(movie);
			movie.addEventListener(Event.ENTER_FRAME, onMovieEnterFrame);
//			trace("onMovieLoadInit", movie.totalFrames);
		}
		
		private function onMovieEnterFrame(e:Event):void
		{
			this.timeStampField.text = formatString("{0}/{1}", this.movieClipWrapper.currentTime>>0, this.movieClipWrapper.totalTime>>0);
		}
		protected function formatString(format:String, ...args):String{
			for(var i:int=0; i < args.length; i++){
				format = format.replace(new RegExp('\\{'+i+'\\}', "g"), args[i]);
			}
			return format;
		}
		
		protected function onTogglBbtnChange(event:Event):void
		{
			var movie:MovieClip = this.movieLoader.content as MovieClip;
			if(event.target.toggled){
				movie.play();
			}else{
				movie.stop();
			}
		}
		
		protected function onBtnClick(event:MouseEvent):void
		{
			trace("click");
			
		}
		
	}
}