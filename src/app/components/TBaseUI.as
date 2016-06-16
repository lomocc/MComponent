package app.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class TBaseUI
	{

		protected var _mc:DisplayObjectContainer;
		
		public function TBaseUI(ui:DisplayObjectContainer=null)
		{
			this._mc=ui|| new Sprite;			
		}


		public function get y():Number
		{
			return _mc.y;
		}

		public function set y(value:Number):void
		{
			_mc.y = value;
		}

		public function get x():Number
		{
			return _mc.x;
		}

		public function set x(value:Number):void
		{
			_mc.x = value;
		}

		public function get parent():DisplayObjectContainer
		{
			return _mc.parent;
		}
		
		public function get name():String
		{
			return _mc.name;
		}
		
		public function get childIndex():int
		{
			if(parent) return parent.getChildIndex(_mc);
			return 0;
		}
		
		public function get view():DisplayObjectContainer
		{
			return _mc;
		}
		
		public function addChild(child:DisplayObject):DisplayObject
		{
			return _mc.addChild(child);
		}
	}
}