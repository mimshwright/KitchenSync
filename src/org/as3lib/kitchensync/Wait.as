package org.as3lib.kitchensync
{
	/**
	 * Does nothing except wait. Used to delay a sequence.
	 */
	public class Wait extends AbstractSynchronizedAction
	{
		override public function set duration(duration:*):void {
			throw new Error("duration is ignored for Wait");
		}
		
		/** Time that the action will wait. Synonym for offset. */
		public function get waitTime():int { return this.offset;}
		public function set waitTime(waitTime:*):void { this.offset = waitTime; }
		
		/**
		 * Constructor.
		 * 
		 * @param waitTime Time that the action will wait.
		 */
		public function Wait (waitTime:*):void {
			super();
			this.offset = waitTime;
		}
		
		override protected function onUpdate(event:SynchronizerEvent):void {
			if (startTimeHasElapsed) {
				if (durationHasElapsed) {
					complete();
				}
			}
		}
		override public function clone():AbstractSynchronizedAction {
			var clone:Wait = new Wait(_offset);
			//clone.timeUnit = _timeUnit;
			clone.autoDelete = _autoDelete;
			return clone;
		}
	}
}