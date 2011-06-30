package ks.action.tweentarget
{

	/**
	 * @private
	 * 
	 * A contract for a user of ITweenTargets.
	 * 
	 * @author Mims Wright
	 * @since 2.0
	 * @see ks.action.tween.KSTween
	 * @see ks.action.tween.ITweenTarget
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