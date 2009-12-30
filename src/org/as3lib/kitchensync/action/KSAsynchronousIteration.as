package org.as3lib.kitchensync.action
{
	import flash.errors.IllegalOperationError;
	import flash.utils.getTimer;
	
	
	/**
	 * KSAsynchronousIteration
	 *
	 * @author Mims H. Wright
	 */
	// todo docs
	// todo cleanup
	// todo test with action controls
	// todo rename?
	public class KSAsynchronousIteration extends AbstractAction
	{
		private var loop:int = 0;
		private var limit:int;
		override public function get progress ():Number { return loop / limit; }
		
		private var maintainFramerate:Number;
		public var frameDruation:int;
		
		private var conditionFunction:Function;
		private var loopFunction:Function;
		
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
		
		public function KSAsynchronousIteration(limit:int, loopFunction:Function, maintainFramerate:Number = 15, conditionFunction:Function = null)
		{
			super();
			
			this.limit = limit;
			this.loopFunction = loopFunction;
			this.frameDruation = int(1 / maintainFramerate * 1000);
			this.maintainFramerate = maintainFramerate;
			
			if (conditionFunction == null) {
				conditionFunction = function (i:int):Boolean {
					return i <= limit; 
				}
			}
			this.conditionFunction = conditionFunction;
		}
		
		override public function stop() : void {
			super.stop();
			loop = 0;
		}
		
		override public function update(currentTime:int) : void {
			var startTime:int = getTimer();
			var frameTime:int = 0;
			while (frameTime < frameDruation) {
				if (conditionFunction(loop)) {
					loop += 1;
					loopFunction.call(null, loop);
				} else {
					complete();
					break;
				}
				frameTime = getTimer() - startTime;
			}
		}
		
		override public function clone() : IAction {
			var clone:KSAsynchronousIteration = new KSAsynchronousIteration (limit, loopFunction, maintainFramerate, conditionFunction);
			return clone;
		}
		
		override public function kill():void {
			super.kill();
			conditionFunction = null;
			loopFunction = null;
		}
	
	}
}