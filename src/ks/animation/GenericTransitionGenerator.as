package ks.animation
{
	import flash.display.MovieClip;
	
	import ks.action.IAction;
	import ks.action.KSFunction;
	import ks.action.KSSetProperty;
	import ks.action.group.IActionGroup;
	import ks.action.group.KSSequenceGroup;
	import ks.action.tween.TweenFactory;
	
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