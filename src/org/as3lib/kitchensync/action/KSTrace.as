package org.as3lib.kitchensync.action
{
	/**
	 * Traces a message at the specified time.
	 */
	public class KSTrace extends KSFunction
	{
		/**
		 * Constructor.
		 * @param message - the message to be displayed in the trace window.
		 * @param offset - the time to wait before tracing in frames.
		 */
		public function KSTrace(message:*, offset:* = 0)
		{
			super(offset, trace, message.toString());
		}
	}
}