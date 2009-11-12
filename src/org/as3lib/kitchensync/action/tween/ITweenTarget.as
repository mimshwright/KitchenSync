package org.as3lib.kitchensync.action.tween
{
	import org.as3lib.math.INumericController;

	/**
	 * A <em>tween target</em> is a bundle that wraps up a property or other value that can be 
	 * tweened by a KSTween object.
	 * In most cases, this will be a property of an object (see TargetProperty class) but it 
	 * could also be something more complex like a tween target that sets the scaleX and scaleY
	 * of a sprite simultaneously or a property of a filter (which can't be set directly). 
	 * 
	 * Tween targets are useful because they allow the value-setting portion of a tween to be
	 * abstracted away and seperated from the timing and easing. This allows a variety of differnt
	 * types of values, such as filter properties, colors, and sound panning, to be set without 
	 * subclassing KSTween for every instance. It also allows for a single KSTween object to 
	 * control multiple tween targets.  
	 * 
	 * The tween target bundle will have a start and end value as well as providing an accessor
	 * to the current value of the target (via INumericController). 
	 * 
	 * Generally speaking, a KSTween will handle anything related to the timing of the tween
	 * while the ITweenTarget handles anything related to the values of the tween. For example,
	 * KSTween holds the duration of the tween and the controls for starting, stopping and pausing
	 * while the tween target has the start and end values and holds a reference to the object
	 * to be tweened.
	 *
	 * 
	 * @see KSTween
	 * @see TargetProperty
	 * 
	 * @author Mims Wright
	 * @since 1.5
	 */
	// todo Make easing function part of tween target instead of KSTween?
	public interface ITweenTarget extends INumericController
	{
		/**
		 * The main function that the Tween uses to update the TweenTarget. 
		 * Sets the percentage complete.
		 * 
		 * @example Typically this is implemented as such: 
		 * <listing version="3.0">	
		 * 	public function updateTween(percentComplete:Number):Number {
		 * 		return currentValue = percentComplete * (endValue - startValue) + startValue;
		 *	}
		 * </listing>
		 * 
		 * @param percentComplete a number between 0 and 1 (but sometimes more or less) that represents
		 * 		  the percentage of the tween that has been completed. This should update the currentValue.
		 * @return Number the new current value of the tween.
		 * 
		 * @see KSTween.update()
		 */
		function updateTween (percentComplete:Number):Number;
		
		/**
		 * The value that the tweenTarget will begin from.
		 */
		function get startValue():Number;
		function set startValue(startValue:Number):void;
		
		/**
		 * The value that the tweenTarget will tween to.
		 */
		function get endValue():Number;
		function set endValue(endValue:Number):void;
		
		/** 
		 * Resets the current value to it's initial pre-tweened state.
		 * (typically, sets the currentValue equal to the startValue).
		 * This is usually called by the reset() method of the KSTween class.
		 * 
		 * @see KSTween#reset()
		 */
		function reset():void;
		
		/** 
		 * Creates a deep copy of the tweenTarget object.
		 * Does not copy the state of the object (such as 
		 * its current progress in the tween).
		 * 
		 * @see KSTween#clone()
		 * @return ITweenTarget a clone of the tween target object 
		 */
		function clone():ITweenTarget;
	}
}