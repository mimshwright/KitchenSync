package org.as3lib.kitchensync.action
{
	/**
	 * An action for tracing a message. Very useful when stringing together 
	 * several actions in a group to report the progress of a group but can 
	 * also be used to simply delay a trace by a specified time.
	 * 
	 * @author Mims Wright
	 * @since 0.1
	 * 
	 * @example <listing version="3.0">
	 * // trace a message after 5 seconds
	 * new KSTrace("5 seconds have elapsed.", 5000).start();
	 * 
	 * // trace when the first url in the group finishes loading.
	 * new KSSequenceGroup(
	 * 	new KSURLLoader("http://www.example.com/1"),
	 * 	new KSTrace("Example 1 loaded. loading example 2."),
	 * 	new KSURLLoader("http://www.example.com/2")
	 * ).start();
	 * </listing>
	 */
	public class KSTrace extends KSFunction
	{
		/** The message to trace. */
		public function get message():String { return _args[0]; }
		public function set message(message:String):void { _args[0] = message; }
		
		/**
		 * Constructor.
		 * @param message - the message to be displayed in the trace window.
		 * @param delay - the time to wait before tracing in frames.
		 */
		public function KSTrace(message:*, delay:* = 0)
		{
			super(trace, delay, message.toString());
		}
		
		/** @inheritDoc */
		override public function clone():IAction { 
			var clone:KSTrace = new KSTrace(message, _delay);
			clone.autoDelete = _autoDelete;
			return clone;
		}
		
	}
}