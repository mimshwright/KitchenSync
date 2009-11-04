package org.as3lib.kitchensync.action
{
	import flash.errors.IllegalOperationError;
	
	import org.as3lib.kitchensync.core.*;
	
	/**
	 * Packages up a function to be run at a specified time or as part of a sequence.
	 * 
	 * @example
	 * <listing version="3.0">
	 * function doSomething():void {
	 * 	// function body
	 * }
	 * 
	 * new KSFunction(doSomething, "5sec").start(); // function will be run after 5 seconds
	 * </listing>
	 * 
	 * @author Mims Wright
	 * @since 0.1
	 */
	public class KSFunction extends AbstractAction
	{
		/**
		 * The function that will be called by the action.
		 */
		public function get func():Function { return _func; } 
		public function set func(func:Function):void { _func = func; }
		protected var _func:Function;
		
	 	/** 
	 	 * Duration cannot be set. Setting _duration to anything 
	 	 * but zero will cause the function 
	 	 * to repeat every frame until the duration is reached.
	 	 */
		override public function set duration(duration:*):void { 
			throw new IllegalOperationError("Duration cannot be set for KSFunction"); 
		}
		
		/**
		 * The result of the function (if the function generates one.
		 */		
		public function get result():* { return _result; }
		protected var _result:*;
		
		/**
		 * Arguments that will be passed into the function.
		 */
		protected var _args:Array;
		
		
		/**
		 * Constructor.
		 * 
		 * @param func The function or method to call at the specified time
		 * @param delay The duration to wait before invoking the function after start() is called.
		 * @param args The rest of the parameters become arguments passed to the function at the time it's called.
		 */
		public function KSFunction(func:Function, delay:Object = 0, ... args)
		{
			super();
			_duration = 0;
			this.func = func;
			this.delay = delay;
			_args = args;
		}
		
		
		/**
		 * Calls the function with the arguments specified. The result of the function is stored in the 
		 * results property of the SynchronizedFunction object.
		 * 
		 * @see #result
		 * 
		 * @returns the results from the function call which are stored in the <code>result</code> property.
		 */
		public function invoke():* {
			_result = _func.apply(this, _args);
			return _result;
		}
		
		
		/**
		 * @inheritDoc
		 * Executes the function when the delay has elapsed.
		 */
		override public function update(currentTime:int):void {
			if (startTimeHasElapsed(currentTime)) {
				invoke();
				if (durationHasElapsed(currentTime)) {
					complete();
				}
			}
		}
		
		
		/** @inheritDoc */
		override public function clone():IAction {
			var clone:KSFunction = new KSFunction(_func);
			clone._args = _args;
			clone._result = _result;
			clone.autoDelete = _autoDelete;
			return clone;
		}
		
		
		/** @inheritDoc */
		override public function kill():void {
			super.kill();
			_func = null;
			_args = null;
			_result = null;
		} 
	}
}