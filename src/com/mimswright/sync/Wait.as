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
		
		override internal function onUpdate(event:SynchronizerEvent):void {
			if (_startTimeHasElapsed) {
				if (_durationHasElapsed) {
					complete();
				}
			}
		}
		override public function clone():AbstractSynchronizedAction {
			return new Wait(_offset);
		}
	}
}