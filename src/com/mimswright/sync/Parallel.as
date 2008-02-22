package com.mimswright.sync
{
	import flash.utils.getQualifiedClassName;
	
	/**
	 * A group of actions that executes all at once the group is started and the offset is reached.
	 */
	public class Parallel extends AbstractSynchronizedActionGroup
	{	
		
		protected var _runningChildren:int = 0;
		
		public  function get childrenAreRunning():Boolean { return _runningChildren > 0; }
		
		/**
		 * Constructor.
		 * 
		 * @throws TypeError - if any children are not of type AbstractSynchronizedAction.
		 * 
		 * @params children - a list of AbstractSynchronizedActions that will be added as children of the group.
		 */
		public function Parallel (... children) {
			super();
			for (var i:int = 0; i < children.length; i++) {
				if (children[i] is AbstractSynchronizedAction) {
					var action:AbstractSynchronizedAction = AbstractSynchronizedAction(children[i]);
					addAction(action); 
				} else {
					throw new TypeError ("All children must be of type AbstractSynchronizedAction. Make sure you are not calling start() on the objects you've added to the group. Found " + getQualifiedClassName(children[i]) + " where AbstractSynchronizedAction was expected.");
				}
			}
		}
		
		/**
		 * When the first update occurs, all of the child actions are started simultaniously.
		 */
		override protected function onUpdate(event:SynchronizerEvent):void {
			var time:Timestamp = event.timestamp;
			if (startTimeHasElapsed && !childrenAreRunning) {
				// reset the number of running children.
				_runningChildren = 0;				
				// for all child actions
				for (var i:int=0; i < _childActions.length; i++) {
					var childAction:AbstractSynchronizedAction = AbstractSynchronizedAction(_childActions[i]);
					// add a listener to each action so that the completion of the entire group can be tracked.
					childAction.addEventListener(SynchronizerEvent.START, onChildStart);
					childAction.addEventListener(SynchronizerEvent.COMPLETE, onChildFinished);
					// start the child action
					childAction.start();
					// add one running child.
					_runningChildren++;
				}
				// once this has started, it doesn't need updates anymore.
				unregister();
			}
		}
		
		
		/**
		 * Called when child actions are completed. After each is finished, checks to see if the entire set is 
		 * complete. If not, it waits for the next child.
		 * Completed children are removed from the array so they can be garbage collected.
		 * 
		 * @param event - The SynchronizerEvent.COMPLETE
		 * @param event - The SynchronizerEvent.CHILD_COMPLETE
		 */
		override protected function onChildFinished (event:SynchronizerEvent):void {
			super.onChildFinished(event);
			var childAction:AbstractSynchronizedAction = AbstractSynchronizedAction(event.target);
			childAction.removeEventListener(SynchronizerEvent.COMPLETE, onChildFinished);
			childAction.removeEventListener(SynchronizerEvent.START, onChildStart);
			_runningChildren--;
			if (_runningChildren == 0) {
				complete();
			}
		}
		
		override public function clone():AbstractSynchronizedAction {
			var clone:Parallel = new Parallel();
			clone._childActions = _childActions;
			clone.offset = _offset;
			clone.autoDelete = _autoDelete;
			return clone;
		}
		
		override public function toString():String {
			return "Parallel group containing " + _childActions.length + " children";
		}
	}
}