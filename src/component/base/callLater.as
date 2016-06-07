import flash.events.Event;
import flash.utils.Dictionary;

private static var inCallLaterPhase:Boolean=false;
private var callLaterMethods:Dictionary = new Dictionary();
protected function callLater(fn:Function):void {
	if (inCallLaterPhase) { return; }
	
	callLaterMethods[fn] = true;
	if (stage != null) {
		try {
			stage.addEventListener(Event.RENDER,callLaterDispatcher,false,0,true);
			stage.invalidate();
		} catch (se:SecurityError) {
			addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
		}
	} else {
		addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
	}
}

private function callLaterDispatcher(event:Event):void {
	if (event.type == Event.ADDED_TO_STAGE) {
		try {
			removeEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher);
			// now we can listen for render event:
			stage.addEventListener(Event.RENDER,callLaterDispatcher,false,0,true);
			stage.invalidate();
			return;
		} catch (se1:SecurityError) {
			addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
		}
	} else {
		event.target.removeEventListener(Event.RENDER,callLaterDispatcher);
		event.target.removeEventListener(Event.ENTER_FRAME,callLaterDispatcher);
		try {
			if (stage == null) {
				// received render, but the stage is not available, so we will listen for addedToStage again:
				addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
				return;
			}
		} catch (se2:SecurityError) {
		}
	}
	
	inCallLaterPhase = true;
	
	var methods:Dictionary = callLaterMethods;
	for (var method:Object in methods) {
		method();
		delete(methods[method]);
	}
	inCallLaterPhase = false;
}
