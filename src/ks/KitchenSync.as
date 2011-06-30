package ks
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	
	import ks.core.EnterFrameCore;
	import ks.core.ISynchronizerCore;
	import ks.core.Synchronizer;
	import ks.utils.ITimeStringParser;
	import ks.utils.KitchenSyncDefaults;
	

	/**
	 * Gateway to the library. Initializes the entire system.
	 * 
	 * @example 
	 *  Initialize with default settings.
	 * 	<listing version="3.0">
	 * 	KitchenSync.initialize(this);
	 * 	</listing>
	 * 
	 *  Initialize with a specific core and version checking.
	 * 	<listing version="3.0">
	 * 	KitchenSync.initializeWitCore(new EnterFrameCore(this), "2.0");
	 * 	</listing>
	 * 
	 * @see ks.core.Synchronizer
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
		public static const VERSION:String = "3.0";
			
		/**
		 * A reference to the stage. Can be set here and if defined may be used when 
		 * the stage is needed to figure out framerates and such.
		 */
		public static var stage:Stage; 
		
		
		/**
		 * Will return true once the initialize function has been called.
		 */
		public static function get isInitialized():Boolean { return _isInitialized; }
		private static var _isInitialized:Boolean = false;
		
		/**
		 * A reference to the time string parser used in KitchenSync.
		 * The default is defined in KitchenSyncDefaults.
		 * 
		 * @see ks.utils.ITimeStringParser
		 */
		public static function get timeStringParser():ITimeStringParser { 
			if (_timeStringParser == null) {
				_timeStringParser = KitchenSyncDefaults.timeStringParser;
			} 
			return _timeStringParser; 
		}
		public static function set timeStringParser(timeStringParser:ITimeStringParser):void { _timeStringParser = timeStringParser; }
		private static var _timeStringParser:ITimeStringParser;
		
		/**
		 * Initializes the timing core for KitchenSync. 
		 * As of 2.0.1 no longer required to start KitchenSync
		 * By default, the system uses EnterFrameCore as the core but other cores can be specified by
		 * calling initializeWithCore() instead. 
		 * 
		 * @example <listing version="3.0">
		 * // In most circumstances you can initialize KS by adding this line to  
		 * // the main funciton of your program (or in the first frame)
		 * KitchenSync.initialize();
		 * </listing>
		 * 
		 * @deprecated
		 * 
		 * @see #initializeWithCore()
		 * 
		 * @param versionCheck a string for the version you think you're using. e.g. 1.2 This is recommended
		 * 					   but not required. It will throw an error if you're using the wrong version of KS. 
		 */
		public static function initialize(stage:Stage = null, versionCheck:String = VERSION):void
		{	
			var core:ISynchronizerCore = new EnterFrameCore();
			initializeWithCore(core, stage, versionCheck);
		}
		
		/**
		 * Allows you to specify a synchronizer core when you initialize the system.
		 * This can be any of the ISynchronizerCores and will allow you to use enterframes, timers, or other mehtods
		 * to drive the dispatches of your synchronizer. If this sounds too complicated, you can use
		 * the default settings by calling <code>KitchenSync.initialize()</code>
		 *
		 * @see #initialize()
		 * @see ks.core.ISynchronizerCore
		 *  
		 * @param synchronizerCore The synchronizer core to use to drive updates.
		 * @param versionCheck a string for the version you think you're using. e.g. 1.2 This is recommended
		 * 					   but not required. It will throw an error if you're using the wrong version of KS. 
		 */
		public static function initializeWithCore(synchronizerCore:ISynchronizerCore, stage:Stage = null, versionCheck:String = VERSION):void {
			KitchenSync.stage = stage;
			
			if (_isInitialized) {
				trace("Warning: KitchenSync has already been initialized.");
				return;
			}
			if (versionCheck != VERSION) {
				throw new Error ("Version check failed. You tested for version " + versionCheck + " but it's actually version " + VERSION + ". Some syntax may have changed in this version.");
			}
			
			
			var synchronizer:Synchronizer;
			synchronizer = Synchronizer.getInstance();
			synchronizer.core = synchronizerCore;
			
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

