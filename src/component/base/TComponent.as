package component.base
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import component.base.display.TSprite;
	import component.base.ui.TBaseUI;
	import component.events.ClickCountEvent;
	import component.events.DragAndDropEvent;
	import component.utils.DisplayUtil;
	import component.utils.IntPoint;
	import component.utils.SourceData;
	
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	
	[Event(name="clickCount", type="com.throne.gui.events.ClickCountEvent")]
	
	
	[Event(name="dragRecognized", type="com.throne.gui.events.DragAndDropEvent")]
	
	
	[Event(name="dragEnter", type="com.throne.gui.events.DragAndDropEvent")]
	
	
	[Event(name="dragExit", type="com.throne.gui.events.DragAndDropEvent")]
	
	
	[Event(name="dragDrop", type="com.throne.gui.events.DragAndDropEvent")]
	
	
	[Event(name="dragOverring", type="com.throne.gui.events.DragAndDropEvent")]


	public class TComponent extends TSprite{
		/**
		 * The max interval time to judge whether click was continuously.
		 */
		private static var MAX_CLICK_INTERVAL:int = 400;
	
		
	
		protected var drawTransparentTrigger:Boolean = true;
		
		public var _width:Number = 0;
		public var _height:Number = 0;
		
		private var enabled:Boolean;
		private var dragEnabled:Boolean;
		private var dropTrigger:Boolean;
		private var dragAcceptableInitiator:Dictionary;
		private var dragAcceptableInitiatorAppraiser:Function;
		
		
		private var invalidated:Boolean=false;
		
		//protected var uiContainer:TBaseUI;
		
		
		public function TComponent(ui:TBaseUI=null)
		{
			super(null);
			
			if(ui)
			{
				this.x=ui.x;
				this.y=ui.y;
				ui.x = 0;
				ui.y = 0;
				if(ui.parent)
				{
					var index:int = ui.childIndex;
					ui.parent.addChildAt(this,index);
				}
				addChild(ui.view);
			}
			
			enabled = true;
			
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDown);
			addEventListener(MouseEvent.CLICK, __mouseClick);
			init();
		}
		
		
		/**
		 * Initilizes the component.
		 */
		protected function init():void
		{
			addChildren();
			invalidate();
		}
		
		
		/**
		 * Overriden in subclasses to create child display objects.
		 */
		protected function addChildren():void
		{
			
		}
		
		
		/**
		 * Marks the component to be redrawn on the next frame.
		 */
		public function invalidate():void
		{
			
			if(invalidated) return;
			invalidated=true;
			//EnterFrameManager.getInstance().addTickedObject(this);
			addEventListener(Event.ENTER_FRAME,onTick);
		}
	
		private function onTick(event:Event):void{
			invalidated=false;
			removeEventListener(Event.ENTER_FRAME,onTick);
			redraw();
		}
		
		public function redraw():void
		{
			
		}
		
		
		public function isVisible():Boolean{
			return visible;
		}
			
		
	    /**
	     * Indicates the alpha transparency value of the component. 
	     * Valid values are 0 (fully transparent) to 1 (fully opaque).
	     * @param alpha the alpha for this component, between 0 and 1. default is 1.
	     */
	    public function setAlpha(alpha:Number):void{
	    	this.alpha = alpha;
	    }
	    
	    /**
	     * Returns the alpha of this component.
	     * @return the alpha of this component. default is 1.
	     */
	    public function getAlpha():Number{
	    	return alpha;
	    }
	    
	    /**
	     * Returns the coordinate of the mouse position, in pixels, in the component scope.
	     * @return the coordinate of the mouse position.
	     */
	    public function getMousePosition():IntPoint{
	    	return new IntPoint(mouseX, mouseY);
	    }
		
		
		/*override public function set x(value:Number):void
		{
			if(uiContainer){
				uiContainer.x=Math.round(value);
				return;
			}
			super.x = Math.round(value);
		}
		
		override public function set y(value:Number):void
		{
			if(uiContainer){
				uiContainer.y=Math.round(value);
				return;
			}
			super.y = Math.round(value);
		}
		
		
		override public function get x():Number{
			if(uiContainer){
				return uiContainer.x;
			}
			return super.x;
		}
		
		
		override public function get y():Number{
			if(uiContainer){
				return uiContainer.y;
			}
			return super.y;
		}*/
		
		
		
		/**
		 * Set the component's location in global coordinate. This method should only be called when the component 
		 * is on the display list.
		 * @param gp the global location.
		 * @see #setLocation()
		 * @see #localToGlobal()
		 * @see #MovieClip.globalToLocal()
		 */
		public function setGlobalLocation(gp:IntPoint):void{
			var newPos:Point = parent.globalToLocal(new Point(gp.x, gp.y));
			setLocationXY(newPos.x, newPos.y);
		}
		
		/**
		 * Set the component's location in global coordinate. This method should only be called when the component 
		 * is on the display list.
		 * @param x the global x location.
		 * @param y the global y location.
		 * @see #setLocation()
		 * @see #localToGlobal()
		 * @see #globalToLocal()
		 */
		public function setGlobalLocationXY(x:int, y:int):void{
			setGlobalLocation(new IntPoint(x, y));
		}
		

		
		/**
		 * Stores the global location value of this component into "return value" p and returns p. 
		 * If p is null a new Point object is allocated. 
		 * @param p the return value, modified to the component's global location.
		 * @see #getLocation()
		 * @see #setGlobalLocation()
		 * @see MovieClip.localToGlobal()
		 * @see MovieClip.globalToLocal()
		 */
		public function getGlobalLocation(rv:IntPoint=null):IntPoint{
			var gp:Point = localToGlobal(new Point(0, 0));
			if(rv != null){
				rv.setLocationXY(gp.x, gp.y);
				return rv;
			}else{
				return new IntPoint(gp.x, gp.y);
			}
		}
		
		public function globalToComponent(p:IntPoint):IntPoint{
			var np:Point = new Point(p.x, p.y);
			np = globalToLocal(np);
			return new IntPoint(np.x, np.y);
		}
		
		public function componentToGlobal(p:IntPoint):IntPoint{
			var np:Point = new Point(p.x, p.y);
			np = localToGlobal(np);
			return new IntPoint(np.x, np.y);
		}	
	

		
		/**
		 * Enable or disable the component.
		 * <p>
		 * If a component is disabled, it will not fire mouse events. 
		 * And some component will has different interface when enabled or disabled.
		 * @param b true to enable the component, false to disable it.
		 */
		public function setEnabled(b:Boolean):void{
			if(enabled != b){
				enabled = b;
				mouseEnabled = b;
			}
		}
		
		/**
		 * Returns whether the component is enabled.
		 * @see #setEnabled()
		 */
		public function isEnabled():Boolean{
			return enabled;
		}
		
	
	
		/**
		 * Sets whether this component can fire ON_DRAG_RECOGNIZED event.
		 * @see #ON_DRAG_RECOGNIZED 
		 * @see #isDragEnabled()
		 */
		public function setDragEnabled(b:Boolean):void{
			dragEnabled = b;
		}
		
		/**
		 * Returns whether this component can fire ON_DRAG_RECOGNIZED event. (Default value is false)
		 * @see #ON_DRAG_RECOGNIZED
		 * @see #setDragEnabled()
		 */
		public function isDragEnabled():Boolean{
			return dragEnabled;
		}
		
		/**
		 * Sets whether this component can trigger dragging component to fire drag events 
		 * when dragging over to this component.
		 * @param b true to make this component to be a trigger that trigger drag and drop 
		 * action to fire events, false not to do that things.
		 * @see #ON_DRAG_ENTER
		 * @see #ON_DRAG_OVER
		 * @see #ON_DRAG_EXIT
		 * @see #ON_DRAG_DROP
		 * @see #isDropTrigger()
		 */
		public function setDropTrigger(b:Boolean):void{
			dropTrigger = b;
		}
		
		/**
		 * Returns whether this component can trigger dragging component to fire drag events 
		 * when dragging over to this component.(Default value is false)
		 * @return true if this component is a trigger that can trigger drag and drop action to 
		 * fire events, false it is not.
		 * @see #ON_DRAG_ENTER
		 * @see #ON_DRAG_OVER
		 * @see #ON_DRAG_EXIT
		 * @see #ON_DRAG_DROP
		 * @see #setDropTrigger()
		 */
		public function isDropTrigger():Boolean{
			return dropTrigger;
		}
	
		/**
		 * Adds a component to be the acceptable drag initiator to this component.
		 * <p>
		 * It is not meanning that the DnD events will not be fired when the initiator 
		 * is dragging enter/over/exit/drop on this component.
		 * It is meanning that you can have a convenient way to proccess that events from 
		 * the method <code>isDragAcceptableInitiator</code> later, and the default dragging 
		 * image will take advantage to present a better picture when painting.
		 * </p>
		 * @param com the acceptable drag initiator
		 * @see #isDragAcceptableInitiator()
		 */
		public function addDragAcceptableInitiator(com:TComponent):void{
			if(dragAcceptableInitiator == null){
				dragAcceptableInitiator = new Dictionary(true);
			}
			dragAcceptableInitiator[com] = true;
		}
		
		/**
		 * Removes a component to be the acceptable drag initiator to this component.
		 * @param com the acceptable drag initiator
		 * @see #addDragAcceptableInitiator()
		 */
		public function removeDragAcceptableInitiator(com:TComponent):void{
			if(dragAcceptableInitiator != null){
				dragAcceptableInitiator[com] = undefined;
				delete dragAcceptableInitiator[com];
			}
		}
		
		/**
		 * Sets a function to judge whether a component is acceptable drag initiator.
		 * This function will be called to judge when <code>dragAcceptableInitiator</code> set 
		 * does not contains the component.
		 * @param the judge function func(initiator:Component):Boolean
		 */
		public function setDragAcceptableInitiatorAppraiser(func:Function):void{
			dragAcceptableInitiatorAppraiser = func;
		}
		
		/**
		 * Returns whether the component is acceptable drag initiator for this component.
		 * @param com the maybe acceptable drag initiator
		 * @return true if it is acceptable drag initiator, false not
		 */
		public function isDragAcceptableInitiator(com:TComponent):Boolean{
			if(dragAcceptableInitiator != null){
				return dragAcceptableInitiator[com] == true;
			}else{
				if(dragAcceptableInitiatorAppraiser != null){
					return dragAcceptableInitiatorAppraiser(com);
				}else{
					return false;
				}
			}
		}		
	
		

		
		
		/**
		 * Returns whether the component hit the mouse.
		 */
		public function hitTestMouse():Boolean{
			if(isOnStage()){
				return hitTestPoint(stage.mouseX, stage.mouseY, false);
			}else{
				return false;
			}
		}
	
	
		
		
		/**
		 * Returns the keyboard manager of this component's <code>JRootPane</code> ancestor.
		 * @return the keyboard manager, or null if no root pane ancestor.
		 */
		/*public function getKeyboardManager():KeyboardManager{
			var rootPane:JRootPane = getRootPaneAncestor();
			if(rootPane){
				return rootPane.getKeyboardManager();
			}
			return null;
		}*/
		
		private function fireDragRecognizedEvent(touchedChild:TComponent):void{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_RECOGNIZED, this, null, new IntPoint(stage.mouseX, stage.mouseY)));
		}
		
		/**
		 * @private
		 * Fires ON_DRAG_ENTER event.(Note, this method is only for DragManager use)
		 */
		public function fireDragEnterEvent(dragInitiator:TComponent, sourceData:SourceData, mousePos:IntPoint, relatedTarget:TComponent):void{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_ENTER, dragInitiator, sourceData, mousePos, this, relatedTarget));
		}
		/**
		 * @private
		 * Fires DRAG_OVERRING event.(Note, this method is only for DragManager use)
		 */
		public function fireDragOverringEvent(dragInitiator:TComponent, sourceData:SourceData, mousePos:IntPoint):void{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_OVERRING, dragInitiator, sourceData, mousePos, this));
		}
		/**
		 * @private
		 * Fires DRAG_EXIT event.(Note, this method is only for DragManager use)
		 */
		public function fireDragExitEvent(dragInitiator:TComponent, sourceData:SourceData, mousePos:IntPoint, relatedTarget:TComponent):void{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_EXIT, dragInitiator, sourceData, mousePos, this, relatedTarget));
		}
		/**
		 * @private
		 * Fires DRAG_DROP event.(Note, this method is only for DragManager use)
		 */
		public function fireDragDropEvent(dragInitiator:TComponent, sourceData:SourceData, mousePos:IntPoint):void{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_DROP, dragInitiator, sourceData, mousePos, this));
		}    
		
		//----------------------------------------------------------------
		//               Event Handlers
		//----------------------------------------------------------------
		private var lastClickTime:int;
		private var _lastClickPoint:IntPoint;
		private var clickCount:int;
		private function __mouseClick(e:MouseEvent):void{
			var time:int = getTimer();
			var mousePoint:IntPoint = getMousePosition();
			if(mousePoint.equals(_lastClickPoint) && time - lastClickTime < MAX_CLICK_INTERVAL){
				clickCount++;
			}else{
				clickCount = 1;
			}
			lastClickTime = time;
			dispatchEvent(new ClickCountEvent(ClickCountEvent.CLICK_COUNT, clickCount));
			_lastClickPoint = mousePoint;
		}
		
		//retrive the focus when mouse down if not focused child or self
		//this will works because focusIn will be fired before mouseDown
		private function __mouseDown(e:MouseEvent):void{
			
			if(isDragEnabled()){
				addEventListener(MouseEvent.MOUSE_MOVE, __mouseMove);
				addEventListener(MouseEvent.ROLL_OUT, __rollOut);
				DisplayUtil.getStage().addEventListener(MouseEvent.MOUSE_UP, __mouseUp, false, 0, true);
				pressingPoint = getMousePosition();
			}
		}
		
		private var pressingPoint:IntPoint;
		private function __mouseUp(e:MouseEvent):void{
			stopListernDragRec();
		}
		private function __mouseMove(e:MouseEvent):void{
			var mp:IntPoint = getMousePosition();
			if(mp.distanceSq(pressingPoint) > 1){
				fireDragRecognizedEvent(null);
				stopListernDragRec();
			}
		}
		private function __rollOut(e:MouseEvent):void{
			stopListernDragRec();
		}
		private function stopListernDragRec():void{
			removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMove);
			removeEventListener(MouseEvent.ROLL_OUT, __rollOut);
			stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseUp);
		}
		
		
		
		
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		public function setSize(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			dispatchEvent(new Event(Event.RESIZE));
			invalidate();
		}
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the width of the component.
		 */
		/*override public function set width(w:Number):void
		{
			_width = w;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		override public function get width():Number
		{
			return _width;
		}*/
		
		/**
		 * Sets/gets the height of the component.
		 */
		/*override public function set height(h:Number):void
		{
			_height = h;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		override public function get height():Number
		{
			return _height;
		}*/
	
		override public function dispose():void{
			super.dispose();
			dragAcceptableInitiator= null;
			dragAcceptableInitiatorAppraiser= null;
			
		
		}
	}
}