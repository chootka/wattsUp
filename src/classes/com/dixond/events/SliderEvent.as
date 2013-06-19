﻿package com.dixond.events{	import flash.events.Event;	/**	SliderEvent - Events dispatched from the com.dixond.Slider class	*/	public class SliderEvent extends Event {		public static const SLIDER_INIT:String = "sliderInit";		public static const SLIDER_PRESS:String = "sliderPress";		public static const SLIDER_RELEASE:String = "sliderRelease";		public static const SLIDER_CHANGE:String = "sliderChange";				private var _value:Number;		//		public function SliderEvent(aType:String, aValue:Number=NaN) {			super(aType, false);			_value = aValue;		}		public function get value():Number {			return _value;		}		/**		* @inheritDoc		*/		public override function clone():Event {			return new SliderEvent(type, _value);		}		/**		* @inheritDoc		*/		public override function toString():String {			var str = super.toString();			// note this string does not include all the inherited Event properties that might be useful...			//return "[Event type=" + type + " selected=" + _selected + "]";			return formatToString("SliderEvent","type", "target", "value");		}		// end class	}	// end package}