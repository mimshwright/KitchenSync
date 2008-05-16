package org.as3lib.kitchensync.action
{
	import org.as3lib.kitchensync.core.*;
	
	/**
	 * Does nothing except wait. Used to delay a sequence.
	 */
	public class KSWait extends AbstractAction
	{
		override public function set duration(duration:*):void {
			throw new Error("duration is ignored for Wait");
		}
		
		/** Time that the action will wait. Synonym for delay. */
		public function get waitTime():int { return this.delay;}
		public function set waitTime(waitTime:*):void { this.delay = waitTime; }
		
		/**
		 * Constructor.
		 * 
		 * @param waitTime Time that the action will wait.
		 */
		public function KSWait (waitTime:*):void {
			super();
			this.delay = waitTime;
		}
		
		override protected function onUpdate(event:KitchenSyncEvent):void {
			if (startTimeHasElapsed) {
				if (durationHasElapsed) {
					complete();
				}
			}
		}
		override public function clone():AbstractAction {
			var clone:KSWait = new KSWait(_delay);
			//clone.timeUnit = _timeUnit;
			clone.autoDelete = _autoDelete;
			return clone;
		}
	}
}