package com.mimswright.sync
{
	/**
	 * Timestamp encapsulates an instant as a frame number and a real time so that either may be used for 
	 * calculating synchronicity.
	 */
	public class Timestamp
	{
		private var _currentTime:Number = 0;
		public function get currentTime():Number { return _currentTime; }
		
		private var _currentFrame:Number = 0;
		public function get currentFrame():Number { return _currentFrame; }
		
		public function Timestamp(frame:Number, currentTime:Number) {
			_currentFrame = frame;
			_currentTime = currentTime;
		}
		
		public function toString():String {
			return currentTime + " msec; " + currentFrame + " frames";
		}
	}
}