package com.dixond.events{
	import flash.events.Event;
	/**
	*	CustomEvent - currently contains one property, which is an object.
	*	aParams: object containing whatever info you want to send with this event
	*	
	*	usage: dispatchEvent(new CustomEvent(eventType, params))
	*/
	public class CustomEvent extends Event {
		// note custom vars must be public or they're not recognized by the toString() function and maybe other things...
		public var _params:Object = {};
	
		public function CustomEvent(aType:String, aParams:Object = null) {
			super(aType, false);
			_params = aParams;
		}
		public function get params():Object {
			return _params;
		}
		/**
		* @inheritDoc
		*/
		public override function clone():Event {
			return new CustomEvent(type, _params);
		}
		/**
		* @inheritDoc
		*/
		public override function toString():String {
			// var str = super.toString();
			return formatToString("CustomEvent","type", "target", "_params");
		}
		// end class
	}
	// end package
}