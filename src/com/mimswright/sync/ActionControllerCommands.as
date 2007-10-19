package com.mimswright.sync
{
	/**
	 * A set of commands to be used in conjunction with the ActionController class.
	 * 
	 * @see ActionController
	 */
	public class ActionControllerCommands
	{
		/** start() command. */
		public static const START:int = 1;
		
		/** pause() command. */
		public static const PAUSE:int = 2;

		/** unpause() command. */
		public static const UNPAUSE:int = 3;

		/** stop() command. */
		public static const STOP:int = 4;

		/** kill() command. */
		public static const KILL:int = 5;

		/** reset() command. For Tween objects only. */
		public static const RESET:int = 6;
	}
}