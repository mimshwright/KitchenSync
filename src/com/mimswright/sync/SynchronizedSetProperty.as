package com.mimswright.sync
{
	/**
	 * @todo - write docs
	 * @todo - test
	 */
	public class SynchronizedSetProperty extends SynchronizedFunction
	{
		public function SynchronizedSetProperty(target:Object, key:String, value:*, offset:int = 0)
		{
			var func:Function = new Function
			super(offset, setProperty, target, key, value);
		}
		
		public function setProperty(target:Object, key:String, value:*):void {
			target[key] = value;	
		}
	}
}