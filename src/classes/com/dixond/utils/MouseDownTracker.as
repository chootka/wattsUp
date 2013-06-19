package com.dixond.utils{
	
	/*
	*	MouseDownTracker - Object to track when the mouse is held down. Sends MOUSE_STILL_DOWN events.
	*	Enables the DisplayObject to dispatch a MOUSE_STILL_DOWN event, when the mouse is clicked and held on it.
	*	 
	*	Two ways to use it:
	*	1. Make a new instance, passing the object you want to test if mouse is held down on that will dispatch the MOUSE_STILL_DOWN event:  
	*		m = new MouseDownTracker(someDisplayObject); 
	*		m = new MouseDownTracker(displayObject.stage); // use the stage as a global mouse_still_down tracker
	*	
	*	2. Use the static shortcut:
	*		MouseDownTracker.addDispatcher(someDisplayObject);
	*	
	*	3. Assign eventListeners for the MOUSE_STILL_DOWN event. The listener doesn't have to be the same object that is dispatching it.
	*		MouseDownTracker.addDispatcher(someButton);
	*		someButton.addEventListener(MouseDownTracker.MOUSE_STILL_DOWN, buttonStillDownHandler);
			obj.stage.addEventListener(MouseDownTracker.MOUSE_STILL_DOWN, someOtherHandler)
	*	In other words, any object can listen for this event. But the object assigned as the dispatcher must be clicked and held for the event to be sent. So in example 3 above, the stage will recieve the event when someButton is pressed/held, but not when the stage is pressed/held. You can use the Event.target property to determine the dispatcher in your event handler functions.

	*	Once an instance is made you can query whether the mouse is down without waiting for an event via the static method MouseDownTracker.isMouseDown();
	*	The localX and localY positions are relative to the object dispatching the event. Use ExtendedMouseEvent.stageX and stageY for global coords.
	*	Objects that are not on the display list do not recieve MouseEvents, and so won't dispatch the MOUSE_STILL_DOWN event.
	*	
	*	If you add your event listeners to the MouseDownTracker instance, you won't get localX, localY, stageX, and stageY coordinates with your event. Add them to the DisplayObject (or the stage) you want to recieve the event 
	*	
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 10.0
	*
	*	@author 
	*	@since  18.08.2010
	*/
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import com.dixond.events.ExtendedMouseEvent;
	import com.dixond.logging.Logger;
	import com.dougmccune.HitTester;
	
	public class MouseDownTracker extends EventDispatcher {
		private static var _mouseIsDown:Boolean;
		private var _refObject:DisplayObject;
		 	
		private var _stillDownDelayTimer:Timer;
		private var _stillDownRepeatTimer:Timer;
 		private var _useHitTest:Boolean
		
		// aStillDownDelay: how long (milliseconds) mouse must be held down before MOUSE_STILL_DOWN events start firing 
		// aStillDownRepeatRate: how often (milliseconds) to fire the MOUSE_STILL_DOWN event
		public function MouseDownTracker(aReferenceObject:DisplayObject, aStillDownDelay:Number=500, aStillDownRepeatRate:Number=300, aUseHitTest:Boolean = false) {
			// Logger.getLog().debug("MouseDownTracker()", "refObject:" + aReferenceObject);
			_refObject = aReferenceObject;
			_useHitTest = aUseHitTest; 
			
			_refObject.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_refObject.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			_stillDownDelayTimer = new Timer(aStillDownDelay);
			_stillDownRepeatTimer = new Timer(aStillDownRepeatRate);
			_stillDownDelayTimer.addEventListener(TimerEvent.TIMER, stillDownDelayHandler);
			_stillDownRepeatTimer.addEventListener(TimerEvent.TIMER, stillDownRepeatHandler)
		}	
		
		private function sendStillDownEvent() {
			var e:ExtendedMouseEvent = new ExtendedMouseEvent(ExtendedMouseEvent.MOUSE_STILL_DOWN);
			e.localX = _refObject.mouseX;
			e.localY = _refObject.mouseY;
			_refObject.dispatchEvent(e);
		}
		
		private function stillDownDelayHandler(aEvent:TimerEvent) {
			// Logger.getLog().debug("stillDownDelayHandler()");
			// if this event fires, it's time to start dispatching the stillDown message
			sendStillDownEvent();
			_stillDownDelayTimer.reset();
			_stillDownRepeatTimer.start(); // start timer to keep firing this message
		}
		
		private function stillDownRepeatHandler(aEvent:TimerEvent) {
			sendStillDownEvent();
		}
		
		private function mouseDownHandler(aEvent:MouseEvent) {
			// if (_useHitTest) {
				var shapeFlag = _useHitTest;
				// Logger.getLog().debug("Tracker.mouseDownHandler()", "currenttarget: " + aEvent.currentTarget, "_refObject.mouseXY: " + _refObject.mouseX, _refObject.mouseY);
				if (_refObject.hitTestPoint(aEvent.stageX, aEvent.stageY, shapeFlag)) {
				// if (HitTester.realHitTest(_refObject, new Point(aEvent.stageX, aEvent.stageY))) {
					MouseDownTracker._mouseIsDown = true;
					_stillDownDelayTimer.start();
			
					// listen for global mouseUp's outside this object. 
					// otherwise MouseStillDown event will continue to fire if we release outside the object
					_refObject.stage.addEventListener(MouseEvent.MOUSE_UP, globalMouseUpHandler);
					_refObject.stage.addEventListener(Event.REMOVED_FROM_STAGE, refObjRemovedFromStageHandler);
				}
			// }
		}
		
		private function refObjRemovedFromStageHandler(aEvent:Event) {
			// think this gets triggered right before it's removed, so hopefully it doesn't bug out 
			_refObject.stage.removeEventListener(MouseEvent.MOUSE_UP, globalMouseUpHandler);
		}
		
		private function globalMouseUpHandler (aEvent:MouseEvent) {
			// Logger.getLog().debug("MouseTracker.globalMouseUpHandler()", "refObj=" + _refObject, _refObject.name, "target=" + aEvent.target.name);
			if (aEvent.target != _refObject) {  				// || _refObject.contains(aEvent.target)) {
				// mouse was released outside the refObject.
				MouseDownTracker._mouseIsDown = false;
				// stops and resets the timers, thus stopping the event output
				_stillDownDelayTimer.reset(); 
				_stillDownRepeatTimer.reset();
				
				// do we want to add a MOUSE_UP_OUTSIDE event to ExtendedMouseEvents.
			}
			// get rid of the listener or these accumulate on the stage!
			_refObject.stage.removeEventListener(MouseEvent.MOUSE_UP, globalMouseUpHandler);
		}
		
		private function mouseUpHandler(aEvent:MouseEvent) {
			// Logger.getLog().debug("MouseTracker.mouseUpHandler()"
			MouseDownTracker._mouseIsDown = false;
			// stops and resets the timers
			_stillDownDelayTimer.reset(); 
			_stillDownRepeatTimer.reset();
		}
		
		// static shortcut (alternative to new() ) to assign a displayObject to dispatch mouse_still_down events. Can also use new() 
		public static function addDispatcher(aReferenceObject:DisplayObject, aStillDownDelay:Number=500, aStillDownRepeatRate:Number=300, aUseHitTest:Boolean = false) {
			return new MouseDownTracker(aReferenceObject, aStillDownDelay, aStillDownRepeatRate, aUseHitTest);
		}
		
		// note this only works after at least one instance has been created. Something needs to get the MouseDown/Up events, after all.
		public static function isMouseDown() {
			return MouseDownTracker._mouseIsDown;
		}
		
	}//end class
}//end package
