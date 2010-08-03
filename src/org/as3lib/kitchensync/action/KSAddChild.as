package org.as3lib.kitchensync.action
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * Same as calling addChildAt with a KSFunction. Also does some checks on the values passed in so that 
	 * there won't be any annoying errors.
	 * 
	 * @since 2.1
	 */
	public class KSAddChild extends KSFunction
	{
		public function KSAddChild(child:DisplayObject, toParent:DisplayObjectContainer, atIndex:int = -1, delay:int = 0 )
		{
			var f:Function = function (child:DisplayObject, parent:DisplayObjectContainer, index:int):void {
				if (child && parent) {
					if (index < 0 || index > parent.numChildren) {
						parent.addChild(child);
					} else {
						parent.addChildAt(child, index);
					}
				}
			}
			super(f, delay, child, toParent, atIndex);
		}
	}
}