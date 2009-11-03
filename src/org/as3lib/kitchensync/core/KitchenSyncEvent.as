package org.as3lib.kitchensync.core
{
	import flash.events.Event;

	/**
	 * Event type that is dispatched by the Synchronizer and actions.
	 * It contains the time that the event was dispatched (regulated by the 
	 * synchronizer).
	 * 
	 * @since 0.1
	 * @author Mims H. Wright 
	 */
	public class KitchenSyncEvent extends Event
	{
		
		/**
		 * Dispatched by the Synchronizer class at regular intervals.
		 *
		 * @eventType synchronizerUpdate
		 */
		public static const SYNCHRONIZER_UPDATE:String = "synchronizerUpdate";
		
		/**
		 * Dispatched at the start of an action when the start() method is called
		 * or when the action is started within a group.
		 *
		 * @eventType actionStart
		 */
		public static const ACTION_START:String = "actionStart";
		
		/** 
		 * Dispatched when the action is paused successfully.
		 * 
		 * @eventType actionPause
		 */
		public static const ACTION_PAUSE:String = "actionPause";

		/** 
		 * Dispatched when the action is resumed successfully.
		 * 
		 * @eventType actionUnpause
		 */
		public static const ACTION_UNPAUSE:String = "actionUnpause";

		/** 
		 * Dispatched when an action is completed.
		 * 
		 * @eventType actionComplete
		 */
		public static const ACTION_COMPLETE:String = "actionComplete";

		/** 
		 * Dispatched by an action group when one of its children is started.
		 * 
		 * @eventType childActionStart
		 */
		public static const CHILD_ACTION_START:String = "childActionStart";

		/** 
		 * Dispatched by an action group when one of its children completes.
		 * 
		 * @eventType childActionComplete
		 */
		public static const CHILD_ACTION_COMPLETE:String = "childActionComplete";
		
		/**
		 * The time (in terms of the Synchronizer) at which the event was dispatched. 
		 */
		private var _timestamp:int;
		public function get timestamp():int { return _timestamp }
		
		/**
		 * Constructor.
		 * 
		 * @param type Event type.
		 * @param timestamp The time at which the event was dispatched.
		 */
		public function KitchenSyncEvent(type:String, timestamp:int) {
			super(type, false, false);
			_timestamp = timestamp;
		}
		
	}
}