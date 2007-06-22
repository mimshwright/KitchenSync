package com.mimswright.sync
{
	/**
	 * Traces a message at the specified time.
	 */
	public class SynchronizedTrace extends SynchronizedFunction
	{
		/**
		 * Constructor.
		 * @param message - the message to be displayed in the trace window.
		 * @param offset - the time to wait before tracing in frames.
		 */
		public function SynchronizedTrace(message:*, offset:int = 0)
		{
			super(offset, trace, message.toString());
		}
	}
}