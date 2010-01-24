package org.as3lib.kitchensync.action.group
{
	import flash.errors.IllegalOperationError;
	
	import org.as3lib.kitchensync.KitchenSyncDefaults;
	import org.as3lib.kitchensync.action.AbstractAction;
	import org.as3lib.kitchensync.action.IAction;
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
		/** 
		 * If true, the group's KSTween children will reset to their 
		 * default positions when the group is started. 
		 * For example, when a sequence group begins, this will call the
		 * reset() method on all the children when the start() method is
		 * called on the group.
		 * 
		 * @default The default is set in each individual class depending on 
		 * what works best for that class.
		 * 
		 * @see #reset()
		 */
		public function get resetChildrenAtStart():Boolean { return _resetChildrenAtStart; }
		public function set resetChildrenAtStart(resetChildrenAtStart:Boolean):void { _resetChildrenAtStart = resetChildrenAtStart;}
		protected var _resetChildrenAtStart:Boolean = false;
		
		/** @inheritDoc */
		public function get childActions():Array { return _childActions; }
		protected var _childActions:Array = new Array();
		
		/**
		 * Setting duration is overridden on groups and will always be 0.
		 * @see totalDuration.
		 */
		override public function set duration(duration:*):void {
			throw new Error("duration is ignored for IActionGroups");
		}
		
		/** @inheritDoc */
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
		}
		
		/** @inheritDoc */
		public function addAction(action:IAction, ... additionalActions):void {
			// add the first action
			if (action != null) { 
				_childActions.push(action);
			}
			
			// add additional actions
			for each (action in additionalActions) {
				if (action != null) { 
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
		 * @param event The SynchronizerEvent.START from the child action
		 */
		 protected function onChildStart(event:KitchenSyncEvent):void {
		 	dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.CHILD_ACTION_START, event.timestamp));
		 }
		 
		 /**
		 * Called when child actions are completed.
		 * 
		 * @param event The SynchronizerEvent.COMPLETE from the child action
		 */
		protected function onChildFinished (event:KitchenSyncEvent):void {
			dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.CHILD_ACTION_COMPLETE, event.timestamp));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function start():IAction {
			if (resetChildrenAtStart && !_running && !_paused) {
				for each (var action:IAction in _childActions) {
					action.reset();
				}
			}
			return super.start();
		}
		
		/** Pauses the group and all its children. */
		override public function pause():void {
			super.pause();
			for each (var child:IAction in childActions) {
				child.pause();
			}
		}
		
		/** Unpauses the group and all its children. */
		override public function unpause():void {
			super.unpause();
			for each (var child:IAction in childActions) {
				child.unpause();
			}
		}
		
		/** Stops the group and all its children. */
		override public function stop():void {
			super.stop();
			for each (var child:IAction in childActions) {
				child.stop();
			}
		}
		
		/**
		 * @inheritDoc
		 * Reset child actions before resetting group.
		 */
		override public function reset():void {
			for each (var child:IAction in _childActions) {
				child.reset();
			}
			super.reset();
		}
		
		/** Kills the group and all its children. */
		override public function kill():void {
			// Kill child actions to avoid zombie actions.
			for each (var child:IAction in _childActions) {
				child.kill();
			}
			_childActions = [];
			super.kill();
		}

		override public function toString():String {
			return "ActionGroup [" + _childActions.toString() + "]";
		}
	}
}