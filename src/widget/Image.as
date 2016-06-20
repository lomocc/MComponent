package widget
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	import widget.interfaces.IImage;
	
	dynamic public class Image extends Widget implements IImage
	{
		//		protected var container:Sprite;
		protected var loader:Loader;
		//		private var _mask:Sprite;
		public function Image()
		{
			super();
		}
		override protected function createChildren():void
		{
			super.createChildren();
			
			//			this.container = new Sprite();
			
			this.loader = new Loader();
			this.addChild(this.loader);
			
			//			this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.onLoaderInit);
			
			
			//			this.addChild(this.container);
			
			//			this._mask = new Sprite();
			//			this.addChild(this._mask);
		}
		//		protected function onLoaderInit(event:Event):void{
		//			this.container.x = (this.startWidth - this.loader.width)/2;
		//			this.container.y = (this.startHeight - this.loader.height)/2;
		//		}
		
		protected var _url:String = "images/content.png";
		[Inspectable(type="String", defaultValue="images/content.png", name="url（图片地址）")]
		public function get url():String {
			return _url;
		}
		
		public function set url(value:String):void {
			_url = value;
			this.invalidate();
			
		}
		
		//		protected function updateMask():void
		//		{
		//			this._mask.graphics.clear();
		//			this._mask.graphics.beginFill(0xf8f8f8);
		//			this._mask.graphics.drawRect(0,0, startWidth, startHeight);
		//			this._mask.graphics.endFill();
		//		}
		override protected function render():void {
			if(this.url){
				this.loader.load(new URLRequest(this.url));
				//				this.loader.mask = this._mask;
			}else{
				//				this.loader.mask = null;
			}
			//			this.updateMask();
		}
		override public function toConfig():Object{
			var config:Object = super.toConfig();
			config.url = this.url;
			return config;
		}
		override public function fromConfig(config:Object):void
		{
			url = config.url;
		}
	}
}