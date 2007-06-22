package com.mimswright.utils
{
	import flash.utils.*;
	
	/**
	 * Checks the class of instance against the compareClass for strict
	 * equality. If the classes are exactly the same, returns true. If
	 * the classes are different even if the instance's class is a subclass
	 * of compareClass, it returns false.
	 * 
	 * @author Mims Wright
	 * 
	 * @param instance - the object whos class you want to check.
	 * @param compareClass - the class to compare your object against.
	 * @return true if instance is strictly of type compareClass.
	 */
	public function strictIs(instance:Object, compareClass:Class):Boolean {
		var instanceClass:Class = Class(getDefinitionByName(getQualifiedClassName(instance)));
		//trace("instance class: " + instanceClass);
		//trace("compare class: " + compareClass);
		return instanceClass == compareClass;
	}
}