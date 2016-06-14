package
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
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
	
	import utils.MovieClipWrapper;
	import component.base.display.TSprite;
	import component.buttons.CommonButton;
	import component.buttons.CommonToggleButton;
	import component.utils.DisplayUtil;
	
	import widget.interfaces.IImage;
	import widget.interfaces.ILabel;
	import widget.interfaces.IWidget;
	
	[SWF(width="800", height="600")]
	public class Main extends Sprite
	{
		public var ui:ThemeUI = new ThemeUI();
		
		public var frameRate:uint = 24;
		
		public var containerWidth:uint = 800;
		public var containerHeight:uint = 500;
		
		public var componentHeight:uint = 50;
		
		public var movieWidth:uint = 550;
		public var movieHeight:uint = 400;
		
		public var toolPadding:uint = 10;
		
		private var componentList:Sprite;
		
		private var playBtn:CommonToggleButton;
		private var timeStampField:TextField;
		
		private var movieContainer:Sprite;
		private var toolContainer:Sprite;
		
		private var movieLoader:Loader;
		private var movieClipWrapper:MovieClipWrapper;
		
		private var mComponentMap:Dictionary = new Dictionary();
		
		private var mapConfig:Array = [{"scale":1,"url":"images/content.png","frame":1,"type":"widget::Image","contentX":0,"contentY":0},{"scale":1,"url":"images/content.png","frame":1,"type":"widget::Image","contentX":0,"contentY":0},{"scale":0.1,"url":"images/QQ123.png","frame":1,"type":"widget::Image","contentX":0,"contentY":0},{"scale":1,"url":"images/content.png","frame":1,"type":"widget::Image","contentX":0,"contentY":0},{"scale":1,"frame":955,"text":"请输入文字","type":"widget::Label","contentX":0,"font":"微软雅黑","contentY":0},{"scale":1,"url":"images/content.png","frame":955,"type":"widget::Image","contentX":0,"contentY":0},{"scale":1,"frame":1402,"text":"请输入文字","type":"widget::Label","contentX":0,"font":"微软雅黑","contentY":0},{"scale":1,"url":"images/content.png","frame":1402,"type":"widget::Image","contentX":0,"contentY":0}];

//			[{"scale":1,"url":"images/scene.jpg","contentX":0,"type":"widget::Image","frame":1,"contentY":0},{"scale":1,"url":"images/scene.jpg","contentX":0,"type":"widget::Image","frame":1,"contentY":0},{"scale":0.1,"url":"images/QQ123.png","contentX":0,"type":"widget::Image","frame":1,"contentY":0},{"scale":1,"url":"images/scene.jpg","contentX":0,"type":"widget::Image","frame":1,"contentY":0},{"scale":1,"contentX":0,"type":"widget::Label","text":"请输入文字","font":"微软雅黑","frame":955,"contentY":0},{"scale":1,"url":"images/scene.jpg","contentX":0,"type":"widget::Image","frame":955,"contentY":0},{"scale":1,"contentX":0,"type":"widget::Label","text":"请输入文字","font":"微软雅黑","frame":1402,"contentY":0},{"scale":1,"url":"images/scene.jpg","contentX":0,"type":"widget::Image","frame":1402,"contentY":0}];
		private var framesConfig:Object;
		public function Main()
		{
			DisplayUtil.initStage(stage);
			stage.frameRate = frameRate;
			initFrames();
			initContainer();
			initUI();
			initMovie();
		}
		private function initFrames():void
		{
			framesConfig = {};
			for (var i:int = 0, l:int = mapConfig.length; i < l; i++) 
			{
				var props:* = mapConfig[i];
				if(!framesConfig[props.frame]){
					framesConfig[props.frame] = [props];
				}else{
					framesConfig[props.frame].push(props);
				}
			}		
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
			this.movieContainer.y = this.componentHeight;
			this.addChild(this.movieContainer);
			
			this.componentList = new Sprite();
			this.addChild(this.componentList);
			
			this.toolContainer = new Sprite();
			this.toolContainer.y = this.componentHeight + this.containerHeight;
			this.addChild(this.toolContainer);
		}
		
		private function initUI():void
		{
			for (var i:int = 0; i < this.mapConfig.length; i++) 
			{
				var obj:Object = this.mapConfig[i];
				var btn:TSprite = new TSprite();
//				btn.label = obj.type + i;
				btn.addEventListener(MouseEvent.CLICK, this.onComponentClick);
				btn.x = 80 * i;
//				btn.putClientProperty(obj);
				this.componentList.addChild(btn);
			}
			
//			this.playBtn = new PlayButton();
//			this.playBtn.addEventListener(Event.CHANGE, this.onTogglBbtnChange);
//			this.playBtn.x = 10;
//			//			this.playBtn.y = 410;
//			this.playBtn.label = "播放";
//			this.addToolChild(this.playBtn);
			
			this.timeStampField = new TextField();
			this.timeStampField.autoSize = "left";
			this.timeStampField.textColor = 0xffffff;
			this.timeStampField.defaultTextFormat = new TextFormat(null, 30);
			//			this.timeStampField.y = 410;
			this.addToolChild(this.timeStampField);
			
			this.ui = new ThemeUI();
			this.addChild(this.ui);
			new CommonButton(this.ui.btn_test, "播放");
			this.playBtn = new CommonToggleButton(this.ui.btn_toggle, "toggle", this.onTogglBbtnChange)
		}
		
		protected function onComponentClick(event:MouseEvent):void
		{
//			this.playBtn.toggled = false;
//			var btn:Button = event.currentTarget as Button;
//			var obj:Object = btn.getClientProperty();
//			
//			var movie:MovieClip = this.movieLoader.content as MovieClip;
//			movie.gotoAndStop(obj.frame);
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
			this.movieLoader.x = this.containerWidth - this.movieWidth >> 1;
			this.movieLoader.y = this.containerHeight - this.movieHeight >> 1;
			this.movieLoader.contentLoaderInfo.addEventListener(Event.INIT, this.onMovieLoadInit);
			this.movieLoader.load(new URLRequest(mivieURL));
			this.addMovieChild(this.movieLoader);
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
				trace("onMovieFrameConstructed", currentFrame);
				this.timeStampField.text = formatString("{0}/{1}", toTimeString(this.movieClipWrapper.currentTime), toTimeString(this.movieClipWrapper.totalTime));
				this.timeStampField.x = this.containerWidth - this.toolPadding - this.timeStampField.width;
				
				if(framesConfig[currentFrame]){
					loop(this.movieClipWrapper.movieClip, framesConfig[currentFrame].concat())
				}
			}
		}
		private function loop(node:DisplayObject, widgets:Array):void{
			if(node is IWidget){
				if(!mComponentMap[node]){
					mComponentMap[node] = true;
					
					var props:Object = widgets.shift();
					//					var props:Object = {frame:this.currentFrame, type:getQualifiedClassName(node)};
					//					props.contentX = (node as IWidget).contentX;
					//					props.contentY = (node as IWidget).contentY;
					//					props.scale = (node as IWidget).scale;
					
					if(node is IImage)
					{
						if((node as IImage).url != props.url){
							trace(node);
						}
						(node as IImage).url = props.url;
					}else if(node is ILabel){
						(node as ILabel).text = props.text;
						(node as ILabel).font = props.font;
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
		
		
		protected function onTogglBbtnChange():void
		{
			var movie:MovieClip = this.movieLoader.content as MovieClip;
			if(this.playBtn.selected){
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