package com.dixond.logging {
	import com.dixond.logging.Logger;
	import com.dixond.events.LogEvent;
	import flash.events.StatusEvent;
	import flash.events.EventDispatcher;
	import flash.net.LocalConnection;
	
	 /**
	  * Abstract-style class to be subclassed by specific log view classes (e.g. LocalConnectionView, SyslogView)
	  *	that will receive events from the Logger class and display the log message in their particular ways.
	  *	Also extends EventDispatcher to allow for Log Views that need to send events.
	  *	
	  */
	 public class AbstractLogView extends EventDispatcher {
		 // The log that this object is observing.
		protected var _log:Logger;
		protected var _enabled:Boolean;
		 /**
		  * Constructor
		  */
		public function AbstractLogView (aLog:Logger) {
			trace("AbstractLogView()");
			_log = aLog;
 	   }

		protected function disable() {
			_enabled = false;
		}
		protected function enable()  {
			_enabled = true;
		}

		// subclasses do this
		// public function destroy ():void {
		// 	// _log.removeEventListener(LogEvent.UPDATE, logUpdateHandler);
		// }
	}
}