package ks.utils
{
	import ks.core.ISynchronizerClient;
	import ks.core.Synchronizer;

	/**
	 * A singleton class that can track the current and average framerate of the
	 * KitchenSync system (but not necessarily the framerate of the SWF itself). 
	 * The number of frames included in teh average framerate can
	 * be set as well. For a quick visual display of the framerate, 
	 * use <code>FrameRateView</code>.
	 * 
	 * @see org.as3lib.kitchensync.utils.FrameRateView
	 * 
	 * @use <code>
	 *  // get the average framerate
	 *  FrameRateUtil.getInstance().averageFrameRate;
	 *  // set the number of frames to average for the averageFrameRate to 3
	 *  FrameRateUtil.getInstance().averageFrameRateDepth = 3;
	 * 	// get the framerate since the last frame
	 * 	FrameRateUtil.getInstance().instantaneousFrameRate; 
	 *  </code>
	 * 
	 * @author Mims Wright
	 * @since 2.0
	 */
	public class FrameRateUtil implements ISynchronizerClient
	{
		/** The number of framerates to hold in the history */
		public var averageFrameRateDepth:int = 10;
		
		
		/**
		 * Returns the average framerate over the last n frames.
		 */
		public function get averageFrameRate():Number {
			return Math.round(1000 / _cachedAverageDelta / _frameRateHistory.length);	
		}
		
		/** 
		 * Returns the immediate framerate since the last frame
		 * was updated.
		 */ 
		public function get instantaneousFrameRate():int {
			var delta:int =  _currentTime - _previousTime;
			return Math.round(1000/delta);
		}

		
		private static var _instance:FrameRateUtil = null;
		
		private var _previousTime:int = 0;
		private var _currentTime:int = 0;
		
		/** 
		 * This array acts as a buffer to hold the past few framerates.
		 */
		private var _frameRateHistory:Array = [];
		
		/** 
		 * Contains the sum of the past few changes in time between frames.
		 * This is a more optimized way to find the average framerate than
		 * using a for loop over the history array.
		 */
		private var _cachedAverageDelta:int;
		
		
		/**
		 * Constructor.
		 */
		public function FrameRateUtil(singletonEnforcer:SingletonEnforcer)
		{
			Synchronizer.getInstance().registerClient(this);
		}
		
		/**
		 * Returns an instance to the single instance of the class. 
		 * 
		 * @return a reference to the only instance of the Synchronizer.
		 */
		public static function getInstance():FrameRateUtil {
			if (_instance == null) {
				_instance = new FrameRateUtil(new SingletonEnforcer()); 
			}
			return _instance;
		}
		
		
		/**
		 * Framerate is updated by the synchronizer pulses.
		 */
		public function update(currentTime:int):void {	
			_previousTime = _currentTime;
			_currentTime = currentTime;
			
			// add the time to the queue to be averaged.
			var delta:int = currentTime - _previousTime;
			_frameRateHistory.unshift(delta);
			_cachedAverageDelta += delta;
			// if the queue is too long, remove the last one. 
			if (_frameRateHistory.length > averageFrameRateDepth) {
				_cachedAverageDelta -= _frameRateHistory.pop();
			}
		}
	}
}
class SingletonEnforcer {}