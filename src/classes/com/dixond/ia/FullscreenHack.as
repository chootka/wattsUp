package com.dixond.ia {
	
	/*
	*	FullScreen Hack for mac mini. Delays setting of fullscreen to avoid or get rid of the whacky menu bar issue...
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*
	*	@author D
	*	@since  3.11.2008
	*/
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	
	public class FullscreenHack{
		private var _timer:Timer;
		private var _stageRef:Stage;
		
		public function FullscreenHack(aStageRef:Stage, aDelaySeconds){
			_stageRef = aStageRef;
			_timer = new Timer(aDelaySeconds * 1000, 1);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timer.start();
		}
		
		private function timerHandler(aEvent:TimerEvent) {
			trace('SETTING STAGE STATE TO FULLSCREEN');
			// _stageRef.displayState = StageDisplayState.NORMAL;
			_stageRef.displayState = StageDisplayState.FULL_SCREEN;
		}		
	}
	
}
