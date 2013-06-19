package com.dixond.logging {
	import com.dixond.logging.Logger;
	import com.dixond.events.LogEvent;
	import com.airlogger.AirLoggerDebug;
 
	 /**
	  * An observer of the Logger class. 
	  *	Translates and sends my current Logger messages to AirLogger Console
	  *	From Moock's ASDG Observer Example, modified to use AS3 Event model
	  */
	 public class AirLoggerView extends AbstractLogView{

		 /**
		  * Constructor
		  */
		 public function AirLoggerView (aLog:Logger) {
			// _log = aLog;
			super(aLog);
			_log.addEventListener(LogEvent.UPDATE, logUpdateHandler);
	   		enable();
		}
 
	   /**
	    * Invoked when the log changes. For details, see the 
	    * Observer interface.
	    */
		public function logUpdateHandler (aEvent:LogEvent):void {
			var logEvent:LogEvent = aEvent as LogEvent;
			// remove the linebreak at the end because trace() seems to add its own.
			var msg = logEvent.message.slice(0, -1);
			// trace(":" + Logger.getLevelDesc(logEvent.level) + ": " + msg);
			
			// arthropod uses slightly different function names.
			// note: arthropod only has 3 debug levels: log, warning and error.
			// note: can pass a color to the log() function. But not to warning() or error();
			// 	 may do that to distinguish between info and debugs, or fatal and errors.
			switch(logEvent.level) {
				case Logger.FATAL:
					AirLoggerDebug.fatal(msg);
					break;
				case Logger.ERROR:
					AirLoggerDebug.error(msg);
					break;
				case Logger.WARN:
					AirLoggerDebug.warn(msg);
					break;
				case Logger.INFO:
					AirLoggerDebug.info(msg);
					break;
				case Logger.DEBUG:
					AirLoggerDebug.debug(msg); //0xFEFEFE
					break;
			}
		}

		public function destroy ():void {
			_log.removeEventListener(LogEvent.UPDATE, logUpdateHandler);
		}
	}
}