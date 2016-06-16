package app.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import app.utils.DisplayUtil;
	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * 滑动条 
	 */	
	public class TSlider extends TComponent
	{
		protected var _dragging:Boolean = false;
		protected var _handle:Sprite;
		protected var _back:Sprite;
		protected var _backClick:Boolean = true;
		protected var _value:Number = Number.MIN_VALUE;
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		protected var _orientation:String;
		protected var _tick:Number = 0.01;
		
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		protected var ui:TSliderUI;
		protected var _enabled:Boolean =true;
		
		/**
		 * Constructor
		 * @param orientation Whether the slider will be horizontal or vertical.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function TSlider(ui:TSliderUI, orientation:String = TSlider.HORIZONTAL, defaultHandler:Function = null)
		{
			_orientation = orientation;
			this.ui=ui;
			super(ui);
			if(defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
			
		}
		public function get dragging():Boolean
		{
			return this._dragging;
		}
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();

			/*if(_orientation == HORIZONTAL)
			{
				setSize(100, 10);
			}
			else
			{
				setSize(10, 100);
			}*/
			
			setSize(ui.back.width,ui.back.height);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_back = ui.back;
			//_back.filters = [getShadow(2, true)];
			
			_handle = ui.handle;
			//_handle.filters = [getShadow(1)];
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			_handle.buttonMode = true;
			_handle.useHandCursor = true;
		}
		
		/**
		 * Draws the back of the slider.
		 */
		protected function drawBack():void
		{
			/*_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.graphics.endFill();*/

			if(_backClick)
			{
				_back.addEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
			else
			{
				_back.removeEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
		}
		
		/**
		 * Draws the handle of the slider.
		 */
		protected function drawHandle():void
		{	
			positionHandle();
		}
		
		/**
		 * Adjusts value to be within minimum and maximum.
		 */
		protected function correctValue():void
		{
			if(_max > _min)
			{
				//_value = Math.min(_value, _max);
				//_value = Math.max(_value, _min);
				_value = clamp(_value,_min,_max);
			}
			else
			{
				//_value = Math.max(_value, _max);
				//_value = Math.min(_value, _min);
				_value = clamp(_value,_max,_min);
			}
		}
		
		/**
		 * Adjusts position of handle when value, maximum or minimum have changed.
		 * TODO: Should also be called when slider is resized.
		 */
		protected function positionHandle():void
		{
			var range:Number;
			if(_orientation == HORIZONTAL)
			{
				range = _width - _handle.width;
				_handle.x = (_value - _min) / (_max - _min) * range>>0;
			}
			else
			{
				range = _height - _handle.height;
				_handle.y = (_value - _min) / (_max - _min) * range>>0;
			}
		}
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function redraw():void
		{
			super.redraw();
			drawBack();
			drawHandle();
		}
		
		/**
		 * Convenience method to set the three main parameters in one shot.
		 * @param min The minimum value of the slider.
		 * @param max The maximum value of the slider.
		 * @param value The value of the slider.
		 */
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			this.minimum = min;
			this.maximum = max;
			this.value = value;
		}
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Handler called when user clicks the background of the slider, causing the handle to move to that point. Only active if backClick is true.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onBackClick(event:MouseEvent):void
		{
			if(_orientation == HORIZONTAL)
			{
				_handle.x = mouseX - _handle.width / 2;
				_handle.x = Math.max(_handle.x, 0);
				_handle.x = Math.min(_handle.x, _width - _handle.width);
				_value = _handle.x / (_width - _handle.width) * (_max - _min) + _min;
			}
			else
			{
				_handle.y = mouseY - _handle.height / 2;
				_handle.y = Math.max(_handle.y, 0);
				_handle.y = Math.min(_handle.y, _height - _handle.height);
				_value = _handle.y / (_height - _handle.height) * (_max - _min) + _min;
			}
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		/**
		 * Internal mouseDown handler. Starts dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDrag(event:MouseEvent):void
		{
			this._dragging = true;
			DisplayUtil.getStage().addEventListener(MouseEvent.MOUSE_UP, onDrop);
			DisplayUtil.getStage().addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			if(_orientation == HORIZONTAL)
			{
				_handle.startDrag(false, new Rectangle(0, 0, _width - _handle.width, 0));
			}
			else
			{
				_handle.startDrag(false, new Rectangle(0, 0, 0, _height - _handle.height));
			}
		}
		
		
		/**
		 * Internal mouseUp handler. Stops dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDrop(event:MouseEvent):void
		{
			DisplayUtil.getStage().removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			DisplayUtil.getStage().removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			stopDrag();
			this._dragging = false;
		}
		
		
		/**
		 * Internal mouseMove handler for when the handle is being moved.
		 * @param event The MouseEvent passed by the system.
		 */
		protected  function onSlide(event:MouseEvent):void
		{
			
			var oldValue:Number = _value;
			if(_orientation == HORIZONTAL)
			{
				if(_width == _handle.width)
				{
					_value = _min;
				}
				else
				{
					_value = _handle.x / (_width - _handle.width) * (_max - _min) + _min;
				}
			}
			else
			{
				if(_height == _handle.height)
				{
					_value = _min;
				}
				else
				{
					_value = _handle.y / (_height - _handle.height) * (_max - _min) + _min;
				}
			}
			if(_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets whether or not a click on the background of the slider will move the handler to that position.
		 */
		public function set backClick(b:Boolean):void
		{
			_backClick = b;
			invalidate();
		}
		public function get backClick():Boolean
		{
			return _backClick;
		}
		
		public function set enabled(value:Boolean):void{
			_enabled=value;
			//_handle.visible=value;
			mouseChildren=value;
			mouseEnabled=value;
		}
		
		
		/**
		 * Sets / gets the current value of this slider.
		 */
		public function set value(v:Number):void
		{
			if(_value ==v || this._dragging) return;
			_value = v;
			correctValue();
			positionHandle();
//			if(!_enabled) return;
//			dispatchEvent(new Event(Event.CHANGE));
			
		}
		public function get value():Number
		{
			return Math.round(_value / _tick) * _tick;
		}

        /**
         * Gets the value of the slider without rounding it per the tick value.
         */
        public function get rawValue():Number
        {
            return _value;
        }
		
		/**
		 * Gets / sets the maximum value of this slider.
		 */
		public function set maximum(m:Number):void
		{
			_max = m;
			correctValue();
			positionHandle();
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
			_min = m;
			correctValue();
			positionHandle();
		}
		public function get minimum():Number
		{
			return _min;
		}
		
		/**
		 * Gets / sets the tick value of this slider. This round the value to the nearest multiple of this number. 
		 */
		public function set tick(t:Number):void
		{
			_tick = t;
		}
		public function get tick():Number
		{
			return _tick;
		}
		public static function clamp(v:Number, min:Number = 0, max:Number = 1):Number
		{
			if(v < min) return min;
			if(v > max) return max;
			return v;
		}
	}
}
