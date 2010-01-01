package org.as3lib.kitchensync.action
{
	import flash.errors.IllegalOperationError;
	import flash.utils.getTimer;
	
	
	/**
	 * Allows you to split up a loop (like a for or while loop) into smaller chunks
	 * that execute over a period of time (rather than all at once). You can set
	 * the function that executes, the number of times it executes, and the minimum
	 * framerate that must be maintained while it runs. You can also set the conditional
	 * statement that checks to see whether the loop is finished.
	 *
	 * For a more complete implementation of this, see the General Relativity Green Threads
	 * @see http://blog.generalrelativity.org/actionscript-30/green-threads/
	 * 
	 * @author Mims H. Wright
	 * @since 2.0
	 */
	public class KSAsyncLoop extends AbstractAction
	{
	
		/**
		 * The currently running loop number.
		 * Starts at 1 when the action is running and stays at 0 when it isn't.
		 */
		public function get currentLoop():int { return _currentLoop; }
		private var _currentLoop:int = 0;
		
		/**
		 * Total number of loops. 
		 * When currentLoop = loops, the action finishes (unless you use a custom
		 * conditionalFunction).
		 */
		public function get totalLoops():int { return _totalLoops; }
		private var _totalLoops:int;
		
		/**
		 * Returns the progress based on the loops.
		 */
		override public function get progress ():Number { return _currentLoop / _totalLoops; }
		
		/**
		 * The loop can only delay the processor until it drops below
		 * this framerate in a single frame. For example, if the maintainFramerate
		 * value was 10(fps), your loop would execute in chunks of 100ms
		 * until it finished.
		 * The loop will always execute at least once each frame regardless of this number.
		 */
		public function get maintainFramerate():Number { return _maintainFramerate;	}
		public function set maintainFramerate(value:Number):void { _maintainFramerate = value; }
		private var _maintainFramerate:Number;
		
		/**
		 * The estimated number of ms per frame.
		 */
		private var _frameDruation:int;
		
		/**
		 * A function that evaluates whether the loop should end.
		 * Must have the format:
		 * <code>function (currentLoop:int):Boolean</code>
		 * If the function returns true, the loop will continue.
		 * If the function returns false, the loop will stop.
		 * By default, this is set to be <code>currentLoop <= totalLoops</code>
		 */
		private var _conditionFunction:Function;
		
		/**
		 * The function that executes each time the action loops.
		 * Must have the format:
		 * <code>function (currentLoop:int):void</code>
		 */
		private var _loopFunction:Function;
		
		/** 
		 * @inheritDoc
		 * 
		 * This class isn't instantaneous even though the duration can only be 
		 * set to 0.
		 */
		override public function get isInstantaneous() : Boolean {
			return false;
		}
		
		/** 
		 * Duration cannot be set. Setting _duration to anything 
		 * but zero will cause the function 
		 * to repeat every frame until the duration is reached.
		 */
		override public function set duration(duration:*):void { 
			throw new IllegalOperationError("Duration cannot be set for this class"); 
		}
		
		/**
		 * Constructor.
		 * 
		 * @param totalLoops Sets the number of times that the function should loop. (Will be ignored 
		 * 					 if conditionFunction is set)
		 * @param loopFunction The loop to execute. in the format function(currentLoop:int):void
		 * @param maintainFramerate The framerate to maintain. The program won't drop below this framerate
		 * 							because of the KSAsyncLoop. 
		 * @param conditionFunction Optional condition funciton in the form function(currentLoop:int):Boolean
		 * 							If it returns false, the loop will stop.
		 * 							By default, currentLoop is checked against totalLoops.
		 */
		public function KSAsyncLoop (totalLoops:int, loopFunction:Function, maintainFramerate:Number = 15, conditionFunction:Function = null)
		{
			super();
			
			this._totalLoops = totalLoops;
			this._loopFunction = loopFunction;
			this._frameDruation = int(1 / maintainFramerate * 1000);
			this._maintainFramerate = maintainFramerate;
			
			if (conditionFunction == null) {
				conditionFunction = function (i:int):Boolean {
					return i <= totalLoops; 
				}
			}
			this._conditionFunction = conditionFunction;
		}
		
		/** @inheritDoc */
		override public function stop() : void {
			super.stop();
			_currentLoop = 0;
		}
		
		/** @inheritDoc */
		override public function update(currentTime:int) : void {
			var startTime:int = getTimer();
			var frameTime:int = 0;
			while (frameTime < _frameDruation) {
				if (_conditionFunction(currentLoop)) {
					_currentLoop += 1;
					_loopFunction.call(null, _currentLoop);
				} else {
					complete();
					break;
				}
				frameTime = getTimer() - startTime;
			}
		}
		
		/** @inheritDoc */
		override public function clone() : IAction {
			var clone:KSAsyncLoop = new KSAsyncLoop (_totalLoops, _loopFunction, _maintainFramerate, _conditionFunction);
			return clone;
		}
		
		/** @inheritDoc */
		override public function kill():void {
			super.kill();
			_conditionFunction = null;
			_loopFunction = null;
		}
	}
}