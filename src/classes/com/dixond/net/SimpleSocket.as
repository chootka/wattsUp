/* AS3
	Copyright 2008
*/
package com.dixond.net {
	
	/*
	*	SimpleSocket - a simple socket class that allows sending and reading text strings from a port
	*	
	*	Notes:
	*		- updated to store the read data in _dataReceived property. 
	*		- 	thus multiple objects can listen for the SOCKET_DATA event and have access to the results (since reading clears the data)
	*		- 	to retrieve the most recently read data, call getData() after a SOCKET_DATA event
	*	TO DO:
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*
	*	@author D
	*	@since  16.07.2008
	*/
		
	import flash.net.Socket;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.errors.IOError;
	import com.dixond.logging.Logger;
	
	public class SimpleSocket extends Socket {
		private var _log:Logger;
		private var _dataReceived:String; 
		
		// params not necessary here, but if not specified will need to call connect() to initiate the connection
		public function SimpleSocket(aHost:String = null, aPort:int = 0){
			super(aHost, aPort);
			_log = Logger.getLog();
			_log.debug("SimpleSocket()", aHost, aPort);
			// trace("SimpleSocket()", aHost, aPort);
			// add event listeners
			configureListeners();
		}
		
		private function configureListeners():void {
		        addEventListener(Event.CLOSE, closeHandler);
		        addEventListener(Event.CONNECT, connectHandler);
		        addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		        addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		
				// listen with a high priority, so this listener gets handled before any others. 
				// thus, this object can read the data in buffer first and store it.
		        addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler, false, 1000); 
		}
		
		private function connectHandler(aEvent:Event):void {
			_log.debug("SimpleSocket.connectHandler() ----");
		}
		
		private function ioErrorHandler(aEvent:IOErrorEvent):void {
			_log.error("SimpleSocket could not connect: " + aEvent.text);
		}
		
		private function securityErrorHandler(aEvent:SecurityErrorEvent):void {
			_log.error("SimpleSocket could not connect: " + aEvent.text);
		}
		
		private function socketDataHandler(aEvent:ProgressEvent) {
			 _log.debug("socket data received: " + this.bytesAvailable);
			// read the data as a string and store it, since it gets cleared from the buffer
			_dataReceived = readData();
		}
		
		private function closeHandler(aEvent:Event):void {
			_log.warn("SimpleSocket has been closed.");
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		// public function connect(aHost:String, aPort:int) {
		// 	super(aHost, aPort);
		// }
		
		public function send(aData:String) {
			// _log.debug("SimpleSocket.send()", aData);
			try {
				this.writeUTFBytes(aData);
				this.flush();
			} catch(e:Error) {
				_log.error("SimpleSocket could not send data: " + e.message);
			}		
		}
		
		public function readData() {
			//Note: reading the buffer clears it.
			try {
				// QUESTION: Is this a one time read? Or do we want to accumulate the results of all reads?
				return this.readUTFBytes(this.bytesAvailable);
				// _log.debug("data: " + _dataReceived);
			} catch (e:Error) {
				_log.error("SimpleSocket could not read data: " + e.message	);
			}
		}
		
		public function getData():String {
			return _dataReceived;
		}
		
	}// end class
}// end package
