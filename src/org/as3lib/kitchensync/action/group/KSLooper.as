package org.as3lib.kitchensync.action.group
{
	import org.as3lib.kitchensync.action.IAction;
	
	/**
	 * A decorator-like group for looping an action a set number of times.
	 * The looper is actually just a KSSequenceGroup with multiple instances
	 * of the action. 
	 *
	 * @author Mims H. Wright
	 * @since 2.0
	 */
	public class KSLooper extends KSSequenceGroup
	{	
		/**
		 * Returns the current loop starting with 1.
		 * The result is 0 when the action isn't running.
		 * Note, this may not be entirely accurate if you add additional children
		 * to the looper after constructing it.
		 */
		public function get currentLoop():int { return currentActionIndex + 1; } 
		
		/**
		 * Constructor.
		 * 
		 * @param action The action to loop.
		 * @param loops The number of times it will loop. The minimum will be 1. 
		 * @param reuseAction When set to false, the looper will create clones of the action rather
		 * 			than reusing the same action object over and over again. Avoid changing this unless
		 * 			you need to edit the individual loops. 
		 */
		public function KSLooper(action:IAction, loops:int, reuseAction:Boolean = true)
		{
			super();
			
			// Reset the children since you'll be reusing the same aciton.
			resetChildrenAtStart = true;
			
			// make sure loops is always at least 1.
			loops = Math.max(loops, 1); 
			
			for (var i:int = 0; i < loops; i++) {
				if (reuseAction) {  
					addAction(action); 
				} else { 
					addAction(action.clone()); 
				}
			}
		}
	}
}