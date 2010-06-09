package org.as3lib.kitchensync.core
{
	/**
	 * This type has the ability to be updated incrementally with time data.
	 *
	 * @author Mims Wright
	 * @since 2.1
	 */
	public interface IUpdatable
	{
		/**
		 * Updates the object with the current time.
		 * 
		 * @param currentTime The current time. 
		 */
		function update(currentTime:int):void;
	}
}