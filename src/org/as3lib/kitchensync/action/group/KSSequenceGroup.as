package org.as3lib.kitchensync.action.group
{
	import org.as3lib.kitchensync.action.*;
	import org.as3lib.kitchensync.core.*;
	
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
	 * </listing>
	 * 
	 * @author Mims Wright
	 * @since 0.1
	 */
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
		 * Returns -1 if not running.
		 * 
		 * @see #_currentAction
		 */
		public function get currentActionIndex():int { return _currentActionIndex; }
		protected var _currentActionIndex:int = NO_CURRENT_ACTION_INDEX;
		
		
		public function get currentAction():IAction { return _currentAction; }
		
		/**
		 * Constructor.
		 * 
		 * @params children A list of actions that will be added as children of the group. 
		 * 					If any of the children are arrays, they will be parsed into
		 * 					KSParallelGroups.  
		 * 
		 * @example <listing version="3.0">
		 * var sequence:KSSequenceGroup;
		 * 
		 * // new group with no children.
		 * sequence = new KSSequenceGroup();
		 * 
		 * // new group with 3 children. each child will execute after the previous one completes.
		 * sequence = new KSSequenceGroup( myAction, myAction2, myAction3);
		 * 
		 * // new group with styntactic sugar for creating a parallel group on the fly. 
		 * // myAction will execute followed by myAction2 and 3 executing simultaneously, then myAction4 will 
		 * // execute after 2 and 3 both finish. 
		 * // this is identical to using:
		 * // sequence = new KSSequenceGroup( myAction, new KSParallelGroup(myAction2, myAction3), myAction4);
		 * sequence = new KSSequenceGroup( 
		 * 					mAction, 
		 * 					[myAction2, myAction3], 
		 * 					myAction4
		 * 			  );
		 * </listing>
		 */
		public function KSSequenceGroup (... children) {
			super();
			
			var l:int = children.length;
			for (var i:int=0; i < l; i++) {
				addActionOrParallel(children[i] as Object);
			}
		}
		
		
		/**
		 * An internal function used by the constructor and by addActionOrSequence() that will
		 * check the input for arrays and convert them to parallel groups.
		 * 
		 * Notice that the groups can be nested. If an array contains an array, that array will be
		 * parsed into a sequence group by addActionOrSequence(). 
		 * 
		 * @see org.as3lib.kitchensync.action.group.KSParallelGroup#KSParallelGroup()
		 * @see org.as3lib.kitchensync.action.group.KSParallelGroup#addActionOrSequence()
		 * 
		 * @param actionOrParallel Either an IAction or an array. Arrays will be added to the group 
		 * 						   as a KSParallelGroup. 
		 * 
		 * @private
		 */ 
		internal function addActionOrParallel(actionOrParallel:Object):void {
			if (actionOrParallel is IAction) {
				addAction(IAction(actionOrParallel));
				return;
			}
			if (actionOrParallel is Array) {
				var parallel:KSParallelGroup = new KSParallelGroup();
				for each (var item:Object in (actionOrParallel as Array)) {
					parallel.addActionOrSequence(item);
				}
				addAction(parallel);
				return;
			}
			throw new TypeError("The action added must be either an action or an array.");
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
		 * @inheritDoc
		 * 
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