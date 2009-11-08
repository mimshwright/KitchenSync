package org.as3lib.kitchensync.action.group
{
	import org.as3lib.kitchensync.action.*;
	import org.as3lib.kitchensync.core.KitchenSyncEvent;
	
	/**
	 * A group of actions based on the sequence group that plays 
	 * the child actions back in a random order.
	 * 
	 * @author Mims Wright
	 * @since 2.0
	 */
	public class KSRandomGroup extends KSSequenceGroup
	{
		/** An internal reference to the remaining child actions that haven't been started. */
		protected var _remainingActions:Array;
		
		/**
		 * Constructor.
		 * 
		 * @params children - a list of actions that will be added as children of the group.
		 */
		public function KSRandomGroup (... children) {
			super();
			
			var l:int = children.length;
			for (var i:int=0; i < l; i++) {
				addAction(IAction(children[i]));
			}
		}
		
		/** @inheritDoc */
		override public function start():IAction {
			// get a copy of the childAcitons array.
			_remainingActions = childActions.concat();
			return super.start();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function checkForComplete():Boolean{
			// this group is complete when there are no remaining actions to start.
			if (_remainingActions && _remainingActions.length <= 0) { 
				return true;
			}
			return false;
		}
		
		/**
		 * Start the actions in a random order. 
		 */
		override protected function startNextAction():IAction {
			_currentAction = getNextRandomAction();
			_currentAction.addEventListener(KitchenSyncEvent.ACTION_COMPLETE, onChildFinished);
			_currentAction.addEventListener(KitchenSyncEvent.ACTION_START, onChildStart);
			_currentAction.start();
			return _currentAction;
		}
		
		/** Get the next action by random selection of the remaining actions array. */ 
		protected function getNextRandomAction():IAction {
			var nextIndex:int = Math.floor(Math.random() * _remainingActions.length);
			var nextChild:IAction = IAction(_remainingActions[nextIndex]);
			_remainingActions.splice(nextIndex, 1);
			return nextChild;
		}
		
		/** @inheritDoc */
		override public function kill():void {
			super.kill();
			_remainingActions = null;
		}
		
	}
}