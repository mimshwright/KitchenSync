package com.mimswright.sync
{
	import flash.errors.*;
	import flash.events.*;
	
	import org.as3lib.utils.AbstractEnforcer;
	
	[Event(name="actionStart", type="com.mimswright.sync.SynchronizerEvent")]
	[Event(name="actionPause", type="com.mimswright.sync.SynchronizerEvent")]
	[Event(name="actionUnpause", type="com.mimswright.sync.SynchronizerEvent")]
	[Event(name="actionComplete", type="com.mimswright.sync.SynchronizerEvent")]
	
	/**
	 * This can be any action that takes place at a specifity time and uses the Synchronizer class to coordinate
	 * timing. 
	 * 
	 * -todo - sync mode seems to work but i'm seeing multiple calls of the same function sometimes one frame apart.
	 * 		18100 msec; 819 frames We use debuggers
	 * 		18121 msec; 820 frames We use debuggers
	 * -todo - add a settings object
	 * -todo - better implementation of ids
	 */
	public class AbstractSynchronizedAction extends EventDispatcher
	{	
		
		/** 
		 * The timeStringParser will determine how strings are parsed into valid 
		 * time values.
		 * 
		 * @see com.mimswright.sync.ITimeStringParser
		 * @see com.mimswright.sync.TimeStringParser_en
		 */
		public static var timeStringParser:ITimeStringParser;
		
		
		/**
		 * duration is the length of time that the action will run.
		 * Will accept an integer or a parsable string.
		 * 
		 * @see com.mimswright.sync.ITimeStringParser
		 * @see #timeUnit
		 */
		public function get duration():int { return _duration; }
		public function set duration(duration:*):void { 
			if (!isNaN(duration)) {
				_duration = duration;
			} else {
				var timeString:String = duration.toString();
				_duration = timeStringParser.parseTimeString(timeString);
			}
		}
		protected var _duration:int = 0;
		
		
		/**
		 * offset is the time that will pass after the start() method is called
		 * before the action begins. Also known as delay.
		 * Will accept an integer or a parsable string.
		 * 
		 * @see com.mimswright.sync.ITimeStringParser
		 * 
		 * @see #timeUnit
		 */
		public function get offset():int { return _offset; }
		public function set offset(offset:*):void { 
			if (!isNaN(offset)) {
				_offset = offset;
			} else {
				var timeString:String = offset.toString();
				_offset = timeStringParser.parseTimeString(timeString);
			}
		}
		protected var _offset:int = 0;
		
		
		/**
		 * autoDelete is a flag that indicates whether the action should be deleted 
		 * when it is done executing. The default is set to false so the actions must 
		 * be deleted manually.
		 */
		public function get autoDelete():Boolean { return _autoDelete; }
		public function set autoDelete(autoDelete:Boolean):void { _autoDelete = autoDelete; }
		protected var _autoDelete:Boolean;
		
		
		/** 
		 * Setting sync to true will cause the action to sync up with real time
		 * even if framerate drops. Otherwise, the action will be synced to frames.
		 */ 
		public function get sync():Boolean { return _sync; }
		public function set sync(sync:Boolean):void { _sync = sync; }
		protected var _sync:Boolean;
		
		
		/**
		 * The human-readable name of this action. 
		 */
		public function get name():String { return _name; }
		public function set name(name:String):void { _name = name; }
		protected var _name:String;
		
		
		/**
		 * Will return true when the action is running (after start() has been called).
		 * Will continue running until stop() is called or until the action is completed.
		 * Pausing does not change the value of isRunning.
		 */
		public function get isRunning ():Boolean { return _running; }
		protected var _running:Boolean = false;
		
		
		/**
		 * Will return true if the action is paused (after pause() has been called).
		 * Calling unpause() or stop() will return the value to false.
		 */ 
		public function get isPaused ():Boolean { return _paused; }
		protected var _paused:Boolean = false;
		
		
		/**
		 * The time at which the action was last started.
		 */
		protected var _startTime:Timestamp;
		// DEBUG
		public function get startTime():Timestamp { return _startTime; }
		//
		
		/**
		 * The time at which the action was last paused.
		 */
		protected var _pauseTime:Timestamp;
		// DEBUG
		public function get pauseTime():Timestamp { return _pauseTime; }
		//
		
		/**
		 * Constructor.
		 * @abstract
		 */
		public function AbstractSynchronizedAction()
		{
			super(null);
			
			timeStringParser = ActionDefaults.timeStringParser;
			autoDelete = ActionDefaults.autoDelete;
			sync = ActionDefaults.sync;
			
			AbstractEnforcer.enforceConstructor(this, AbstractSynchronizedAction);
		}
		
		/**
		 * Adds the action as a listener to the Synchronizer's update event.
		 * 
		 * @todo see if moving forceUpdate() into start helps.
		 */
		internal function register():void {
			Synchronizer.getInstance().addEventListener(SynchronizerEvent.UPDATE, onUpdate);
			
			// since the first update won't occur until the next frame, force one here to make it
			// happen right away.
			forceUpdate();
		}
		
		/**
		 * Removes the action as a listener to the Synchronizer's update event.
		 */
		internal function unregister():void {
			Synchronizer.getInstance().removeEventListener(SynchronizerEvent.UPDATE, onUpdate);
		}
		
		/**
		 * Starts the timer for this action.
		 * Registers the action with the synchronizer.
		 * 
		 * @throws flash.errors.IllegalOperationError - if the method is called while the action is already running.
		 */
		public function start():AbstractSynchronizedAction {
			if (_paused) {
				unpause();				
			} else {
				if (!_running) {
					_running = true;
					_startTime = Synchronizer.getInstance().currentTimestamp;
					register();
					dispatchEvent(new SynchronizerEvent(SynchronizerEvent.START, _startTime));
				} else {
					throw new IllegalOperationError("The start() method cannot be called when the action is already running. Try stopping the action first or using the clone() method to create a copy of it.");
				}
			}
			return this;
		}
		
		/**
		 * Causes the action to be paused. The action temporarily ignores update events from the Synchronizer 
		 * and the onUpdate() handler will not be called. When unpause() is called,
		 * the action will continue at the point where it was paused.
		 * If the pause() method affects the start time even if the offset time hasn't expired yet. 
		 */
		public function pause():void {
			if (!_running) {
				// Do nothing
				
				//throw new IllegalOperationError("The pause() method cannot be called when the action is not already running or after it has finished running. Use the start() method first.");
			} else if (_paused) {
				//throw new IllegalOperationError("The pause() method cannot be called when the action is already paused. Use the unpause() method first.");
			} else {
				_pauseTime = Synchronizer.getInstance().currentTimestamp;
				_paused = true;
				unregister();
				dispatchEvent(new SynchronizerEvent(SynchronizerEvent.PAUSE, _pauseTime));
			}
		}
		
		/**
		 * Resumes the action at the point where it was paused.
		 */
		public function unpause():void {
			if (!_running) {
				//throw new IllegalOperationError("The unpause() method cannot be called when the action is not already running or after it has finished running. Use the start() method first.");
			} else if (!_paused) {
				//throw new IllegalOperationError("The unpause() method cannot be called when the action is not already paused. Use the pause() method first.");
			} else {
				register();
				_paused = false;
				var timeSincePause:Timestamp = TimestampUtil.subtract(Synchronizer.getInstance().currentTimestamp, _pauseTime);
				_startTime = TimestampUtil.add(_startTime, timeSincePause); 
				dispatchEvent(new SynchronizerEvent(SynchronizerEvent.UNPAUSE, _startTime));
				//trace("_pauseTime:", _pauseTime);
				//trace("_startTime:", _startTime);
				//trace("timeSincePause:", timeSincePause);
				
			}
		}
		
		
		/**
		 * Stops the action from running and resets the timer.
		 */
		public function stop():void {
			_paused = false;
			_running = false;
			_startTime = null;
			unregister();
		}
		
		/**
		 * Causes the action to start playing when another event completes.
		 * 
		 * @param trigger Another action that will trigger the start of this action.
		 * @throws flash.errors.Error If the trigger action is the same as this action.
		 */
		public function addTrigger(trigger:AbstractSynchronizedAction):void {
		 	if (trigger == this) { throw new Error("An action cannot be triggered by itself."); }
			trigger.addEventListener(SynchronizerEvent.COMPLETE, onTrigger);
		}

		/**
		 * Removes a trigger added with addTrigger().
		 * 
		 * @param trigger Another action that triggers the start of this action.
		 */
		public function removeTrigger(trigger:AbstractSynchronizedAction):void {
		 	trigger.removeEventListener(SynchronizerEvent.COMPLETE, onTrigger);
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
		 * @todo make sure this doesn't screw up if there are multiple triggers or if the thing isn't meant to
		 * 		repeat.
		 */
		protected function onTrigger(event:Event):void {
			if (!_running) { start(); }
		}
		
		
		
		/**
		 * This function will be registered by the register method to respond to update events from the synchronizer.
		 * Code that performs the action associated with this object should go in this function.
		 * This function must be implemented by the subclass.
		 * The internal allows certain other classes such as the AbstractSynchronizedGroup to force an update 
		 * of its children.
		 * 
		 * @abstract
		 * @param event - A SychronizerEvent with a timestamp from the Synchronizer.
		 */
		protected function onUpdate(event:SynchronizerEvent):void {
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * Foreces the onUpdate() method to fire without being triggered by Synchronizer.
		 * 
		 * @see #onUpdate()
		 */
		protected function forceUpdate():void {
			onUpdate(new SynchronizerEvent(SynchronizerEvent.UPDATE, Synchronizer.getInstance().currentTimestamp));
		}
		
		/**
		 * Checks to see whether the start time offset has elapsed and if the _startTime is defined. In other words, 
		 * checks to see whether the action is ready to execute. Duration is handled seperately.
		 * @return false if _startTime is null, true if the offset has elapsed.
		 */
		 public function get startTimeHasElapsed():Boolean {
		 	if (!_startTime || !_running || _paused) { return false; }
			if (_sync) {
				if (_startTime.currentTime + _offset <= Synchronizer.getInstance().currentTimestamp.currentTime) { return true; }
			} else {
				if (_startTime.currentFrame + TimestampUtil.millisecondsToFrames(_offset) <= Synchronizer.getInstance().currentTimestamp.currentFrame) { return true; }
			}
		 	return false;
		 }
		
		/**
		 * Checks to see whether the duration of the action has elapsed and if the _startTime is defined. In other words, 
		 * checks to see whether the action is finished executing. 
		 * @return false if _startTime is null, true if the duration has elapsed.
		 */
		 public function get durationHasElapsed():Boolean {
		 	if (!_startTime || !_running || _paused) { return false; }
		 	if (_sync) {
		 		if (_startTime.currentTime + _offset + _duration < Synchronizer.getInstance().currentTimestamp.currentTime) { return true; }		 		
		 	} else {
		 		if (_startTime.currentFrame + TimestampUtil.millisecondsToFrames(_offset) + TimestampUtil.millisecondsToFrames(_duration)-1 < Synchronizer.getInstance().currentTimestamp.currentFrame) { return true; }
		 	}
		 	return false;
		 }
		 

		/**
		 * Creates a copy of the object with all the property values of the original and returns it.
		 * This method should be overrided by child classes to ensure that all properties are copied.
		 * 
		 * @abstract
		 * @returns AbstractSyncrhonizedAction - A copy of the original object. Type casting may be necessary.
		 */
		public function clone():AbstractSynchronizedAction {
			AbstractEnforcer.enforceMethod();
			return this;
		}
				
		/**
		 * Call this when the action has completed.
		 */
		protected function complete():void {
			_running = false;
			unregister();
			dispatchEvent(new SynchronizerEvent(SynchronizerEvent.COMPLETE, Synchronizer.getInstance().currentTimestamp));
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