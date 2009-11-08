package org.as3lib.kitchensync.action
{
	/**
	 * Used in certain action classes for precision timing. Allows users to 
	 * tweak the start time of an action for added control of the playback. 
	 * 
	 * @author Mims Wright
	 * @since 2.0
	 */ 
	public interface IPrecisionAction extends IAction
	{
		/**
		 * This is used by some groups and by advanced users to start the
		 * action at a very specific time down to the millisecond. Use this
		 * when you absoultely need an action to begin at 1000ms rather than 
		 * 1012ms for example. This will affect the playback of certain actions 
		 * with durations > 0 (like tweens) and should help them to appear 
		 * at the correct place at the correct time.
		 * Note: this is an advanced setting and should not be used in most
		 * cases. Instead, use the start() method.
		 * 
		 * @see IAction#start()
		 * 
		 * 
		 */
		function startAtTime(startTime:int):IPrecisionAction;
		
		// todo: make the start time equivelant to the Synchronizer.currentTime at the time of the start() method.

	}
}