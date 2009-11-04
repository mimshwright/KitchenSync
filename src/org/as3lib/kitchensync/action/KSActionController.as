package org.as3lib.kitchensync.action
{
	import org.as3lib.kitchensync.action.tween.KSTween;
	
	/**
	 * An action that controls another action when executed. 
	 * The accepted commands can be found in ActionControllerCommands.
	 * 
	 * @see ActionControllerCommand
	 * 
	 * @example <listing version="3.0">
	 * // start playing a song.
	 * var song:IAction = new KSSoundController("song.mp3").start();
	 * 
	 * // stop the song after 10 seconds.
	 * new KSActionController(song, ActionControllerCommand.STOP, "10s").start(); 
	 * </listing>
	 * 
	 * @since 0.4
	 * @author Mims Wright
	 */
	public class KSActionController extends KSFunction
	{
		/**
		 * The action that the ActionController will send commands to.
		 */
		public function get target ():IAction { return _target; }
		public function set target (target:IAction):void { _target = target; }
		protected var _target:IAction;
		
		/**
		 * Constructor.
		 * 
		 * @param target The action that will receive the commands from the controller.
		 * @param command The function that the action will perform when the controller executes.
		 * @param delay The time to delay this action.
		 */ 
		public function KSActionController (target:IAction, command:ActionControllerCommand = null, delay:* = 0) {
			super(null);
			this.delay = delay;
			
			if (target) {
				_target = target;
			} else {
				throw new ArgumentError ("target AbstractSynchronizedAction must not be null.");
			}
			if (command == null) {  command = ActionControllerCommand.DEFAULT; }
			switch (command) {
				case ActionControllerCommand.START:
					_func = function ():void { _target.start(); };
				break;
				case ActionControllerCommand.PAUSE:
					_func = function ():void { _target.pause(); };
				break;
				case ActionControllerCommand.UNPAUSE:
					_func = function ():void { _target.unpause(); };
				break;
				case ActionControllerCommand.STOP:
					_func = function ():void { _target.stop(); };
				break;
				case ActionControllerCommand.KILL:
					_func = function ():void { _target.kill(); this.kill(); };
				break;
				case ActionControllerCommand.RESET:
					_func = function ():void { _target.reset(); };
				break;
				
				default:
					throw new ArgumentError ("Please provide an appropriate value for the command argument. Use one of the enumeration values from ActionControllerCommands.");
					kill();
				break;
			}
		}
		
		/** @inheritDoc */
		override public function kill():void {
			super.kill();
			_target = null;
		}
	}
}