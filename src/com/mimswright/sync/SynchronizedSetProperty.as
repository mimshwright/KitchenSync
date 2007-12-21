package com.mimswright.sync
{	
	/**
	 * SynchronizedAction to set a property for any object to a specified value.
	 * 
	 * @todo - write docs
	 * @todo - test
	 */
	public class SynchronizedSetProperty extends SynchronizedFunction
	{
		public function SynchronizedSetProperty(target:Object, key:String, value:*, offset:* = 0)
		{
			super(offset, setProperty, target, key, value);
		}
		
		public function setProperty(target:Object, key:String, value:*):void {
			target[key] = value;	
		}
		
		override public function kill():void {
			super.kill();
			_func = null;
			_args = null;
		} 
	}
}