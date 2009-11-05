package org.as3lib.kitchensync.action
{
	import flash.utils.getQualifiedClassName;
	
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
		 * @param children Any parameters to this function will be added as children of the group.
		 */
		public function KSRandomGroup(... children)
		{
			for (var i:int = 0; i < children.length; i++) {
				if (children[i] is IAction) {
					var action:IAction = IAction(children[i]);
					addAction(action); 
				} else {
					throw new TypeError ("All children must be of type IAction. Make sure you are not calling start() on the objects you've added to the group. Found " + getQualifiedClassName(children[i]) + " where IAction was expected.");
				}
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