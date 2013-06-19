package com.dixond.display {
	
	
	/*
	*   Animates sequence of BitmapData objects. Renders to BitmapData object. Is not automatically associated with any DisplayObject.
	*	Dispatches Event.INIT event when images are loaded and ready to animate
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*
	*	@author D
	*	@since  09.07.2008
	*/
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.geom.Point;
	
	import com.dixond.display.BasicAnimator;
	import com.dixond.display.BatchImageLoader;
	
	public class BitmapDataAnim extends EventDispatcher{
		// public static const LOADED:String = "loaded";
		// the BitmapData object that the current frame gets drawn to. MAY RENAME THIS TO BUFFER FOR SOME CLARITY
		private var _bitmapData:BitmapData;
		// array of bitmapData to be animated. 
		private var _imageArray:Array;
		// Animator instance that handles timing and such
		private var _animator:BasicAnimator;
		
		private var _loops:uint;
		private var _fps:uint;
		private var _largestBitmap:BitmapData;
		
		public function BitmapDataAnim(aFileNameArray:Array, aFps:uint, aLoops:uint = 0, aPath:String = ""){
			
			_loops = aLoops;
			_fps = aFps;
			_imageArray = [];
			// load the bitmaps via batch loader
			var batch = new BatchImageLoader(aFileNameArray, aPath);
			batch.addEventListener(BatchImageLoader.LOAD_COMPLETE, batchLoaderCompleteHandler);
		}
		
		private function batchLoaderCompleteHandler(aEvent:Event) {
			_imageArray = aEvent.target.getBitmapDataArray();
			aEvent.target.removeEventListener(BatchImageLoader.LOAD_COMPLETE, batchLoaderCompleteHandler);
			
			// make the animator now that all files have been succes loaded. Unloaded files were not loaded and thus will not be included in the count
			var totalFrames:uint = _imageArray.length;
			_animator = new BasicAnimator(totalFrames, _fps, _loops);
			_animator.addEventListener(BasicAnimator.UPDATE_FRAME, updateFrameHandler);
			var maxWidth:int = 0;
			var maxHeight:int = 0;
			// make the drawing bitmap based on the size of the largest image
			for (var i = 0; i < _imageArray.length; i++) {
				var img = _imageArray[i];
				var w = img.rect.width;
				var h = img.rect.height;
				if (w > maxWidth) {
					maxWidth = w;
				}
				if (h > maxHeight) {
					maxHeight = h;
				}
			}
			// trace("BitmapDataAnim.batchLoaderCompleteHandler()", "max w, h=" + maxWidth, maxHeight);
			// do we want a background color option...??
			_bitmapData = new BitmapData(maxWidth, maxHeight, true, 0x00FFFFFF);
			// alert any listeners that we're ready to start
			dispatchEvent(new Event(Event.INIT));
		}
		
		private function updateFrameHandler(aEvent:Event) {
			// erase frame first by drawing an empty bitmap over it. Note the bitmapData has transparency, but we dont copy the alpha. 
			var clearImg = new BitmapData(_bitmapData.rect.width, _bitmapData.height, true, 0x00FFFFFF);
			_bitmapData.copyPixels(clearImg, clearImg.rect, new Point(0,0), null, null, false);
		
			// draw the image for this frame
			var index = aEvent.target.getFrame() - 1;	
			var img = _imageArray[index];
			_bitmapData.copyPixels(img, img.rect, new Point(0,0), null, null, true);
		}
		
		public function start() {
			_animator.start();
		}
		
		public function stop() {
			_animator.stop();
		}
		
		public function reset() {
			// note this stops the timer as well as resetting it
			_animator.reset();
		}
		
		// jump to first frame of anim. Does not stop the anim. Mirrors typical movie / anim player controls.
		public function rewind() {
			_animator.rewind();
		}
		
		// jump to last frame of anim. Does not stop anim if it's looping. Otherwise anim stops at end.
		public function end() {
			_animator.end();
			// _currentFrame = _frames;
			// dispatchEvent(new Event(Animator.UPDATE_FRAME));
		}
		
		public function setFrame(aFrame:uint):void {
			_animator.setFrame(aFrame);
			// _currentFrame = aFrame;
			// dispatchEvent(new Event(Animator.UPDATE_FRAME));
		}
		
		public function getFrame():uint {
			return _animator.getFrame();
			// return _currentFrame;
		}
		
		public function getBitmapData():BitmapData {
			return _bitmapData;
		}
	}// end class
}// end package
