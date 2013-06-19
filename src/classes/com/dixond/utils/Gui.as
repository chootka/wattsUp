package com.dixond.utils{
	/**
	Gui Class
	Some static function shortcuts to creating gui objects
	*	Note: using this class requires that all the specified components below must be present in the source fla's Library, or else this will not compile.
	*	Will try to find some workaround for this...
	AS3 Update
	10/04/07
	
	*/
	
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import fl.controls.TextArea;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.ComboBox;
	import fl.controls.NumericStepper
	import fl.data.DataProvider;
	
	public class Gui {

		/**
		*  creates a new TextField instance, named and sized to order
		*/
		public static function makeTextField(aName:String, aX:int, aY:int, aWidth:int, aHeight:int, aSelectable:Boolean=false) {
			var tf = new TextField();
			tf.name = aName;
			tf.x = aX;
			tf.y = aY;
			tf.width = aWidth;
			tf.height = aHeight;
			tf.selectable = aSelectable;
			return tf;
		}
		
		// makes TextArea component
		// scroll policy options are "on", "off", "auto" or ScrollPolicy.OFF, ON, AUTO
		public static function makeTextArea(aName:String, aX:int, aY:int, aWidth:int, aHeight:int, aEditable:Boolean=false, aVScroll="auto") {
			var tf = new TextArea();
			tf.name = aName;
			tf.x = aX;
			tf.y = aY;
			tf.width = aWidth;
			tf.height = aHeight;
			tf.editable = aEditable;
			tf.verticalScrollPolicy = aVScroll;
			return tf;
		}
		
		// makes a Button Component.
		// Note must have the component in Fla's library
		// note same string will be used for name and label. If name needs to be diff, it can be set after the fact
		public static function makeButton(aLabel:String, aX:int, aY:int, aWidth:int = 80, aHeight:int = 30 ) {
			var btn = new Button();
			btn.name = aLabel;
			btn.label = aLabel;
			btn.x = aX;
			btn.y = aY;
			btn.width = aWidth;
			btn.height = aHeight;
			return btn;
		}
		
		// makes a label that automatically places itself in relation to a display object. 
		// the default offsets place it on the top left of the display object. The width defaults to the width of the display object. Can set after the fact if needed
		// note the label can contain regular or html text and is set via the .text or .htmlText properties. We're using htmlText here for max flexibility
		// note: width can be an int or null. If null, it will default to the width of the display object it's labeling.
		public static function makeObjectLabel(aLabel:String, aDisplayObj:DisplayObject, aWidth:* = null, aHeight:int = 20, aOffsetX:int = 0, aOffsetY:int = 0) {
			var l = new Label();
			l.htmlText = aLabel;
			if (aWidth == null) {
				l.width = aDisplayObj.width;
			} else {
				l.width = aWidth;
			}
			l.height = aHeight;
			l.x = aDisplayObj.x + aOffsetX;
			l.y = aDisplayObj.y - l.height + aOffsetY;
			return l;
		}
		
		// makes a label (not associated with any other object) with the specified params
		public static function makeLabel(aLabel:String, aX:int, aY:int, aWidth:int = 80, aHeight:int = 20) {
			var l = new Label();
			l.htmlText = aLabel;
			l.width = aWidth;
			l.height = aHeight;
			l.x = aX;
			l.y = aY;
			return l;
		}
		
		// note aItems is an array of Objects e.g. [{label:String, data:*},{label:String, data:*}] destined for the comboBox's DataProvider 
		// note: dataProvider items can have additional properties. "data" property seems to be implied convention, but not required...
		// Note that "label" required if you want to see anything in the combo list.
		public static function makeComboBox(aItems:Array, aX:int, aY:int, aPrompt:String = "", aWidth:int = 200, aHeight:int = 22) {
			var cb = new ComboBox(); 
			cb.x = aX;
			cb.y = aY;
			cb.setSize(aWidth, aHeight);
			cb.prompt = aPrompt;
			
			// create dataProvider and add the specified items to it
			var dp = new DataProvider();
			cb.dataProvider = dp;
			for each(var thisObj in aItems) {
				dp.addItem(thisObj);
			}
			return cb;       
		}
		
		public static function makeNumericStepper(aMin:int, aMax:int, aX:int, aY:int, aWidth:int = 50, aHeight:int = 20, aStepSize:int = 1) {
			var stepper = new NumericStepper();
            stepper.stepSize = aStepSize;
            stepper.minimum = aMin;
            stepper.maximum = aMax;
            stepper.width = aWidth;
			stepper.height = aHeight;
            stepper.move(aX, aY);
			return stepper;
		}
		
		// returns an x coordinate adjacent to specified display object plus specified offset
		public static function getAdjacentX(aDisplayObject:DisplayObject, aOffset:int) {
			return aDisplayObject.x + aDisplayObject.width + aOffset;
		}
		// returns an y coordinate adjacent to specified display object plus specified offset
		public static function getAdjacentY(aDisplayObject:DisplayObject, aOffset:int) {
			return aDisplayObject.y + aDisplayObject.height + aOffset;
		}
		
		// end class
	}
	// end package
}