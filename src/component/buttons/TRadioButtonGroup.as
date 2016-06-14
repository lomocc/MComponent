package component.buttons
{
	import com.throne.utils.HashMap;

	//
	public class TRadioButtonGroup {
		//*****************Static vars and functions***************
		public static  var groups:Object;
		
		public static function getGroup(name:String):TRadioButtonGroup {
			if (groups == null) { groups = {}; }
			var group:TRadioButtonGroup = groups[name] as TRadioButtonGroup;
			if (group == null) {
				group = new TRadioButtonGroup(name);
			}
			return group;
		}
		
		private static function registerGroup(group:TRadioButtonGroup):void {
			if (groups == null) {
				groups = {};
			}
			groups[group.name] = group;
		}
		
		public static function cleanGroup(name:String):void{
			if(groups==null) return;
			var group:TRadioButtonGroup = groups[name] as TRadioButtonGroup;
			if(group!=null && group.objectList.size() == 0){
				disposeGroup(name);	
			}
		}
		
		public static function cleanUpGroups():void {
			for (var name:String in groups) {
				var group:TRadioButtonGroup = groups[name] as TRadioButtonGroup;
				if (group.objectList.size() == 0) {
					disposeGroup(name);
				}
			}
		}
		
		private static function disposeGroup(name:String):void{
			TRadioButtonGroup(groups[name]).dispose();
			delete(groups[name]);
		}
		
		private var _name:String;

		public var objectList:HashMap;

		protected var _selected:TRadioButton;
		
		public function TRadioButtonGroup(name:String) {
			_name = name;
			objectList = new HashMap();
			registerGroup(this);
		}
		
		public function addObject(obj:Object):void {
			if(objectList.containsKey(obj)) return;
			objectList.put(obj,obj);
		}

		public function removeObject(obj:Object):void {
			if(objectList.containsKey(obj)){
				if(selection == obj) selection = null;
				objectList.remove(obj);
			}
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get selection():TRadioButton {
			return _selected;
		}
		
		public function set selection(obj:TRadioButton):void{
			_selected = obj;
		}
		
		public function dispose():void
		{
			objectList=null;
			_selected=null;
		}
	}
	
}
