package com.mimswright.sync
{
	public class TimeStringParserResult
	{
		public var time:Number;
		public var timeUnit:TimeUnit;
		
		public function TimeStringParserResult(time:Number = 0, timeUnit:TimeUnit = null)
		{
			this.time = time;
			this.timeUnit = timeUnit;
		}

	}
}