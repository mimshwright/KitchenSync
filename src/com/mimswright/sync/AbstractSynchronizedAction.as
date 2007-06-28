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
	 * -todo - add pause() and continue (start())
	 * -todo - add stop()
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
		
		protected var _startTime:Timestamp;
		protected var _running:Boolean = false;
		
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
		public function register():void {
			Synchronizer.getInstance().addEventListener(SynchronizerEvent.UPDATE, onUpdate);
		}
		
		/**
		 * Removes the action as a listener to the Synchronizer's update event.
		 */
		public function unregister():void {
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
				_running = true;
				register();
				_startTime = Synchronizer.getInstance().currentTimestamp;
			} else {
				throw new IllegalOperationError("The start() method cannot be called when the action is already running. Try stopping the action first or using the clone() method to create a copy of it.");
			}
		}
		
		/**
		 * Causes the action to start playing when another event completes.
		 * 
		 * @param trigger Another action that will trigger the start of this action.
		 * @throws flash.errors.Error If the trigger action is the same as this action.
		 * 
		 * @todo - add removeTrigger() method
		 */
		public function addTrigger(trigger:AbstractSynchronizedAction):void {
		 	if (trigger == this) { throw new Error("An action cannot be triggered by itself."); }
			trigger.addEventListener(SynchronizerEvent.COMPLETE, onTrigger, false, 0, true);
		}

		/**
		 * Causes the action to start playing when a specified event is fired.
		 * 
		 * @param dispatcher The object that will dispatch the event.
		 * @param eventType The event type to listen for.
		 * 
		 * @todo - add removeEventTrigger() method
		 */
		public function addEventTrigger(dispatcher:IEventDispatcher, eventType:String):void {
			dispatcher.addEventListener(eventType, onTrigger, false, 0, true);
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
		 protected function get startTimeHasElapsed():Boolean {
		 	if (!_startTime || !_running) { return false; }
		 	if (_startTime.currentFrame + _offset < Synchronizer.getInstance().currentTimestamp.currentFrame) { return true; }
		 	return false;
		 }
		
		/**
		 * Checks to see whether the duration of the action has elapsed and if the _startTime is defined. In other words, 
		 * checks to see whether the action is finished executing. 
		 * @return false if _startTime is null, true if the duration has elapsed.
		 */
		 protected function get durationHasElapsed():Boolean {
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
		 * 
		 * -todo - Make kill() optional.
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