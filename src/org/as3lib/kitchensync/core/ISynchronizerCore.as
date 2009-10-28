package org.as3lib.kitchensync.core
{
	/**
	 * Provides a timing core for the Synchronizer. This allows the user to swap out
	 * different methods for time-keeping, be it an enterFrame based system, a Timer, 
	 * setInterval, or some other event.
	 * Each pulse from the ISynchronizerCore will trigger the dispatchUpdate() event in 
	 * the Synchronizer.
	 * 
	 * @see org.as3lib.kitchensync.core.Synchronizer 
	 * 
	 * @since 2.0
	 * @author Mims H. Wright
	 */
	public interface ISynchronizerCore
	{
		/** Starts the core dispatching events. */
		function start():void;
		
		/** Stops the core dispatching events. */
		function stop():void;
	}
}