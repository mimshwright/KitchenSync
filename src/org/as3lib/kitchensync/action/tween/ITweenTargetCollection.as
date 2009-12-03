package org.as3lib.kitchensync.action.tween
{
	/**
	 * @private
	 * 
	 * A contract for a user of ITweenTargets.
	 * 
	 * @author Mims Wright
	 * @since 2.0
	 * @see org.as3lib.kitchensync.action.tween.KSTween
	 * @see org.as3lib.kitchensync.action.tween.ITweenTarget
	 */
	public interface ITweenTargetCollection
	{
		/**
		 * A list of tween targets used by this tween.
		 */
		function get tweenTargets():Array;
		
		/** 
		 * Adds a target to the tween. 
		 */
		function addTweenTarget(tweenTarget:ITweenTarget):void;
		
		/**
		 * Removes a target from the tween.
		 */
		function removeTweenTarget(tweenTarget:ITweenTarget):void; 
	}
}