package org.as3lib.kitchensync.action.tween
{
	/**
	 * An algorithm that parses data from an object into tween data.
	 * 
	 * @see KitchenSyncObjectParser
	 * 
	 * @author Mims Wright
	 * @since 1.6
	 */
	public interface ITweenObjectParser
	{
		/** returns an action based on an object you provide. */
		function parseObject(object:Object):ITween;
	}
}