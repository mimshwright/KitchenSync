
package com.mimswright.sync
{	
	/**
	 * A set of commands to be used in conjunction with the ActionController class.
	 * 
	 * @see ActionController
	 */
	public class ActionControllerCommand
	{
		/** start() command. */
		public static const START:ActionControllerCommand = new ActionControllerCommand();
		
		/** pause() command. */
		public static const PAUSE:ActionControllerCommand = new ActionControllerCommand();

		/** unpause() command. */
		public static const UNPAUSE:ActionControllerCommand = new ActionControllerCommand();

		/** stop() command. */
		public static const STOP:ActionControllerCommand = new ActionControllerCommand();

		/** kill() command. */
		public static const KILL:ActionControllerCommand = new ActionControllerCommand();

		/** reset() command. For Tween objects only. */
		public static const RESET:ActionControllerCommand = new ActionControllerCommand();
	}
}