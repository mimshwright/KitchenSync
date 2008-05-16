package org.as3lib.kitchensync.action
{
	import flash.events.*;
	
	import org.as3lib.kitchensync.core.*;
	
	public class KSAsynchronousFunction extends KSFunction
	{
		
		protected var _completeEventDispatcher:IEventDispatcher;
		protected var _completeEventType:String;
		
		public function KSAsynchronousFunction(delay:*, func:Function, completeEventDispatcher:IEventDispatcher, completeEventType:String, ...args)
		{
			super(delay, func);
			this._args = args;
			
			_completeEventDispatcher = completeEventDispatcher;
			_completeEventType = completeEventType;
			
			_completeEventDispatcher.addEventListener(_completeEventType, onFunctionComplete, false, 0, true);
		}
		
		/**
		 * Executes the function when the delay has elapsed.
		 */
		override protected function onUpdate(event:KitchenSyncEvent):void {
			var time:Timestamp = event.timestamp;
			if (startTimeHasElapsed) {
				invoke();
				unregister();
			}
		}
		
		/**
		 * Event listener that is called when the asyncronous function is completed.
		 */
		protected function onFunctionComplete(event:Event):void {
			_completeEventDispatcher.removeEventListener(_completeEventType, onFunctionComplete);
			complete();
		}
		
		override public function clone():AbstractAction {
			var clone:KSAsynchronousFunction = new KSAsynchronousFunction(_delay, _func, _completeEventDispatcher, _completeEventType);
			clone._args = _args;
			clone.duration = _duration;
			clone.autoDelete = _autoDelete;
			return clone;
		}
		
		override public function kill():void {
			super.kill();
			_completeEventDispatcher = null;
		}
		
	}
}