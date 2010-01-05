package org.as3lib.kitchensync
{
	import org.as3lib.kitchensync.action.*;
	import org.as3lib.kitchensync.action.tween.*;
	import org.as3lib.kitchensync.easing.*;
	import org.as3lib.kitchensync.utils.*;
	
	/**
	 * All default settings for KitchenSync can be configured through this
	 * class. You can change the values by setting the public vars before 
	 * initializing KitchenSync or by changing this class directly in a 
	 * local copy of the library.
	 * 
	 * @author Mims H. Wright
	 * @since 1.1
	 */
	// todo: set this class up to pull in data from XML. 
	public class KitchenSyncDefaults
	{
		/**
		 * When set to true, the synchronizer will use weak references
		 * to connect to running actions.
		 * 
		 * @default false 
		 */
		public static var syncrhonizerUsesWeakReferences:Boolean = false;
		
		
		
///////// ALL ACTIONS
		
		/**
		 * Determines whether actions will attemp to delete themselves when they complete.
		 * Set this to true if you are having memory or performance issues with your app.
		 * 
		 * @default false
		 * @see org.as3lib.kitchensync.action.AbstractAction
		 */
		public static var autoDelete:Boolean = false;
		
		/** 
		 * The Instance of ITimeStringParser to use to parse time strings like "1.4seconds" 
		 * 
		 * @default TimeStringParser_en The basic, english language parser.
		 * @see org.as3lib.kitchensync.utils.ITimeStringParser
		 */
		public static var timeStringParser:ITimeStringParser = new TimeStringParser_en();
		
		/**
		 * The default easing function used in KSTweens (KSSimpleTweens do not use this value).
		 * 
		 * @default org.as3lib.kitchensync.easing.Linear.ease
		 * @see org.as3lib.kitchensync.action.KSTween
		 * @see org.as3lib.kitchensync.easing
		 */
		public static var easingFunction:Function = Linear.ease;
		
		/** The default duration when using object parser. */
		public static var duration:int = 1000;
		
		
		
///////// TWEENS
		/**
		 * When set to true, the value at the end of a tween will always be
		 * set to the endValue regardless of what the easing function interpoplates.
		 * 
		 * @default true
		 */
		public static var snapToValueOnComplete:Boolean = true;
		
		/**
		 * When set to true, the values that a tween generates will always be rounded
		 * to the nearest integer. This can make the animated image appear sharper but
		 * can make slower animations appear a little jumpy.  
		 * Use this when you need text to appear 'on-pixel'. 
		 * 
		 * @default false 
		 */		
		public static var snapToInteger:Boolean = false;
		
		/**
		 * The default ITweenObjectParser used for interpolating an action based on 
		 * a dynamic object.
		 * 
		 * @default is the standard KitchenSyncObjectParser
		 * @see org.as3lib.kitchensync.action.tween.ITweenObjectParser
		 */
		public static var tweenObjectParser:ITweenObjectParser = new KitchenSyncObjectParser();
	}
}