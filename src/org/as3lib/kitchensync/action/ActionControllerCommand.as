package org.as3lib.kitchensync.action
{
	/**
	 * A set of commands to be used in conjunction with the ActionController class.
	 * 
	 * @see KSActionController
	 */
	final public class ActionControllerCommand
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

		/** reset() command. */
		public static const RESET:String = "reset";
		
		/** The default command will be used if nothing is specified. */
		public static var DEFAULT:String = START;
	}
}