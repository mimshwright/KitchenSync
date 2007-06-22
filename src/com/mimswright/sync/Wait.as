package com.mimswright.sync
{
	/**
	 * Does nothing except wait. Used to delay a sequence.
	 */
	public class Wait extends AbstractSynchronizedAction
	{
		public function Wait (delay:Number):void {
			_offset = delay;
		}
		
		override internal function onUpdate(event:SynchronizerEvent):void {
			if (_startTimeHasElapsed) {
				if (_durationHasElapsed) {
					complete();
				}
			}
		}
		
	}
}