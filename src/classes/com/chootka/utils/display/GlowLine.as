/**
 * @author sgrant
 */

package com.chootka.utils.display 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	public class GlowLine extends Sprite 
	{
		public function GlowLine(xx:int, yy:int, length:uint, clr:Number,stroke:Number,orientation:String="horiz")
		{
			//trace("drawing Rect, " + arguments);
			var g:Graphics = this.graphics;
			
			g.lineStyle(stroke, clr);
			g.moveTo(xx, yy); 
			orientation == "horiz" ? g.lineTo(xx+length, yy) : g.lineTo(xx, yy+length);
			
			var filter:BitmapFilter = getBitmapFilter(clr);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			filters = myFilters;
		}
		
		private function getBitmapFilter(clr:uint):BitmapFilter {
			var color:Number = clr;
			var alpha:Number = 0.4;
			var blurX:Number = 12;
			var blurY:Number = 12;
			var strength:Number = 2;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			return new GlowFilter(color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}
	}
}