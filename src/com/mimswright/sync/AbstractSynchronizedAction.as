package com.mimswright.sync
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import com.mimswright.utils.AbstractEnforcer;
	import flash.utils.ByteArray;
	import flash.net.registerClassAlias;
	
	/**
	 * This can be any action that takes place at a specifity time and uses the Synchronizer class to coordinate
	 * timing. 
	 * 
	 * @TODO - add pause() and continue (start())
	 * @todo - add stop()
	 * @todo - add a settings object
	 * @todo - add the ability to use msec instead of frames.
	 * @todo - better implementation of ids
	 */
	public class AbstractSynchronizedAction extends EventDispatcher
	{
		protected var _duration:int = 0;
		public function get duration():int { return _duration; }
		public function set duration(duration:int):void { _duration = duration; }
		
		protected var _offset:int = 0;
		public function get offset():int { return _offset; }
		public function set offset(offset:int):void { _offset = offset; }
		
	/* 	protected var _id:String;
		public function get id ():String {
			return _id;
		}
		public function set id (id:String):void { _id = id; } */
		
		protected var _startTime:Timestamp;
		protected var _running:Boolean = false;
		
		/**
		 * Constructor. Registers the action with the synchronizer.
		 * @abstract
		 */
		public function AbstractSynchronizedAction()
		{
			super(null);
			AbstractEnforcer.enforceConstructor(this, AbstractSynchronizedAction);
			register();
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
		 */
		public function start():void {
			_running = true;
			_startTime = Synchronizer.getInstance().currentTimestamp;
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
		 protected function get _startTimeHasElapsed():Boolean {
		 	if (!_startTime || !_running) { return false; }
		 	if (_startTime.currentFrame + _offset < Synchronizer.getInstance().currentTimestamp.currentFrame) { return true; }
		 	return false;
		 }
		
		/**
		 * Checks to see whether the duration of the action has elapsed and if the _startTime is defined. In other words, 
		 * checks to see whether the action is finished executing. 
		 * @return false if _startTime is null, true if the duration has elapsed.
		 */
		 protected function get _durationHasElapsed():Boolean {
		 	if (!_startTime || !_running) { return false; }
		 	if (_startTime.currentFrame + _offset + _duration-1 < Synchronizer.getInstance().currentTimestamp.currentFrame) { return true; }
		 	return false;
		 }
		
		
		public function clone():AbstractSynchronizedAction {
			AbstractEnforcer.enforceMethod();
			return this;
		}
				
		/**
		 * Call this when the action has completed.
		 * 
		 * @TODO - Make kill() optional.
		 */
		protected function complete():void {
			dispatchEvent(new SynchronizerEvent(SynchronizerEvent.COMPLETE, Synchronizer.getInstance().currentTimestamp));
			_running = false;
			kill();
		}		
		
		/**
		 * Subclass this function to remove references to objects used by the action.
		 */
		 public function kill():void {
		 	if (_running) { complete(); }
		 	unregister();
		 }
	}
}