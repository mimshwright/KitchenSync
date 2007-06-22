package com.mimswright.easing
{
	public class Quadratic
	{
	    /**
	     *  @param timeElapsed - The time since the tween began in milliseconds or frames.
	     *  @param duration - The duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeIn(timeElapsed:Number, duration:Number):Number
		{
			return (timeElapsed/=duration)*timeElapsed;
		}
				
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeOut(timeElapsed:Number, duration:Number):Number
		{
			return -1 *(timeElapsed/=duration)*(timeElapsed-2);
		}
	
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeInOut(timeElapsed:Number, duration:Number):Number
		{
			if ((timeElapsed/=duration/2) < 1) return 0.5*timeElapsed*timeElapsed;
			return -0.5 * ((--timeElapsed)*(timeElapsed-2) - 1);
		}
	
	}
}