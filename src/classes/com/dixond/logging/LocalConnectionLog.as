package com.dixond.logging {
	import com.dixond.logging.Logger;
	import com.dixond.events.LogEvent;
	import fl.controls.TextArea;
	import flash.text.TextFormat;
	import flash.events.StatusEvent;
	import flash.events.Event;;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.net.LocalConnection;
	
	 /**
	 *	Document class for a Flash projector that receives log messages from logging class LocalConnectionView 
	 *	This LocalConnection Object receives under the name "lc_log". So anyone wanting to send log messages to it must send to "lc_log"
	 *	NOTE: When the .fla doc is in the com.dixond.logging folder, this won't compile. Gives error #5001 about the Logger class' package declaration not matching it's file location. WTF?!
	 */
	public class LocalConnectionLog extends Sprite {
		private var _lc:LocalConnection;
		private var _ta:TextArea;
		private var _connectionName:String = "lc_log";
		private var _hMargin:Number;
		private var _vMargin:Number;

		 /**
		  * Constructor
		  */
		public function LocalConnectionLog () {
			// add listener for stage resize events
			this.stage.scaleMode = StageScaleMode.SHOW_ALL;
			this.stage.addEventListener(Event.RESIZE, resizeHandler);
			// make the receiving LC and prepare it for receiving.
			makeTextArea();
			_lc = new LocalConnection();
			_lc.client = this;
            try {
				_lc.allowDomain("*");
				_lc.connect(_connectionName);
            } catch (e:ArgumentError) {
                trace("lc_log can't connect: " + e);
            }
			update("lc_log connected\n");
	 	}
 		
		private function makeTextArea() {
			_ta = new TextArea();
			// _ta.setSize(630, 460);
			_hMargin = 5;
			_vMargin = 5;
			_ta.setSize(this.stage.stageWidth - (_hMargin * 2), this.stage.stageHeight - (_vMargin * 2));
			_ta.x = 5;
			_ta.y = 10;
			var fmt = new TextFormat();
			fmt.font = "Courier";
			fmt.size = 14;
			fmt.color = 0x000000;
			_ta.setStyle("textFormat", fmt);
			_ta.text = "starting lc_log...\n";
			// _ta.appendText("I’ve actually run into a case today where removing and adding the files does not fix the problem. I really wish I knew what was causing this. Sometimes it compiles fine, other times not. I’ve tried closing Flash and re-opening it in the hopes that it might be some kind of cache issue, but that still doesn’t work. Once I find a true workaround, I’ll post.")
	
 			this.addChild(_ta);
		}
		// NOTE: this doesn't work. Somehow the left of the stage is not at the left of the window, so you end up with lots of space on the left and the field cut off on the right
		//  i don't get it...
		function resizeTextArea() {
			_ta.setSize(this.stage.stageWidth - (_hMargin * 2), this.stage.stageHeight - (_vMargin * 2));
			// _ta.x = _hMargin;
			// _ta.y = _vMargin + 15;
			// _ta.setSize(this.stage.stageWidth, this.stage.stageHeight);
			_ta.x = -100;
			_ta.y = 0;
			this.x = 0;
			this.y = 0;
			trace("_ta loc=" + _ta.x, _ta.y, "sprite loc=" + this.x, this.y);
			trace("stage rect=" + this.stage.getBounds(this.stage), "sprite bounds=" + this.getBounds(this.stage));
			trace("text bounds to stage=" + _ta.getBounds(this.stage), "sprite bounds to this=" + _ta.getBounds(this));
		}
		function resizeHandler(aEvent:Event){
			trace("resizeHandler()", aEvent);
			resizeTextArea();
		}
	   /**
	    * Invoked when the log changes. For details, see the 
	    * Observer interface.
	    */
		public function update (aMsg):void {
			_ta.appendText(aMsg);
 			_ta.verticalScrollPosition = _ta.maxVerticalScrollPosition;
		} 

		public function destroy ():void {
			_lc.close();
			_lc = null;
		}
	}
}