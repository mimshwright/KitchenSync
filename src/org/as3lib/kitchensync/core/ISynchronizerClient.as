package org.as3lib.kitchensync.core
{
	/**
	 * A consumer of the Synchronizer class. This type has the ability to be updated incrementally
	 * with time data.
	 *
	 * @author Mims Wright
	 * @since 1.6
	 */
	public interface ISynchronizerClient
	{
		/**
		 * Update will allow the synchronizer to update the action with the current time.
		 * 
		 * @param currentTime The current time from the synchronizer. 
		 */
		function update(currentTime:int):void;
	}
}