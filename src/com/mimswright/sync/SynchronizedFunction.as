package com.mimswright.sync
{
	/**
	 * Packages up a function to be run at a specified time or as part of a sequence.
	 * Setting _duration to anything but zero will cause the function to repeat every frame until the duration is reached.
	 */
	public class SynchronizedFunction extends AbstractSynchronizedAction
	{
		protected var _func:Function;
		public function set func(func:Function):void { _func = func; }
		protected var _args:Array;
		protected var _result:*;
		public function get result():* { return _result; }
		
		/**
		 * Constructor.
		 * 
		 * @param offset - the number of frames to offset the action
		 * @param func - the function or method to call at the specified time
		 * @param args - the rest of the parameters become arguments passed to the function at the time it's called.
		 */
		public function SynchronizedFunction(offset:int, func:Function, ... args)
		{
			super();
			_offset = offset;
			_func = func;
			_args = args;
		}
		
		/**
		 * Calls the function with the arguments specified. The result of the function is stored in the 
		 * results property of the SynchronizedFunction object.
		 * 
		 * @returns the results from the function call.
		 */
		public function invoke():* {
			_result = _func.apply(this, _args);
			return _result;
		}
		
		/**
		 * Executes the function when the offset has elapsed.
		 * If the duration is > 0, it will repeat until the duration has elapsed.
		 */
		override protected function onUpdate(event:SynchronizerEvent):void {
			var time:Timestamp = event.timestamp;
			if (startTimeHasElapsed) {
				invoke();
				if (durationHasElapsed) {
					complete();
				}
			}
		}
		
		override public function clone():AbstractSynchronizedAction {
			var clone:SynchronizedFunction = new SynchronizedFunction(_offset, _func);
			clone.timeUnit = _timeUnit;
			clone._args = _args;
			clone._result = _result;
			clone.duration = _duration;
			clone.autoDelete = _autoDelete;
			return clone;
		}
	}
}