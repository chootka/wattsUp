package com.dixond.utils{
	
	/*
	*	PieTimer
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 10.0
	*
	*	@author 
	*	@since  14.09.2010
	*/
	
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.TimerEvent;
 	import com.dixond.utils.UpdatingTimer;
	
	public class PieTimer extends Sprite {
		private var _timer:UpdatingTimer;
		private var _backgroundColor:Number;
		private var _foregroundColor:Number;
		private var _centerX:int;
		private var _centerY:int;
		private var _radius;
		private var _wedgeSize:Number; // 0 - 1 representing a percentage of the circle. These are the units used by the drawing methods here.
		private var _startAngle:Number;
		private var _currentStartAngle:Number;
		
		public function PieTimer(aSeconds:Number, aUpdatesPerSecond:int, aRadius:Number, aStartAngle:Number, aBackColor:Number, aForeColor:Number){
			_timer = new UpdatingTimer(aSeconds, aUpdatesPerSecond);
			_timer.addEventListener(TimerEvent.TIMER, timerUpdateHandler);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			// set up the graphic bits
			_radius = aRadius;
			_backgroundColor = aBackColor;
			_foregroundColor = aForeColor;
			
			// this makes the sprite exactly the size of circle. Move the sprite to reposition it.
			_centerX = aRadius;
			_centerY = aRadius;
			// angles and wedge size are expressed as percentage of the circle, not degrees or radians. So values are 0 - 1;
			_wedgeSize = (1/aUpdatesPerSecond)/aSeconds;
			_startAngle = aStartAngle; // since 0 is to the left and we want it to start at the top of the circle i assume.
			_currentStartAngle = _startAngle;
			drawBackground();
		}
		
		private function drawBackground() {
			this.graphics.beginFill(_backgroundColor);
			drawWedge(this.graphics, _centerX, _centerY, _radius, 0, 1, 100); // 0 is the start and 1 is the end of the circle
		}
		
		private function timerUpdateHandler(aEvent:TimerEvent) {
			var timer = aEvent.target;
			this.graphics.beginFill(_foregroundColor);
			drawWedge(this.graphics, _centerX, _centerY, _radius, _currentStartAngle, _wedgeSize, 100);
			_currentStartAngle += _wedgeSize;
			// dispatch an update event
			dispatchEvent(new TimerEvent(TimerEvent.TIMER));
			
		}

		private function timerCompleteHandler(aEvent:TimerEvent) {
			// trace("PieTimer.complete()");
			// dispatch a complete event
			dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
		}
		
		// Adapted from drawArc by PiXELWiT: http://www.pixelwit.com/blog/2007/07/draw-an-arc-with-actionscript/. 
		// Draws a filled wedge based on specified arc
		// Angles are expressed as a number between 0 and 1 representing a percentage of the circle. So .25 = 90 degrees.
		// If you prefer using degrees, write 90 degrees like so "90/360".
		// aSteps determines how smooth the circle is. For this i'm using 100 cuz it makes a nice circle that is not jagged
		public static function drawWedge(aGrapics:Graphics, aCenterX, aCenterY, aRadius, aStartAngle, aArcAngle, aSteps){
		    // For convenience, store the number of radians in a full circle.
		    var twoPI = 2 * Math.PI;
		    //
		    // To determine the size of the angle between each point on the
		    // arc, divide the overall angle by the total number of points.
		    var angleStep = aArcAngle/aSteps;
		    //
		    // Determine coordinates of first point using basic circle math.
		    var xx = aCenterX + Math.cos(aStartAngle * twoPI) * aRadius;
		    var yy = aCenterY + Math.sin(aStartAngle * twoPI) * aRadius;
		    //
		    // start at the center point
			aGrapics.moveTo(aCenterX, aCenterY)
			// draw line to the first point in the arc
		    aGrapics.lineTo(xx, yy);
		    //
		    // Draw a line to each point on the arc.
		    for(var i=1; i<=aSteps; i++){
		        //
		        // Increment the angle by "angleStep".
		        var angle = aStartAngle + i * angleStep;
		        //
		        // Determine next point's coordinates using basic circle math.
		        xx = aCenterX + Math.cos(angle * twoPI) * aRadius;
		        yy = aCenterY + Math.sin(angle * twoPI) * aRadius;
		        //
		        // Draw a line to the next point.
		        aGrapics.lineTo(xx, yy);
		    }
			// draw line back to the center, closing the shape
			aGrapics.lineTo(aCenterX, aCenterY);
		}
		
		
		public function start() {
			_timer.start();
		}
		
		public function stop() {
			_timer.stop();
		}
		
		public function reset() {
			_currentStartAngle = _startAngle;
			this.graphics.clear();
			drawBackground();
			_timer.reset();
		}
		
		// returns elapsed time in milliseconds
		public function getElapsedTime():Number {
			return _timer.getElapsedTime();
		}
		
		// returns remaining time in milliseconds
		public function getRemainingTime():Number {
			return _timer.getRemainingTime();		
		}
				
		public function formatTime (aMillis, hours=true, minutes=true, seconds=true, fractions=false):String {
			return _timer.formatTime(aMillis, hours, minutes, seconds, fractions);
		}
		
		//		
	}//end class
}//end package
