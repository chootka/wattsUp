package com.dixond.net {
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	import com.dixond.events.MessageEvent;
	
	 /**
	 *	facilitates two-way LC communication via LocalConnection object
	 *	MAY BREAK THESE UP INTO LCSender and LCReceiver objects to avoid some confusion...
	 *	
	 */
	 public class LCMessager extends EventDispatcher {
		private var _lcReceive:LocalConnection;
		private var _lcSend:LocalConnection;
		private var _sendingChannelName;
		private var _receivingChannelName;
		 /**
		  * Constructor
		  */
		public function LCMessager (aReceiveChannelName:String, aSendChannelName:String) {
			_receivingChannelName = aReceiveChannelName;
			_sendingChannelName = aSendChannelName;
			// set up the local connection object to send
			_lcSend = new LocalConnection();
			_lcSend.addEventListener(StatusEvent.STATUS, statusHandler)
			
			// set up lc obj to receive
			_lcReceive = new LocalConnection();
			_lcReceive.client = this;
           try {
             _lcReceive.connect(_receivingChannelName);
            } catch (error:ArgumentError) {
                trace("LCMessager cannot connect...the connection name '" + _lcReceive + "' is already being used by another SWF");
            }
 	   }
 		
		public function send (aMethodName, ... aArgs) {
			// _lcSend.send (_sendingChannelName, aMethodName)
			var argArray =  [_sendingChannelName, aMethodName].concat(aArgs);
			trace("LCMessager.send()", aMethodName, aArgs, "argArray=" + argArray);
			_lcSend.send.apply(this, argArray);
		}
		
		private function statusHandler(aEvent:StatusEvent) {
			switch (aEvent.level) {
                case "status":
                    //trace("LocalConnection.send() succeeded");
                    break;
                case "error":
                    // trace("LocalConnectionView - send failed!");
                    break;
            }
		} 
		
		// this is the function that the sending LC must call
		public function incomingMessage(... args) {
			trace("LCMessager.receive", args);
			dispatchEvent(new MessageEvent(MessageEvent.MESSAGE, args));
		}
		
		// 	   /**
		// 	    * Invoked when the log changes. For details, see the 
		// 	    * Observer interface.
		// 	    */
		// public function logUpdateHandler (aEvent:LogEvent):void {
		// 	var logEvent:LogEvent = aEvent as LogEvent;
		// 	// NOTE: can delete the newline when you fix logger to add it. Most situations want it. But the outputpanel adds one anyway. So fix that one to remove it.
		// 	var timeStamp = TimeStamp.getTimeStamp();
		// 	var levelDesc = Logger.getLevelDesc(logEvent.level); 
		// 	var msg = timeStamp + " " + levelDesc + ": " + logEvent.message;
		// 	_lc.send("lc_log", "update", msg);
		// } 

		public function destroy ():void {
			// _log.removeEventListener(LogEvent.UPDATE, logUpdateHandler);
		}
	}
}