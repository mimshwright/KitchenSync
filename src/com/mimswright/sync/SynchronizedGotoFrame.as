package com.mimswright.sync
{
	/**
	 * Tells a target MovieClip to play a specified frame.
	 *
	 * @todo consider expanding this to a MovieClip controller
	 * @todo test
	 */
	public class SynchronizedGotoFrame extends SynchronizedFunction
	{
		protected var _target:MovieClip;
		public function get target ():MovieClip { return _target; }
		public function set target (target:MovieClip):Void { _target = target; }
		
		protected var _frameIdentifier:*;
		public function get frameIdentifier ():* { return _frameIdentifier; }
		public function set frameIdentifier (frameIdentifier:*) { _frameIdentifier = frameIdentifier ;}
		
		/**
		 * Constructor.
		 * 
		 * @param offset - the number of frames to offset the action
		 * @param target - the MovieClip whose frames you are going to
		 * @param frameIdentifier - a String or uint to go to
		 */
		public function SynchronizedFunction(offset:int, target:MovieClip, frameIdentifier:*)
		{
			super(offset, target.gotoAndPlay, frameIdentifier);
		}
		
		override public function clone():AbstractSynchronizedAction {
			var clone:SynchronizedGotoFrame = new SynchronizedGotoFrame();
			clone._args = _args;
			clone._result = _result;
			clone.duration = _duration;
			clone.autoDelete = _autoDelete;
			clone._frameIdentifier = _frameIdentifier;
			clone._target = _target;
			return clone;
		}
	}
}