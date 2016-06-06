package mcomponents
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	dynamic public class MImage extends MComponent
	{
		private var _mask:Sprite = new Sprite();
		public function MImage()
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
			trace("updateMask Image",startWidth, startHeight);
			this._mask.graphics.clear();
			this._mask.graphics.beginFill(0xf8f8f8);
			this._mask.graphics.drawRect(0,0, startWidth, startHeight);
			this._mask.graphics.endFill();
		}
		override protected function render():void {
			trace("render", this.url);
			if(this.url){
				trace("load", true, this.url);
				this.loader.load(new URLRequest(this.url));
				this.loader.mask = this._mask;
			}else{
				trace("load", false);
				this.loader.mask = null;
			}
			this.updateMask();
		}
	}
}