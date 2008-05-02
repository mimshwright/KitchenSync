package org.as3lib.kitchensync
{
	/**
	 * Takes a string containing.
	 */
	public interface ITimeStringParser
	{
		/** Takes a time in string format and returns a number in milliseconds */
		function parseTimeString(timeString:String):int;
	}
}