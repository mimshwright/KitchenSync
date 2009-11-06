package org.as3lib.kitchensync.action.group
{
	import flash.utils.getQualifiedClassName;
	
	import org.as3lib.kitchensync.core.*;
	import org.as3lib.kitchensync.action.*;
	
	/**
	 * A group of actions that execute one at a time in the order that 
	 * they were added to the group. This is probably the most useful 
	 * action group. It allows you to queue up several actions and have 
	 * them execute in order as a single unit. This type of group can 
	 * be used for transitions between pages in a site or for queueing
	 * up several functions to be executed in order.
	 * 
	 * @example <listing version="3.0">
	 * var transitionOut:KSTween = new KSTween(...) // some transition-OUT tween
	 * var transitionIn:KSTween = new KSTween(...) // some transition-IN tween
	 * var myFunction:KSFunction = new KSFunction (...) // some function
	 * 
	 * // play the transition out, then some function, then the transition in.
	 * var sequence:KSSequenceGroup = new KSSequenceGroup (
	 * 	transitionOut,
	 * 	myFunction,
	 * 	transitionIn
	 * );
	 * sequence.start();
	 * </version>
	 * 
	 * @author Mims Wright
	 * @since 0.1
	 */
	 // todo: add example
	public class KSSequenceGroup extends AbstractActionGroup
	{
		/**
		 * Used internally with the currentAciton property to denote that there is 
		 * no action currently executing.
		 * 
		 * @see #_currentActionIndex
		 */ 
		protected const NO_CURRENT_ACTION_INDEX:int = -1;
		
		/**
		 * The action currently executing.
		 */
		protected var _currentAction:IAction = null;
		
		/**
		 * The index of the action currently executing.
		 * @see #_currentAction
		 */
		protected var _currentActionIndex:int = NO_CURRENT_ACTION_INDEX;
		
		public function get currentAction():IAction { return _currentAction; }
		
		/**
		 * Constructor.
		 * 
		 * @throws TypeError - if any children are not of type AbstractSynchronizedAction.
		 * 
		 * @params children - a list of AbstractSynchronizedActions that will be added as children of the group.
		 */
		public function KSSequenceGroup (... children) {
			super();
			for (var i:int = 0; i < children.length; i++) {
				if (children[i] is IAction) {
					var action:IAction = IAction(children[i]);
					addAction(action); 
				} else {
					throw new TypeError ("All children must be of type IAction. Make sure you are not calling start() on the objects you've added to the group. Found " + getQualifiedClassName(children[i]) + " where IAction was expected.");
				}
			}
		}
		
		/**
		 * Listens for updates to synchronize the start time of the sequence.
		 * The first action in the sequence is called by using the startNextAction() method.
		 * After the Sequence starts running, it no longer needs to listen to updates so it unregisters.
		 */
		override public function update(currentTime:int):void {
			if (startTimeHasElapsed(currentTime)) {
				startNextAction();
				// Sequence no longer needs to listen for events from Synchronizer
				// since it now receives all cues from its children.
				unregister();
			}
		}
		
		/**
		 * Starts playing the next action in the sequence. Listens for the COMPLETE event for each child
		 * and runs onChildFinished() when each child completes. The action that is currently playing
		 * will be stored in _currentAction which is publicly accessible. 
		 * 
		 * @return The currently playing action.
		 */
		protected function startNextAction():IAction {
			_currentActionIndex++;
			_currentAction = getChildAtIndex(_currentActionIndex);
			_currentAction.addEventListener(KitchenSyncEvent.ACTION_COMPLETE, onChildFinished);
			_currentAction.addEventListener(KitchenSyncEvent.ACTION_START, onChildStart);
			_currentAction.start();
			return _currentAction;
		}
		
		/**
		 * Called when child actions are completed. After each is finished, checks to see if the sequence is 
		 * complete. If not, it starts the next child.
		 * Also remove reference to child action so it can be garbage collected.
		 * 
		 * @param event - The SynchronizerEvent.COMPLETE from the _currentAction
		 */
		override protected function onChildFinished (event:KitchenSyncEvent):void {
			super.onChildFinished(event);
			_currentAction.removeEventListener(KitchenSyncEvent.ACTION_COMPLETE, onChildFinished);
			_currentAction.removeEventListener(KitchenSyncEvent.ACTION_START, onChildStart);
			if (!checkForComplete()) {
				startNextAction();
			} else {
				complete();
			}
		}
		
		/**
		 * Checks to see if all of the children have completed. If so, calls the complete method.
		 * 
		 * @return true if complete, otherwise false.
		 */
		protected function checkForComplete():Boolean{
			if (_childActions && (_childActions.length > 0 ) && (_currentActionIndex >= _childActions.length-1)) { 
				return true;
			}
			return false;
		}
		
		/**
		 * override to reset the _currentActionIndex.
		 */
		override protected function complete():void {
			_currentActionIndex = NO_CURRENT_ACTION_INDEX;
			_currentAction = null;
			super.complete();
		}
		
		/**
		 * Override start to automatically quit if there are no children.
		 */
		override public function start():IAction {
			super.start();
			if (childActions && childActions.length < 1) { complete(); }
			return this;
		}
		
		override public function clone():IAction {
			var clone:KSSequenceGroup = new KSSequenceGroup();
			for (var i:int = 0; i < _childActions.length; i++) {
				var action:IAction = getChildAtIndex(i).clone();
				clone.addActionAtIndex(action, i);
			}
			clone.delay = _delay;
			clone.autoDelete = _autoDelete;
			return clone;
		}
		
		override public function toString():String {
			var string:String = "KSSequenceGroup[";
			for each (var action:IAction in _childActions) {
				string += Object(action).toString() + ", ";
			}  
			string += "]";
			return  string;
		}
	}
}