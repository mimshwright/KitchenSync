package com.mimswright.sync
{
	import com.mimswright.easing.Linear;
	
	public class ActionDefaults
	{
		// ALL ACTIONS
		public static var autoDelete:Boolean = false;
		public static var sync:Boolean = true;
		public static var timeUnit:TimeUnit = TimeUnit.MILLISECONDS;
		public static var timeStringParser:ITimeStringParser = new TimeStringParser_en();
		public static var easingFunction:Function = Linear.ease;
		
		// TWEENS
		public static var snapToValueOnComplete:Boolean = false;
		public static var snapToWholeNumber:Boolean = false;
	}
}