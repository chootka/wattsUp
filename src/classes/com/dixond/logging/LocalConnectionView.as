package com.dixond.logging {
	import com.dixond.logging.Logger;
	import com.dixond.events.LogEvent;
	import com.dixond.utils.TimeStamp;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	 /**
	  * An observer of the Logger class. This class sends 
	  * log messages to a separate Flash movie via Local Connection Object
	  *	
	  */
	 public class LocalConnectionView {
		 // The log that this object is observing.
		private var _log:Logger;
		private var _lc:LocalConnection;
		private var _showTimeStamp:Boolean = true;
		
		 /**
		  * Constructor
		  */
		public function LocalConnectionView (aLog:Logger) {
			_log = aLog;
			_log.addEventListener(LogEvent.UPDATE, logUpdateHandler);
			// set up the local connection object to send
			_lc = new LocalConnection();
			_lc.addEventListener(StatusEvent.STATUS, statusHandler)
 	   }
 		
		private function statusHandler(aEvent:StatusEvent) {
			switch (aEvent.level) {
                case "status":
                    //trace("LocalConnection.send() succeeded");
                    break;
                case "error":
					// don't use the log here, cuz if it fails, you get a stack overload.
                    // _log.warn("LocalConnectionView - send failed!");
                    break;
            }
		} 
	   /**
	    * Invoked when the log changes. For details, see the 
	    * Observer interface.
	    */
		public function logUpdateHandler (aEvent:LogEvent):void {
			var logEvent:LogEvent = aEvent as LogEvent;
			var timeStamp = TimeStamp.getTimeStamp();
			var levelDesc = Logger.getLevelDesc(logEvent.level); 
			var msg:String = "";
			// make the timestamp optional
			if (_showTimeStamp) {
				msg += timeStamp + " ";
			}
			// var msg = timeStamp + " " + levelDesc + ": " + logEvent.message;
			msg += "-- " + levelDesc + ": " + logEvent.message;
			// there is a 40k limit on what can be sent. ArgumentError is thrown if 40k exceeded. Use try/catch to keep this from breaking
			try {
				_lc.send("lc_log", "update", msg);
			} catch(e:Error) {
				_log.error("LCConnectionView could not send log message. " + e.message);
			}
		} 

		public function showTimeStamp(aState) {
			_showTimeStamp = aState;
		}
		
		public function destroy ():void {
			_log.removeEventListener(LogEvent.UPDATE, logUpdateHandler);
		}
	}
}