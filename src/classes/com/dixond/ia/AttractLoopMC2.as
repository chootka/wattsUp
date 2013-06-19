package com.dixond.ia {
	/*
	*	AttractLoopMC2 - update that takes a loaded swf instead of a file
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*
	*	@author D
	*	@since  09.2010
	*	
	*/
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;

	import com.dixond.display.MediaLoader;
	// TEMP
	import com.dixond.logging.Logger;
	
	public class AttractLoopMC2 extends AttractLoop {
		// loader that will contain the swf to play
		private var _loader:MediaLoader;
		// direct ref to the loaded swf
		private var _clip:MovieClip;
		
		// alter this class to include a setFile and loadFile function ?? To give option to load or pass preloaded movie
		public function AttractLoopMC2(aParent:DisplayObjectContainer, aIdleTimeout:IdleTimeout, aClip:MovieClip=null) {
			super(aParent, aIdleTimeout);
			_clip = aClip;
			_mainLayer.addChild(_clip); 
			
			// listen for idle timer
			_timeout.addEventListener(IdleTimeout.IDLE_TIMEOUT, idleEventListener, false, 0, true);
			// listen for mouse click on attract loop
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener, false, 0, true);
		}
		
		// event sent when idleTimeout has elapsed with no input events
		protected function idleEventListener(aEvent:Event) {
			// only do this if we're not already playing. 
			if (!_active) {
				start();
			}
		}
		// mouse listener for clicks on attract loop
		protected function mouseDownListener(aEvent:MouseEvent) {
			// turn off attract
			stop();
			// don't need to reset the timer. The idleTimeout already takes care of that, since it's listening for it too.
		}

		// notify of any probs loading the clip
		private function loaderErrorListener(aEvent:IOErrorEvent) {
			Logger.getLog().error("Could not load attract swf file. " + aEvent.text);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorListener, false);
		}
		
		// loop at the end of the clip
		private function enterFrameHandler(aEvent:Event) {
			if (_clip.currentFrame == _clip.totalFrames) {
				_clip.gotoAndPlay(1);
			}
		}
		//--------------------------------------
		//  public methods to start and stop the attract loop 
		//--------------------------------------
		
		/**
		*	adds this object to display list and starts the movie
		*/
		public override function start() {
			Logger.getLog().debug("AttractMC2.start()");
			// may need a different test than active, since this gets turned true on the idletimeout. See AttractLoopVideo. 
			if (!_active) {
				// add listener for looping
				_clip.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				_clip.gotoAndPlay(1);
			}
			// this must happen at end, cuz it sets _active to true!
			super.start();
		}
		
		/**
		* stops the movie and removes this object from display list
		*/
		public override function stop() {
			_clip.stop();
			_clip.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			super.stop();
		}
		
		public override function toString():String{
			return "[object AttractLoopMC]"
		}
	} // end class
}// end package
