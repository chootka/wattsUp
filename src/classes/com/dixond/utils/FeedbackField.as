package com.dixond.utils{
	
	/*
	*	TextField that allows for easy populating of individual lines. 
	*	Useful for debugging rapidly updating info e.g. serial port input values, object locs, etc 
	*	Instead of adding text directly to the field, we add it to an array, which then writes each array item to a line. 
	*	Currently uses an object so not really numbered. May go back to array, since dont think it wasn't what was causing the hanging bug...
	*	Need to guard against adding many lines repeatedly to the textfield...!!
	*	
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 10.0
	*
	*	@author 
	*	@since  16.08.2010
	*/
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.dixond.logging.Logger;
	
	public class FeedbackField extends TextField {
		
		private var _content:Object = {}; //Array = [];
		private var _format:TextFormat;
		private var _log:Logger;
		
		public function FeedbackField(aX:int, aY:int, aWidth:int, aHeight:int, aSize:int = 16, aColor:Number=0x000000, aFont:String="Verdana"){
			super();
			_log = Logger.getLog();
			this.x = aX;
			this.y = aY;
			this.width = aWidth;
			this.height = aHeight;
			var fmt:TextFormat = new TextFormat();
			fmt.size = aSize;
			fmt.color = aColor;
			fmt.font = aFont;
			this.defaultTextFormat = fmt;
			this.setTextFormat(fmt);
			_format = fmt;
		}
		
		// specify line numbers or labels. 
		public function setLine(aLineId:*, ... args) {
			// _log.debug("FeedbackField.setLine()", aLineId, "args=" + args);
			var str = "";
			for each (var a in args) {
				str += a + ", ";
			}
			str = str.substring(0, str.length-2); // remove the trailing comma
			_content[aLineId] = str;
			updateField();
		}
		
		public function clearLine(aLineId:*) { 
			_content[aLineId] = null;
			updateField();
		}
		
		private function updateField() {
			this.text = "" // clear the field out first!
			var str:String = "";
			for each(var t in _content) {
				str += (t + "\n");
			}
			this.text = str;
		}
		
		public function setBorder(aState:Boolean, aColor:Number=0x0) {
			this.border = aState;
			this.borderColor = aColor;
		}
		
		// note would need to make this class subclasss Sprite if we want an alpha background. 
		// Textfield doesn't have a graphics object to draw one on...
		public function setBackground(aState:Boolean, aColor:Number=0x0) {
			this.background = aState;
			this.backgroundColor = aColor;
		}
		
		public function setAlpha(a:Number) {
			this.alpha = a;
		}
		
		public function moveTo(aX:int, aY:int) {
			this.x = aX;
			this.y = aY;
		}
				
	}//end class
}//end package
