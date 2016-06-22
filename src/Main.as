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
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
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
		
		private var ui:ThemeUI;
		
		private var componentList:TList;
		
		private var playBtn:CommonToggleButton;
		private var soundBtn:CommonToggleButton;
		private var progressSlider:TSlider;
		
		private var movieLoader:Loader;
		private var movieMask:Shape;
		private var movieClipWrapper:MovieClipWrapper;
		
		private var mComponentMap:Dictionary = new Dictionary();
		
		private var movieConfig:Object;
		
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
			this.movieConfig = JSON.parse(event.target.content);
			var mivieURL:String = movieConfig.url;
			
			initFrames();
			initUI();
			
			var movieMaxWidth:Number = ui.mc_movie.width;
			var movieMaxHeight:Number = ui.mc_movie.height;
			
			var movieScale:Number = Math.min(ui.mc_movie.width/this.movieConfig.config.width, ui.mc_movie.height/this.movieConfig.config.height);
			
			var movieWidth:Number = movieScale * this.movieConfig.config.width;
			var movieHeight:Number = movieScale * this.movieConfig.config.height;
			
			var movieX:Number = (ui.mc_movie.width - movieWidth)/2 + ui.mc_movie.x;
			var movieY:Number = (ui.mc_movie.height - movieHeight)/2 + ui.mc_movie.y;
			
			movieMask = new Shape();
			movieMask.graphics.beginFill(0, 0);
			movieMask.graphics.drawRect(movieX, movieY,  movieWidth, movieHeight);
			movieMask.graphics.endFill();
			this.addChild(movieMask);
			
			this.movieLoader = new Loader();
			
			this.movieLoader.x = movieX;
			this.movieLoader.y = movieY;
			this.movieLoader.scaleX = movieScale;
			this.movieLoader.scaleY = movieScale;
			
			DisplayUtil.replace(ui.mc_movie, this.movieLoader);
			this.movieLoader.mask = movieMask;
			
			this.movieLoader.contentLoaderInfo.addEventListener(Event.INIT, this.onMovieLoadInit);
			this.movieLoader.load(new URLRequest(mivieURL));
		}
		
		private function initFrames():void
		{
			framesConfig = {};
			for (var i:int = 0, l:int = movieConfig.config.frames.length; i < l; i++) 
			{
				var props:* = movieConfig.config.frames[i];
				if(!framesConfig[props.frame]){
					framesConfig[props.frame] = [props];
				}else{
					framesConfig[props.frame].push(props);
				}
			}		
		}
		
		private function initUI():void
		{
			this.ui = new ThemeUI();
			this.addChild(this.ui);
			
			this.componentList = new TList(new TListUI(ui.mc_list),null,TList.HORIZONTAL);
			
			componentList.addEventListener(ListItemEvent.ITEM_CLICK, this.onWidgetSelect);
			componentList.setCellType(WidgetItem);
			componentList.setCellWidth(200);
			componentList.setCellHeight(200);
			
			componentList.items = movieConfig.config.frames;
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