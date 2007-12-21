package com.mimswright.sync
{
	/**
	 * An enumeration listing the differnt types of time units supported by KitchenSync. 
	 * 
	 * @todo docs
	 * @todo implement seconds
	 */
	final public class TimeUnit {
		
		/** Use whole and fractions of seconds as the unit of time. */
		//public static const SECONDS:TimeUnit = new TimeUnit("seconds");
		/** Use milliseconds (1/1000th of a second) as the unit of time. */
		public static const MILLISECONDS:TimeUnit = new TimeUnit("milliseconds");
		/** Use frames based on the current framerate as the unit of time. */
		public static const FRAMES:TimeUnit = new TimeUnit("frames");
		
		/** 
		 * The default timeunit is variable and should be set 
		 * to one of the other timeunits above. 
		 */
		public static var DEFAULT:TimeUnit = MILLISECONDS;
	
		
		
		// The string equivelant of the TimeUnit
		private var _string:String;
		
		public function TimeUnit(string:String = "") {
			_string = string;
		} 
		
		public function toString():String {
			if (!_string) { return super.toString(); }
			return _string;
		}
	}
}