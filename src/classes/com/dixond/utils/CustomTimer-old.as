package com.dixond.utils {
	
	/*
	*	CustomTimer - Extension of flash.utils.Timer class that tracks the start time 
	*	thus allows you to calculalte the current elapsed time and use as a countdown timer.
	*	- note all times returned in milliseconds
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*
	*	@author 
	*	@since  03.02.2009
	*/
	import flash.utils.Timer;
	
	public class CustomTimer extends Timer {
		// milliseconds at which this timer was started
		private var _startTime:Date;
		
		public function CustomTimer(aDelay:Number, aRepeatCount:int=0){
			super(aDelay, aRepeatCount);
		}
		
		public override function start():void {
			_startTime = new Date();
			super.start();
		}
		
		public function getElapsedTime():Number {
			var currentTime = new Date().getTime()
			return currentTime - _startTime.getTime();
		}
		
		public function getRemainingTime():Number {
			return this.delay - getElapsedTime();			
		}
		
		public static function millisToHms (aMillis):Object{
			// forgot to note where i got this...
			//Convert duration from milliseconds to 0000:00:00.00 format
			var o:Object = {};
			var hms = "";
			var dtm = new Date(); 
			dtm.setTime(aMillis);
			if (dtm < 0) {
				return {hours:"0000", minutes:"00", seconds:"00", fractions:"00"};
			} else {
				var h = "000" + Math.floor(aMillis / 3600000);
				var m = "0" + dtm.getMinutes();
				var s = "0" + dtm.getSeconds();
				var cs = "0" + Math.round(dtm.getMilliseconds() / 10);
			
				o.hours	= h.substr(h.length-4);
				o.minutes = m.substr(m.length-2);
				o.seconds = s.substr(s.length-2);
				o.fractions = cs.substr(cs.length-2);
				return o;
			}
			
			// hms = h.substr(h.length-4)+":"+m.substr(m.length-2)+":";
			// hms += s.substr(s.length-2)+"."+cs.substr(cs.length-2);
			// return hms
		}
		
		
		public function formatTime (aMillis, hours=true, minutes=true, seconds=true, fractions=false):String {
			var hms = millisToHms(aMillis);
			var str = "";
			var a:Array = [];
			if (hours) {
				a.push(hms.hours);
			}
			if (minutes) {
				a.push(hms.minutes);
			}
			if (seconds) {
				a.push(hms.seconds);
			}
			str = a.join(":");
			
			if (fractions){
				str += hms.fractions;
			}
			return str;
		}
		
	}//end class
}//end package
