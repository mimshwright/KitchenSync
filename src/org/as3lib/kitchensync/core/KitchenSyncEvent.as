package org.as3lib.kitchensync.core
{
	import flash.events.Event;

	/**
	 * Event type that is dispatched by the Synchronizer and AbstractSynchronizedActions. 
	 */
	 // todo: review this class
	 // todo: make sure the stings and the constant names match.
	 // todo: rename timestamp
	public class KitchenSyncEvent extends Event
	{
		public static const START:String = "actionStart";
		public static const PAUSE:String = "actionPause";
		public static const UNPAUSE:String = "actionUnpause";
		public static const UPDATE:String = "synchronizerUpdate";
		public static const COMPLETE:String = "actionComplete";
		public static const CHILD_START:String = "childActionStart";
		public static const CHILD_COMPLETE:String = "childActionComplete";
		
		private var _timestamp:int;
		public function get timestamp():int { return _timestamp }
		
		public function KitchenSyncEvent(type:String, timestamp:int) {
			super(type, false, false);
			_timestamp = timestamp;
		}
		
	}
}