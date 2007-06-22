package com.mimswright.sync
{
	import com.mimswright.utils.AbstractEnforcer;
	
	public class AbstractSynchronizedActionGroup extends AbstractSynchronizedAction
	{
		protected var _childActions:Array = new Array();
		public function get childActions():Array { return _childActions; }
		
		override public function set duration(duration:int):void {
			throw new Error("duration is ignored for SynchronizedActionGroups");
		}
		
		/**
		 * Constructor.
		 * 
		 * @abstract
		 */
		public function AbstractSynchronizedActionGroup() {
			AbstractEnforcer.enforceConstructor(this, AbstractSynchronizedActionGroup);
		}
		
		/**
		 * Adds an action to the group.
		 * 
		 * @param action - The action to add. Don't start this action. That will be handled by the group.
		 */
		public function addAction(action:AbstractSynchronizedAction):void {
			_childActions.push(action);
		}
		
		/**
		 * Adds an action to the group at the specified index.
		 * 
		 * @param action - The action to add. Don't start this action. That will be handled by the group.
		 * @param index - The location at which to add the action. Defaults to the end of the Array
		 */
		public function addActionAtIndex(action:AbstractSynchronizedAction, index:int = -1):void {
			if (index < 0) {
				_childActions.push(action);
			} else {
				_childActions.splice(index, 0, action);
			}
		}
		
		/**
		 * Removes an action from the group.
		 * 
		 * @throws Error if the action cannot be found.
		 * @param action - The action to remove.
		 * @return The removed action.
		 */
		public function removeAction(action:AbstractSynchronizedAction):AbstractSynchronizedAction {
			var index:int = _childActions.indexOf(action);
			if (index != -1) {
				return _childActions.splice(index, 1)[0];
			} else {
				throw new Error("Specified child action does not exist");
			}
		}
		
		/**
		 * Removes an action at the specified index. 
		 * 
		 * @throws Error if the action cannot be found.
		 * @param index - The index in the array of the action to remove.
		 */
		 public function removeActionAtIndex(index:int):AbstractSynchronizedAction {
			if (index < 0 || index >= _childActions.length) {
				throw new Error("Specified child action does not exist");
			} else {
				return _childActions.splice(index, 1)[0];
			}
		 }
			
		/**
		 * Checks to see if all of the children have completed. If so, calls the complete method.
		 * 
		 * @return true if complete, otherwise false.
		 */
		protected function checkForComplete():Boolean{
			if (_childActions.length == 0) { 
				complete();
				return true;
			}
			return false;
		}

		override public function toString():String {
			return "SynchronizedActionGroup containing " + _childActions.length + " children";
		}
	}
}