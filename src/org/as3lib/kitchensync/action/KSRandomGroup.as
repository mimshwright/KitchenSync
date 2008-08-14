package org.as3lib.kitchensync.action
{
	import flash.utils.getQualifiedClassName;
	
	import org.as3lib.kitchensync.core.KitchenSyncEvent;
	
	/**
	 * A sequence of actions that plays back in a random order.
	 * 
	 * @author Mims Wright
	 * @since 1.6
	 */
	// Todo implement.
	public class KSRandomGroup extends KSSequenceGroup
	{
		public function KSRandomGroup(... children)
		{
			for (var i:int = 0; i < children.length; i++) {
				if (children[i] is AbstractAction) {
					var action:AbstractAction = AbstractAction(children[i]);
					addAction(action); 
				} else {
					throw new TypeError ("All children must be of type AbstractAction. Make sure you are not calling start() on the objects you've added to the group. Found " + getQualifiedClassName(children[i]) + " where AbstractAction was expected.");
				}
			}
		}
		
		override protected function startNextAction():AbstractAction {
			_currentAction = getNextRandomAction();
			_currentAction.addEventListener(KitchenSyncEvent.COMPLETE, onChildFinished);
			_currentAction.addEventListener(KitchenSyncEvent.START, onChildStart);
			_currentAction.start();
			return _currentAction;
		}
		
		protected function getNextRandomAction():AbstractAction {
			// TODO make random
			return getChildAtIndex(_currentActionIndex++);
		}
		
	}
}