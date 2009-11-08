package org.as3lib.kitchensync.action.group
{
	import org.as3lib.kitchensync.KitchenSync;
	import org.as3lib.kitchensync.action.*;
	import org.as3lib.kitchensync.core.*;
	import org.as3lib.kitchensync.utils.*;
	
	/**
	 * A group of actions that executes in sequence seperated by a specified gap.
	 * 
	 * Note that this class extends KSParallelGroup while it behaves more like a 
	 * KSSequenceGroup. This is because internally, the staggered group is more 
	 * similar structurally to the parallel group than the sequence. 
	 * 
	 * @author Mims Wright
	 * @since 0.2
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
				_stagger = 1;
			}
		}
		protected var _stagger:int;
		
		
		/**
		 * A reference to the last time that <code>update()</code>
		 * was called. Used internally. 
		 * @see #update()
		 */
		protected var _previousChildStartTime:int;
		
		/**
		 * The index of the last child action that was started.
		 * Used internally.
		 * @see #update()
		 */
		protected var _previousChildIndex:int;
		
		protected var _previousUpdate:int; 
		
		
		
		/** @inheritDoc */
		override public function get totalDuration():int {
			// add the stagger ammount to the total duration.
			return super.totalDuration + _stagger * (childActions.length - 1);
		}
		
		
		/**
		 * Constructor.
		 * 
		 * 
		 * @params stagger - The amount of time to stagger between each action starting. 
		 *					 The first one will not stagger (but will use the delay for the Staggered object)
		 * 					 Accepts an integer or a parseable string.
		 * @params children - a list of AbstractSynchronizedActions that will be added as children of the group.
		 */
		public function KSStaggeredGroup (stagger:*, ... children) {
			super();

			var l:int = children.length;
			for (var i:int=0; i < l; i++) {
				addAction(IAction(children[i]));
			}
			this.stagger = stagger;
		}
		
		/** @inheritDoc */
		override public function start():IAction {
			_previousChildStartTime = -1;
			_previousChildIndex = -1;
			var action:IAction = super.start();
			return action;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 * When the update happens, if the stagger time sicne the 
		 * last child started has elapsed, a new child is started.
		 */
		override public function update(currentTime:int):void { 
			if ( startTimeHasElapsed(currentTime) ) {
				
				// if this is the first time the group is started, 
				// reset the number of running children.
				if (_previousChildStartTime < 0) {
					_runningChildren = _childActions.length;
				}
				
				// if this is the first update or 
				// if the time since the last child started is longer than the stagger time.
				if ((_previousChildStartTime < 0) || (currentTime - _previousChildStartTime > _stagger)) {
					// store the currentTime as the last time a child was started.
					_previousChildStartTime = currentTime;
					var adjustedCurrentTime:int = currentTime - delay - _startTime;
					var currentStartIndex:int = Math.floor(adjustedCurrentTime / _stagger);
					
					// for all of the indexes since the last index.
					for (var i:int = _previousChildIndex + 1; i <= currentStartIndex; i++) {
						if (i < childActions.length) {
							var childAction:IAction = IAction(_childActions[i]);
							// add a listener to each action so that the completion of the entire group can be tracked.
							childAction.addEventListener(KitchenSyncEvent.ACTION_COMPLETE, onChildFinished);
							childAction.addEventListener(KitchenSyncEvent.ACTION_START, onChildStart);
							// start the child action
							if (childAction is IPrecisionAction) {
								// offset the start time by the stagger ammount.
								IPrecisionAction(childAction).startAtTime(_startTime + delay + i * _stagger);
							} else {
								childAction.start();
							}
						}
					} 
					
					_previousChildIndex = currentStartIndex;
					
					_previousUpdate = currentTime;
					
					// if this is the last child, unregister
					if (currentStartIndex == _childActions.length - 1) {
						unregister();
					}
				}
			}
		}
		
		/** @inheritDoc */
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