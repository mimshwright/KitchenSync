package com.mimswright.sync
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * A group of actions that execute one at a time in the order that they were added to the group.
	 * 
	 * -todo - Child actions should not be deleted from the Aray until they are completed.
	 */
	public class Sequence extends AbstractSynchronizedActionGroup
	{
		protected var _currentAction:AbstractSynchronizedAction = null;
		public function get currentAction():AbstractSynchronizedAction { return _currentAction; }
		
		/**
		 * Constructor.
		 * 
		 * @throws TypeError - if any children are not of type AbstractSynchronizedAction.
		 * 
		 * @params children - a list of AbstractSynchronizedActions that will be added as children of the group.
		 */
		public function Sequence (... children) {
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
		 * Listens for updates to synchronize the start time of the sequence.
		 * The first action in the sequence is called by using the startNextAction() method.
		 * After the Sequence starts running, it no longer needs to listen to updates so it unregisters.
		 */
		override internal function onUpdate(event:SynchronizerEvent):void {
			var time:Timestamp = event.timestamp;
			if (_startTimeHasElapsed) {
				startNextAction();
				unregister();
			}
		}
		
		/**
		 * Starts playing the next action in the sequence. Listens for the COMPLETE event for each child
		 * and runs onChildFinished() when each child completes. The action that is currently playing
		 * will be stored in _currentAction which is publicly accessible. 
		 * 
		 * -todo - fix bug where child action begins playing 1 frame late.
		 * @return The currently playing action.
		 */
		protected function startNextAction():AbstractSynchronizedAction {
			_currentAction = _childActions.shift() as AbstractSynchronizedAction;
			_currentAction.addEventListener(SynchronizerEvent.COMPLETE, onChildFinished);
			_currentAction.start();
			return _currentAction;
		}
		
		/**
		 * Called when child actions are completed. After each is finished, checks to see if the sequence is 
		 * complete. If not, it starts the next child.
		 * Also remove reference to child action so it can be garbage collected.
		 * 
		 * @param event - The SynchronizerEvent.COMPLETE from the _currentAction
		 * -todo - Add a reference to the completed child to the CHILD_COMPLETE event.
		 */
		protected function onChildFinished (event:Event):void {
			dispatchEvent(new SynchronizerEvent(SynchronizerEvent.CHILD_COMPLETE, Synchronizer.getInstance().currentTimestamp));
			_currentAction.removeEventListener(SynchronizerEvent.COMPLETE, onChildFinished);
			_currentAction = null;
			if (!checkForComplete()) {
				startNextAction();
			}
		}
		
		/**
		 * Override start to automatically quit if there are no children.
		 */
		override public function start():void {
			super.start();
			checkForComplete();
		}
		
		override public function clone():AbstractSynchronizedAction {
			var clone:Sequence = new Sequence();
			clone._childActions = _childActions;
			clone.offset = _offset;
			clone.autoDelete = _autoDelete;
			return clone;
		}
	}
}