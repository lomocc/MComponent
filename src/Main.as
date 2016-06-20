package
{
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VolumePlugin;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import app.components.CommonToggleButton;
	import app.components.TListUI;
	import app.components.TSlider;
	import app.components.TSliderUI;
	import app.components.list.TList;
	import app.events.ListItemEvent;
	import app.utils.DisplayUtil;
	import app.utils.MovieClipWrapper;
	import app.utils.ScriptUtil;
	import app.views.WidgetItem;
	
	import assets.ThemeUI;
	
	import widget.Image;
	import widget.Label;
	import widget.interfaces.IWidget;
	
	public class Main extends Sprite
	{
		TweenPlugin.activate([VolumePlugin, AutoAlphaPlugin]);
		
		ScriptUtil.importClass(Image, Label);
		
		public var containerWidth:uint = 800;
		public var containerHeight:uint = 500;
		
		public var componentHeight:uint = 50;
		
		public var movieWidth:uint = 550;
		public var movieHeight:uint = 400;
		
		public var toolPadding:uint = 10;
		
		private var ui:ThemeUI;
		
		private var componentList:TList;
		
		private var playBtn:CommonToggleButton;
		private var soundBtn:CommonToggleButton;
		private var progressSlider:TSlider;
		//		private var timeStampField:TextField;
		
		private var movieContainer:Sprite;
		private var toolContainer:Sprite;
		
		private var movieLoader:Loader;
		private var movieClipWrapper:MovieClipWrapper;
		
		private var mComponentMap:Dictionary = new Dictionary();
		
		private var movieConfig:Array;
		
		private var framesConfig:Object;
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStage);
		}
		
		protected function addedToStage(event:Event):void
		{
			DisplayUtil.initStage(stage);
			
			loadConfig();
			
		}
		private function loadConfig():void
		{
			new DataLoader("fla/Template-61.json", {onComplete:configLoadCompleteHandler, autoDispose:true}).load();
		}
		private function configLoadCompleteHandler(event:LoaderEvent):void
		{
			var templateConfig:Object = JSON.parse(event.target.content);
			var mivieURL:String = templateConfig.url;
			this.movieConfig = templateConfig.config;
			
			initFrames();
			initContainer();
			initUI();
			
			this.movieLoader = new Loader();
			this.movieLoader.x = this.containerWidth - this.movieWidth >> 1;
			this.movieLoader.y = this.containerHeight - this.movieHeight >> 1;
			this.movieLoader.contentLoaderInfo.addEventListener(Event.INIT, this.onMovieLoadInit);
			this.movieLoader.load(new URLRequest(mivieURL));
			this.addMovieChild(this.movieLoader);
		}
		
		private function initFrames():void
		{
			framesConfig = {};
			for (var i:int = 0, l:int = movieConfig.length; i < l; i++) 
			{
				var props:* = movieConfig[i];
				if(!framesConfig[props.frame]){
					framesConfig[props.frame] = [props];
				}else{
					framesConfig[props.frame].push(props);
				}
			}		
		}
		private function initContainer():void
		{	
			var g:Graphics = this.graphics;
			g.beginFill(0x313131);
			g.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			g.endFill();
			
			this.movieContainer = new Sprite();
			this.movieContainer.y = this.componentHeight;
			this.addChild(this.movieContainer);
			
			this.toolContainer = new Sprite();
			this.toolContainer.y = this.componentHeight + this.containerHeight;
			this.addChild(this.toolContainer);
		}
		
		private function initUI():void
		{
			this.ui = new ThemeUI();
			this.addChild(this.ui);
			
			this.componentList = new TList(new TListUI(ui.mc_list),null,TList.HORIZONTAL);
			
			componentList.addEventListener(ListItemEvent.ITEM_CLICK, this.onWidgetSelect);
			componentList.setCellType(WidgetItem);
			componentList.setCellWidth(200);
//			componentList.setCellHeight(200);
			
			componentList.items = movieConfig;
			this.soundBtn = new CommonToggleButton(this.ui.btn_sound, "", onTogglSoundChange);
			this.playBtn = new CommonToggleButton(this.ui.btn_play, "", this.onTogglBtnChange);
			
			progressSlider = new TSlider(new TSliderUI(this.ui.mc_progress), TSlider.HORIZONTAL, onProgressSliderChange);
			progressSlider.maximum = 1;
			progressSlider.minimum = 0;
		}
		
		protected function onWidgetSelect(event:ListItemEvent):void
		{
			var frame:int = event.getValue().frame;
			componentList.selectedCell = event.getCell();
			if(frame != this.movieClipWrapper.movieClip.currentFrame){
				trace(123,JSON.stringify(event.getValue()));
				this.playBtn.selected = false;
				
				this.movieClipWrapper.movieClip.gotoAndStop(frame);
			}
		}
		private function onTogglSoundChange():void
		{
			if(this.soundBtn.selected){
				TweenLite.to(this.movieClipWrapper.movieClip, 1, {volume:0});
				//				this.movieClipWrapper.movieClip.soundTransform = new SoundTransform(0);
			}else{
				TweenLite.to(this.movieClipWrapper.movieClip, 1, {volume:1});
				//				this.movieClipWrapper.movieClip.soundTransform = new SoundTransform(1);
			}
		}
		
		private function onProgressSliderChange(e:Event):void
		{
			this.movieClipWrapper.progress = progressSlider.value;
			this.playBtn.selected = false;
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
		
		protected function onMovieLoadInit(event:Event):void
		{
			var movie:MovieClip = LoaderInfo(event.target).content as MovieClip;
			movie.stop();
			
			this.movieClipWrapper = new MovieClipWrapper(movie);
			movie.addEventListener(Event.FRAME_CONSTRUCTED, onMovieFrameConstructed);
			//			trace("onMovieLoadInit", movie.totalFrames);
		}
		
		public var lastFrame:int = -1;
		private function onMovieFrameConstructed(e:Event):void
		{
			var currentFrame:int = this.movieClipWrapper.movieClip.currentFrame;
			//			trace("frame", this.movieClipWrapper.movieClip.currentFrame);
			if(currentFrame != lastFrame){
				lastFrame = currentFrame;
				this.ui.tf_timeStamp.text = formatString("{0}/{1}", toTimeString(this.movieClipWrapper.currentTime), toTimeString(this.movieClipWrapper.totalTime));
				//				this.ui.tf_timeStamp.x = this.containerWidth - this.toolPadding - this.timeStampField.width;
				
				if(framesConfig[currentFrame]){
					loop(this.movieClipWrapper.movieClip, framesConfig[currentFrame].concat())
				}
			}
			progressSlider.value = this.movieClipWrapper.progress;
		}
		private function loop(node:DisplayObject, widgets:Array):void{
			if(node is IWidget){
				if(!mComponentMap[node]){
					mComponentMap[node] = true;
					
					var config:Object = widgets.shift();
					if(config){
						(node as IWidget).fromConfig(config);
					}
				}
			}else if(node is DisplayObjectContainer){
				for(var i:int = 0, l:int = (node as DisplayObjectContainer).numChildren;i < l;i++)
				{
					loop((node as DisplayObjectContainer).getChildAt(i), widgets);
				}
			}
		}
		protected function formatString(format:String, ...args):String{
			for(var i:int=0; i < args.length; i++){
				format = format.replace(new RegExp('\\{'+i+'\\}', "g"), args[i]);
			}
			return format;
		}
		protected function toTimeString(time:Number):String{
			var seconds:uint = time % 60;
			var minutes:uint = time/60%60;
			//			var hours:uint = time/3600>>0;
			return formatString("{0}:{1}", zeroPad(minutes), zeroPad(seconds));
		}
		protected function zeroPad(str:*, num:uint=2):String{
			str = str.toString();
			return "00000000".substr(0, num - str.length) + str;
		}
		
		
		protected function onTogglBtnChange():void
		{
			var movie:MovieClip = this.movieLoader.content as MovieClip;
			if(this.playBtn.selected){
				movie.play();
			}else{
				movie.stop();
			}
		}
	}
}