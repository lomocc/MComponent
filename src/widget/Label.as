package widget
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import widget.interfaces.ILabel;
	
	public class Label extends Widget implements ILabel
	{
		//		private var serverURL:String = "images/font.swf";
		
		private var _tf:TextField;
		
		public function Label()
		{
			super();
		}
		override protected function createChildren():void
		{
			super.createChildren();
			
			this._tf = new TextField();
			this._tf.autoSize = "left";
			this.addChild(this._tf);
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
		protected var _color:uint = 0;
		[Inspectable(format="Color", type="Color", defaultValue=0x000000, name="color（文本颜色）")]
		public function get color():uint {
			return _color;
		}
		public function set color(value:uint):void {
			_color = value;
			
			this.invalidate();
		}
		//		protected function formatString(format:String, ...args):String{
		//			for(var i:int=0; i < args.length; i++){
		//				format = format.replace(new RegExp('\\{'+i+'\\}', "g"), args[i]);
		//			}
		//			return format;
		//		}
		override protected function render():void {
			//			if(this.text){
			//				var url:String = this.serverURL;//formatString("{0}?text={1}&font={2}", this.serverURL, this.text, this.font);
			//				this.loader.load(new URLRequest(url));
			//				this.loader.mask = this._mask;
			
			this._tf.text = this.text;
			
			var size:uint = this.scale * 12;
			var textFormat:TextFormat = new TextFormat(this.font, size, this.color);
			this._tf.setTextFormat(textFormat);
			//				var url:String = 'images/myboldfont.swf';
			//				var fontLoader:FontLoader = new FontLoader( new URLRequest( url ) );
			//				fontLoader.addEventListener( Event.COMPLETE, onFontLoaded );
			//				this._tf.mask = this._mask;
			//			}else{
			////				this.loader.mask = null;
			//			}
			//			this.updateMask();
		}
		
		protected function onFontLoaded(event:Event):void
		{
			var size:uint = this.scale * 12;
			this._tf.setTextFormat(new TextFormat(this.font, size, this.color));
		}
	}
}