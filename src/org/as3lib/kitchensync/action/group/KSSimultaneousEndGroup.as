package org.as3lib.kitchensync.action.group
{
	import flash.utils.Dictionary;
	
	import org.as3lib.kitchensync.action.*;
	import org.as3lib.kitchensync.core.KitchenSyncEvent;
	
	/**
	 * A simultaneous-end-group or reverse-parallel-group where where all children 
	 * END at the same time instead of starting at the same time. Instantaneous items 
	 * such as KSFunctions will play at the end. 
	 * 
	 * @example <listing version="3.0">
	 * var sprite:Sprite = new Sprite();
	 * sprite.graphics.beginFill(0);
	 * sprite.graphics.drawCircle(50,50,20);
	 * addChild(sprite);
	 * 
	 * // In this group, the circle will move from left to right over the course of 5 seconds
	 * // then 3 seconds in to the animation, the circle will move down as well. 
	 * // The X and Y animations will end at precicely the same time. 
	 * 
	 * var longTween:IAction = new KSSimpleTween(sprite, "x", 0, 200, 5000, 0, Cubic.easeInOut);
	 * var shortTween:IAction = new KSSimpleTween(sprite, "y", 0, 200, 2000, 0, Cubic.easeInOut);
	 * 
	 * var simultaneousEndGroup:IActionGroup = new KSSimultaneousEndGroup(longTween, shortTween);
	 * simultaneousEndGroup.start(); 
	 * </listing>
	 * 
	 * @author Mims Wright
	 * @since 1.6
	 */
	public class KSSimultaneousEndGroup extends KSParallelGroup {
		
		/**
		 * The duration of the longest item in the group. 
		 */
		private var _longestItemsTotalDuration:int;
		
		/**
		 * Dictionary for tracking the start times of all the children
		 * in the group. 
		 */
		private var _childStartTimes:Dictionary;
		
		/** Constructor. */
		public function KSSimultaneousEndGroup (... children) {
			super();
			var l:int = children.length;
			for (var i:int = 0; i < l; i++) {
				addAction(IAction(children[i])); 
			}
		}
		
		/** @inheritDoc */
		override public function update(currentTime:int):void {
			if (startTimeHasElapsed(currentTime) ) {
				var childAction:IAction;
				// if the group isn't already running...
				if (!childrenAreRunning) {
					// reset the number of running children.
					_runningChildren = 0;				
					// cache the longest duration
					_longestItemsTotalDuration = getLongestItemsTotalDuration();
					// reset the dictionary.
					_childStartTimes = new Dictionary(true);
					
					// for all child actions
					childAction = null;
					for each (childAction in childActions) {
						// add the start time to a dictionary.
						_childStartTimes[childAction] = calculateStartTime(childAction, _longestItemsTotalDuration);
						
						// add a listener to each action so that the completion of the entire group can be tracked.
						childAction.addEventListener(KitchenSyncEvent.ACTION_START, onChildStart);
						childAction.addEventListener(KitchenSyncEvent.ACTION_COMPLETE, onChildFinished);
						
						//trace("final start time: " + _childStartTimes[childAction]);
					}
				}
				
				childAction = null;
				// Once it's running, for all child actions
				for each (childAction in childActions) {
					// check to see if start time has elapsed for the child.
					if (isChildStartTimeElapsed(childAction, currentTime)) {
						// if so, start the child.
						childAction.start();
						// add one running child.
						_runningChildren++;
					}
				}
				// if all children are running, unregister the group.
				if (_runningChildren >= _childActions.length) { unregister(); }
			}
		}
		
		/**
		 * Determines if the child should start yet.
		 */
		 private function isChildStartTimeElapsed(childAction:IAction, currentTime:int):Boolean {
		 	if (childAction.isRunning) { return false; }
		 	var startTime:int = _childStartTimes[childAction];
		 	
			if (startTime <= currentTime) { return true; }
			return false;
		 }
		
		/**
		 * Calculates the start time for an action using the following formula:
		 * S: start time for item.
		 * G: start time for the group.
		 * L: longest item's delay and duration.
		 * O: item's offset
		 * D: item's duration
		 * S = G + L - O - D
		 * 
		 * @param action The action to get the start time for.
		 * @param longestItemsTotalDuration The delay + duration of the longest item.
		 */
		 private function calculateStartTime(action:IAction, longestItemsTotalDuration:int):int {
		 	return _startTime + longestItemsTotalDuration - action.delay - action.duration;
		 }
		
		/**
		 * Returns the combined duration and delay for the item(s) with the longest combined delay and duration.
		 * 
		 * @return int The longest time of any child action.
		 */
		private function getLongestItemsTotalDuration():int {
			var longestTime:int = 0;
			var currentTime:int = 0;
			if (childActions.length > 0) {
				for each (var action:IAction in childActions) {
					// get combined delay and duration.
					currentTime = action.delay + action.duration;
					// if it's the longest, save the value. 
					longestTime = currentTime > longestTime ? currentTime : longestTime;
				}	
			}
			return longestTime;
		}
		
	}
}