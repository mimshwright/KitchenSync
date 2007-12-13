package com.mimswright.sync
{
	import flash.events.Event;

	/**
	 * Event type that is dispatched by the Synchronizer and AbstractSynchronizedActions. 
	 * 
	 * @todo - take the timestamp property out of this class. This value can always be gotten from the synchronizer.
	 */
	public class SynchronizerEvent extends Event
	{
		public static const START:String = "ActionStart";
		public static const PAUSE:String = "ActionPause";
		public static const UNPAUSE:String = "ActionUnpause";
		public static const UPDATE:String = "SynchronizerUpdate";
		public static const COMPLETE:String = "ActionComplete";
		public static const CHILD_START:String = "ChildActionStart";
		public static const CHILD_COMPLETE:String = "ChildActionComplete";
		
		private var _timestamp:Timestamp;
		public function get timestamp():Timestamp { return _timestamp }
		
		public function SynchronizerEvent(type:String, timestamp:Timestamp = null) {
			super(type, false, false);
			_timestamp = timestamp;
		}
		
	}
}