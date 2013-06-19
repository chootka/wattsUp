package com.dixond.utils{
	/**
	Textd Class
	Some static TextField related functions
	*	Note: may combine with Stringd ??
	AS3 Update
	10/04/07
	
	*/
	
	import flash.text.*;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	
	public class Textd {

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
		
		
		// centers textField vertically (based on its textheight) within the the specified aTarget DisplayObject
		// 	-if no target object is passed, the fields parent DisplayObjectContainer is used
		//	-aOffset allows to adjust for diffs in lineheights in different fonts, resulting in variable centering	
		public static function getVerticalCenter(aField:TextField, aTarget:DisplayObject = null, aOffset:int = 0) {
			var target:DisplayObject = aTarget;
			if (target == null) {
				target = aField.parent;
			}
			// var textParent:DisplayObjectContainer = aField.parent;
			var h = aField.textHeight;
			// note: this calc doesn't work if the field is empty (cuz textHeight is 0?)
			if (aField.text != "") {
			 	var ypos = ((target.height - h)/2 ) + aOffset;
				return ypos;
			} else {
				// just return the original y, i guess
				return aField.y ;
			}
		}
		
		// keep the components out of this one, cuz otherwise you need to embed the components in to any fla that uses Textd
		// // scroll policy options are "on", "off", "auto" or ScrollPolicy.OFF, ON, AUTO
		// public static function makeTextArea(aName:String, aX:int, aY:int, aWidth:int, aHeight:int, aEditable:Boolean=false, aVScroll="auto") {
		// 	var tf = new TextArea();
		// 	tf.name = aName;
		// 	tf.x = aX;
		// 	tf.y = aY;
		// 	tf.width = aWidth;
		// 	tf.height = aHeight;
		// 	tf.editable = aEditable;
		// 	tf.verticalScrollPolicy = aVScroll;
		// 	return tf;
		// }

		// end class
	}
	// end package
}