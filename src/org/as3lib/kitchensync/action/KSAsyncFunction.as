package org.as3lib.kitchensync.action
{
	import flash.events.*;
	
	import org.as3lib.kitchensync.core.*;
	
	/**
	 * An action for calling an asynchronous function that is expected to dipatch an event when
	 * it completes. This could be, for example, a server-side operation such as loading
	 * a file from a remote system. 
	 * 
	 * @author Mims Wright
	 * @since 1.5
	 */
	 // todo: add example
	public class KSAsyncFunction extends KSFunction
	{
		/** a reference to the event dispatcher */
		protected var _completeEventDispatcher:IEventDispatcher;
		/** the type of event to listen for */
		protected var _completeEventType:String;
		
		protected var _isComplete:Boolean = false;
		
		/** 
		 * @inheritDoc
		 * 
		 * This class isn't instantaneous even though the duration can only be 
		 * set to 0.
		 */
		override public function get isInstantaneous() : Boolean {
			return false;
		}
		
		/** @overrideDoc */
		override public function get progress ():Number { 
			if (_isComplete) { return 1; }
			return 0;
		}
		
		/**
		 * Constructor.
		 * 
		 * @param delay The time to wait before calling the function.
		 * @param func The function to call
		 * @param completeEventDispatcher The IEventDispatcher that will fire the event signaling that the 
		 * 								  function is complete.
		 * @param completeEventType The type (name) of the event that will be fired when complete.
		 * @param args All additional parameters will be passed as arguments to the function when it is called. 
		 */
		public function KSAsyncFunction(func:Function, completeEventDispatcher:IEventDispatcher, completeEventType:String, ...args)
		{
			super(func);
			this._args = args;
			
			_completeEventDispatcher = completeEventDispatcher;
			_completeEventType = completeEventType;
			
			_completeEventDispatcher.addEventListener(_completeEventType, onFunctionComplete, false, 0, false);
		}
		
		/**
		 * Executes the function when the delay has elapsed.
		 */
		override public function update(currentTime:int):void {
			if (startTimeHasElapsed(currentTime)) {
				invoke();
				unregister();
			}
		}
		
		
		/**
		 * @inheritDoc
		 * 
		 * NOTE: Pausing this doesn't actually pause the asynchronous function, however, 
		 * it does pause the action from completing.  
		 */
		override public function pause() : void {
			super.pause();
			trace("Warning: Pausing a KSAsyncFunction will not stop the funciton from executing.");
		}
		
		override public function unpause() : void {
			_paused = false;
			if (_isComplete) {
				complete();
			}
		}

		/**
		 * @inheritDoc
		 * 
		 * NOTE: Stopping this doesn't actually stop the asynchronous function, however, 
		 * it does stop the action from completing.  
		 */
		override public function stop() : void {
			trace("Warning: Pausing a KSAsyncFunction will not stop the funciton from executing.");
		}
	
		
		/** @inheritDoc */
		override public function start() : IAction {
			_isComplete = false;
			return super.start();
		}
		
		/** @inheritDoc */
		override public function reset() : void {
			super.reset();
			_isComplete = false;
		}
		
		/**
		 * Event listener that is called when the asyncronous function is completed.
		 */
		protected function onFunctionComplete(event:Event):void {
			_completeEventDispatcher.removeEventListener(_completeEventType, onFunctionComplete);
			_isComplete = true;
			if (!_paused) {
				complete();
			}
		}
		
		/** @inheritDoc */
		override public function clone():IAction {
			var clone:KSAsyncFunction = new KSAsyncFunction(_func, _completeEventDispatcher, _completeEventType);
			clone._args = _args;
			clone.delay = _delay;
			clone.duration = _duration;
			clone.autoDelete = _autoDelete;
			return clone;
		}
		
		/** @inheritDoc */
		override public function kill():void {
			super.kill();
			_completeEventDispatcher = null;
		}
		
	}
}