package org.as3lib.kitchensync.action
{
	import flash.errors.*;
	import flash.events.*;
	
	import org.as3lib.kitchensync.*;
	import org.as3lib.kitchensync.core.*;
	import org.as3lib.kitchensync.utils.*;
	import org.as3lib.utils.AbstractEnforcer;
	
	/** @eventType org.as3lib.kitchensync.core.KitchenSyncEvent.ACTION_START */
	[Event(name="actionStart", type="org.as3lib.kitchensync.core.KitchenSyncEvent")]
	
	/** @eventType org.as3lib.kitchensync.core.KitchenSyncEvent.ACTION_PAUSE */
	[Event(name="actionPause", type="org.as3lib.kitchensync.core.KitchenSyncEvent")]
	
	/** @eventType org.as3lib.kitchensync.core.KitchenSyncEvent.ACTION_UNPAUSE */
	[Event(name="actionUnpause", type="org.as3lib.kitchensync.core.KitchenSyncEvent")]

	/** @eventType org.as3lib.kitchensync.core.KitchenSyncEvent.ACTION_COMPLETE */
	[Event(name="actionComplete", type="org.as3lib.kitchensync.core.KitchenSyncEvent")]
	
	/**
	 * A default implementation of IAction. 
	 *
	 * @see IAction
	 * 
	 * @author Mims Wright
	 * @since 0.1
	 */
	 // todo - review this class in detail. Update docs, make sure everything is correct.
	 // todo - better implementation of ids
	public class AbstractAction extends EventDispatcher implements IJumpableAction
	{	
		
		/**
		 * duration is the length of time that the action will run.
		 * Will accept an integer or a parsable string.
		 * 
		 * @see org.as3lib.kitchensync.ITimeStringParser
		 */
		public function get duration():int { return _duration; }
		public function set duration(duration:*):void { 
			if (!isNaN(duration)) {
				_duration = duration;
			} else {
				var timeString:String = duration.toString();
				_duration = KitchenSync.timeStringParser.parseTimeString(timeString);
			}
		}
		protected var _duration:int = 0;
		
		
		/**
		 * delay is the time that will pass after the start() method is called
		 * before the action begins.
		 * Will accept an integer or a parsable string.
		 * 
		 * @see org.as3lib.kitchensync.ITimeStringParser
		 */
		public function get delay():int { return _delay; }
		public function set delay(delay:*):void { 
			if (!isNaN(delay)) {
				_delay = delay;
			} else {
				var timeString:String = delay.toString();
				_delay = KitchenSync.timeStringParser.parseTimeString(timeString);
			}
		}
		protected var _delay:int = 0;
		
		
		/** @inheritDoc */
		public function get isInstantaneous():Boolean {
			return ( _delay <= 0 && _duration <= 0 );
		}
		
		
		/**
		 * autoDelete is a flag that indicates whether the action should be killed 
		 * when it is done executing. The default is set in KitchenSyncDefaults
		 * 
		 * @see org.as3lib.kitchensync.KitchenSyncDefaults
		 */
		public function get autoDelete():Boolean { return _autoDelete; }
		public function set autoDelete(autoDelete:Boolean):void { _autoDelete = autoDelete; }
		protected var _autoDelete:Boolean;
		
		
		// todo: what's this about?
		// removed for now.
		/**
		 * The human-readable name of this action. 
		public function get name():String { return _name; }
		public function set name(name:String):void { _name = name; }
		protected var _name:String;
		 */
		
		
		/**
		 * @inheritDoc
		 */
		public function get isRunning ():Boolean { return _running; }
		protected var _running:Boolean = false;
		
		
		/**
		 * @inheritDoc
		 */ 
		public function get isPaused ():Boolean { return _paused; }
		protected var _paused:Boolean = false;
		
		
		/**
		 * The time at which the action was last started.
		 */
		internal function get startTime():int { return _startTime; }
		protected var _startTime:int;
		
		/**
		 * The time at which the action was last paused.
		 */
		internal function get pauseTime():int { return _pauseTime; }
		protected var _pauseTime:int;
		
		
		/**
		 * @inheritDoc
		 */ 
		public function get runningTime():int { 
			if (!_running) { return 0; }
			// If the action is paused, factor that into the results
			if (isPaused) {
				return  (_pauseTime - _startTime);
			} else {
				return (Synchronizer.getInstance().currentTime - _startTime); 
			}
		}
		
		
		/**
		 * Constructor.
		 * @abstract
		 */
		public function AbstractAction()
		{
			super();
			autoDelete = KitchenSyncDefaults.autoDelete;
			
			AbstractEnforcer.enforceConstructor(this, AbstractAction);
		}
		
		/**
		 * Adds the action as a listener to the Synchronizer's update event.
		 * Used internally.
		 */
		internal function register():void {
			Synchronizer.getInstance().registerClient(this);
			
			// since the first update won't occur until the next frame, force one here to make it
			// happen right away.
			forceUpdate();
		}
		
		/**
		 * Removes the action as a listener to the Synchronizer's update event.
		 * Used internally.
		 */
		internal function unregister():void {
			Synchronizer.getInstance().unregisterClient(this);
		}
		
		/**
		 * @inheritDoc 
		 */
		public function start():IAction {
			if (_paused) {
				unpause();				
			} else {
				if (!_running) {
					_running = true;
					_startTime = Synchronizer.getInstance().currentTime;
					register();
					dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.ACTION_START, _startTime));
				} else {
					throw new IllegalOperationError("The start() method cannot be called when the action is already running. Try stopping the action first or using the clone() method to create a copy of it.");
				}
			}
			return this;
		}
		
		/** 
		 * @inheritDoc 
		 */
		public function pause():void {
			if (_running && !_paused) {
				var currentTime:int = Synchronizer.getInstance().currentTime;
				_pauseTime = currentTime;
				_paused = true;
				unregister();
				dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.ACTION_PAUSE, currentTime));
			}
		}
		
		/** @inheritDoc */
		public function unpause():void {
			if (!_running && !_paused) {
				_paused = false;
				var currentTime:int = Synchronizer.getInstance().currentTime;
				var timeSincePause:int = currentTime - _pauseTime;
				_startTime = _startTime + timeSincePause; 
				register();
				dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.ACTION_UNPAUSE, currentTime));
			}
		}
		
		
		/** @inheritDoc */
		public function stop():void {
			if (_running) { 
				_paused = false;
				_running = false;
				_startTime = -1;
				unregister();
			}
		}
		
		/** @inheritDoc */
		public function reset():void {
			stop();
		}
		
		/** @inheritDoc */
		public function jumpToTime(time:*, ignoreDelay:Boolean = false):void {
			// jumpToTime will fail if the action isn't running.
			if (!isRunning || isInstantaneous) { 
				// todo: make this error optional.
				throw new IllegalOperationError("Can't jump to time if the action isn't running or if duration is 0.");
				return; 
			}
			
			// parse time strings if this is a string.
			var jumpTime:int;
			//if time is a number
			if (!isNaN(time)) {
				jumpTime = int(time);
			} else {
				var timeString:String = time.toString();
				jumpTime = KitchenSync.timeStringParser.parseTimeString(timeString);
			}
			
			// Ignore the delay in this equation if ignoreDelay is true.
			var totalDuration:int = ignoreDelay ? duration : duration + delay;
			
			var currentTime:int = Synchronizer.getInstance().currentTime;
			
			// check that the jump time is valid
			if (jumpTime > totalDuration || jumpTime < 0) {
				// you can't jump to a time that is past the end of the action's total time.
				// todo: make this error optional.
				throw new RangeError("'time' must be less than the total time of the action and greater than 0.");
			} else {
				// adjust the startTime to make it appear that the playhead should be at 
				// a different point in time on the next update.
				_startTime = -1 * (jumpTime - currentTime); //_startTime - jumpTime - runningTime;
				
				// if ignoring the delay, also move the playhead forward by the delay amount.
				if (ignoreDelay) { 
					_startTime = _startTime - delay; 
				} 
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function jumpByTime(time:*):void {
			// parse time strings if this is a string.
			var jumpTime:int;
			//if time is a number
			if (!isNaN(time)) {
				jumpTime = int(time);
			} else {
				var timeString:String = time.toString();
				jumpTime = KitchenSync.timeStringParser.parseTimeString(timeString);
			}
			
			jumpToTime(runningTime + jumpTime);
		}
				
		/**
		 * Causes the action to start playing when another event completes.
		 * 
		 * @param trigger Another action that will trigger the start of this action.
		 * @throws flash.errors.Error If the trigger action is the same as this action.
		 */
		public function addTrigger(trigger:IAction):void {
		 	if (trigger == this) { throw new Error("An action cannot be triggered by itself."); }
			trigger.addEventListener(KitchenSyncEvent.ACTION_COMPLETE, onTrigger);
		}

// TODO: Consider removing the trigger system from KS.

		/**
		 * Removes a trigger added with addTrigger().
		 * 
		 * @param trigger Another action that triggers the start of this action.
		 */
		public function removeTrigger(trigger:IAction):void {
		 	trigger.removeEventListener(KitchenSyncEvent.ACTION_COMPLETE, onTrigger);
		}
		
		/**
		 * Causes the action to start playing when a specified event is fired.
		 * 
		 * @param dispatcher The object that will dispatch the event.
		 * @param eventType The event type to listen for.
		 */
		public function addEventTrigger(dispatcher:IEventDispatcher, eventType:String):void {
			dispatcher.addEventListener(eventType, onTrigger);
		}

		/**
		 * Removes an event trigger added by addEventTrigger().
		 * 
		 * @param dispatcher The event dispatcher to remove.
		 * @param eventType The event type to listen for.
		 */
		public function removeEventTrigger(dispatcher:IEventDispatcher, eventType:String):void {
			dispatcher.removeEventListener(eventType, onTrigger);
		}
		
		/**
		 * Handler that starts playing the action that is called by a trigger event.
		 * @see #addTrigger()
		 * @see #addEventTrigger()
		 * 
		 */
		 // todo - make sure this doesn't screw up if there are multiple triggers or if the thing isn't meant to repeat.
		protected function onTrigger(event:Event):void {
			if (!_running) { start(); }
		}
		
		
		/**
		 * This function will be registered by the register method to respond to update events from the synchronizer.
		 * Code that performs the action associated with this object should go in this function.
		 * This function must be implemented by the subclass.
		 * 
		 * @abstract
		 * @param currentTimestamp The current timestamp from the Synchronizer.
		 */
		public function update(currentTime:int):void {
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * Foreces the update() method to fire without being triggered by Synchronizer.
		 * 
		 * @see #update()
		 */
		protected function forceUpdate():void {
			update(Synchronizer.getInstance().currentTime);
		}
		
		/**
		 * Checks to see whether the start time delay has elapsed and if the _startTime is defined. In other words, 
		 * checks to see whether the action is ready to execute. Duration is handled seperately.
		 * 
		 * @param currentTime The current time according to the Synchronizer. 
		 * @return false if _startTime is null, true if the delay has elapsed.
		 */
		 public function startTimeHasElapsed(currentTime:int):Boolean {
		 	if (isNaN(_startTime) || !_running || _paused) { return false; }
			if (_startTime + _delay <= currentTime) { return true; }
		 	return false;
		 }
		
		/**
		 * Checks to see whether the duration of the action has elapsed and if the _startTime is defined. In other words, 
		 * checks to see whether the action is finished executing. 
		 * 
		 * @return false if _startTime is null, true if the duration has elapsed.
		 */
		 public function durationHasElapsed(currentTime:int):Boolean {
		 	if (isNaN(_startTime) || !_running || _paused) { return false; }
	 		if (_startTime + _delay + _duration <= currentTime) { return true; }		 		
		 	return false;
		 }
		 

		/**
		 * Creates a copy of the object with all the property values of the original and returns it.
		 * This method should be overrided by child classes to ensure that all properties are copied.
		 * 
		 * @abstract
		 * @returns IAction A copy of the original object. Type casting may be necessary.
		 */
		public function clone():IAction {
			AbstractEnforcer.enforceMethod();
			return this;
		}
				
		/**
		 * Internal function that completes the action by cleaning up any running processes
		 * and unregistering it from the synchronizer. Called when the action has completed.
		 */
		 // todo: make this function use a parameter for currentTime instead of asking synchronizer
		protected function complete():void {
			_running = false;
			unregister();
			dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.ACTION_COMPLETE, Synchronizer.getInstance().currentTime));
			if (_autoDelete) { kill(); }
		}		
		
		/**
		 * Unregisters the function and removes any refrerences to objects that it may be holding onto.
		 * Subclass this function to remove references to objects used by the action.
		 */
		 public function kill():void {
		 	if (_running) { complete(); }
		 }
	}
}