package com.throne.gui.components
{
	import com.throne.display.TSprite;
	import com.throne.gui.ui.TRangeUI;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	
	/**
	 * 输入一个区间 
	 * @author heven
	 * 
	 */	
	public class TRange extends TComponent
	{
		//protected var _value:Number = 0;
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		
		/**
		 * 区间最大值和最小值 
		 */		
		protected var _p_max:Number = 100;
		protected var _p_min:Number = 0;
		
		protected var ui:TRangeUI;
		
		protected var _tf_min:TextField;
		protected var _tf_max:TextField;
		
		public function TRange(ui:TRangeUI,_min:Number,_max:Number,defaultHandler:Function = null)
		{
			this.ui=ui;
			this._min=_min;
			this._max=_max;
			this._p_min=_min;
			this._p_max=_max;
			super(ui);
			
			maxChars=String(_max).length;
			if(defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
			
		}
		
		/**
		 * 设置最大位数 
		 * @param value
		 * 
		 */		
		public function set maxChars(value:int):void{
			_tf_max.maxChars = value;
			_tf_min.maxChars = value;
		}
		
		public function set restrict(value:String):void{
			_tf_min.restrict = value;
			_tf_max.restrict = value;
		}
		
		/**
		 * Creates and adds child display objects.
		 */
		override protected function addChildren():void
		{
			_tf_min = ui._tf_min;
			initTextFid(_tf_min);
			
			_tf_max = ui._tf_max;
			initTextFid(_tf_max);
			
		}
		
		protected function initTextFid(_t:TextField):void{
			_t.embedFonts = false;
			_t.selectable = true;
			_t.type = TextFieldType.INPUT;
			_t.restrict = "0-9.\\-";
			//_t.addEventListener(Event.CHANGE, onChange);
			_t.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
		}
		
		protected function onFocusOut(event:FocusEvent):void
		{
			switch(event.target){
				case _tf_min:
					minimum = parseFloat(_tf_min.text);
					break;
				case _tf_max:
					maximum = parseFloat(_tf_max.text);
					break;	
			}
		}		
		
		/*protected function onChange(event:Event):void
		{
			switch(event.target){
				case _tf_min:
					minimum = Number(_tf_min.text);
				break;
				case _tf_max:
					maximum = Number(_tf_max.text);
				break;	
			}
		}*/
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function redraw():void
		{
			super.redraw();
			_tf_min.text=String(minimum);
			_tf_max.text=String(maximum);
		}
		
		
		/**
		 * Gets / sets the maximum value of this slider.
		 */
		public function set maximum(m:Number):void
		{
			
			var _vmax:Number = m<minimum ? minimum : m;
			_vmax = _vmax>_p_max?_p_max:_vmax;
			
			//invalidate();
			
			if(_max==_vmax){
				redraw();
				return;
			}
			_max=_vmax;
			redraw();
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		
		public function get maximum():Number
		{
			return _max;
		}
		
		/**
		 * Gets / sets the minimum value of this slider.
		 */
		public function set minimum(m:Number):void
		{
			var _vmin:Number = m>maximum ? maximum : m;
			_vmin = _vmin<_p_min?_p_min:_vmin;
			//invalidate();
		
			if(_min==_vmin){
				redraw();
				return;
			}
			
			_min=_vmin;
			redraw();
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		public function get minimum():Number
		{
			return _min;
		}
		
		
		/**
		 * 获取一个数字是否在范围之内  
		 * @param m 输入一个数字
		 * @return  返回一个布尔
		 * 
		 */		
		public function isInRange(m:Number):Boolean{
			return m>=_min && m<=_max;
		}
		
	}
}