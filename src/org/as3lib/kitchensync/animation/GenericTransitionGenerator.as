package org.as3lib.kitchensync.animation
{
	import flash.display.MovieClip;
	
	import org.as3lib.kitchensync.action.IAction;
	import org.as3lib.kitchensync.action.KSSetProperty;
	import org.as3lib.kitchensync.action.group.KSSequenceGroup;
	import org.as3lib.kitchensync.action.tween.TweenFactory;
	
	public class GenericTransitionGenerator extends MovieClip implements ITransitionGenerator
	{
		/** An action used for transitioning this section in and out. */
		protected var transition:IAction;
		
		public function get isActive():Boolean { return _isActive; }
		public function set isActive(isActive:Boolean):void { 
			_isActive = isActive;
		}
		protected var _isActive:Boolean = false;
		
		public function GenericTransitionGenerator()
		{
		}
		
		public function stopCurrentTransition():void {
			if (transition && transition.isRunning) { transition.stop(); }
		}
		
		public function getShowTransition():IAction {
			stopCurrentTransition();
			transition = new KSSequenceGroup(
				new KSSetProperty(this, "isActive", true),
				TweenFactory.newFadeInTween(this, "0.6s", 0, true, true)
			);
			return transition;
		}
		public function getHideTransition():IAction {
			stopCurrentTransition();
			transition = new KSSequenceGroup(
				TweenFactory.newFadeOutTween(this, "0.6s"),
				new KSSetProperty(this, "isActive", false)
			);
			return transition;
		}
	}
}