package com.mimswright.sync
{
	/**
	 * Does nothing except wait. Used to delay a sequence.
	 */
	public class Wait extends AbstractSynchronizedAction
	{
		override public function set duration(duration:int):void {
			throw new Error("duration is ignored for Wait");
		}
		
		public function Wait (offset:Number):void {
			_offset = offset;
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
			clone.timeUnit = _timeUnit;
			clone.autoDelete = _autoDelete;
			return clone;
		}
	}
}