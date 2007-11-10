package com.mimswright.sync
{
	import flash.events.Event;

	public class SynchronizerEvent extends Event
	{
		public static const START:String = "ActionStart";
		public static const UPDATE:String = "SynchronizerUpdate";
		public static const COMPLETE:String = "ActionComplete";
		public static const CHILD_COMPLETE:String = "ChildActionComplete";
		
		private var _timestamp:Timestamp;
		public function get timestamp():Timestamp { return _timestamp }
		
		public function SynchronizerEvent(type:String, timestamp:Timestamp = null) {
			super(type, false, false);
			_timestamp = timestamp;
		}
		
	}
}