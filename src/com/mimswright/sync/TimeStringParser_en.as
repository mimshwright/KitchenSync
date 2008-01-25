package com.mimswright.sync
{
	
	/**
	 * Parses a string into milliseconds or frames and returns an object that can be
	 * used by synchronized events.
	 */ 
	public class TimeStringParser_en implements ITimeStringParser
	{
		public static const MILLISECONDS:String = "milliseconds";
		public static const MILLISECONDS_VALUE:Number = 1;
		public static const SECONDS:String = "seconds";
		public static const SECONDS_VALUE:Number = 1000;
		public static const MINUTES:String = "minutes";
		public static const MINUTES_VALUE:Number = 60000;
		public static const HOURS:String = "hours";
		public static const HOURS_VALUE:Number = 3600000;
		public static const DAYS:String = "days";
		public static const DAYS_VALUE:Number = 86400000;
		
		public var result:TimeStringParserResult;
		private var _framesRX:RegExp = /([^a-z]|^)(f|fr|frames?)/;
		private var _millisecondsRX:RegExp = /([^a-z]|^)(ms|msecs?|milliseconds?)/;
		private var _secondsRX:RegExp = /([^a-z]|^)(s|secs?|seconds?)/;
		private var _minutesRX:RegExp = /([^a-z]|^)(m|mins?|minutes?)/;
		private var _hoursRX:RegExp = /(h|hrs?|hours?)/;
		private var _daysRX:RegExp = /(d|days?)/;
		
		public function TimeStringParser_en() {
			super();	
		}

		/**
		 * Parses a string into milliseconds or frames and returns an object that can be
		 * used by synchronized events. 
		 * Times can use multiple units. Each unit should be separated by a comma or a space.
		 * Units will only be detected if they are placed after the time value. 
		 * TimeUnit will be FRAMES if any frames are specified. Otherwise, MS will be used.
		 * If no time unit is specified, the result will use null for the time unit and
		 * the synchronized action will use its default.
		 * These are all valid options:
		 * "1 hour, 2 minutes, 3 seconds, 4 milliseconds"
		 * "1h2m3s4ms"
		 * "5sec,12fr"
		 * "300 frames"
		 * "1.25s"
		 * "5 milliseconds, 15mins, 6 hrs"
		 * "0.25 days"
		 * 
		 * @todo Add timecode notation
		 * 
		 * @param timeString - a string representing some ammount of time.
		 * @return A TimeStringParserResult object containing the time value and the timeUnit.
		 */
		public function parseTimeString(timeString:String):TimeStringParserResult
		{
			result = new TimeStringParserResult();
			
			// if the string is empty, throw an error. 
			if (!timeString) { throw new ParseError(ParseError.NO_DATA); return null;}
			
			// if string contains only a number value, return it and don't specify a time unit
			if (Number(timeString)) {
				result.time = Number(timeString);
				result.timeUnit = null;
				return result;
			}
			
			// make time string not case sensitive
			timeString = timeString.toLocaleLowerCase();
			
			// separate by number / unit pairs separated by spaces or commas.
			var unitValuePairs:Array = timeString.match(/(\d+(\.\d+)?)\s*[a-z]+\s*,?\s*/g);
			if (unitValuePairs.length < 1) {
				throw new ParseError(ParseError.MALFORMED_DATA + ": " + timeString);
				return null;
			}
			
			
			// check for time units
			if (unitValuePairs.toString().search(_framesRX) >= 0) {
				// use FRAMES if any part of the string contains frames as a unit.
				result.timeUnit = TimeUnit.FRAMES;
			} else {
				// otherwise use MILLISECONDS
				result.timeUnit = TimeUnit.MILLISECONDS;
			}
			
			var parsedPairs:Array = new Array();
			for each (var pair:String in unitValuePairs) {
				var time:Number = Number(pair.match(/\d+(\.\d+)?/g)[0]);
				var timeUnit:String = pair.match(/[a-z]+/)[0];
				
				if (timeUnit.search(_framesRX) >= 0) {
					// do nothing. no conversion needed
				} else {
					if (timeUnit.search(_millisecondsRX) >= 0) {
						//timeUnit = MILLISECONDS;
						time *= MILLISECONDS_VALUE;
					} else if (timeUnit.search(_secondsRX) >= 0) {
						//timeUnit = SECONDS;
						time *= SECONDS_VALUE;
					} else if (timeUnit.search(_minutesRX) >= 0) {
						//timeUnit = MINUTES;
						time *= MINUTES_VALUE;
					} else if (timeUnit.search(_hoursRX) >= 0) {
						//timeUnit = HOURS;
						time *= HOURS_VALUE;
					} else if (timeUnit.search(_daysRX) >= 0) {
						//timeUnit = DAYS;
						time *= DAYS_VALUE;
					} else {
						// this is probably a different type of unit.
						throw new ParseError(ParseError.MALFORMED_DATA);
						continue;
					}
					if (result.timeUnit == TimeUnit.FRAMES) {
						// convert ms to frames
						time = TimestampUtil.millisecondsToFrames(time);
					}
				}
				time = Math.round(time);
				result.time += time;
			} 
			
			//trace(result.time, result.timeUnit);
			
			return result;
		}
	}
}