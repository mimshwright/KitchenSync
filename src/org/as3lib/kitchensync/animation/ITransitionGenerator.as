package org.as3lib.kitchensync.animation
{
	import org.as3lib.kitchensync.action.IAction;
	
	/**
	 * Creates actions using KitchenSync for show and hide transitions.
	 * Keep in mind that the transitions are not necessarily started at the time they are requested
	 * so you shouldn't assume that a generator is shown just because getShowTransition() was called.
	 * 
	 * Use isActive when you want to let the transition generator know when it's been shown. 
	 */
	public interface ITransitionGenerator
	{
		/**
		 * Stops the current transition.
		 */
		function stopCurrentTransition():void;
		
		function getShowTransition():IAction;
		function getHideTransition():IAction;
		
		/**
		 * Use isActive when you want to let the transition generator know when it's been shown. 
		 * Set isActive to true during the show transition and to false in the hide transition. 
		 */
		function get isActive():Boolean;
		function set isActive(isActive:Boolean):void;
	}
}