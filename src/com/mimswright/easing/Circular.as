package com.mimswright.easing
{
	public class Circular
	{
	    /**
	     *  @param timeElapsed - The time since the tween began in milliseconds or frames.
	     *  @param duration - The duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeIn(timeElapsed:Number, duration:Number):Number
		{
			return -1 * (Math.sqrt(1 - (timeElapsed/=duration)*timeElapsed) - 1);
		}
				
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeOut(timeElapsed:Number, duration:Number):Number
		{
			return Math.sqrt(1 - (timeElapsed=timeElapsed/duration-1)*timeElapsed);
		}
	
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeInOut(timeElapsed:Number, duration:Number):Number
		{
			if ((timeElapsed/=duration/2) < 1) {
				return -0.5 * (Math.sqrt(1 - timeElapsed*timeElapsed) - 1);
			} 
			return 0.5 * (Math.sqrt(1 - (timeElapsed-=2)*timeElapsed) + 1);
		}
	
	}
}