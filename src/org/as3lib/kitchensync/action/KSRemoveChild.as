package org.as3lib.kitchensync.action
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * Same as using a KSFunciton to call removeChild. Also checks to make sure neither child nor parent is
	 * null and makes sure parent contains child before removing thus avoiding annoying errors.
	 * 
	 * @since 2.1
	 */
	public class KSRemoveChild extends KSFunction
	{
		public function KSRemoveChild(child:DisplayObject, fromParent:DisplayObjectContainer, delay:int = 0)
		{
			var f:Function =  function (child:DisplayObject, parent:DisplayObjectContainer):void 
								{
									var contains:Boolean = child.parent == parent;
									if (child && parent && contains) {
										parent.removeChild(child);
									}
								}
			super(f, delay, child, fromParent);
		}
	}
}