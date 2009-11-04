package org.as3lib.kitchensync.action.tween
{
	import org.as3lib.kitchensync.action.IAction;
	
	/**
	 * A special type of action that changes a numeric value
	 * (such as the x position of a Sprite) over time. 
	 * 
	 * @author Mims Wright
	 * @since 1.6
	 */
	public interface ITween extends IAction
	{
		/**
		 * The function used to interpolated the values between the start and end points.
		 * 
		 * @see org.as3lib.kitchensync.easing
		 */
		function get easingFunction():Function;
		function set easingFunction(easingFunction:Function):void;
		
		/**
		 * Used to modify the results of the easing function. 
		 * This is only used on some functions such as Elastic.
		 * 
		 * @see org.as3lib.kitchenSync.easing.Elastic
		 */
		function get easingMod1():Number;
		function set easingMod1(easingMod1:Number):void;

		/**
		 * Used to modify the results of the easing function. 
		 * This is only used on some functions such as Elastic.
		 * 
		 * @see org.as3lib.kitchenSync.easing.Elastic
		 */
		function get easingMod2():Number;
		function set easingMod2(easingMod2:Number):void;
	}
}