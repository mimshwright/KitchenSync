package com.mimswright.utils
{
	import com.mimswright.utils.strictIs;
	import com.mimswright.errors.AbstractError;
	
	public class AbstractEnforcer
	{
		public static function enforceConstructor(instance:Object, className:Class):void {
			if (strictIs(instance, className)) {
				throw (new AbstractError(AbstractError.CONSTRUCTOR_ERROR));
			}
		}
		
		public static function enforceMethod ():void {
			throw (new AbstractError(AbstractError.METHOD_ERROR));
		}
	}
}