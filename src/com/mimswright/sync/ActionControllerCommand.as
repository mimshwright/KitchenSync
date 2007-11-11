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
		public static const START:String = "start";
		
		/** pause() command. */
		public static const PAUSE:String = "pause";

		/** unpause() command. */
		public static const UNPAUSE:String = "unpause";

		/** stop() command. */
		public static const STOP:String = "stop";

		/** kill() command. */
		public static const KILL:String = "kill";

		/** reset() command. For Tween objects only. */
		public static const RESET:String = "reset";
	}
}