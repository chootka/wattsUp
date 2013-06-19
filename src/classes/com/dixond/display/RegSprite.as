package com.dixond.display {
	
	/*
	*	RegSprite - Sprite with a registration point around which transformations can be made
	*	At least this is my attempt at such. Won't not cover all possibilities yet, cuz i only need a specific few.
	*	
	*	To move, rotate, or scale this object based on the regPoint, you must use the methods provided here. 
	*	When you want to treat it as a normal sprite, can just call normal sprite methods and properties
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 10.0
	*
	*	@author 
	*	@since  06.07.2011
	*/
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import fl.motion.MatrixTransformer;
	
	public class RegSprite extends Sprite {
		private var _origMatrix:Matrix; 		// matrix before any transformations. May use this for resetting...
		private var _baseMatrix:Matrix;			// matrix that all transformations are based off of
		private var _regPoint:Point;
		private var _currentRotation:Number;	// current rotation of this object in degrees
		private var _currentLoc:Point; 			// current loc based on regPoint
		private var _useCenterRegPoint:Boolean;
				
		public function RegSprite(aUseCenterRegPoint:Boolean=true){
			// setRegistration();
			_useCenterRegPoint = aUseCenterRegPoint;
			_origMatrix = this.transform.matrix;
			_baseMatrix = this.transform.matrix;
			_currentRotation = this.rotation;
		}
		
		public function setRegPoint(aX:Number = 0, aY:Number=0) {
			// setting a specific regPoint nullifies a true _useCenterRegPoint setting
			_regPoint = new Point(aX, aY);
			_useCenterRegPoint = false;
		}
				
		override public function addChild(aOb:DisplayObject):DisplayObject {
			// only allow one child, to keep it simple. That child can have as much content as it needs in it.
			// remove any existing children
			while(this.numChildren > 0) {
				this.removeChildAt(0);
			}
			var returnVal = super.addChild(aOb);
			// zero out the loc of child cuz it will affect the bounds returned by this container
			aOb.x = 0;
			aOb.y = 0;
			// if specified, center the regPoint to this content
			if (_useCenterRegPoint) {
				setCenterRegPoint();
			}
			// _baseMatrix = this.transform.matrix;
			return returnVal;
		}
		
		public function setCenterRegPoint() {
			// trick here is calculating the center point in a way that accounts for any scaling
			// the reg point must be based on the full scale of the object to work correctly

			// use getBounds with local coordinate space. 
			// This returns the orig with and height without scaling or rot factored in!
			var bounds = getBounds(this);
			var centerX = bounds.width/2;
			var centerY = bounds.height/2;
			_regPoint = new Point(centerX, centerY);
			_useCenterRegPoint = true;
			// trace("RegSprite.setRegitrationCenter()", "_regPoint=" + _regPoint);
		}
		
		//--------------------------------------
		//  sets the loc based on the registration point
		//--------------------------------------
		public function setLoc(aX:Number, aY:Number) {
			// var intPoint =  new Point(aAnchorX, aAnchorY);
			var extPoint = new Point(aX, aY);

			// dont use a clone of _baseMatrix here. here we're allowing it to update the stored matrix. 
			// hope we don't regret it...
			MatrixTransformer.matchInternalPointWithExternal(_baseMatrix, _regPoint, extPoint);
			// update the object immediately. Otherwise change not noticed until some other transformation occurs
			this.transform.matrix = _baseMatrix;
			_currentLoc = extPoint;
		}

		public function getLoc():Point {
			return _currentLoc;
		}
		
		//--------------------------------------
		//  sets the rotation to a specific number in degrees
		//	rotation is around the pre-specified _regPoint
		//--------------------------------------
		public function setRotation(aDegrees:Number) {
			// note that the matrix passed, must be a static unchanging matrix. 
			// So don't use the current matrix of the object.
		
			// to prevent alleged cumulative errors, we manually keep track of the rotation 
			//  instead of changing it in the _baseMatrix
			// use a clone of _baseMatrix to avoid altering it
			var mat:Matrix = _baseMatrix.clone(); // use a copy cuz it gets changed
			MatrixTransformer.rotateAroundInternalPoint(mat, _regPoint.x, _regPoint.y, aDegrees); 
			this.transform.matrix = mat;
			_currentRotation = this.rotation;
			// trace("RegSprite.setRotation()", "_currentRotation=" + _currentRotation);
		}
		
		public function getRotation():Number {
			return this.rotation;
		}
		
		//--------------------------------------
		//  increments the rotation by specified amountn of degrees
		//--------------------------------------
		public function rotate(aDegrees:Number) {
			// trace("RegSprite.rotate()", "_currentRotation=" + _currentRotation);
			var newRot = _currentRotation + aDegrees;
			// trace("\t", "newRot=" + newRot);
			setRotation(newRot);
		}
		
		//--------------------------------------
		//  sets the scale
		//--------------------------------------
		public function setScale(aX:Number, aY:Number) {
			// gonna alter the base matrix here
			MatrixTransformer.setScaleX(_baseMatrix, aX);
			MatrixTransformer.setScaleY(_baseMatrix, aY);
			// update the object immediately. Otherwise change not noticed until some other transformation occurs
			this.transform.matrix = _baseMatrix;
		}
		
		// function move(aDeltaY:Number, aDeltaY:Number) {
		// 	_currentX
		// }
	}//end class
}//end package
