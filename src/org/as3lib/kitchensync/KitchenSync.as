package org.as3lib.kitchensync
{
	import flash.errors.IllegalOperationError;
	
	import org.as3lib.kitchensync.core.ISynchronizerCore;
	import org.as3lib.kitchensync.core.Synchronizer;
	import org.as3lib.kitchensync.core.TimerCore;
	import org.as3lib.kitchensync.utils.ITimeStringParser;
	

	/**
	 * Gateway to the library. Initializes the entire system.
	 * 
	 * @example 
	 *  Initialize with default settings.
	 * 	<listing version="3.0">
	 * 	KitchenSync.initialize();
	 * 	</listing>
	 * 
	 *  Initialize with a specific core and version checking.
	 * 	<listing version="3.0">
	 * 	KitchenSync.initializeWitCore(new EnterFrameCore(this), "2.0");
	 * 	</listing>
	 * 
	 * @see org.as3lib.kitchensync.core.Synchronizer
	 * 
	 * @since 1.2
	 * @author Mims H. Wright
	 */ 
	 
	 // TODO: go through this list of optimizations http://www.insideria.com/2009/04/51-actionscript-30-and-flex-op.html
	public final class KitchenSync
	{
		/** 
		 * The current version of the library. Use this to verify that the library is the
		 * version that your software expects. 
		 */ 
		public static const VERSION:String = "2.0"
		
		/**
		 * Will return true once the initialize function has been called.
		 */
		public static function get isInitialized():Boolean { return _isInitialized; }
		private static var _isInitialized:Boolean = false;
		
		/**
		 * A reference to the time string parser used in KitchenSync.
		 * The default is defined in KitchenSyncDefaults.
		 * 
		 * @see org.as3lib.kitchensync.utils.ITimeStringParser
		 */
		public static function get timeStringParser():ITimeStringParser { return _timeStringParser; }
		public static function set timeStringParser(timeStringParser:ITimeStringParser):void { _timeStringParser = timeStringParser; }
		private static var _timeStringParser:ITimeStringParser;
		
		/**
		 * Initializes the timing core for KitchenSync. Must be called before using any actions.
		 * 
		 * @param frameRate Is an optional parameter that allows you to set the rate of the dispatches.
		 * 					This can be different than the SWF's framerate but for best results, use the framerate of the swf.
		 * 					The system may not perform well over 60.
		 * @param versionCheck a string for the version you think you're using. e.g. 1.2 This is recommended
		 * 					   but not required. It will throw an error if you're using the wrong version of KS. 
		 */
		 // todo: make the library auto-initializing
		public static function initialize(frameRate:int = 30, versionCheck:String = VERSION):void
		{	
			var core:TimerCore = new TimerCore();
			core.interpolateIntervalFromFrameRate(frameRate);
			initializeWithCore(core, versionCheck);
		}
		
		/**
		 * Allows you to specify a synchronizer core when you initialize the system.
		 * This can be any of the ISynchronizerCores and will allow you to use enterframes, timers, or other mehtods
		 * to drive the dispatches of your synchronizer. If this sounds too complicated, you can use
		 * the default settings by calling <code>KitchenSync.initialize()</code>
		 *
		 * @see #initialize()
		 * @see org.as3lib.kitchensync.core.ISynchronizerCore
		 *  
		 * @param synchronizerCore The synchronizer core to use to drive updates.
		 * @param versionCheck a string for the version you think you're using. e.g. 1.2 This is recommended
		 * 					   but not required. It will throw an error if you're using the wrong version of KS. 
		 */
		public static function initializeWithCore(synchronizerCore:ISynchronizerCore, versionCheck:String = VERSION):void {
			if (_isInitialized) {
				// todo make this error optional.
				throw new IllegalOperationError("KitchenSync has already been initialized.");
			}
			if (versionCheck != VERSION) {
				throw new Error ("Version check failed. Please update to the correct version or to continue using this version (at your own risk) put the initialize() method inside a try{} block.");
			}
			var synchronizer:Synchronizer;
			synchronizer = Synchronizer.getInstance();
			synchronizer.core = synchronizerCore;
			
			timeStringParser = KitchenSyncDefaults.timeStringParser;
			_isInitialized = true;
		}
		
		/**
		 * Constructor. Not used.
		 */
		public function KitchenSync () {
			throw new IllegalOperationError ("There is no need to instantiate this class. use KitchenSync.initialize() instead");
		}
	}
}

