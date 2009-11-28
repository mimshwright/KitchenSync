package org.as3lib.kitchensync.action.tween
{
	/**
	 * A numeric value that can be used in a tween
	 * where the start or end value should be evaluated at runtime.
	 * Essentially, this is a function that gets a property at the 
	 * time that it is called. 
	 * 
	 * @example <listing version="3.0">
	 * 
	 * // create a tween sequence that moves a sprite from 0 to 100 
	 * // then back starting from the end of the first tween. 
	 * var sequence:KSSequenceGroup = new KSSequenceGroup(
	 * 	new KSTween(sprite, "x", 0, 100),
	 * 	new KSTween(sprite, "x", new RuntimeValue(sprite,'x'), 0)
	 * );
	 * 
	 * </listing>
	 * 
	 * @since 2.0
	 * @author Mims H. Wright
	 */
	// todo: check syntax in the example
	// todo: make TweenTargets use this class behind the scenes.
	public class RuntimeValue
	{
		/** The object from which to pull the value. */
		private var _target:Object;
		
		/** The property name to get from <code>target</code>. */
		private var _property:String;
		
		/** 
		 * Returns the value. 
		 */
		public function get value():Number {
			return Number(_target[_property]);
		}
		
		/**
		 * Constructor.
		 * 
		 * @param target The object from which to pull the value.
		 * @param property The property name to get from <code>target</code>.
		 */
		public function RuntimeValue(target:Object, property:String)
		{
			_target = target;
			_property = property;
		}
	}
}