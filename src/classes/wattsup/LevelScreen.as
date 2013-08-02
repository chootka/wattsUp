﻿package wattsup{	import com.chootka.utils.display.Rect;	import com.dixond.events.CustomEvent;	import com.dixond.ia.AppConfig;	import com.greensock.TweenLite;	import flash.display.Bitmap;	import flash.display.Shape;	import flash.display.Sprite;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.events.Event;	import flash.media.SoundChannel;	import flash.text.TextField;	import flash.text.TextFormat;		public class LevelScreen extends Screen 	{			// make a grid of boxes		private var _grid:Sprite = new Sprite();		private var _results:Sprite = new Sprite();		private var _maxCols:Number = 10;		private var _maxRows:Number = 17;		private var _col_w:Number = 161;		private var _col_h:Number = 54.7;		private var _colTotalHeight:Number = (_maxRows*_col_h) - _col_h;		private var _block_w:Number = 155;		private var _block_h:Number = 43;		private var _inactive_clr:Number = 0xbcbec0;		private var _active_clr:Number = 0xffffff;		private var _hilite_clr:Number = 0xf15523;		private var _currentLevel:int = 1;		private var _maxLevel:int = 4;		private var _instructions_txt:MLTextField;		private var _try_again_txt:MLTextField;		private var _challengeComplete:Boolean = false;		private var _timer:Timer;		private var _tryTimer:Timer;		private var _appArray:Array = [];		private var _applianceList:XMLList;		private var _objectsPerLevel:Array = [3, 6, 8, 10, 10];		private var _buzzplaying:Boolean = false;		private var _winplaying:Boolean = false;		private var _buzzChannel:SoundChannel;		private var _winChannel:SoundChannel;				public function LevelScreen(tm:MLTextManager, imageObj:Object, soundObj:Object, initLevel:int, maxLevel:int)		{			super(imageObj,soundObj,tm);						// 4px on L/R, 13px on top, 6px in between cols			// cols are 155 wide						_tm = tm;			_images = imageObj;			_sounds = soundObj;			_currentLevel = initLevel;			_maxLevel = maxLevel;			_timer = new Timer(1000,1);			_tryTimer = new Timer(3000,1);						// yellow side rect left			var left_bar:Rect = new Rect(0, 0, 155, 1081, 0xE9E732);			// blue top rect			var top_bar:Rect = new Rect(155, 0, 1615, 138, 0x67C9D1);			// yellow side rect right			var right_bar:Rect = new Rect(1771, 0, 155, 1081, 0xE9E732);			// green background			var bg:Rect = new Rect(155, 0, 1616, 1081, 0xB2DBB8);						// position the grid holder			bg.addChild(_grid);			_grid.x = AppConfig.settings.gridX;			_grid.y = AppConfig.settings.gridY;						_col_w = AppConfig.settings.total_width;			_col_h = AppConfig.settings.total_height;			_block_w = AppConfig.settings.block_width;			_block_h = AppConfig.settings.block_height;						// create text fields			_instructions_txt = new MLTextField(160, 25, 1600, 400);			_instructions_txt.selectable = false;			_tm.setFieldContent(_instructions_txt, "instructions_level1");						_try_again_txt = new MLTextField(160, 70, 1600, 400);			_try_again_txt.selectable = false;						// process the appliance XML			_applianceList = AppConfig.settings.appliance;						// add objects to stage			addToLayer([bg, left_bar, top_bar, right_bar, _instructions_txt, _try_again_txt]);		}				public function init( level:int ):void {			_log.info("init level " + level + " ");			_currentLevel = level;						_tm.setFieldContent(_instructions_txt, "instructions_level"+level);			_tm.setFieldContent(_try_again_txt, "");						// reset grid			_clearResults();						// based on what level we are on make those squares the active color			// make the rest inactive color			var posX:Number = 0;			var posY:Number = 0;			// only draw new columns			var starting:int = _currentLevel == 1 ? 0 : _objectsPerLevel[_currentLevel-2];			for (var j:int=starting; j<_maxCols; j++){				posX = j*_col_w;				posY = 0;								for (var i:int=0; i<_maxRows; i++) {					posY = i*_col_h;					var rectangle:Shape = new Shape();					rectangle.graphics.beginFill( j < _objectsPerLevel[_currentLevel-1] ? _active_clr : _inactive_clr );					rectangle.graphics.drawRect(posX, posY, _block_w, _block_h); 					rectangle.graphics.endFill();					_grid.addChild(rectangle);				}			}						// turn the tally light off			dispatchEvent( new CustomEvent( "onDeactivateTally" ) );						// cue level LEDs to light up, if we are not in attract loop mode			dispatchEvent( new CustomEvent( "onLightLevel", { level:_currentLevel } ) );						// finally, get what objects, if any, are currently in the dock			dispatchEvent( new CustomEvent( "onCheckForObjects" ) );		}				public function attractLoop( action:String ):void {			if( action == "start" ) {				// do stuff				_log.info("starting attract loop in level screen ");			}			else {				_log.info("stopping attract loop in level screen ");				// reset and start the game over at level 1				_appArray = [];				_timer.stop();				_tryTimer.stop();								// start the game over				_currentLevel = 1;				init( _currentLevel );			}		}				public function addObject( data:String ):void {			// dock number will be the first digit in the serial data			var dock = data.substring(0,1);			var id = data.substring(2,data.length-1);						// if an object is added to a dock not yet active, return			if (dock >= _objectsPerLevel[_currentLevel-1]) {				_log.info("object added to dock outside of current level. ");				// play buzz so they get negative feedback				//_sounds["buzz"].play();				return;			}						// to get around obj not being read at all, try taking the below conditional out. go ahead and let an object get read more than once, 			// i guess. just means that i will i have to remove all instances of it in 'removeObject' and will have to guard against 			// if the object added is already in the appArray, return			// check line 258 in checkOrder			//for (var k in _appArray) {				// don't add the same object twice				// check the tag ID				//if (_appArray[k].id == id) {					//_log.info("object is already in array ");					//return;				//}			//}						// otherwise, add the object			_appArray.push( {index:dock, id:id} );			_log.info("added object with id " + dock + " and rating " + _getRating(id) + " ");									// play 'beep' sound per column			_sounds["beep"].play();						// check to see if enough appliances have been added			if(_appArray.length >= _objectsPerLevel[_currentLevel-1]) {				_log.info("activate tally light ");				dispatchEvent( new CustomEvent( "onTallyReady" ) );			}		}				public function removeObject( index:String ):void {			for (var k in _appArray) {				if (_appArray[k].index == index) {					_appArray.splice(k, 1);					_log.info("removing object at dock " + index + " ");										// remove watts from screen, return color to active color, unless it is in a dock beyond the currently active docks					if (index < _objectsPerLevel[_currentLevel-1]) {						_toggleColumn( Number(index), _active_clr, 0 );					}					else {						_toggleColumn( Number(index), _inactive_clr, 0 );					}					//break;				}			}						// check to see if enough appliances have been removed			if(_appArray.length < _objectsPerLevel[_currentLevel-1]) {				_log.info("deactivate tally light ");				//dispatchEvent( new CustomEvent( "onDeactivateTally" ) );			}		}				public function checkOrder():void {			// if not enough objects are on the board, tell them to try again			//if(_appArray.length < _objectsPerLevel[_currentLevel-1]) {				//_log.info("checking order... but not enough!");				//_tryAgain();				//return;			//}			// otherwise, check to see that items were in the correct order						// remove all checks and exes			_clearResults();						_log.info("checkOrder ");			_log.info("_appArray.length: " + _appArray.length + " ");			_log.info("_objectsPerLevel[_currentLevel-1]: " + _objectsPerLevel[_currentLevel-1] + " ");						var prev_max:int = 0;			var ok:Boolean = true;			// sort array on descending index position			_appArray.sortOn( "index", Array.NUMERIC | Array.DESCENDING );			_appArray.reverse();						// look for duplicate objects by index number. remove them if they exist, before 			// looping thru array to tally up wattages!!!			for (var i:int = _appArray.length-1; i>0; --i) {				if (_appArray[i].id == _appArray[i-1].id) {					_appArray.splice(i,1);				}			}						for (var i=0; i<_objectsPerLevel[_currentLevel-1]; i++) { // in case they put down more than # of objs required for the level, only check up to the max # of objects per level				_log.info("i: " + i + " ");				_log.info("_appArray.length: " + _appArray.length + " ");								if ( i >= _appArray.length ) {					_log.info("i is greater than appArray length. NOT OK ");					ok = false;					break;				}								var rating = _getRating(_appArray[i].id);				_log.info("_appArray[i]: " + _appArray[i] + " ");				_log.info("rating: " + rating + " ");				_log.info("Math.max(prev_max, rating): " + Math.max(prev_max, rating) + " ");								// show watts on screen -- light the columns up				_toggleColumn( _appArray[i].index, _hilite_clr, rating );							// and do some value comparisions... are ratings going from low to high?				if ( Math.max(prev_max, rating) == rating ) {					_log.info("green check! ");					prev_max = rating;					// show check mark on column					var greencheck:Bitmap = new Bitmap(Bitmap(_images.greencheck).bitmapData);					_results.addChild(greencheck);					greencheck.x = (_appArray[i].index * _col_w) + (_col_w/2) - 25;					greencheck.y = 3;				}				else {					_log.info("red X! ");										ok = false;					// show x mark on column					var redx:Bitmap = new Bitmap(Bitmap(_images.redx).bitmapData);					_results.addChild(redx);					redx.x = (_appArray[i].index * _col_w) + (_col_w/2) - 25;					redx.y = 3;				}			}						_grid.addChild(_results);			ok ? _completeLevel() : _tryAgain();		}				private function _toggleColumn( dock:Number, clr:Number, rating:Number ):void {			var posY:Number = 0;			for (var j:int=0; j<_maxRows; j++){				var rectangle:Shape = new Shape();				// if j is less than the wattage rating (and therefore, number of blocks to light up in a column)				// OR rating is equal to zero (in which case, we are forcing it to a color. a rating of				// 0 is a special flag to indicate we are passing in a custom color), color the block				// the passed in color. otherwise, make it the active color				rectangle.graphics.beginFill( ( j < rating || rating == 0 ) ? clr : _active_clr );				rectangle.graphics.drawRect(dock*_col_w, Math.abs(posY-_colTotalHeight), _block_w, _block_h); 				rectangle.graphics.endFill();				_grid.addChild(rectangle);								// increment the posY 				posY += _col_h;			}		}				private function _getRating( id:String ):Number {			for (var i=0; i<_applianceList.length(); i++) {				if (id == _applianceList[i].id) return _applianceList[i].rating;			}						return 0;		}				private function _completeLevel():void {			_log.info("_completeLevel ");			_tm.setFieldContent(_instructions_txt, "");			_tm.setFieldContent(_try_again_txt, "");						// play 'win'			if( !_winplaying ) {			_log.info("play win ");				_winChannel = _sounds["win"].play();				//_winChannel.addEventListener(Event.SOUND_COMPLETE, _winComplete);				// reset _winplaying to false when new leve is initialized				_winplaying = true;			}						_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _onCompleteTimerEnd);			_timer.start();		}				private function _onCompleteTimerEnd(e:TimerEvent):void {			_log.info("_onCompleteTimerEnd ");			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onCompleteTimerEnd);						// after a delay of 5 seconds, advance to the next level			if( _currentLevel < _maxLevel ) {				init( ++_currentLevel );			}			else {				_completeChallenge();			}						_winplaying = false;		}				private function _tryAgain():void {			_log.info("_tryAgain ");			_tm.setFieldContent(_try_again_txt, "try_again", "redMed");						// play 'buzz'			if( !_buzzplaying ) {			_log.info("play buzz ");				_buzzChannel = _sounds["buzz"].play();				//_buzzChannel.addEventListener(Event.SOUND_COMPLETE, _buzzComplete);				_buzzplaying = true;			}						// after a delay of 5 seconds, reset current level			_tryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _onTryTimerEnd);			_tryTimer.start();		}				private function _onTryTimerEnd(e:TimerEvent):void {			_log.info("_onTryTimerEnd ");			_tryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onTryTimerEnd);			_buzzplaying = false;						_tm.setFieldContent(_try_again_txt, "");						// remove all checks and exes			_clearResults();		}				private function _completeChallenge():void {			_log.info("_completeChallenge ");			// reset			_appArray = [];			_timer.stop();			_tryTimer.stop();						// start the game over			_currentLevel = 1;			init( _currentLevel );		}				private function _clearResults():void {			_log.info("_clearResults ");			// remove all children of resuts			while(_results.numChildren > 0) _results.removeChildAt(0);			_log.info("_results.numChildren: " + _results.numChildren + " ");						if ( _grid.contains(_results) ) {				// then remove results				_grid.removeChild(_results);			}						_results = null;			_results = new Sprite();		}			}}