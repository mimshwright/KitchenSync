package org.as3lib.kitchensync.core
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	[Event(name="synchronizerUpdate", type="org.as3lib.kitchensync.KitchenSyncEvent")]
	
	/**
	 * Synchronizer acts as the main time keeper for the animation engine. 
	 * 
	 * @author Mims H. Wright
	 * @since 0.1
	 */
	public class Synchronizer extends EventDispatcher
	{
		/** 
		 * The current version of the library. Use this to verify that the library is the
		 * version that your software expects. 
		 */ 
		public static const VERSION:String = "1.1"
			
		private static var _instance:Synchronizer = null;
		private var _stage:Stage = null;
		
		private var _frames:Number = 0;
		private var _previousTime:Number  = 0;
		private var _currentTime:Number = 0;
		//private var _active:Boolean = true;
		//public function get active ():Boolean { return _active; }
		//public function set active (active:Boolean):void { _active = active; }
		
		/** The frameRate (as defined in the stage) */
		public function get frameRate():int {return _stage.frameRate; }
		//public function get actualFrameRate():Number {
		//	return 1000/(_currentTime - _previousTime);	
		//}
		
		/**
		 * Constructor. SingletonEnforcer prevents this class from being instantiated without
		 * using the initialize() method.
		 * 
		 * @param enforcer - a SingletonEnforcer can only be created internally.
		 */
		public function Synchronizer(enforcer:SingletonEnforcer) { 
			super(); 
		}
		
		/**
		 * Sets the framerate seed for the synchronizer.
		 * @param frameRateSeed must be a DisplayObject that is added to the display list.
		 * @since 1.2
		 */ 
		public function set frameRateSeed(frameRateSeed:DisplayObject):void {
			if (frameRateSeed && frameRateSeed.stage) {
				_stage = frameRateSeed.stage;
				_stage.addEventListener(Event.ENTER_FRAME, _instance.onEnterFrame, false, int.MAX_VALUE, false);
			} else {
				throw new ArgumentError("frameRateSeed must be a DisplayObject that is part of the Display List.");
			}
		}
		
		
		/**
		 * Returns an instance to the single instance of the class. 
		 * 
		 * @return a reference to the only instance of the Synchronizer.
		 */
		public static function getInstance():Synchronizer {
			if (_instance == null) {
				_instance = new Synchronizer(new SingletonEnforcer()); 
			}
			return _instance;
		}
		
		/**
		 * Triggered by every passing frame of the Stage. Rebroadcasts the event with additional
		 * information about the time at which it occurred. 
		 */
		private function onEnterFrame(event:Event = null):void {
			_frames++;
			_previousTime = _currentTime;
			_currentTime = getTimer();
			dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.UPDATE, currentTimestamp));
			//trace(currentTimestamp);
		}
		
		/**
		 * Returns the current time as a timestamp object.
		 */
		public function get currentTimestamp():Timestamp {
			return new Timestamp(_frames, _currentTime);
		}
		
	}
}
class SingletonEnforcer {}