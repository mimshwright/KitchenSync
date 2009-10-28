package org.as3lib.kitchensync.utils
{
	import org.as3lib.kitchensync.core.ISynchronizerClient;
	import org.as3lib.kitchensync.core.Synchronizer;

	/**
	 * A singleton class that can track the current and average framerate of the
	 * KitchenSync system (when using EnterFrameCore, this is the framerate of 
	 * the movie itself). The number of frames included in the average framerate can
	 * be set as well. For a quick visual display of the framerate, 
	 * use <code>FrameRateView</code>.
	 * 
	 * @see org.as3lib.kitchensync.utils.FrameRateView
	 * 
	 * @example 
	 *  <listing version="3.0">
	 *  // get the average framerate
	 *  FrameRateUtil.getInstance().averageFrameRate;
	 *  // set the number of frames to average for the averageFrameRate to 3
	 *  FrameRateUtil.getInstance().averageFrameRateDepth = 3;
	 * 	// get the framerate since the last frame
	 * 	FrameRateUtil.getInstance().instantaneousFrameRate; 
	 *  </listing>
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
			var avgDelta:Number = _cachedDeltaSum / _frameRateHistory.length;
			return Math.round(1000 / avgDelta);	
		}
		
		/** 
		 * Returns the immediate framerate since the last frame
		 * was updated.
		 */ 
		public function get instantaneousFrameRate():int {
			var delta:int =  _currentTime - _previousTime;
			return Math.round(1000 / delta);
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
		private var _cachedDeltaSum:int = 0;
		
		
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
			this._previousTime = this._currentTime;
			this._currentTime = currentTime;
			
			// add the time to the queue to be averaged.
			var delta:int = _currentTime - _previousTime;
			_frameRateHistory.unshift(delta);
			_cachedDeltaSum += delta;
			// if the queue is too long, remove the last one. 
			if (_frameRateHistory.length > averageFrameRateDepth) {
				_cachedDeltaSum -= _frameRateHistory.pop();
			}
		}
	}
}
class SingletonEnforcer {}