package com.dixond.logging {
	 import com.dixond.logging.Logger;
	 import com.dixond.events.LogEvent;
 
	 /**
	  * An observer of the Logger class. When a movie is played in 
	  * the Flash authoring tool's Test Movie mode, this class displays
	  * log messages in the Output panel.
	  *	From Moock's ASDG Observer Example, modified to use AS3 Event model
	  */
	 public class OutputPanelView extends AbstractLogView{

		 /**
		  * Constructor
		  */
		 public function OutputPanelView (aLog:Logger) {
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
			trace(":" + Logger.getLevelDesc(logEvent.level) + ": " + msg);
		}

		public function destroy ():void {
			_log.removeEventListener(LogEvent.UPDATE, logUpdateHandler);
		}
	}
}