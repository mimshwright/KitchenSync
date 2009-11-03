package org.as3lib.kitchensync.action
{
	import org.as3lib.kitchensync.action.IAction;

	/**
	 * An interface that adds methods to IAction for jumping to a certain time
	 * or by a certain time. This allows the action to be scrubbed or to be controlled
	 * in a way similar to video controls (with fast-forward and rewind).
	 * 
	 * @author Mims H. Wright
	 * @since 2.0
	 */
	public interface IJumpableAction extends IAction
	{
		/**
		 * Moves the playhead to a specified time in the action. If this method is called while the 
		 * action is paused, it will not appear to jump until after the action is unpaused.
		 * This function won't work for instantaneous actions.
		 * 
		 * @param time The time parameter can either be a number or a parsable time string. If the 
		 * time to jump to is greater than the total duration of the action, it will throw an IllegalOperationError.
		 * @param ignoreDelay If set to true, the delay will be ignored and the action will jump to
		 * the specified time in relation to the duration.
		 * 
		 * @throws flash.errors.RangeError If the time to jump to is before the start or after the end of the action.
		 * @throws flash.errors.IllegalOperationError If this method is called when the action isn't running.
		 */
		function jumpToTime(time:*, ignoreDelay:Boolean = false):void;
		
		/**
		 * Moves the playhead forward (or backward) by a specified time. If this method is called while the 
		 * action is paused, it will not appear to jump until after the action is unpaused.
		 * 
		 * @param time The time parameter can either be a number or a parsable time string.
		 * 
		 * @throws flash.errors.RangeError If the time to jump to is shorter or longer than the total time for the action.
		 * @throws flash.errors.IllegalOperationError If this method is called when the action isn't running.
		 */
		function jumpByTime(time:*):void;
	}
}