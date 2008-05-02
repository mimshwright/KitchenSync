package org.as3lib.kitchensync
{
	import flash.utils.getQualifiedClassName;
	
	/**
	 * A group of actions that executes in sequence seperated by a specified gap.
	 */
	public class Staggered extends Parallel
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
				_stagger = timeStringParser.parseTimeString(timeString);
			}
			if (_stagger <= 0) {
				throw new RangeError("Stagger amount must be an integer greater than 0.");
			}
		}
		protected var _stagger:int;
		
		protected var _lastStartTime:Timestamp;
		
		
		/**
		 * Constructor.
		 * 
		 * 
		 * @params stagger - The amount of time to stagger between each action starting. 
		 *					 The first one will not stagger (but will use the offset for the Staggered object)
		 * 					 Accepts an integer or a parseable string.
		 * @params children - a list of AbstractSynchronizedActions that will be added as children of the group.
		 * 
		 * @throws TypeError - if any children are not of type AbstractSynchronizedAction.
		 */
		public function Staggered (stagger:*, ... children) {
			super();
			for (var i:int = 0; i < children.length; i++) {
				if (children[i] is AbstractSynchronizedAction) {
					var action:AbstractSynchronizedAction = AbstractSynchronizedAction(children[i]);
					addAction(action); 
				} else {
					throw new TypeError ("All children must be of type AbstractSynchronizedAction. Make sure you are not calling start() on the objects you've added to the group. Found " + getQualifiedClassName(children[i]) + " where AbstractSynchronizedAction was expected.");
				}
			}
			this.stagger = stagger;
		}
		
		
		/**
		 * When the first update occurs, all of the child actions are started simultaniously.
		 */
		override protected function onUpdate(event:SynchronizerEvent):void {
			var time:Timestamp = event.timestamp;
			if (startTimeHasElapsed) {
				if (!_lastStartTime) {
					_runningChildren = _childActions.length;
				}
				if (!_lastStartTime || time.currentFrame - _lastStartTime.currentFrame > TimestampUtil.millisecondsToFrames(_stagger)) {
					_lastStartTime = time;
					var currentTime:int = time.currentFrame - TimestampUtil.millisecondsToFrames(offset) - _startTime.currentFrame;
					var childActionIndex:int = Math.floor(currentTime / TimestampUtil.millisecondsToFrames(_stagger));
					var childAction:AbstractSynchronizedAction = AbstractSynchronizedAction(_childActions[childActionIndex]);

					// add a listener to each action so that the completion of the entire group can be tracked.
					childAction.addEventListener(SynchronizerEvent.COMPLETE, onChildFinished);
					childAction.addEventListener(SynchronizerEvent.START, onChildStart);
					// start the child action
					childAction.start();
					
					// if this is the last child, unregister
					if (childActionIndex == _childActions.length - 1) {
						unregister();
					}
				}
			}
		}
		
		override public function clone():AbstractSynchronizedAction {
			var clone:Staggered = new Staggered(_stagger);
			clone._childActions = _childActions;
			clone.offset = _offset;
			clone.autoDelete = _autoDelete;
			return clone;
		}
		
		override public function toString():String {
			return "Staggered Group containing " + _childActions.length + " children";
		}
	}
}