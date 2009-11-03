package org.as3lib.kitchensync.action
{
	import org.as3lib.kitchensync.core.*;
	
	/**
	 * Does nothing except wait for the delay to pass. Can be used to delay a sequence.
	 * 
	 * @example 
	 * <listing version="3.0">
	 * // a sequence where someFunction() is called, then 2 seconds 
	 * // later, nextFunction() is called.
	 * new KSSequence(
	 * 	new KSFunction(someFunction),
	 * 	new KSWait("2 seconds"),
	 * 	new KSFunction(nextFunction)
	 * ).start();
	 * </listing>
	 * 
	 * @since 0.2
	 * @author Mims Wright
	 */
	public class KSWait extends AbstractAction
	{
		/** Not used for KSWait. Use delay instead. */
		override public function set duration(duration:*):void {
			throw new Error("duration is ignored for KSWait");
		}
		
		/**
		 * Constructor.
		 * 
		 * @param waitTime Time that the action will wait before completing.
		 */
		public function KSWait (waitTime:*):void {
			super();
			this.delay = waitTime;
		}
		
		/** @inheritDoc */
		override public function update(currentTime:int):void {
			if ( startTimeHasElapsed(currentTime) ) {
				if (durationHasElapsed(currentTime)) {
					complete();
				}
			}
		}
		
		/** @inheritDoc */
		override public function clone():IAction {
			var clone:KSWait = new KSWait(_delay);
			clone.autoDelete = _autoDelete;
			return clone;
		}
	}
}