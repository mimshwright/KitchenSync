package com.mimswright.sync
{
	/**
	 * Executes a function within another AbstractSynchronizedAction when executed. This allows you to easily
	 * control other actions within a sequence. The accepted commands can be found in ActionControllerCommands.
	 * 
	 * @see ActionControllerCommands
	 */
	public class ActionController extends SynchronizedFunction
	{
		protected var _target:AbstractSynchronizedAction;
		public function set target (target:AbstractSynchronizedAction):void { _target = target; }
		public function get target ():AbstractSynchronizedAction { return _target; }
		
		/**
		 * Constructor.
		 * 
		 * @param target - the AbstractSynchronizedAction that will recieve the commands from the controller.
		 * @param command - the function that the SynchronizedAction will perform when the ActionController executes.
		 * @param offset - the number of frames to offset the action.
		 */ 
		public function ActionController (target:AbstractSynchronizedAction, command:int = ActionControllerCommands.START, offset:int = 0) {
			super(offset, null);
			if (target) {
				_target = target;
			} else {
				throw new ArgumentError ("target AbstractSynchronizedAction must not be null.");
			}
			switch (command) {
				case ActionControllerCommands.START:
					_func = function ():void { _target.start(); };
				break;
				case ActionControllerCommands.PAUSE:
					_func = function ():void { _target.pause(); };
				break;
				case ActionControllerCommands.UNPAUSE:
					_func = function ():void { _target.unpause(); };
				break;
				case ActionControllerCommands.STOP:
					_func = function ():void { _target.stop(); };
				break;
				case ActionControllerCommands.KILL:
					_func = function ():void { _target.kill(); this.kill(); };
				break;
				case ActionControllerCommands.RESET:
					// RESET only appllies to Tweens so use stop() if the object isn't a Tween.
					_func = function ():void { 
						if (_target is Tween) { 
							Tween(_target).reset();
						} else { 
							_target.stop(); 
						} 
					};
				break;
				
				default:
					throw new ArgumentError ("Please provide an appropriate value for the command argument. Use one of the constant values from ActionControllerCommands.");
					kill();
				break;
			}
		}
		
		override public function kill():void {
			super.kill();
			_target = null;
		}
	}
}