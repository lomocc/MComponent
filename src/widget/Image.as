package widget
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	import widget.interfaces.IImage;
	
	dynamic public class Image extends Widget implements IImage
	{
		private var _mask:Sprite = new Sprite();
		public function Image()
		{
			super();
		}
		override protected function createChildren():void
		{
			this.addChild(this._mask);
			super.createChildren();
		}
		
		protected var _url:String = "images/content.png";
		[Inspectable(type="String", defaultValue="images/content.png", name="url（图片地址）")]
		public function get url():String {
			return _url;
		}
		
		public function set url(value:String):void {
			_url = value;
			this.invalidate();
			
		}
		
		protected function updateMask():void
		{
			this._mask.graphics.clear();
			this._mask.graphics.beginFill(0xf8f8f8);
			this._mask.graphics.drawRect(0,0, startWidth, startHeight);
			this._mask.graphics.endFill();
		}
		override protected function render():void {
			if(this.url){
				this.loader.load(new URLRequest(this.url));
				this.loader.mask = this._mask;
			}else{
				this.loader.mask = null;
			}
			this.updateMask();
		}
	}
}