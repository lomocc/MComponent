package com.throne.gui.events{

import flash.events.Event;


public class InteractiveEvent extends Event{
	
	public static const STATE_CHANGED:String = "stateChanged";

	private var programmatic:Boolean;
	
	public function InteractiveEvent(type:String, programmatic:Boolean=false, bubbles:Boolean=false, cancelable:Boolean=false){
		super(type, bubbles, cancelable);
		this.programmatic = programmatic;
	}
	

	public function isProgrammatic():Boolean{
		return programmatic;
	}
	
	override public function clone():Event{
		return new InteractiveEvent(type, isProgrammatic(), bubbles, cancelable);
	}
}
}