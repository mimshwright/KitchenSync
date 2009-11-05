package org.as3lib.kitchensync.action
{
	import flash.display.MovieClip;
	
	/**
	 * An action to control the playback of a movie clip. Allows you to 
	 * call <code>gotoAndPlay()</code> on a MovieClip.
	 * 
	 * @author Mims Wright
	 */
	 // todo test
	public class KSMovieClipController extends KSFunction
	{
		/** The movie clip that will be targeted by the action. */
		public function get target ():MovieClip { return _target; }
		public function set target (target:MovieClip):void { _target = target; }
		protected var _target:MovieClip;
		
		/**
		 * The frame identifier to jump to in the movieclip. 
		 * Could be a string or a frame number to play
		 */
		protected var _frameIdentifier:*;
		public function get frameIdentifier ():* { return _frameIdentifier; }
		public function set frameIdentifier (frameIdentifier:*):void { _frameIdentifier = frameIdentifier ;}
		
		/**
		 * Constructor.
		 * 
		 * @param delay - the number of frames to delay the action
		 * @param target - the MovieClip whose frames you are going to
		 * @param frameIdentifier - a String or uint to go to
		 */
		public function KSMovieClipController(target:MovieClip, frameIdentifier:*)
		{
			super(target.gotoAndPlay, frameIdentifier);
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function clone():IAction {
			var clone:KSMovieClipController = new KSMovieClipController(target, frameIdentifier);
			clone._delay = _delay;
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