package com.mimswright.sync
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	[Event(name="synchronizerUpdate", type="com.mimswright.sync.SynchronizerEvent")]
	
	/**
	 * Synchronizer acts as the main time keeper for the animation engine. It uses the EnterFrame
	 * event of the Stage to trigger updates.
	 * 
	 * @author Mims H. Wright
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
		 * Use initialize() to set up the internal EnterFrame listener. Only needs to be called
		 * once. After that, use getInstance() to get references to the Synchronizer.
		 * 
		 * @see getInstance()
		 * @throws Error - if versionCheck fails
		 * @throws ArgumentError - if frameRateSeed isn't a part of the display list. 
		 * @throws IllegalOperationError - if initialize() has already been called.
		 * 
		 * @param frameRateSeed - This DisplayObject must be added to the stage. Use the application route.
		 * @param versionCheck - Use this to make sure the version of Synchronizer is what you're program expects.
		 * @return a reference to the only instance of the Synchronizer.
		 */
		public static function initialize(frameRateSeed:DisplayObject, versionCheck:String = VERSION):Synchronizer {
			if (versionCheck != VERSION) {
				throw new Error("Version check failed. Please update to the correct version or to continue using this version (at your own risk) put the initialize() method inside a try{} block.");
			}
			if (!_instance) {
				if (frameRateSeed && frameRateSeed.stage) {
					_instance = new Synchronizer(new SingletonEnforcer());
					_instance._stage = frameRateSeed.stage;
					_instance._stage.addEventListener(Event.ENTER_FRAME, _instance.onEnterFrame, false, int.MAX_VALUE, false);
					//_instance.onEnterFrame();
					//_instance._active = true;
					return _instance;
				} else {
					throw new ArgumentError("frameRateSeed must be a DisplayObject that is part of the Display List.");
				}
			} else {
				throw new IllegalOperationError("Synchronizer has already been initialized.");
			}
			return null;
		}
		
		/**
		 * Returns an instance to the single instance of the class. 
		 * Note: initialize() must be called before this function will work.
		 * 
		 * @see initialize()
		 * @throws Error - if initialize() was never called.
		 * @return a reference to the only instance of the Synchronizer.
		 */
		public static function getInstance():Synchronizer {
			if (_instance) { 
				return _instance;
			} else {
				throw new Error("Synchronizer must be initialized. Use Synchronizer.initialize()");
			}
		}
		
		/**
		 * Triggered by every passing frame of the Stage. Rebroadcasts the event with additional
		 * information about the time at which it occurred. 
		 */
		private function onEnterFrame(event:Event = null):void {
			_frames++;
			_previousTime = _currentTime;
			_currentTime = getTimer();
			dispatchEvent(new SynchronizerEvent(SynchronizerEvent.UPDATE, currentTimestamp));
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