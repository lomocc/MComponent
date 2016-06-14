package component.events
{

	import flash.events.Event;
	
	import component.base.TComponent;
	import component.utils.IntPoint;

	public class DragAndDropEvent extends Event 
	{
		public static const DRAG_RECOGNIZED:String = "dragRecognized";
		public static const DRAG_START:String = "dragStart";
		public static const DRAG_ENTER:String = "dragEnter";
		public static const DRAG_OVERRING:String = "dragOverring";
		public static const DRAG_EXIT:String = "dragExit";
		public static const DRAG_DROP:String = "dragDrop";
		
		private var dragInitiator:TComponent;
		private var sourceData:Object;
		private var mousePos:IntPoint;
		private var targetComponent:TComponent;
		private var relatedTargetComponent:TComponent;
		
		/**
		 * 事件构造函数
		 * @param	type	事件类型
		 * @param	dragInitiator	拖动源组件
		 * @param	sourceData	拖动的数据源
		 * @param	mousePos	光标的坐标点
		 * @param	targetComponent	目标组件
		 * @param	relatedTargetComponent 相关联的组件,例如,拖动时经过的组件等..
		 */
		public function DragAndDropEvent(type:String, 
		dragInitiator:TComponent, sourceData:Object, mousePos:IntPoint, 
		targetComponent:TComponent=null, relatedTargetComponent:TComponent=null) 
		{ 
			super(type, false, false);
			this.dragInitiator = dragInitiator;
			this.sourceData = sourceData;
			this.mousePos = mousePos;
			this.targetComponent = targetComponent;
			this.relatedTargetComponent = relatedTargetComponent;
		}
		
		public function getDragInitiator():TComponent{
			return dragInitiator;
		}

		public function getSourceData():Object{
			return sourceData;
		}

		public function getMousePosition():IntPoint{
			return mousePos;
		}
		
		public function getTargetComponent():TComponent{
			return targetComponent;
		}

		public function getRelatedTargetComponent():TComponent{
			return relatedTargetComponent;
		}
		
		public override function clone():Event
		{ 
			return new DragAndDropEvent(type,dragInitiator,sourceData,mousePos,targetComponent,relatedTargetComponent);
		} 
		
		public override function toString():String
		{
			return formatToString("DragAndDropEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
	}
	
}