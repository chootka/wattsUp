package com.dixond.utils {
	
	/*
	*	Some handy static drawing utilities
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 10.0
	*
	*	@author 
	*	@since  22.08.2010
	*/
	
	import flash.display.Graphics;
	
	public class Drawing {
		
		public function Drawing(){
		}
		
		public static function drawRect(aTarget:Graphics, x, y, w, h, lineSize=1, lineColor=0x00FF00, alpha=1 ) {
			aTarget.endFill(); // just in case it was left open
			aTarget.lineStyle(lineSize, lineColor, alpha);
			aTarget.drawRect(x,y,w,h);
		}

		// note this currently makes the line and fill the same alpha
		public static function fillRect(aTarget:Graphics, x, y, w, h, lineSize=1, lineColor=0x00FF00, fillColor=0xFF0000, alpha=1 ) {
			aTarget.lineStyle(lineSize, lineColor, alpha);
			aTarget.beginFill(fillColor, alpha);
			aTarget.drawRect(x, y, w, h);
			aTarget.endFill();
		}
		
		// Arc drawing code from PiXELWiT: http://www.pixelwit.com/blog/2007/07/draw-an-arc-with-actionscript/
		// Angles are expressed as a number between 0 and 1.  .25 = 90 degrees.
		// If you prefer using degrees, write 90 degrees like so "90/360".
		public static function drawArc(graphics:Graphics, centerX, centerY, radius, startAngle, arcAngle, steps){
		    //
		    // For convenience, store the number of radians in a full circle.
		    var twoPI = 2 * Math.PI;
		    //
		    // To determine the size of the angle between each point on the
		    // arc, divide the overall angle by the total number of points.
		    var angleStep = arcAngle/steps;
		    //
		    // Determine coordinates of first point using basic circle math.
		    var xx = centerX + Math.cos(startAngle * twoPI) * radius;
		    var yy = centerY + Math.sin(startAngle * twoPI) * radius;
		    //
		    // Move to the first point.
		    graphics.moveTo(xx, yy);
		    //
		    // Draw a line to each point on the arc.
		    for(var i=1; i<=steps; i++){
		        //
		        // Increment the angle by "angleStep".
		        var angle = startAngle + i * angleStep;
		        //
		        // Determine next point's coordinates using basic circle math.
		        xx = centerX + Math.cos(angle * twoPI) * radius;
		        yy = centerY + Math.sin(angle * twoPI) * radius;
		        //
		        // Draw a line to the next point.
		        graphics.lineTo(xx, yy);
		    }
		}
		
		// Adapted from drawArc above. Draws a filled wedge based on specified arc
		// Angles are expressed as a number between 0 and 1.  .25 = 90 degrees.
		// If you prefer using degrees, write 90 degrees like so "90/360".
		public static function drawWedge(graphics:Graphics, centerX, centerY, radius, startAngle, arcAngle, steps){
		    //
		    // For convenience, store the number of radians in a full circle.
		    var twoPI = 2 * Math.PI;
		    //
		    // To determine the size of the angle between each point on the
		    // arc, divide the overall angle by the total number of points.
		    var angleStep = arcAngle/steps;
		    //
		    // Determine coordinates of first point using basic circle math.
		    var xx = centerX + Math.cos(startAngle * twoPI) * radius;
		    var yy = centerY + Math.sin(startAngle * twoPI) * radius;
		    //
		    // start at the center point
			graphics.moveTo(centerX, centerY)
			// draw line to the first point in the arc
		    graphics.lineTo(xx, yy);
		    //
		    // Draw a line to each point on the arc.
		    for(var i=1; i<=steps; i++){
		        //
		        // Increment the angle by "angleStep".
		        var angle = startAngle + i * angleStep;
		        //
		        // Determine next point's coordinates using basic circle math.
		        xx = centerX + Math.cos(angle * twoPI) * radius;
		        yy = centerY + Math.sin(angle * twoPI) * radius;
		        //
		        // Draw a line to the next point.
		        graphics.lineTo(xx, yy);
		    }
			// draw line back to the center, closing the shape
			graphics.lineTo(centerX, centerY);
		}
		
	}//end class
}//end package
