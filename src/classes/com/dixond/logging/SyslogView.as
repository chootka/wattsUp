package com.dixond.logging {
	import flash.net.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.errors.IOError;
	import com.dixond.logging.Logger;
	import com.dixond.events.LogEvent;
	import com.dixond.utils.TimeStamp;


	 /**
	 *	SyslogView - An obserSyslogViewver of the Logger class. Sends log messages to a syslog server. 
	 *	Some notes about syslog:
	 *		Syslog message consists of the following 
	 *			PRIORITY - number representing the facility and level surrounded by <>. E.g. <8>
	 *			HEADER - consists of TIMESTAMP and HOSTNAME. Each must be followed by single SPACE char.
	 *			MESSAGE - contains TAG (appname or process sending message. 32 chars max) and CONTENT (freeform detailed msg. )
	 *		Each Syslog message includes a priority value at the beginning of the text. 
	 *		The priority value ranges from 0 to 191 and is made up of a Facility value and a Level value. 
	 *		The priority is enclosed in "<>" delimiters. Calc priority via: Priority = Facility * 8 + Level 
	 *	
	 *		Level codes used by syslog
	 *		0 Emergency: system is unusable 
			1 Alert: action must be taken immediately 
			2 Critical: critical conditions 
			3 Error: error conditions 
			4 Warning: warning conditions 
			5 Notice: normal but significant condition 
			6 Informational: informational messages 
			7 Debug: debug-level messages 
	*	
	*	Note: Only the following levels (used by the Logger Class) are used by SyslogView and passed to the syslog:
	*		0 Fatal
	*		3 Error
	*		4 Warn
	*		6 Info
	*		7 Debug
	*	Note: Flash has no easy way to get it's own ip address. So we may not pass that value in the HOSTNAME part syslog message.
			

	 */
	public class SyslogView extends AbstractLogView{
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		// always use "user-level messages" as the facility. The code for this is 1
		private const FACILITY:int = 1;
		private const TCP_PORT:int = 1468;
		private const SPACE:String = " ";
		private const COLON:String = ":";
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		// The log that this object is observing.
		
		// map for selected syslog levels (for now only using the level labels that Logger's also uses). Maps Logger levels to syslog equivalents
		private var _loggerToSyslogLevels:Object = {"FATAL":0, "ERROR":3, "WARN":4, "INFO":6, "DEBUG":7};
		private var _socket:Socket;
		// object with data about the host for use in the id and tag fields in syslog message. Tag is by convention the application name. 
		// private var _info:Object;
		// can be ip or domain name. Used as an identifier.
		private var _clientAddress:String;
		// name of the application running. Also used to identify the source of log entries in the console  
		private var _appName:String;
		private var _host:String;
		
		/**
		 * Constructor
		 *	aLog - reference to the Logger object we're observing
		 *	aClientIP and AppName - identifying info that gets sent in the syslog message. Including address (ideally domain or ip address) and TAG (usually the app name).
		 *		I usually leave _clientAddress empty or as a dummy string (e.g. "x.x.x.x") because 
		 *			- flash can't get it's own ip. And most of the time for us it's not even relevant except to satisfy the syslog protocol. 
		 *			- both Kiwi (win daemon) and syslog-ng seem to figure it out anyway. So it's redundant
		 *	aAppName - name of the app that instantiated the syslog. Used to identify the source of syslog messages in the console. 
		 *	- note the tag property should not inculde any spaces or colon or "[" as theses are seen as terminating characters for this field
		 */		
		
		public function SyslogView (aLog:Logger, aHost:String, aClientAddress:String = "x.x.x.x", aAppName:String = "") {
			super(aLog);
			_socket = new Socket();
			// _info = aInfo;
			_clientAddress = aClientAddress;
			_appName = aAppName;
			_host = aHost;
			// register with log to receive log messages
			// _log.addObserver(this);
			_log.addEventListener(LogEvent.UPDATE, logUpdateHandler);
			// add the listeners
	        _socket.addEventListener(Event.CONNECT, socketConnectHandler);
	        _socket.addEventListener(Event.CLOSE, socketCloseHandler);
	        _socket.addEventListener(IOErrorEvent.IO_ERROR, socketIoErrorHandler);
	       	_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socketSecurityErrorHandler);
	        _socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			
			_socket.connect(_host, TCP_PORT);
		}
		private function socketConnectHandler(aEvent:Event) {
			enable();
			_log.info("// ======= Connected to syslog daemon at " + _host + ":" + TCP_PORT + " ======= //");
			dispatchEvent(aEvent);
		}
		private function socketCloseHandler(aEvent:Event) {
			_log.debug("SyslogView.closeHandler()");
			dispatchEvent(aEvent);
			disable();
		}
		private function socketIoErrorHandler(aEvent:IOErrorEvent) {
			// _log.error("SyslogView.ioErrorHandler() " + aEvent.text);
			_log.warn("Unable to connect to syslog daemon. " + aEvent.text);
			dispatchEvent(aEvent);
			disable();
		}
		private function socketSecurityErrorHandler(aEvent:SecurityErrorEvent) {
			_log.error("SyslogView.ioErrorHandler() " + aEvent.text);
			dispatchEvent(aEvent);
			disable();
		}
		// shouldn't ever receive anything...
		private function socketDataHandler(aEvent:ProgressEvent) {
			dispatchEvent(aEvent);
			_log.debug("SyslogView.socketDataHandler() " + aEvent);
		}

		/**
		 * Invoked when the log changes. For details, see the 
		 * Observer interface.
		 */
		public function logUpdateHandler (aEvent:LogEvent):void {
			var logEvent:LogEvent = aEvent as LogEvent;
		 	var loggerLevelDesc:String = Logger.getLevelDesc(logEvent.level);
			// add a linebreak after message, cuz syslog-ng on mac seems to prefer it. 
			// Otherwise all messages are buffered until the swf or app quits.
			var logMsg = logEvent.message;
			// format the message in manner appropriate to syslog (RFC 3164)
			var syslogLevel = getSyslogLevel(loggerLevelDesc);
			var priority = FACILITY * 8 + syslogLevel;
			var timestamp = TimeStamp.getSyslogTimeStamp(new Date());
			var msg = "<" + priority + ">" + timestamp + SPACE + _clientAddress + SPACE + _appName + " - " + loggerLevelDesc + ": " + logMsg;
			sendData(msg);
		}
		
		private function sendData(aMsg:String) {
			// avoid stack overloads on failed logging by disabling this log when its write target is not available.
            // _socket.writeUTFBytes(aMsg);
			if (_enabled) {
				try {            
				    _socket.writeUTFBytes(aMsg);
				}
				catch (e:IOError) {
				    // handle error here
					disable();
					// other logs should still display this error
					_log.debug("Could not write to the log file at " + _host + ". " + e );
				}
			}
		}

		private function getSyslogLevel(aLoggerLevelDesc:String) {
			return _loggerToSyslogLevels[aLoggerLevelDesc];
		}
		public function destroy ():void {
			_socket.close();
			 _log.removeEventListener(LogEvent.UPDATE, logUpdateHandler);
		}
	}
}