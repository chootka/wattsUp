package com.dixond.display {
	
	
	/*
	*   IN PROGRESS - UNTESTED
	*	Handles non-graphic aspects of a frame based animation. Manages the timer; tracks and updates the current index based on the time.
	*	No display is handled here. Subclasses define how to render the anim and use this class to handle the timing and currentframe. That's the idea anyway...
	*
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*
	*	@author D
	*	@since  09.07.2008
	*/
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class BasicAnimator extends EventDispatcher {
		// event sent whenever the frame is changed
		public static const UPDATE_FRAME = "update_frame";
		
		private var _timer:Timer;
		// note frames are 1-based
		private var _frames:uint;
		private var _currentFrame:uint;
		// private var _fps:uint;
		// loops value of 0 or null means forever
		private var _loops:uint;
		// direction is -1(reverse) or 1(fwd)
		private var _direction:int;
		
		
		public function BasicAnimator(aFrames:uint, aFps:uint, aLoops:uint = 0){
			
			_frames = aFrames;
			_loops = aLoops;
			// default to fwd
			_direction = 1;
			// if (_loops == 0) {
			// 	_loops = null;
			// }
			var delay = 1000/aFps;
			
			if (_loops == 0) {
				_timer = new Timer(delay);
			}else  {
				_timer = new Timer(delay, _loops);
			}
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			// default to the first frame
			_currentFrame = 1;
		}
		
		public function timerHandler(aEvent:TimerEvent) {
			// update the current frame based on direction
			_currentFrame += (1 * _direction);
			// wrap
			if (_direction == 1) {
				if (_currentFrame > _frames) {
					_currentFrame = 1;
				}
			} else if (_direction == -1) {
				if (_currentFrame < 1) {
					_currentFrame = _frames;
				}
			}
			dispatchEvent(new Event(BasicAnimator.UPDATE_FRAME));
		}
		
		public function start() {
			_timer.start();
		}
		
		public function stop() {
			_timer.stop();
		}
		
		public function reset() {
			// note this stops the timer as well as resetting it
			_timer.reset();
		}
		
		// jump to first frame of anim. Does not stop the anim. Mirrors typical movie / anim player controls.
		public function rewind() {
			_currentFrame = 1;
			dispatchEvent(new Event(BasicAnimator.UPDATE_FRAME));
		}
		
		// jump to last frame of anim. Does not stop anim if it's looping. Otherwise anim stops at end.
		public function end() {
			_currentFrame = _frames;
			dispatchEvent(new Event(BasicAnimator.UPDATE_FRAME));
		}
		
		public function setFrame(aFrame:uint):void {
			_currentFrame = aFrame;
			dispatchEvent(new Event(BasicAnimator.UPDATE_FRAME));
		}
		
		public function getFrame():uint {
			return _currentFrame;
		}
		
	}// end class
}// end package
