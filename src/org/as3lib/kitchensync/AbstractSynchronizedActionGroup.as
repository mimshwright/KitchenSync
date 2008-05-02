package org.as3lib.kitchensync
{
	import org.as3lib.utils.AbstractEnforcer;
	
	[Event(name="childActionStart", type="org.as3lib.kitchensync.SynchronizerEvent")]
	[Event(name="childActionComplete", type="org.as3lib.kitchensync.SynchronizerEvent")]
	
	public class AbstractSynchronizedActionGroup extends AbstractSynchronizedAction
	{
		
		protected var _childActions:Array = new Array();
		public function get childActions():Array { return _childActions; }
		
		override public function set duration(duration:*):void {
			throw new Error("duration is ignored for SynchronizedActionGroups");
		}
		
		/**
		 * Constructor.
		 * 
		 * @abstract
		 */
		public function AbstractSynchronizedActionGroup() {
			super();
			AbstractEnforcer.enforceConstructor(this, AbstractSynchronizedActionGroup);
		}
		
		/**
		 * Adds an action to the group.
		 * 
		 * @param action - One or more actions to add to the group. Don't start this action. That will be handled by the group.
		 */
		public function addAction(action:AbstractSynchronizedAction, ... additionalActions):void {
			_childActions.push(action);
			if (additionalActions.length > 0) {
				for each (action in additionalActions) {
					_childActions.push(action);
				}
			}
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
		 * @return The removed action.
		 */
		 public function removeActionAtIndex(index:int):AbstractSynchronizedAction {
			if (index < 0 || index >= _childActions.length) {
				throw new Error("Specified child action does not exist");
			} else {
				return _childActions.splice(index, 1)[0];
			}
		 }
		
		/**
		 * Returns the action at the specified index. 
		 * 
		 * @throws Error if the action cannot be found.
		 * @param index - The index in the array of the action to return.
		 * @return The specified action.
		 */ 
		 public function getChildAtIndex(index:int):AbstractSynchronizedAction {
		 	if (index < 0 || index >= _childActions.length) {
				throw new Error("Specified child action does not exist");
			} else {
				return _childActions[index];
			}
		 }
		 
		 /**
		 * Reverse the order that the children play back in. Essentially, this just reverses the child array.
		 * -todo - test this
		 */
		 public function reverseChildOrder():void {
		 	_childActions = _childActions.reverse();
		 }
		 
		 /**
		 * Dispatches a CHILD_START event when the child begins.
		 * 
		 * @param event - The SynchronizerEvent.START from the child action
		 * @event SynchronizerEvent.CHILD_START
		 * -todo - Add a reference to the started child to the event.
		 */
		 protected function onChildStart(event:SynchronizerEvent):void {
		 	dispatchEvent(new SynchronizerEvent(SynchronizerEvent.CHILD_START, event.timestamp));
		 }
		 
		 /**
		 * Called when child actions are completed.
		 * 
		 * @param event - The SynchronizerEvent.COMPLETE from the child action
		 * @event SynchronizerEvent.CHILD_COMPLETE
		 * -todo - Add a reference to the completed child to the event.
		 */
		protected function onChildFinished (event:SynchronizerEvent):void {
			dispatchEvent(new SynchronizerEvent(SynchronizerEvent.CHILD_COMPLETE, event.timestamp));
		}
		
		override public function pause():void {
			super.pause();
			//_paused = true;
			for each (var child:AbstractSynchronizedAction in childActions) {
				child.pause();
			}
		}
		
		override public function unpause():void {
			super.unpause();
			//_paused = false;
			for each (var child:AbstractSynchronizedAction in childActions) {
				child.unpause();
			}
		}
		
		override public function stop():void {
			super.stop();
			for each (var child:AbstractSynchronizedAction in childActions) {
				child.stop();
			}
		}
		
		override public function kill():void {
			// Kill child actions to avoid zombie actions.
			for each (var child:AbstractSynchronizedAction in _childActions) {
				child.kill();
			}
			_childActions = null;
			super.kill();
		}

		override public function toString():String {
			return "SynchronizedActionGroup containing " + _childActions.length + " children";
		}
	}
}