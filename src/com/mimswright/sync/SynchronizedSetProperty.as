package com.mimswright.sync
{	
	/**
	 * SynchronizedAction to set a property for any object to a specified value.
	 */
	public class SynchronizedSetProperty extends SynchronizedFunction
	{
		/**
		 * @param target - The object whose property you want to modify.
		 * @param key - The name of the property to modify.
		 * @param value - The new value of the property.
		 * @param offset - The delay before the action executes.
		 */ 
		public function SynchronizedSetProperty(target:Object, key:String, value:*, offset:* = 0)
		{
			super(offset, setProperty, target, key, value);
		}
		
		/** This is the function that will be called to set the property. */
		protected function setProperty(target:Object, key:String, value:*):void {
			target[key] = value;	
		}
	}
}