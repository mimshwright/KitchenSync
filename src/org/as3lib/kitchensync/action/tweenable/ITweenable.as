package org.as3lib.kitchensync.action.tweenable
{
	public interface ITweenable
	{
		/**
		 * This is the current value of the tweenable.
		 */
		function set currentValue(currentValue:Number):void;
		function get currentValue():Number;
		
		/**
		 * The value that the tweenable will begin from.
		 */
		function set startValue(startValue:Number):void;
		function get startValue():Number;
		
		/**
		 * The value that the tweenable will end on.
		 */
		function set endValue(endValue:Number):void;
		function get endValue():Number;

		/** Returns the tweenable to its pre-tweened state */
		function reset():void;
		
		/** Create a copy of the tweenable object */
		function clone():ITweenable;
	}
}