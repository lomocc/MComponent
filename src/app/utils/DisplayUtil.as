package app.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import app.interfaces.IDisposable;

	public class DisplayUtil
	{
		private static var stage:Stage;
		
		public static function initStage(stage:Stage):void{
			DisplayUtil.stage = stage;
		}
		
		public static function getStage():Stage{
			return stage;
		}
		
		/**
		 * 删除所有子元件 
		 * @param tar 操作对象
		 * @param disposeChild 是否尝试调用dispose 如果不能被销毁 会进行递归删除子子子子元件
		 * @param recursive 是否递归删除子子子子元件
		 * @param stopMc 子元件如果是mc 会被stop
		 */		
		public static function removeAllChildren(tar:DisplayObjectContainer,disposeChild:Boolean=false,recursive:Boolean=false,stopMc:Boolean = true):void{
			while(tar.numChildren){
				var temp:DisplayObject=tar.getChildAt(0);
				if(recursive && (temp is DisplayObjectContainer) && !(temp is IDisposable)) removeAllChildren(temp as DisplayObjectContainer,disposeChild,recursive);
				if(disposeChild && (temp is IDisposable)) (temp as IDisposable).dispose();
				if(stopMc && temp is MovieClip) (temp as MovieClip).stop();
				if(temp.parent) temp.parent.removeChild(temp);
			}
		}
		
		public static function removeFromContainer(child:DisplayObject):void
		{
			if(child && child.parent) child.parent.removeChild(child);
		}
		public static function wrap(source:DisplayObject):Sprite
		{
			if (!source)
			{
				return null;
			}
			var s:Sprite = new Sprite;
			s.x=source.x;
			s.y=source.y;
			source.x = 0;
			source.y = 0;
			if(source.parent)
			{
				var index:int = source.parent.getChildIndex(source);
				source.parent.addChildAt(s,index);
			}
			s.addChild(source);
			return s;
		}
		/**
		 * Returns whether or not the ancestor is the child's ancestor.
		 * @return whether or not the ancestor is the child's ancestor.
		 */
		public static function isAncestorDisplayObject(ancestor:DisplayObjectContainer, child:DisplayObject):Boolean{
			if(ancestor == null || child == null) 
				return false;
			
			var pa:DisplayObjectContainer = child.parent;
			while(pa != null){
				if(pa == ancestor){
					return true;
				}
				pa = pa.parent;
			}
			return false;
		}
		/**
		 * 创建层
		 * @param width 宽度
		 * @param height 高度
		 * @param bgColor 背景色
		 * @param alpha 透明度
		 * @return
		 *
		 */
		public static function createSprite(width:int, height:int, bgColor:uint = 0xFFFFFF, alpha:Number = 1):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(bgColor, alpha);
			sp.graphics.drawRect(0, 0, width, height);
			sp.graphics.endFill();
			return sp;
		}

	}
}