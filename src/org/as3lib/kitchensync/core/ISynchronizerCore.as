package org.as3lib.kitchensync.core
{
	import flash.events.IEventDispatcher;
	
	/**
	 * A timer of some kind that drives the Synchronizer updates. This
	 * could be a Timer, an enter frame event, or some other method.
	 * 
	 * @since 2.0
	 * @author Mims Wright
	 */
	public interface ISynchronizerCore
	{
		/**
		 * Starts the timing core counting.
		 */
		function start():void;
		/**
		 * Stops the timing core.
		 */
		function stop():void;
	}
}