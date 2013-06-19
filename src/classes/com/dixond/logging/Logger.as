package com.dixond.logging {
	import flash.events.EventDispatcher;
	import com.dixond.events.LogEvent;
	
  /**
   * 	A general log class. Derived from Moock's ASDG2 Observer sample.
   *	This one uses AS3's Event model instead of the Observer / Observable interfaces
   *
   *	Use getLog() to create an app-wide instance.
   * 	Send messages with fatal(), error(), warn(), info(), and debug().
   * 	Add views for the log with addEventListener()
   * 
   * 	@version 1.0.0
   */
  public class Logger extends EventDispatcher {
    // Static variable. A reference to the log instance (Singleton).
    private static var _log:Logger = null;

    // The possible log levels for a message.
    public static var FATAL:Number = 0;
    public static var ERROR:Number = 1;
    public static var WARN:Number  = 2;
    public static var INFO:Number  = 3;
    public static var DEBUG:Number = 4;

    // private var lastMsg:LogMessage;

    // The human-readable descriptions of the above log levels.
    public static var levelDescriptions:Array = ["FATAL", "ERROR", 
                                           "WARN", "INFO", "DEBUG"];

    // The zero-relative filter level for the log. Messages with a level 
    // above logLevel will not be passed on to observers.
    // Default is 3, "INFO" (only DEBUG messages are filtered out).
    private var _logLevel:Number;

    /**
     * Logger Constructor
     */
    // ## THIS IS A SINGLETON, CONSTRUCTOR SHOULD BE PRIVATE
    // BUT PRIVATE CONSTRUCTORS AREN'T IN ActionScript 3.0 YET
    public function Logger () {
      // Show "INFO" level messages by default.
      setLevel(Logger.INFO);   
    }

    /**
     * Returns a reference to the log instance.
     * If no log instance exists yet, creates one.
     *
     * @return   A Logger instance.
     */
    public static function getLog():Logger {
      if (_log == null) {
        _log = new Logger();
      }
      return _log;  
    }

    /**
     * Returns a human readable string representing the specified log level.
     */
    public static function getLevelDesc(aLevel:Number):String {
      return levelDescriptions[aLevel];
    }

    /**
     * Sets the message filter level for the log.
     *
     * @param   lev   The level above which messages are filtered out.
     */
    public function setLevel(aLevel:Number):void {
      // Make sure the supplied level is an integer.
      aLevel = Math.floor(aLevel);
      // Set the log level if it's one of the acceptable levels.
      if (aLevel >= Logger.FATAL && aLevel <= Logger.DEBUG) {
        _logLevel = aLevel;
        info("Log level set to: " + aLevel);
        return;
      }
      // If we get this far, the log level isn't valid.
      warn("Invalid log level specified.");
    }

    /**
     * Returns the message filter level for the log.
     */
    public function getLevel():Number {
      return _logLevel;
    }

    // /**
    //  * Returns the most recent message sent to the log.
    //  */
    // public function getLastMsg():LogMessage {
    //   return lastMsg;
    // }

    /**
     * Sends a message to the log, with severity "FATAL".
     */
    public function fatal(... msg):void {
      // If the filter level is at least "FATAL", broadcast the message to observers.
      if (_logLevel >= Logger.FATAL) {
 		// send the event to any listeners
		dispatchEvent(new LogEvent(LogEvent.UPDATE, Logger.FATAL, msg.join()));
		
       }
    }

    /**
     * Sends a message to the log, with severity "ERROR".
     */
    public function error(... msg):void {
      // If the filter level is at least "ERROR", broadcast the message to observers.
      if (_logLevel >= Logger.ERROR) {
 		// send the event to any listeners
		dispatchEvent(new LogEvent(LogEvent.UPDATE, Logger.ERROR, msg.join()));

      }
    }

    /**
     * Sends a message to the log, with severity "WARN".
     */
    public function warn(... msg):void {
      // If the filter level is at least "WARN", broadcast the message to observers.
      if (_logLevel >= Logger.WARN) {
 		// send the event to any listeners
 		dispatchEvent(new LogEvent(LogEvent.UPDATE, Logger.WARN, msg.join()));
      }
    }
  
    /**
     * Sends a message to the log, with severity "INFO".
     */
    public function info(... msg):void {
      // If the filter level is at least "INFO", broadcast the message to observers.
      if (_logLevel >= Logger.INFO) {
 		// send the event to any listeners
		dispatchEvent(new LogEvent(LogEvent.UPDATE, Logger.INFO, msg.join()));
      }
    }

    /**
     * Sends a message to the log, with severity "DEBUG".
     */
    public function debug(... msg):void {
      // If the filter level is at least "DEBUG", broadcast the message to observers.
      if (_logLevel >= Logger.DEBUG) {
 		// send the event to any listeners
		dispatchEvent(new LogEvent(LogEvent.UPDATE, Logger.DEBUG, msg.join())	);
      }
    }
  }
}