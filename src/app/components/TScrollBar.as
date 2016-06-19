/**
 * ScrollBar.as
 * Keith Peters
 * version 0.9.9
 * 
 * Base class for HScrollBar and VScrollBar
 * 
 * Copyright (c) 2011 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package app.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import app.utils.DisplayUtil;

	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * 滚动条 
	 * @author heven
	 * 
	 */	
	public class TScrollBar extends TComponent
	{
		protected const DELAY_TIME:int = 500;
		protected const REPEAT_TIME:int = 100; 
		protected const UP:String = "up";
		protected const DOWN:String = "down";

        protected var _autoHide:Boolean = false;
		protected var _upButton:TButton;
		protected var _downButton:TButton;
		protected var _scrollSlider:ScrollSlider;
		protected var _orientation:String;
		protected var _lineSize:int = 1;
		protected var _delayTimer:Timer;
		protected var _repeatTimer:Timer;
		protected var _direction:String;
		protected var _shouldRepeat:Boolean = false;
		
		
		protected var ui:TScrollBarUI;
		
		
		public static function get HORIZONTAL():String{ return TSlider.HORIZONTAL };
		public static function get VERTICAL():String { return TSlider.VERTICAL };
		
		/**
		 * Constructor
		 * @param orientation Whether this is a vertical or horizontal slider.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function TScrollBar(ui:TScrollBarUI,orientation:String=TSlider.VERTICAL, defaultHandler:Function = null)
		{
			_orientation = orientation;
			this.ui=ui;
			super(ui);
			
			if(defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
			
		}
		
		
		/**
		 * Called when the mouse wheel is scrolled over the component.
		 */
		protected function onMouseWheel(event:MouseEvent):void
		{
			event.preventDefault();
			event.stopImmediatePropagation();
			if(event.delta>0){
				value -= lineSize;
			}
			else if(event.delta<0)
			{
				value -= -lineSize;
			}
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_scrollSlider = new ScrollSlider(ui,_orientation, onChange);
			createUpButton();
			_upButton.addEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
		
			
			createDownButton();
			_downButton.addEventListener(MouseEvent.MOUSE_DOWN, onDownClick);
			
			mouseWheel=true;
		}
		
		protected function createDownButton():void
		{
			_downButton = new TButton(ui.downButton);
		}
		
		protected function createUpButton():void
		{
			_upButton = new TButton(ui.upButton);
			
		}		
		
		/**
		 * Initializes the component.
		 */
		protected override function init():void
		{
			super.init();
			setSize(ui.back.width,ui.back.height);
			_delayTimer = new Timer(DELAY_TIME, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer = new Timer(REPEAT_TIME);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
		}
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Convenience method to set the three main parameters in one shot.
		 * @param min The minimum value of the slider.
		 * @param max The maximum value of the slider.
		 * @param value The value of the slider.
		 */
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			_scrollSlider.setSliderParams(min, max, value);
		}
		
		/**
		 * Sets the percentage of the size of the thumb button.
		 */
		public function setThumbPercent(value:Number):void
		{
			_scrollSlider.setThumbPercent(value);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function redraw():void
		{
			super.redraw();
		
			_scrollSlider.redraw();
			
			if(_scrollSlider.thumbPercent < 1.0){
				visible = true;
				enabled = true;
			}else{
				visible = !_autoHide;
				enabled = false;
			}
			
			updateButtonState();
		}

		
		public function set enabled(value:Boolean):void{
			_scrollSlider.enabled=value;
			
			mouseChildren=value;
			mouseEnabled=value;
			_upButton.enable=value;
			_downButton.enable=value;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

        /**
         * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
         */
        public function set autoHide(value:Boolean):void
        {
            _autoHide = value;
            invalidate();
        }
        public function get autoHide():Boolean
        {
            return _autoHide;
        }

		/**
		 * Sets / gets the current value of this scroll bar.
		 */
		public function set value(v:Number):void
		{
			_scrollSlider.value = v;
			updateButtonState();
		}
		public function get value():Number
		{
			return _scrollSlider.value;
		}
		
		/**
		 * Sets / gets the minimum value of this scroll bar.
		 */
		public function set minimum(v:Number):void
		{
			_scrollSlider.minimum = v;
			updateButtonState();
		}
		public function get minimum():Number
		{
			return _scrollSlider.minimum;
		}
		
		/**
		 * Sets / gets the maximum value of this scroll bar.
		 */
		public function set maximum(v:Number):void
		{
			_scrollSlider.maximum = v;
			updateButtonState();
		}
		public function get maximum():Number
		{
			return _scrollSlider.maximum;
		}
		
		/**
		 * Sets / gets the amount the value will change when up or down buttons are pressed.
		 */
		public function set lineSize(value:int):void
		{
			_lineSize = value;
		}
		public function get lineSize():int
		{
			return _lineSize;
		}
		
		/**
		 * Sets / gets the amount the value will change when the back is clicked.
		 */
		public function set pageSize(value:int):void
		{
			_scrollSlider.pageSize = value;
			invalidate();
		}
		public function get pageSize():int
		{
			return _scrollSlider.pageSize;
		}
		

		
		public function set pos(value:Number):void
		{
			_scrollSlider.pos =value;
			updateButtonState();
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		protected function onUpClick(event:MouseEvent):void
		{
			goUp();
			_shouldRepeat = true;
			_direction = UP;
			_delayTimer.start();
			DisplayUtil.getStage().addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
				
		protected function goUp():void
		{
			_scrollSlider.value -= _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onDownClick(event:MouseEvent):void
		{
			goDown();
			_shouldRepeat = true;
			_direction = DOWN;
			_delayTimer.start();
			DisplayUtil.getStage().addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function goDown():void
		{
			_scrollSlider.value += _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onMouseGoUp(event:MouseEvent):void
		{
			_delayTimer.stop();
			_repeatTimer.stop();
			_shouldRepeat = false;
		}
		
		protected function onChange(event:Event):void
		{
			updateButtonState();
			dispatchEvent(event);
		}
		
		private function updateButtonState():void
		{
			_upButton.enable=value>minimum;
			_downButton.enable=value<maximum;
		}
		
		protected function onDelayComplete(event:TimerEvent):void
		{
			if(_shouldRepeat)
			{
				_repeatTimer.start();
			}
		}
		
		protected function onRepeat(event:TimerEvent):void
		{
			if(_direction == UP)
			{
				goUp();
			}
			else
			{
				goDown();
			}
		}
		

		public function set mouseWheel(b:Boolean):void
		{
			
			if(b){
				addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}else{
				removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			_upButton = null;
			_downButton = null;
			_scrollSlider = null;
			_delayTimer = null;
			_repeatTimer = null;
		}
	}
}



import com.greensock.TweenLite;

import flash.events.Event;
import flash.events.MouseEvent;

import app.components.TScrollBarUI;
import app.components.TSlider;


/**
 * Helper class for the slider portion of the scroll bar.
 */
class ScrollSlider extends TSlider
{
	protected var _thumbPercent:Number = 1.0;
	protected var _pageSize:int = 1;
	

	
	/**
	 * Constructor
	 * @param orientation Whether this is a vertical or horizontal slider.
	 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
	 */
	public function ScrollSlider(ui:TScrollBarUI, orientation:String=TSlider.VERTICAL, defaultHandler:Function = null)
	{
		super(ui,orientation);
		
		if(defaultHandler != null)
		{
			addEventListener(Event.CHANGE, defaultHandler);
		}
	}
	
	/**
	 * Initializes the component.
	 */
	protected override function init():void
	{
		super.init();
		setSliderParams(0, 1, 0);
		backClick = true;
	}

	/**
	 * Adjusts position of handle when value, maximum or minimum have changed.
	 * TODO: Should also be called when slider is resized.
	 */
	protected override function positionHandle():void
	{
		TweenPostion();
	}
	
	private function TweenPostion(dur:Number=0.3):void
	{
		var range:Number;
		if(_orientation == HORIZONTAL)
		{
			range = _width - _handle.width;
			TweenLite.to(_handle,dur,{x: (_value - _min) / (_max - _min) * range});
		}
		else
		{
			range = _height - _handle.height;
			TweenLite.to(_handle,dur,{y:(_value - _min) / (_max - _min) * range});
		}
	}
	
	public function set pos(value:Number):void
	{
		_value=value;
		correctValue();
		TweenPostion(0);
	}
	
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Sets the percentage of the size of the thumb button.
	 */
	public function setThumbPercent(value:Number):void
	{
		_thumbPercent = Math.min(value, 1.0);
		invalidate();
	}
	
	
	override protected function drawHandle():void
	{	
		if(_orientation == HORIZONTAL)
		{
			_handle.scaleX=_thumbPercent;
			_handle.scaleY=1;
		}
		else
		{
			_handle.scaleX=1;
			_handle.scaleY=_thumbPercent;
		}
		super.drawHandle();
	}
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Handler called when user clicks the background of the slider, causing the handle to move to that point. Only active if backClick is true.
	 * @param event The MouseEvent passed by the system.
	 */
	protected override function onBackClick(event:MouseEvent):void
	{
		if(_orientation == HORIZONTAL)
		{
			if(mouseX < _handle.x)
			{
				if(_max > _min)
				{
					_value -= _pageSize;
				}
				else
				{
					_value += _pageSize;
				}
				correctValue();
			}
			else
			{
				if(_max > _min)
				{
					_value += _pageSize;
				}
				else
				{
					_value -= _pageSize;
				}
				correctValue();
			}
			positionHandle();
		}
		else
		{
			if(mouseY < _handle.y)
			{
				if(_max > _min)
				{
					_value -= _pageSize;
				}
				else
				{
					_value += _pageSize;
				}
				correctValue();
			}
			else
			{
				if(_max > _min)
				{
					_value += _pageSize;
				}
				else
				{
					_value -= _pageSize;
				}
				correctValue();
			}
			positionHandle();
		}
		dispatchEvent(new Event(Event.CHANGE));
		
	}
	
	/**
	 * Internal mouseDown handler. Starts dragging the handle.
	 * @param event The MouseEvent passed by the system.
	 */
	protected override function onDrag(event:MouseEvent):void
	{
		super.onDrag(event);
		TweenLite.killTweensOf(_handle);
	}
	
	protected override function onDrop(event:MouseEvent):void
	{
		super.onDrop(event);
		value=int(value+0.5);
	}
	
	
	
	
	public override function set enabled(value:Boolean):void{
		_enabled=value;
		_handle.visible=value;
		mouseChildren=value;
		mouseEnabled=value;
	}
	
	
	
	///////////////////////////////////
	// getter/setters
	///////////////////////////////////
		
	/**
	 * Sets / gets the amount the value will change when the back is clicked.
	 */
	public function set pageSize(value:int):void
	{
		_pageSize = value;
		invalidate();
	}
	public function get pageSize():int
	{
		return _pageSize;
	}

    public function get thumbPercent():Number
    {
        return _thumbPercent;
    }
}
