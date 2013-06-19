package com.dixond.ia {
	/*
	*	AttractLoop - Intended as an base class that gets subclassed to handle specific media types. 
	*	Contains 2 display layers: mainLayer, overlayLayer (intended to allow for overlaying text or graphics over a movie)
	*	Manages activating, hiding and showing of the attractloop. Recieves events from IdleTimeout object. 
	*	Subclasses handle the loading and playing / stopping of the media file
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*
	*	@author D
	*	@since  04.09.2007
	*	
	*/

	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import com.dixond.display.Container;
	
	public class AttractLoop extends Container {
		public static var ATTRACT_STARTED:String = "attract_started";
		public static var ATTRACT_STOPPED:String = "attract_stopped";
		// parent DisplayObject that will contain this AttractLoop object; 
		protected var _parent:DisplayObjectContainer;
		// Timer object to monitor idletimeouts
		protected var _timeout:IdleTimeout;
		// flag for attract loop is active or not
		protected var _active:Boolean;
		
		// layer for the animation loop
		protected var _mainLayer:Sprite;
		// optional layer for overlaying over swf
		protected var _overlayLayer:Sprite;
		
		public function AttractLoop(aParent:DisplayObjectContainer, aIdleTimeout:IdleTimeout) {
			name = "attractLoop";
			_parent = aParent;
			_timeout = aIdleTimeout;

			// set playing flag
			_active = false;
			
			_mainLayer = new Sprite();
			_overlayLayer = new Sprite();
			this.addChild(_mainLayer);
			this.addChild(_overlayLayer);
			
		}
		
		//--------------------------------------
		//  public methods to start and stop the attract loop 
		//--------------------------------------
		
		/**
		*	adds this object to display list and starts the movie
		*/
		public function start() {
			if (!_active) {
				this.addToParent(_parent);
				// notify listeners that the attractloop has been triggered
				dispatchEvent(new Event(AttractLoop.ATTRACT_STARTED));
				_active = true;
			}
		}
		
		/**
		* stops the movie and removes this object from display list
		*/
		public function stop() {
			if (_active) {
				this.remove();
			}
			// notify whoever cares that attract has been dismissed
			dispatchEvent(new Event(AttractLoop.ATTRACT_STOPPED));
			_active = false;
		}

		/**
		* add display objects to the overlay layer
		*/
		public function addToOverlay(... args):void {
			for each (var o:DisplayObject in args) {
				_overlayLayer.addChild(o);
			}
		}

		public override function toString():String{
			return "[object AttractLoop]"
		}
	} // end class
}// end package