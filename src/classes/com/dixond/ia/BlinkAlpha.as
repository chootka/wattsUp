﻿package com.dixond.ia {	import flash.display.DisplayObject;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.events.Event;	import flash.events.EventDispatcher;		/*	*	Causes a display object to blink by toggling it's alpha value on and off	*	*	@langversion ActionScript 3.0	*	@playerversion Flash 9.0	*	*	@author D	*	@since  28.02.2008	*/	public class BlinkAlpha extends EventDispatcher{		//--------------------------------------		// PRIVATE AND PROTECTED VARIABLES		//--------------------------------------		private var _timer:Timer;		private var _target:DisplayObject;		private var _origAlpha:Number;		private var _finalState:Boolean;		// current toggle state		private var _state:Boolean;		//--------------------------------------		//  CONSTRUCTOR		//--------------------------------------		/**		*/		public function BlinkAlpha (aTarget:DisplayObject, aDelayMillis:Number, aCount:int, aFinalState:Boolean = true):void {			// trace("BlinkAlpha()", aTarget, aDelayMillis, aCount);			_target = aTarget;			_origAlpha = _target.alpha;			_state = _target.alpha != 0;					_finalState= aFinalState;			// if (_finalState == null) {			// 	_finalState= _state;			// } 						_timer = new Timer(aDelayMillis, aCount * 2);			_timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, false);			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false, 0, false);			// just start it automatically for now			start();		}				public function start() {			// trace("BlinkAlpha.start()");			// toggle state befor timer, for immediate feedback			toggleState();			_timer.start();		}				public function stop() {			_timer.stop();		}				private function timerHandler(aEvent:TimerEvent) {			// trace("BlinkAlpha.timerHandler()");			toggleState();		}				private function toggleState() {			_state = !_state;			setAlpha();		}				private function setAlpha() {			// draw the state			if (_state) {				_target.alpha = _origAlpha;			} else {				_target.alpha = 0;			}					}				// should send an event so we know when the blinking is done		private function timerCompleteHandler(aEvent:TimerEvent) {			// trace("BlinkAlpha.timerCompleteHandler()");						// restore the alpha			_state = _finalState;			setAlpha();			// dispose of the timer			_timer.removeEventListener(TimerEvent.TIMER, timerHandler, false);			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false);			_timer = null;			dispatchEvent(new Event(Event.COMPLETE));		}	}}