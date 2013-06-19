package com.dixond.display{
	/*
	*	Container - generic container superclass to contain & display a group of child display objects
	*	 			has some convenience methods for hiding, showing, and adding & removing from display
	*				- also has option to only allow a single child. Can update this child via setChild w/o having to specifically remove existing child.
	*	
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*
	*	@author D
	*	@since  04.09.2007
	*	
	*	updates
	*		- 8/21/08 - changed addTo to addToParent() to avoid various confusions.
	*/
	import flash.display.*;
	import flash.events.*;
	import com.dixond.utils.*;
	
	public class Container extends Sprite {
		
		private var _oneChildLimit:Boolean;
		
		// a string identifier of this container. Also useful for debugging.
		// private var _name:String;
		
		/**
		*	Constructor
		*/
		public function Container(aName:String = "", aOneChildLimit:Boolean = false) {
			_oneChildLimit = aOneChildLimit;
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
			// trace("Container.addChild()", aChild, aChild.name);
			if (_oneChildLimit) {
				trace("WARNING! This Container is restricted to one child. Use setChild(aDisplayObject)");
				return null;
			} else {
				return super.addChild(aChild);
			}
		}
		
		/**
		*	Only way to assign a child to this Container if it's restricted to one child. 
		*	If not restricted, behaves same as addChild().
		*/	
		public function setChild(aChild:DisplayObject):DisplayObject {
			// trace("Container.setChild()", aChild);
			if (_oneChildLimit) {
				// if any child is already present, remove it. Then add this one
				for (var i = 0; i < this.numChildren; i++) {
					super.removeChildAt(i);
				}
			} 
			return super.addChild(aChild);
		}
		
		/**
		*	removes child from restricted Container
		*/
		public function clearChild():void {
			if (this.numChildren > 0) {
				removeChildAt(0);
			}
		}
		
		/**
		*	adds this container object to displayList of the DisplayObjectContainer specified by aParent
		*/
		public function addToParent(aCont:DisplayObjectContainer, aIndex:int=-1):void {
			// trace("Container.addTo()", "this=" + this, "aCont=" + aCont, "dest container name=" + aCont.name);
			try{
				if (! isNaN(aIndex) && aIndex > -1 ) {
					aCont.addChildAt(this, aIndex);
				} else{
					aCont.addChild(this);
				}
			} catch (e:Error) {
				trace ("Container.addTo() - Could not add this Container to specified parent: " + this + ".\n\t" + e.message);
			}
			// trace("Container.addTo() POST ADD", "this=" + this, "new parent=" + this.parent, "parent name=" + this.parent.name);
		}
		
		/**
		*	removes this container from the display list of it's parent DisplayObjectContainer
		*/
		public function remove():void {
			try {
				if (this.parent != null) {
					this.parent.removeChild(this);
				}
			}catch(e:Error) {
				trace ("Container.remove() - Could not remove this Container from displayList: " + this + ".\n\t" + e.message);
			}
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
