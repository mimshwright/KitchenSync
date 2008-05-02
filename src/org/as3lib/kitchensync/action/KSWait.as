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
		
		/** Time that the action will wait. Synonym for offset. */
		public function get waitTime():int { return this.offset;}
		public function set waitTime(waitTime:*):void { this.offset = waitTime; }
		
		/**
		 * Constructor.
		 * 
		 * @param waitTime Time that the action will wait.
		 */
		public function KSWait (waitTime:*):void {
			super();
			this.offset = waitTime;
		}
		
		override protected function onUpdate(event:KitchenSyncEvent):void {
			if (startTimeHasElapsed) {
				if (durationHasElapsed) {
					complete();
				}
			}
		}
		override public function clone():AbstractAction {
			var clone:KSWait = new KSWait(_offset);
			//clone.timeUnit = _timeUnit;
			clone.autoDelete = _autoDelete;
			return clone;
		}
	}
}