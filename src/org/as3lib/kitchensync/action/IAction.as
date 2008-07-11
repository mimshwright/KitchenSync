package org.as3lib.kitchensync.action
{
	import org.as3lib.kitchensync.core.ISynchronizerClient;
	
	/**
	 * An action is a type that represents any kind of happening that takes place at
	 * a certain time. 
	 * 
	 * @since 1.5.1
	 * @author Mims Wright
	 */
	public interface IAction extends ISynchronizerClient
	{
		/**
		 * duration is the length of time that the action will run.
		 * Uses * to allow use of time string parser.
		 */
		function get duration():int;
		function set duration(duration:*):void;
		
		/**
		 * delay is the time that will pass after the start() method is called
		 * before the action begins.
		 * Uses * to allow use of time string parser.
		 */
		function get delay():int;
		function set delay(delay:*):void; 
		
		/**
		 * Starts the timer for this action.
		 * 
		 * @return The action that was just started for convenience.
		 */
		function start():IAction;
		
		/**
		 * Stops the action from running and resets the timer.
		 */
		function stop():void;
	}
}