package org.as3lib.kitchensync
{
	import org.as3lib.kitchensync.easing.Linear;
	import org.as3lib.kitchensync.util.*;
	
	public class KitchenSyncDefaults
	{
		// ALL ACTIONS
		public static var autoDelete:Boolean = false;
		public static var sync:Boolean = true;
		public static var timeStringParser:ITimeStringParser = new TimeStringParser_en();
		public static var easingFunction:Function = Linear.ease;
		
		// TWEENS
		public static var snapToValueOnComplete:Boolean = true;
		public static var snapToWholeNumber:Boolean = false;
	}
}