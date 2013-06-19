package com.dixond.ia{
	/*
	*	AttractLoopVideo
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*
	*	@author D
	*	@since  04.09.2007
	*	
	*	NOTE: figure out best way to add translatable option as we did with AttractLoopMC
	*	
	*/
	
 	import flash.display.DisplayObjectContainer;
	import fl.video.FLVPlayback;
	import fl.video.VideoScaleMode;
	import fl.video.VideoEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// temp
	import com.dixond.logging.Logger;
	
	public class AttractLoopVideo extends AttractLoop {
		private var _video:FLVPlayback;
		
		public function AttractLoopVideo(aParent:DisplayObjectContainer, aIdleTimeout:IdleTimeout, aFilePath:String) {
			super(aParent, aIdleTimeout);
			
			// listen for idle timer
			_timeout.addEventListener(IdleTimeout.IDLE_TIMEOUT, idleEventListener, false, 0, true);
			// listen for mouse click on attract loop
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener, false, 0, true);
	
			// load the video
			_video = new FLVPlayback();
			_video.autoPlay = false;
			// _video.autoRewind = true;
			// _video.scaleMode = VideoScaleMode.NO_SCALE;
			_video.fullScreenTakeOver = false;
			_video.source = aFilePath;
			_video.addEventListener(VideoEvent.COMPLETE, videoCompleteHandler);
			_mainLayer.addChild(_video);
			
			// add a listener so we know when we've been added to the stage
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
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
		
		
		// loops the video
		private function videoCompleteHandler(aEvent:VideoEvent):void {
			var flv:FLVPlayback = aEvent.target as FLVPlayback;
			flv.play();
		}
		
		private function addedToStageHandler(aEvent:Event) {
			// trace("AttractLoopVideo.addedToStageHandler()");
			// get the stage size and make the video match it
			_video.width = this.stage.stageWidth;
			_video.height = this.stage.stageHeight;
		}
		
		//--------------------------------------
		//  public methods to start and stop the attract loop 
		//--------------------------------------
		
		/**
		*	adds this object to display list and starts the movie
		*/
		public override function start() {
			Logger.getLog().debug("AttractLoopVideo.start()");
			super.start();
			if (!_video.playing) {
				// this is assuming the video is same size as the stage, which it should be to protect the whole screen
				_video.x = 0;
				_video.y = 0;
				_video.play();
			}
			// Logger.getLog().debug("stage info: " + this.stage.width, this.stage.height, this.stage.stageWidth, this.stage.stageHeight, stage.scaleMode);
			// Logger.getLog().debug("video position: " + _video.x, _video.y, _video.width, _video.height);
			// Logger.getLog().debug("video registration: " + _video.registrationX, _video.registrationY, _video.registrationWidth, _video.registrationHeight);
		}
		
		/**
		* stops the movie and removes this object from display list
		*/
		public override function stop() {
			_video.stop();
			super.stop();
		}
		public override function toString():String{
			return "[object AttractLoopVideo]"
		}
	} // end class
}// end package
