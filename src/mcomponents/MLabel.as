package mcomponents
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	public class MLabel extends MComponent
	{
		private var serverURL:String = "images/font.swf";
		private var _mask:Sprite = new Sprite();
		
		public function MLabel()
		{
			super();
		}
		override protected function createChildren():void
		{
			this.addChild(this._mask);
			super.createChildren();
		}
		
		protected var _text:String = "请输入文字";
		[Inspectable(type="String", defaultValue="请输入文字", name="text（文本内容）")]
		public function get text():String {
			return _text;
		}
		public function set text(value:String):void {
			_text = value;
			
			this.invalidate();
		}
		protected var _font:String = "微软雅黑";
		[Inspectable(type="Font Name", defaultValue="微软雅黑", name="font（字体）")]
		public function get font():String {
			return _font;
		}
		public function set font(value:String):void {
			_font = value;
			
			this.invalidate();
		}
		protected function updateMask():void
		{
			trace("updateMask Label", startWidth, startHeight);
			this._mask.graphics.clear();
			this._mask.graphics.beginFill(0xf8f8f8);
			this._mask.graphics.drawRect(0,0, startWidth, startHeight);
			this._mask.graphics.endFill();
		}
		protected function formatString(format:String, ...args):String{
			for(var i:int=0; i < args.length; i++){
				format = format.replace(new RegExp('\\{'+i+'\\}', "g"), args[i]);
			}
			return format;
		}
		override protected function render():void {
			if(this.text){
				var url:String = this.serverURL;//formatString("{0}?text={1}&font={2}", this.serverURL, this.text, this.font);
				trace("load font _font", true, url, _font);
				this.loader.load(new URLRequest(url));
				this.loader.mask = this._mask;
				
			}else{
				trace("load", false);
				this.loader.mask = null;
			}
			this.updateMask();
		}
	}
}