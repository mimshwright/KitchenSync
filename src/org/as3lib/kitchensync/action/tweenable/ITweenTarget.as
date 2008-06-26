package org.as3lib.kitchensync.action.tweenable
{
	/**
	 * A bundle that wraps up a property or other value that can be tweened by a KSTween.
	 * Generally speaking, a KSTween will handle the timing of the tween while the ITweenable
	 * handles the values of the tween.
	 * 
	 * @author Mims Wright
	 * @since 1.4
	 * @see org.as3lib.kitchensync.action.KSTween
	 */
	public interface ITweenTarget
	{
		/**
		 * The main function that the Tween uses to update the Tweenable. 
		 * Sets the percentage complete.
		 * 
		 * @use Typically this is implemented as such: 
		 * <code>	
		 * 	public function updateTween(percentComplete:Number):Number {
		 * 		return currentValue = percentComplete * (endValue - startValue) + startValue;
		 *	}
		 * </code>
		 * 
		 * @param percentComplete a number between 0 and 1 (but sometimes more or less) that represents
		 * 		  the percentage of the tween that has been completed. This should update
		 * @return Number the new current value of the tween.
		 */
		function updateTween (percentComplete:Number):Number;
		
		/**
		 * This is the current value of the tweenable.
		 */
		function get currentValue():Number;
		function set currentValue(currentValue:Number):void;
		
		/**
		 * The value that the tweenable will begin from.
		 */
		function get startValue():Number;
		function set startValue(startValue:Number):void;
		
		/**
		 * The value that the tweenable will end on.
		 */
		function get endValue():Number;
		function set endValue(endValue:Number):void;

		/** Returns the tweenable to its pre-tweened state */
		function reset():void;
		
		/** Create a copy of the tweenable object */
		function clone():ITweenTarget;
	}
}