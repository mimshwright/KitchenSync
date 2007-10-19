package com.mimswright.sync
{
	/**
	 * Provides helpful utility functions for working with Timestamp objects.
	 * 
	 * @see Timestamp
	 */
	public class TimestampUtil
	{	
		/**
		 * Adds the two timestamps and returns a new one that is the sum of the two times.
		 * 
		 * @param timestampA
		 * @param timestampB
		 * @return the sum of timestampA and timestampB
		 */
		public static function add(timestampA:Timestamp, timestampB:Timestamp):Timestamp {
			return new Timestamp(timestampA.currentFrame + timestampB.currentFrame, timestampA.currentTime + timestampB.currentTime);
		}

		/**
		 * Subtracts timestampB from timestampA and returns the difference of the two times.
		 * 
		 * @param timestampA - the timstamp to subtract from.
		 * @param timestampB - the ammount of time to subtract from timestampA.
		 * @return the difference between timestampA and timestampB
		 */
		public static function subtract(timestampA:Timestamp, timestampB:Timestamp):Timestamp {
			return new Timestamp(timestampA.currentFrame - timestampB.currentFrame, timestampA.currentTime - timestampB.currentTime);
		}
	}
}