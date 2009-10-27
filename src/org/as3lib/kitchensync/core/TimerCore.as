package org.as3lib.kitchensync.core
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * A Synchronizer core based on a Timer class. 
	 * This is the default core for the Synchronizer.
	 * It allows the user to specify a timer interval or 
	 * automatically set it based on the framerate.
	 * 
	 * @since 2.0
	 * @author Mims Wright
	 */
	 // Todo: add notes on performance. 
	public class TimerCore implements ISynchronizerCore
	{
		/** 
		 * The actual timer object 
		 */
		private var _timer:Timer;
		
		public function TimerCore(interval:int = 33)
		{
			_timer = new Timer(interval);
		}
		
		/** @inherit */
		public function start():void {
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}

		/** @inherit */
		public function stop():void {
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer.stop();
		}
		
		private function onTimer(event:TimerEvent):void {
			Synchronizer.getInstance().dispatchUpdate();
		}
		
		/**
		 * Determines a Timer interval based on the frame rate.
		 * This will give you a number based on the optimal frame rate but
		 * may not necessarily provide the best performace.
		 */
		public function interpolateIntervalFromFrameRate(frameRate:int):void {
			var interval:int = Math.floor(1/frameRate*1000);
			if (_timer.running) {
				_timer.stop();
				_timer = new Timer(interval);
				_timer.start();
			}
			else {
				_timer = new Timer(interval);
			}
		}
	}
}