package org.as3lib.kitchensync.action.group
{
	import flash.utils.getQualifiedClassName;
	
	import org.as3lib.kitchensync.KitchenSync;
	import org.as3lib.kitchensync.core.*;
	import org.as3lib.kitchensync.utils.*;
	import org.as3lib.kitchensync.action.*;
	
	/**
	 * A group of actions that executes in sequence seperated by a specified gap.
	 */
	 //TODO: make sure all children execute as expected when framerate is too low to keep up.
	 // todo: add example
	 // todo: review
	public class KSStaggeredGroup extends KSParallelGroup
	{	
		/**
		 * Time to wait between the execution of each of the children.
		 * Accepts integer or parsable time string.
		 * 
		 * @see org.as3lib.kitchensync.ITimeStringParser;
		 */
		public function get stagger():int { return _stagger;}
		public function set stagger(stagger:*):void { 
			if (!isNaN(Number(stagger))) {
				_stagger = stagger; 
			} else {
				var timeString:String = stagger.toString();
				_stagger = KitchenSync.timeStringParser.parseTimeString(timeString);
			}
			if (_stagger <= 0) {
				throw new RangeError("Stagger amount must be an integer greater than 0.");
			}
		}
		protected var _stagger:int;
		
		protected var _lastStartTime:int;
		protected var _lastStartIndex:int;
		
		override public function get totalDuration():int {
			// add the stagger ammount to the total duration.
			return super.totalDuration + _stagger * childActions.length;
		}
		
		
		/**
		 * Constructor.
		 * 
		 * 
		 * @params stagger - The amount of time to stagger between each action starting. 
		 *					 The first one will not stagger (but will use the delay for the Staggered object)
		 * 					 Accepts an integer or a parseable string.
		 * @params children - a list of AbstractSynchronizedActions that will be added as children of the group.
		 * 
		 * @throws TypeError - if any children are not of type AbstractSynchronizedAction.
		 */
		public function KSStaggeredGroup (stagger:*, ... children) {
			super();
			for (var i:int = 0; i < children.length; i++) {
				if (children[i] is IAction) {
					var action:IAction = IAction(children[i]);
					addAction(action); 
				} else {
					throw new TypeError ("All children must be of type IAction. Make sure you are not calling start() on the objects you've added to the group. Found " + getQualifiedClassName(children[i]) + " where IAction was expected.");
				}
			}
			this.stagger = stagger;
		}
		
		/** @inheritDoc */
		override public function start():IAction {
			_lastStartIndex = -1;
			var action:IAction = super.start();
			return action;
		}
		
		/**
		 * When the first update occurs, all of the child actions are started simultaniously.
		 */
		override public function update(currentTime:int):void { 
			if ( startTimeHasElapsed(currentTime) ) {
				if (!_lastStartTime) {
					_runningChildren = _childActions.length;
				}
				if (!_lastStartTime || currentTime - _lastStartTime > _stagger) {
					_lastStartTime = currentTime;
					var currentTime:int = currentTime - delay - _startTime;
					var currentStartIndex:int = Math.floor(currentTime / _stagger);
					
					// for all of the indexes since the last index.
					for (var i:int = _lastStartIndex + 1; i <= currentStartIndex; i++) {
						if (i < childActions.length) {
							var childAction:IAction = IAction(_childActions[i]);
							// add a listener to each action so that the completion of the entire group can be tracked.
							childAction.addEventListener(KitchenSyncEvent.ACTION_COMPLETE, onChildFinished);
							childAction.addEventListener(KitchenSyncEvent.ACTION_START, onChildStart);
							// start the child action
							childAction.start();
						}
					} 
					
					_lastStartIndex = currentStartIndex;
					
					
					// if this is the last child, unregister
					if (currentStartIndex == _childActions.length - 1) {
						unregister();
					}
				}
			}
		}
		
		override public function clone():IAction {
			var clone:KSStaggeredGroup = new KSStaggeredGroup(_stagger);
			for (var i:int = 0; i < _childActions.length; i++) {
				var action:IAction = getChildAtIndex(i).clone();
				clone.addActionAtIndex(action, i);
			}
			clone.delay = _delay;
			clone.autoDelete = _autoDelete;
			return clone;
		}
		
		override public function toString():String {
			return "Staggered Group containing " + _childActions.length + " children";
		}
	}
}