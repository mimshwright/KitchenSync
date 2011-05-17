package ks.animation
{
	import ks.action.IAction;
	
	/**
	 * Creates actions using KitchenSync for show and hide transitions.
	 * Keep in mind that the transitions are not necessarily started at the time they are requested
	 * so you shouldn't assume that a generator is shown just because getShowTransition() was called.
	 */
	public interface ITransitionGenerator
	{
		/**
		 * Stops the current transition.
		 */
		function stopCurrentTransition():void;
		
		function getShowTransition():IAction;
		function getHideTransition():IAction;
	}
}