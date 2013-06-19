﻿package com.dixond.ia{	import flash.events.EventDispatcher;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	/**	*	XMLLoader  	*	Simplifies the reading of xml files by handling the URLRequest overhead	*	Dispatches Event.COMPLETE when done reading	*	Retreive loaded document via [XMLLoaderInstance].data	*	* @langversion ActionScript 3	* @playerversion Flash 9.0.0	*	* @author D	* @since  3.5.2008	*/	public class XMLLoader extends EventDispatcher {		/**		* data read from file		*/		private var _data:XML;		/**		* @filePath file to load @default 'settings.xml'		*/		public function XMLLoader(aFilePath:String):void {			readData(aFilePath);		}		/**		* read text data from specified file		*/		private function readData(aFilePath:String):void {			trace("XmlLoader.readData()", aFilePath);			var request:URLRequest = new URLRequest(aFilePath);			var urlLoader:URLLoader = new URLLoader();			urlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);			// catch any immediate errors			try {				urlLoader.load(request);			} catch (e:Error) {				//trace("ERROR: " + e);				throw new Error("Could not read xml file." + e.message);			}		}		private function loadCompleteHandler(aEvent:Event):void {			// trace("XMLLoader.loadCompleteHandler()", aEvent.target, aEvent);			// extract xml data from loader			_data = new XML(aEvent.target.data);			dispatchEvent(new Event(Event.COMPLETE));		}		private function loadErrorHandler(aEvent:IOErrorEvent):void {			// dispatch an error event if this doesn't load			dispatchEvent(aEvent);		}		/**		* returns whole xml doc		*/		public function get data():XML {			return _data;		}		public override function toString():String {			return "[object XMLLoader]";		}		// end class	}	// end package}