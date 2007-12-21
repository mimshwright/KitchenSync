package com.mimswright.sync
{
	/**
	 * Takes a string containing.
	 */
	public interface ITimeStringParser
	{
		function parseTimeString(timeString:String):TimeStringParserResult;
	}
}