package org.as3lib.kitchensync.animation
{
	import flash.display.MovieClip;
	
	import org.as3lib.kitchensync.action.IAction;
	import org.as3lib.kitchensync.action.KSFunction;
	import org.as3lib.kitchensync.action.KSSetProperty;
	import org.as3lib.kitchensync.action.group.IActionGroup;
	import org.as3lib.kitchensync.action.group.KSSequenceGroup;
	import org.as3lib.kitchensync.action.tween.TweenFactory;
	
	public class GenericTransitionGenerator extends MovieClip implements ITransitionGenerator
	{
		/** An action used for transitioning this section in and out. */
		protected var transition:IActionGroup;
		
		public function onEntry():void {}
		public function onExit():void {}
		
		public function GenericTransitionGenerator()
		{
		}
		
		public function stopCurrentTransition():void {
			if (transition && transition.isRunning) { transition.stop(); }
		}
		
		public function getShowTransition():IAction {
			stopCurrentTransition();
			transition = new KSSequenceGroup(
				TweenFactory.newFadeInTween(this, "0.5s", 0, false, true),
				new KSFunction(onEntry)
			);
			return transition;
		}
		public function getHideTransition():IAction {
			stopCurrentTransition();
			transition = new KSSequenceGroup(
				new KSFunction(onExit),
				TweenFactory.newFadeOutTween(this, "0.5s", 0, false)
			);
			return transition;
		}
	}
}