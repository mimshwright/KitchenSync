package org.as3lib.kitchensync.core
{
	/**
	 * Represents some type of object which can be paused and unpaused (in
	 * whatever way makes sense for that object). 
	 */
	public interface IPauseable
	{
		/** Should return true if paused. */
		function get isPaused():Boolean;
		
		/**
		 * Causes the object to be paused. When unpause() is called,
		 * the object will continue at the point where it was paused.
		 */
		function pause():void;
		
		/**
		 * Resumes the object at the point where it was paused.
		 */
		function unpause():void;
	}
}