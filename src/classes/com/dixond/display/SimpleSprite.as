package com.dixond.display{
	/*
	*	SimpleSprite 
	*	Sprite that only allows one child object at a time on it's displayList. Adding a new child, replaces the old child
	*	
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*
	*	@author D
	*	@since  04.09.2007
	*/
	import flash.display.*;
	import flash.events.*;
	import com.dixond.utils.*;
	import com.dixond.logging.Logger;
	
	public class SimpleSprite extends Sprite {
	
		// a string identifier of this container. Also useful for debugging.
		// private var _name:String;
		
		/**
		*	Constructor
		*/
		public function SimpleSprite(aName:String = "") {
			this.name = aName
		}
		
		// ===== public methods ===== //
		
		/**
		*	hides object via visible property
		*/
		public function hide():void{
			this.visible = false;
		}
		
		/**
		*	displays object via visible property
		*/
		public function show():void {
			this.visible = true;
		}
		
		/**
		*	override the addChild function to return with a warning. 
		*	We don't want to allow adding more than one thing, so we force the use of setChild instead. 
		*	It simply outputs a warning.
		*/
		public override function addChild(aChild:DisplayObject):DisplayObject {
			trace("SimpleSprite.addChild()", aChild, aChild.name);
			trace("WARNING! Cannot use addChild() with SimpleSprite. Use setChild(aDisplayObject)");
			return null;
		}
					
		// the only means to assign a child to this Sprite. 
		public function setChild(aChild:DisplayObject):DisplayObject {
			trace("SimpleSprite.setChild()", aChild);
			// if any child is already present, remove it. Then add this one
			for (var i = 0; i < this.numChildren; i++) {
				super.removeChildAt(i);
			}
			return super.addChild(aChild);
		}
		
		public function clearChild():void {
			if (this.numChildren > 0) {
				removeChildAt(0);
			}
		}
		
		public function getChild():DisplayObject {
			if (this.numChildren > 0) {
				return this.getChildAt(0);
			}
			return null;
		}
		/**
		*	do any clean up before removing this container from the display
		*	this should be overridden to do specific things
		*/
		public function dispose():void {
			
		}
		
		/**
		*	provide more specific feedback in output statements
		*/
		public override function toString():String {
			return "[object Container: name=" + this.name + "]";
		}
				
	} // end class
}// end package
