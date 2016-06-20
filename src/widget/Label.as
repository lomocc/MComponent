package widget
{
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
		protected var _textColor:uint = 0;
		[Inspectable(format="Color", type="Color", defaultValue=0x000000, name="textColor（文本颜色）")]
		public function get textColor():uint {
			return _textColor;
		}
		public function set textColor(value:uint):void {
			_textColor = value;
			
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
		protected var _fontSize:uint = 12;
		[Inspectable(type="Number", defaultValue=12, name="fontSize（字体大小）")]
		public function get fontSize():Number {
			return _fontSize;
		}
		public function set fontSize(value:Number):void {
			_fontSize = value;
			
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
			trace("this.text",this.text);
			this._tf.text = this.text || "";
			var textFormat:TextFormat = new TextFormat(this.font, this.fontSize, this.textColor);
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
		override public function toConfig():Object{
			var config:Object = super.toConfig();
			config.text = this.text;
			config.textColor = this.textColor;
			config.font = this.font;
			config.fontSize = this.fontSize;
			return config;
		}
		override public function fromConfig(config:Object):void
		{
			super.fromConfig(config);
			text = config.text;
			textColor = config.textColor;
			font = config.font;
			fontSize = config.fontSize;
		}
		//		protected function onFontLoaded(event:Event):void
		//		{
		//			var size:uint = this.contentScale * 12;
		//			this._tf.setTextFormat(new TextFormat(this.font, size, this.color));
		//		}
	}
}