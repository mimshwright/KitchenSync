package org.as3lib.kitchensync.core
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * This core uses an ENTER_FRAME listener to drive Synchronizer updates.
	 * 
	 * @since 2.0
	 * @author Mims Wright
	 */
	 //Todo: add notes on performance.
	public class EnterFrameCore implements ISynchronizerCore
	{
		private var _displayObject:DisplayObject;
		
		/**
		 * Constructor.
		 * 
		 * @param displayObject The displayObject to use for enterFrame updates.
		 */
		public function EnterFrameCore(displayObject:DisplayObject)
		{
			_displayObject = displayObject;
		}

		public function start():void
		{
			_displayObject.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function stop():void
		{
			_displayObject.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void {
			Synchronizer.getInstance().dispatchUpdate();
		}
		
	}
}