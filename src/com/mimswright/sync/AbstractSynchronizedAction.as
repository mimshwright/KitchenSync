package com.mimswright.sync
{
	import com.mimswright.utils.AbstractEnforcer;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * This can be any action that takes place at a specifity time and uses the Synchronizer class to coordinate
	 * timing. 
	 * 
	 * -todo - test pause, stop, reset on functions and events
	 * -todo - test removeTrigger method
	 * -todo - add a settings object
	 * -todo - add the ability to use msec instead of frames.
	 * -todo - better implementation of ids
	 */
	public class AbstractSynchronizedAction extends EventDispatcher
	{
		protected var _duration:int = 0;
		public function get duration():int { return _duration; }
		public function set duration(duration:int):void { _duration = duration; }
		
		protected var _offset:int = 0;
		public function get offset():int { return _offset; }
		public function set offset(offset:int):void { _offset = offset; }
		
		protected var _autoDelete:Boolean = true;
		public function get autoDelete():Boolean { return _autoDelete; }
		public function set autoDelete(autoDelete:Boolean):void { _autoDelete = autoDelete; }
		
	/* 	protected var _id:String;
		public function get id ():String {
			return _id;
		}
		public function set id (id:String):void { _id = id; } */
		
		protected var _running:Boolean = false;
		public function get isRunning ():Boolean { return _running; }
		protected var _paused:Boolean = false;
		public function get isPaused ():Boolean { return _paused; }
		
		protected var _startTime:Timestamp;
		protected var _pauseTime:Timestamp;
		
		/**
		 * Constructor.
		 * @abstract
		 */
		public function AbstractSynchronizedAction()
		{
			super(null);
			AbstractEnforcer.enforceConstructor(this, AbstractSynchronizedAction);
		}
		
		/**
		 * Adds the action as a listener to the Synchronizer's update event.
		 */
		internal function register():void {
			Synchronizer.getInstance().addEventListener(SynchronizerEvent.UPDATE, onUpdate);
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
		public function start():void {
			if (!_running) {
				if (_paused) {
					unpause();				
				} else {
					_running = true;
					register();
					_startTime = Synchronizer.getInstance().currentTimestamp;
				}
			} else {
				throw new IllegalOperationError("The start() method cannot be called when the action is already running. Try stopping the action first or using the clone() method to create a copy of it.");
			}
		}
		
		/**
		 * Causes the action to be paused. The onUpdate event will not be called. When unpause() is called,
		 * the action will continue where it was paused (including offset).
		 * 
		 * @throws flash.errors.IllegalOperationError - if the action is already paused.
		 */
		public function pause():void {
			if (!_running) {
				// Do nothing
				
				//throw new IllegalOperationError("The pause() method cannot be called when the action is not already running or after it has finished running. Use the start() method first.");
			} else if (_paused) {
				throw new IllegalOperationError("The pause() method cannot be called when the action is already paused. Use the unpause() method first.");
			} else {
				_pauseTime = Synchronizer.getInstance().currentTimestamp;
				_paused = true;
				unregister();
			}
		}
		
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
		 * 
		 * @todo - test
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
		 * 
		 * @todo - test
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
		internal function onUpdate(event:SynchronizerEvent):void {
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * Checks to see whether the start time offset has elapsed and if the _startTime is defined. In other words, 
		 * checks to see whether the action is ready to execute. Duration is handled seperately.
		 * @return false if _startTime is null, true if the offset has elapsed.
		 */
		 public function get startTimeHasElapsed():Boolean {
		 	if (!_startTime || !_running) { return false; }
		 	if (_startTime.currentFrame + _offset < Synchronizer.getInstance().currentTimestamp.currentFrame) { return true; }
		 	return false;
		 }
		
		/**
		 * Checks to see whether the duration of the action has elapsed and if the _startTime is defined. In other words, 
		 * checks to see whether the action is finished executing. 
		 * @return false if _startTime is null, true if the duration has elapsed.
		 */
		 public function get durationHasElapsed():Boolean {
		 	if (!_startTime || !_running) { return false; }
		 	if (_startTime.currentFrame + _offset + _duration-1 < Synchronizer.getInstance().currentTimestamp.currentFrame) { return true; }
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
			dispatchEvent(new SynchronizerEvent(SynchronizerEvent.COMPLETE, Synchronizer.getInstance().currentTimestamp));
			_running = false;
			unregister();
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