package com.dixond.display{
	
	/*
	*	
	*	 - very very very basic attempt at layer management. Needs more thinking out but no time for that!
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 10.0
	*
	*	@author 
	*	@since  14.06.2011
	*/
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import com.dixond.utils.Util;
	import com.dixond.log.Logger;
	
	public class LayerGroup extends Object {
		
		private var _layers:Object = {};
		private var _parent:DisplayObjectContainer;
		
		public function LayerGroup(aLayerNames:Array=null, aParent:DisplayObjectContainer=null, aAddToDisplay:Boolean=true, aMouseEnabled:Boolean=false){
			for each(var n in aLayerNames) {
				makeLayer(n, aParent, aAddToDisplay, aMouseEnabled);
			}
		}
		
		public function makeLayer(aLayerName:String, aParent:DisplayObjectContainer, aAddToDisplay:Boolean=true, aMouseEnabled:Boolean=false):void {
			var layer = new Sprite(); 
			layer.name = "layer_" + aLayerName;
			_layers[aLayerName] = layer;
			_parent = aParent;
			layer.mouseEnabled = aMouseEnabled;
			if (aAddToDisplay) {
				aParent.addChild(layer); 
			}
		}
		
		public function addToLayer(aLayerName:String, aObj:DisplayObject):void {
			// Logger.debug("LayerGroup.addToLayer()", aLayerName, aObj.name);
			_layers[aLayerName].addChild(aObj);
		}
		
		public function removeFromLayer(aObj:DisplayObject):void {
			// Logger.debug("LayerGroup.removeFromLayer()", aObj.name);
			Util.removeDisplayObject(aObj);
		}
		
		public function getLayer(aLayerName:String):Sprite {
			return _layers[aLayerName];
		}
		
		public function clearAll() {
			// removes display objects from all layers!
			for each(var layer in _layers) {
				clearLayer(layer);
			}
		}
		
		public function clearLayer(aLayerOrName:*) {
			// removes all displayObjects from this layer
			// can specfy the layer sprite directly or the name
			if (aLayerOrName is String) {
				var layer = _layers[aLayerOrName];
			} else if (aLayerOrName is Sprite) {
				layer = aLayerOrName;
			}
			
			// Logger.debug("LayerGroup.clearLayer()", this, aLayerOrName, layer);
			while (layer.numChildren > 0) {
				layer.removeChildAt(0);
			}
		}
		
		public function displayAllLayers() {
			// adds all layers in this set to _parent's displayList 
			for each(var layer in _layers) {
				_parent.addChild(layer);
			}
		}
		
		public function removeAllLayers() {
			// removes all layers in this set from the displayList
			for each(var layer in _layers) {
				Util.removeDisplayObject(layer);
				// Logger.debug("LayerGroup.removeAllLayers()", "removing: " + layer.name);
			}
		}
		
		public function setMouseEnabled(aLayerOrName:*, aState:Boolean) {
			if (aLayerOrName is String) {
				var layer = _layers[aLayerOrName];
			} else if (aLayerOrName is Sprite) {
				layer = aLayerOrName;
			}
			layer.mouseEnabled = aState;
		}
	}//end class
}//end package
