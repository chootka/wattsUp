package com.dixond.events{
	
	/*
	*   ExtendedMouseEvent - adds some extra Types to the MouseEvent class
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 10.0
	*
	*	@author 
	*	@since  18.08.2010
	*/
	
	import flash.events.MouseEvent;
	import flash.display.InteractiveObject;
	
	public class ExtendedMouseEvent extends MouseEvent {
		public static const MOUSE_STILL_DOWN = "mouse_still_down";
		
		public function ExtendedMouseEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false, localX:Number = NaN, localY:Number = NaN, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0, commandKey:Boolean = false, controlKey:Boolean = false, clickCount:int = 0){
			
			 super(type);
			// super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta, commandKey, controlKey, clickCount);
			
			// compiler says this is only expecting 11 args, so removed the last 3. Not sure why the error tho, cuz i copied these right from the docs!
			// super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
			
		}
		
		
	}//end class
}//end package
