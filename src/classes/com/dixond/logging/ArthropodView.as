package com.dixond.logging {
	import com.dixond.logging.Logger;
	import com.dixond.events.LogEvent;
	import com.carlcalderon.arthropod.Debug;
 
	 /**
	  * An observer of the Logger class. 
	  *	Translates and sends my current Logger messages to Arthropod
	  *	From Moock's ASDG Observer Example, modified to use AS3 Event model
	  */
	 public class ArthropodView extends AbstractLogView{

		 /**
		  * Constructor
		  */
		 public function ArthropodView (aLog:Logger) {
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
					Debug.error(msg);
					break;
				case Logger.ERROR:
					Debug.error(msg);
					break;
				case Logger.WARN:
					Debug.warning(msg);
					break;
				case Logger.INFO:
					Debug.log(msg, 0x00FF00);
					break;
				case Logger.DEBUG:
					Debug.log(msg, 0xFFFFFF); //0xFEFEFE
					break;
			}
		}

		public function destroy ():void {
			_log.removeEventListener(LogEvent.UPDATE, logUpdateHandler);
		}
	}
}