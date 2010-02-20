package org.as3lib.kitchensync.action
{
	
	/**
	 * An empty action that doesn't do anything and has no duration.
	 * This can be used, for example, when you need a function to generate
	 * an action but you don't want the action to do anything.
	 * 
	 * @since 2.0.1
	 * @author Mims H. Wright
	 */ 
	public class KSNullAction extends KSWait
	{
		public function KSNullAction()
		{
			super(0);
		}
		
		override public function clone():IAction {
			var clone:KSNullAction = new KSNullAction();
			return clone;
		}
	}
}