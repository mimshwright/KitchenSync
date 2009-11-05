package org.as3lib.kitchensync.action
{	
	/**
	 * An action for setting a property for an object. 
	 * This is similar to a tween but it happens instantaneously instead
	 * of over a set duration. Useful for setting non-numeric properties
	 * such as 'visible' on a DisplayObject.
	 * 
	 * @example <listing version="3.0">
	 * // hide 'mySprite' after 5 seconds.
	 * new KSSetProperty(mySprite, "visible", false, 5000).start();
	 * </listing>
	 * 
	 * @author Mims Wright
	 * @since 0.4
	 */
	public class KSSetProperty extends KSFunction
	{
		/**
		 * Constructor.
		 * 
		 * @param target - The object whose property you want to modify.
		 * @param key - The name of the property to modify.
		 * @param value - The new value of the property.
		 * @param delay - The delay before the action executes.
		 */ 
		public function KSSetProperty(target:Object, key:String, value:*, delay:* = 0)
		{
			super(setProperty, delay, target, key, value);
		}
		
		/** This is the function that will be called to set the property. */
		protected function setProperty(target:Object, key:String, value:*):void {
			target[key] = value;	
		}
	}
}