package org.as3lib.kitchensync.action
{
	import flash.errors.IllegalOperationError;
	
	import org.as3lib.kitchensync.core.*;
	import org.as3lib.utils.AbstractEnforcer;
	
	/**
	 * @eventType org.as3lib.kitchensync.core.KitchenSyncEvent.CHILD_ACTION_START
	 */
	[Event(name="childActionStart", type="org.as3lib.kitchensync.core.KitchenSyncEvent")]

	/**
	 * @eventType org.as3lib.kitchensync.core.KitchenSyncEvent.CHILD_COMPLETE
	 */
	[Event(name="childActionComplete", type="org.as3lib.kitchensync.core.KitchenSyncEvent")]
	
	// todo: add docs
	// todo: thoroughly review this class for errors, kruft, improvements
	// todo: add the ability to reset child tweens at the start of the group
	// todo: add skipCurrentAction()
	/**
	 * A default implementation of IActionGroup. Provides the basic functionality
	 * for dealing with child actions within a group.
	 * 
	 * @abstract
	 * @author Mims H. Wright
	 * @since 0.1
	 */
	public class AbstractActionGroup extends AbstractAction implements IActionGroup
	{
		/** If true, the group's KSTween children will reset to their default positions when the group is started. */
		//public var resetChildrenAtStart:Boolean = true;
		
		/**
		 * An array containing all of the child actions of the group.
		 */
		public function get childActions():Array { return _childActions; }
		protected var _childActions:Array = new Array();
		
		/**
		 * Setting duration is overridden on groups and will always be 0.
		 * @see totalDuration.
		 */
		override public function set duration(duration:*):void {
			throw new Error("duration is ignored for IActionGroups");
		}
		
		/**
		 * @inheritDoc
		 */
		public function get totalDuration():int {
			var totalDuration:int = duration;
			for each (var action:IAction in childActions) {
				totalDuration += action.delay + action.duration;
			}
			return totalDuration;
		} 
		
		/**
		 * Constructor.
		 * 
		 * @abstract
		 */
		public function AbstractActionGroup() {
			super();
			AbstractEnforcer.enforceConstructor(this, AbstractActionGroup);
			//resetChildrenAtStart = KitchenSyncDefaults.resetChildrenAtStart;
		}
		
		/**
		 * Adds an action to the group.
		 * 
		 * @param action - One or more actions to add to the group. Don't start this action. That will be handled by the group.
		 */
		public function addAction(action:IAction, ... additionalActions):void {
			_childActions.push(action);
			if (additionalActions.length > 0) {
				for each (action in additionalActions) {
					_childActions.push(action);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function addActionAtIndex(action:IAction, index:int = -1):void {
			if (index < 0) {
				_childActions.push(action);
			} else {
				_childActions.splice(index, 0, action);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAction(action:IAction):IAction {
			var index:int = _childActions.indexOf(action);
			if (index != -1) {
				return _childActions.splice(index, 1)[0];
			} else {
				throw new Error("Specified child action does not exist");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		 public function removeActionAtIndex(index:int):IAction {
			if (index < 0 || index >= _childActions.length) {
				throw new RangeError("Specified index does not exist");
			} else {
				return _childActions.splice(index, 1)[0];
			}
		 }
		
		/**
		 * @inheritDoc
		 */ 
		 public function getChildAtIndex(index:int):IAction {
		 	if (index < 0 || index >= _childActions.length) {
				throw new RangeError("Specified index does not exist");
			} else {
				return IAction(_childActions[index]);
			}
		 }
		 
		 /**
		 * @inheritDoc
		 */
		 public function reverseChildOrder():void {
		 	if (isRunning) { throw new IllegalOperationError("reverseChildOrder cannot be called while the group is running."); }
		 	_childActions = _childActions.reverse();
		 }
		 
		 /**
		 * Dispatches a CHILD_START event when the child begins.
		 * 
		 * @param event - The SynchronizerEvent.START from the child action
		 */
		 // todo - Add a reference to the started child to the event.
		 protected function onChildStart(event:KitchenSyncEvent):void {
		 	dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.CHILD_ACTION_START, event.timestamp));
		 }
		 
		 /**
		 * Called when child actions are completed.
		 * 
		 * @param event - The SynchronizerEvent.COMPLETE from the child action
		 * @event SynchronizerEvent.CHILD_COMPLETE
		 */
		 // todo - Add a reference to the completed child to the event.
		protected function onChildFinished (event:KitchenSyncEvent):void {
			dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.CHILD_ACTION_COMPLETE, event.timestamp));
		}
		
		override public function start():IAction {
			/* if (resetChildrenAtStart && !_running && !_paused) {
				for (var i:int = 0; i < _childActions.length; i++ ) {
					var tween:KSTween = _childActions[i] as KSTween;
					if (tween != null) { tween.reset(); }
					
				}
			} */
			return super.start();
		}
		
		override public function pause():void {
			super.pause();
			//_paused = true;
			for each (var child:IAction in childActions) {
				child.pause();
			}
		}
		
		override public function unpause():void {
			super.unpause();
			//_paused = false;
			for each (var child:IAction in childActions) {
				child.unpause();
			}
		}
		
		override public function stop():void {
			super.stop();
			for each (var child:IAction in childActions) {
				child.stop();
			}
		}
		
		override public function kill():void {
			// Kill child actions to avoid zombie actions.
			for each (var child:IAction in _childActions) {
				child.kill();
			}
			_childActions = [];
			super.kill();
		}

		override public function toString():String {
			return "SynchronizedActionGroup containing " + _childActions.length + " children";
		}
	}
}