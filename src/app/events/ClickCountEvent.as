package app.events
{

import flash.events.Event;

/**
 * For continusely clicks.
 */
public class ClickCountEvent extends Event{
	
	
	public static const CLICK_COUNT:String = "clickCount";
	
	private var count:int;
	
	public function ClickCountEvent(type:String, count:int){
		super(type, false, false);
		this.count = count;
	}
	
	public function getCount():int{
		return count;
	}
	
	override public function clone():Event{
		return new ClickCountEvent(type, count);
	}
	
}
}