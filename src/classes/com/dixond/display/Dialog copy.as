/* AS3
	Copyright 2008
*/
package com.dixond.display  {
	
	/*
	*	Dialog - Simple Ok dialog or Confirmation dialog with Ok or OK, Cancel buttons
	*		- Dispatches Event.SELECT when "OK" button is pressed, and Event.CANCEL when "Cancel" button pressed
	*		- NOTE: This needs to get cleaned up.
	*			- add border to bg shape
	*			- do some better centering of text
	*			- place center point of dialog at specified loc instead of top left. That way we don't need to calculate the loc in the calling code, but can just pass the center point of the parent.
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*
	*	@author D
	*	@since  30.10.2008
	*/
	
	import flash.display.Sprite; 
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	// import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	import fl.controls.TextArea;
	import fl.controls.Button; 
	
	import com.dixond.utils.Gui;

	public class Dialog extends Sprite {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		// may use this to keep track of any open dialogs...
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function Dialog(aParent:DisplayObjectContainer, aX, aY, aMsg:String, aIncludeCancel:Boolean = false, aOkButtonLabel:String="Ok", aCancelButtonLabel="Cancel"){
			// don't think we need to store refs since they'll only need to exist while on display
			// make the containing sprite
			var bgSprite = new Sprite();
			var w = 300;
			var h = 150;
			bgSprite.graphics.lineStyle(1, 0x000000, 1);
			bgSprite.graphics.beginFill(0xBBAABB, .95);
			bgSprite.graphics.drawRect(0, 0, 300, 150);
			
			var margin = 20;
			// make a specific sized field for now. Automatically center this later
			var fmt = new TextFormat();
			fmt.font = "Verdana";
			fmt.size = 12;
			fmt.color = 0x000000;
			
			var field = Gui.makeTextField("messageField", margin, margin, 250, 100, false);
			field.wordWrap = true;
			field.defaultTextFormat = fmt;
			// field.setStyle("textFormat", fmt);
			field.htmlText = aMsg;
			
			// make button(s)
			var buttonW = 60;
			var buttonH = 30;
			var okButton = Gui.makeButton(aOkButtonLabel, w - buttonW - margin, h - buttonH - margin, buttonW, buttonH);
			okButton.addEventListener(MouseEvent.CLICK, okButtonClickHandler);

			if (aIncludeCancel) {
				var cancelButton = Gui.makeButton(aCancelButtonLabel, okButton.x - buttonW - 25 , h - buttonH - margin, buttonW, buttonH);
				cancelButton.addEventListener(MouseEvent.CLICK, cancelButtonClickHandler);
				// bgSprite.addChild(cancelButton);
			}
			
			// add everything to display
			bgSprite.addChild(field);
			bgSprite.addChild(okButton);
			if (aIncludeCancel) {
				bgSprite.addChild(cancelButton);
			}
			
			this.addChild(bgSprite);
			// add this dialog to the specified parent
			this.x = aX - this.width/2;
			this.y = aY - this.height/2;
			aParent.addChild(this);
		}
		
		public function closeDialog() {
			this.parent.removeChild(this);
		}
		
		private function okButtonClickHandler(aEvent:MouseEvent) {
			dispatchEvent(new Event(Event.SELECT));
			closeDialog();
		} 
		
		private function cancelButtonClickHandler(aEvent:MouseEvent) {
			dispatchEvent(new Event(Event.CANCEL	));
			closeDialog();
		} 
		
		
	}// end class
}// end package
