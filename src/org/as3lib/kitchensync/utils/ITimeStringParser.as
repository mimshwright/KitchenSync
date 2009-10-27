package org.as3lib.kitchensync.utils
{
	/**
	 * Converts a string representation of time and converts it into milliseconds. 
	 * For example, "2.65 seconds" would become the integer 2650.
	 * 
	 * @author Mims Wright
	 * @since 0.4.2
	 */
	public interface ITimeStringParser
	{
		/** Takes a time in string format and returns a number in milliseconds */
		function parseTimeString(timeString:String):int;
	}
}