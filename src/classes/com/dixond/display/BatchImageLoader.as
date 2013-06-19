/* AS3
	Copyright 2008 .
*/
package com.dixond.display {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Bitmap;
	
	/*
	* 	BatchImageLoader - Loads a batch of images. Dispatches an event when done, or if errors occur
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*
	*	@author D
	* 	@since  24.06.2008
	*/	
	public class BatchImageLoader extends EventDispatcher {
		
		/**
		*	event contstants
		*/
		public static const LOAD_COMPLETE = "loadComplete";
		public static const LOAD_ERROR = "loadError";
		
		// temp array of loader objects that load the images.
		private var _loaders:Array;
		
		private var _imagesToLoad:uint;
		// increments when an image is loaded
		private var _imagesLoaded:uint;
		// any image that fails to load increments this var. 
		private var _errors:uint;
		
		// array of most recently loaded batch of images as Bitmap objects
		private var _bitmapArray:Array;
		// array of most recently loaded batch of images as BitmapData data objects
		private var _bitmapDataArray:Array;
		
		// if this is true, a new batch can be loaded. Otherwise a loading is in progress.
		private var _readyToLoad:Boolean;
		
		
		/**
		*	Constructor. Creates new BatchLoader Instance. If parameters passed to constructor, loading will begin automatically.
		*	Otherwise call loadImages() to begin loading. 
		*	@param aImgArray - (optional) array of file or path names. 
		*	@param aPath - (optional) base bath to append to all filenames in aImgArray. 
		*/
		public function BatchImageLoader(aFileArray:Array=null, aPath:String = "") {
			trace("BatchImageLoader()", "aFileArray=" + aFileArray, "aPath=" + aPath);
			_readyToLoad = true;
			
			if (aFileArray.length > 0) {
				loadImages(aFileArray, aPath);
			}
		}
		
		public function loadImages(aFileArray:Array, aPath:String = "") {
			if (!_readyToLoad) {
				// DO: THROW AN ERROR HERE. AND USE TRY CATCH...??
				trace("Batch loading in progress. Could not start new batch.");
			} else {
				_imagesToLoad = aFileArray.length;
				_imagesLoaded = 0;
				_errors = 0;
				_bitmapArray = [];
				_bitmapDataArray = [];
				_loaders = [];
			
				for (var i = 0; i < _imagesToLoad; i++) {
					var file = aPath + aFileArray[i];
					try {
						var url= new URLRequest(file);
					
						_loaders[i] = new Loader();
						_loaders[i].contentLoaderInfo.addEventListener(Event.INIT, loaderInitHandler);
						_loaders[i].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
						_loaders[i].load(url);
						trace("loading: " + url.url);
					} catch(e:Error) {
						// Logger.getLog().debug("Error in BatchImageLoader.loadImages(): " + e);
						trace("Error in BatchImageLoader.loadImages(): " + e);
					} 
				}
				// don't allow this batch to initiate another load until current batch is loaded
				_readyToLoad = false;
			}
		}
		
		private function loaderInitHandler(aEvent:Event) {
			trace("img loaded: " + aEvent.target);
			// add content as Bitmap to _bitmapArray - can't do that here, cuz we cant guarantee they'll load in order...
			// unload bitmap from loader so it can be GC's when loaders array is nulled (when batch is complete)
			// increment loaded count
			_imagesLoaded += 1;
			checkLoadStatus(); 
			// check to see if all are loaded
		}

		private function loaderErrorHandler(aEvent:IOErrorEvent){
			// what should we do about errors? Does one error kill the whole batch? Or do we just alert to a missing image...
			trace("Error:BatchImageLoader.loadErrorHandler(): " + aEvent.text);
			_errors += 1;
			checkLoadStatus();
		}
		
		private function checkLoadStatus() {
			trace("BatchImageLoader.checkLoadStatus()", "_imagesToLoad=" + _imagesToLoad, "_imagesLoaded="+ _imagesLoaded, "_errors="+_errors);
			if (_imagesLoaded + _errors == _imagesToLoad) {
				batchLoaded();
			}
		}
		
		private function batchLoaded() {
			// trace("BatchImageLoader.batchLoaded()");
			// transfer bitmap objects from _loaders to _bitmapArray and _bitmapDataArray
			for (var i = 0; i < _loaders.length; i++) {
				var bmp = Bitmap(_loaders[i].content);
				// only add content if it successfully loaded. Thus final batch length may be shorter than orig file array, if any files were not loaded
				if (bmp != null) {
					_bitmapArray.push(bmp);
					_bitmapDataArray.push(bmp.bitmapData);
				}
				// unload the bitmap from Loader so we can dispose of the Loader
				_loaders[i].contentLoaderInfo.removeEventListener(Event.INIT, loaderInitHandler);
				_loaders[i].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
				_loaders[i].unload();
				_loaders[i] = null;
			}
			// reset the _loaders array for next batch
			_loaders = [];
			_readyToLoad = true;
			// may make this a custom event so we can pass the _bitmapArray array with it...
			// params will be: _bitmapArray, error message (maybe an array of images that didn't load...)
			var evt = new Event(BatchImageLoader.LOAD_COMPLETE);
			dispatchEvent(evt);
		}
		
		/**
		*	returns the array currenly loaded bitmaps. 
		*/
		public function getBitmapArray() {
			return _bitmapArray;
		}
		
		public function getBitmapDataArray() {
			return _bitmapDataArray;
		}
	} // end class
} // end package
