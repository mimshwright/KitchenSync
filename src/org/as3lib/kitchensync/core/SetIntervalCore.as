package org.as3lib.kitchensync.core
{
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * A Synchronizer core based on the setInterval function. 
	 * 
	 * @since 2.0
	 * @author Mims Wright
	 */
	 // todo: test
	 // Todo: add notes on performance.
	public class SetIntervalCore implements ISynchronizerCore
	{
		/** 
		 * The id of the interval 
		 */
		private var _id:int;
		
		/**
		 * The delay time of the interval in ms.
		 */
		private var _delay:int;
		
		public function SetIntervalCore(delay:int = 33)
		{
			_delay = delay;
		}
		
		public function start():void {
			_id = setInterval(onInterval, _delay);
		}

		public function stop():void {
			clearInterval(_id);
		}
		
		private function onInterval():void {
			Synchronizer.getInstance().dispatchUpdate();
		}
	}
}