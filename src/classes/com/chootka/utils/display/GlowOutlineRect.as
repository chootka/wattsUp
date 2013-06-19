package com.chootka.utils.display
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	public class GlowOutlineRect extends Sprite {
		
		public function GlowOutlineRect(xx:int, yy:int, width:uint, height:uint, clr:uint) {
			var g:Graphics = this.graphics;
			g.lineStyle(2.8, clr);
			g.drawRect(xx,yy,width,height);
			
			var filter:BitmapFilter = getBitmapFilter(clr);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			filters = myFilters;
		}
		
		public function destroy():void {
			filters = [];
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